# Buzz: два модуля на других архитектурах

Основная архитектура описана в [architecture.md](architecture.md): MVVM на `@Observable` + координаторы на UIKit. Два небольших модуля сделаны иначе, чтобы сравнить подходы на одном приложении:

| Модуль | Архитектура | Почему именно он |
|---|---|---|
| `AddEntryFeature` (шит «Добавить») | **Clean Architecture** | Здесь есть настоящая бизнес-логика: расчёт кофеина и сахара, валидация, проверка лимита. Use case-ам есть что делать |
| `SettingsFeature` («Настройки») | **Redux** (самописный, без TCA) | Мало экранной логики, но много асинхронных событий: сохранение лимита, синхронизация, выход. Хорошо видно, как Redux раскладывает их на действия и эффекты |
| Остальные (`Today`, `Catalog`, `Stats`) | MVVM на `@Observable` | Основной подход |

Главное правило: **снаружи модули выглядят одинаково.** Каждый отдаёт фабрику, которая принимает зависимости и Output (замыкания для навигации) и возвращает `some View`. Координатору всё равно, что внутри: он делает `deps.host(...)` и показывает экран. Поэтому архитектуру одного модуля можно поменять, не трогая остальные.

```swift
// Одинаковый «вход» у всех фич
public enum AddEntryModule {
    @MainActor public static func make(deps: AddEntryDependencies, output: AddEntryOutput) -> some View { ... }
}
public enum SettingsModule {
    @MainActor public static func make(deps: SettingsDependencies, output: SettingsOutput) -> some View { ... }
}
```

---

## 1. «Добавить» на Clean Architecture

### Слои и правило зависимостей

```
AddEntryFeature/
├── Domain/                     ← ни SwiftUI, ни SwiftData, только Foundation
│   ├── NutritionCalculator.swift      чистая логика
│   ├── UseCases/
│   │   ├── GetRecentDrinksUseCase.swift
│   │   ├── SearchDrinksUseCase.swift
│   │   └── AddEntryUseCase.swift
│   └── Errors.swift
├── Presentation/               ← SwiftUI и @Observable
│   ├── AddEntryViewModel.swift
│   ├── AddEntryView.swift
│   └── AddEntryState.swift
└── AddEntryModule.swift        ← сборка: создаёт use case-ы и ViewModel
```

Зависимости направлены только внутрь: `Presentation → Domain`, а реализации репозиториев (`Persistence`, общий модуль) подставляются снаружи через протоколы из общего `Domain`. Use case не знает, откуда данные, ViewModel не знает про репозитории, только про use case-ы.

Чтобы правило проверял компилятор, а не дисциплина, можно сделать в Tuist два таргета: `AddEntryDomain` и `AddEntryFeature` (зависит от `AddEntryDomain`). Для начала хватит папок.

### Domain

```swift
// Чистая функция: проще всего тестировать
public struct NutritionCalculator: Sendable {
    public init() {}
    public func nutrition(of drink: Drink, volumeMl: Int) -> (caffeineMg: Double, sugarG: Double) {
        let k = Double(volumeMl) / 100
        return (drink.caffeinePer100ml * k, drink.sugarPer100ml * k)
    }
}

public enum AddEntryError: Error, Equatable {
    case invalidVolume
    case invalidPrice
    case dateInFuture
}

public struct AddEntryResult: Sendable, Equatable {
    public let entry: Entry
    public let todayTotalMg: Double
    public let isOverLimit: Bool        // ViewModel решит, показать ли предупреждение
}
```

```swift
public protocol AddEntryUseCase: Sendable {
    func execute(drink: Drink, volumeMl: Int, consumedAt: Date, price: Decimal?) async throws -> AddEntryResult
}

public struct DefaultAddEntryUseCase: AddEntryUseCase {
    let entries: EntryRepository        // протоколы из общего Domain
    let settings: SettingsRepository
    let calculator: NutritionCalculator
    let now: @Sendable () -> Date       // время тоже зависимость: так тесты не зависят от часов

    public func execute(drink: Drink, volumeMl: Int, consumedAt: Date, price: Decimal?) async throws -> AddEntryResult {
        guard (50...2000).contains(volumeMl) else { throw AddEntryError.invalidVolume }
        if let price, price < 0 { throw AddEntryError.invalidPrice }
        guard consumedAt <= now() else { throw AddEntryError.dateInFuture }

        let n = calculator.nutrition(of: drink, volumeMl: volumeMl)
        let entry = Entry(id: UUID(), drinkId: drink.id, brand: drink.brand, drinkName: drink.name,
                          consumedAt: consumedAt, volumeMl: volumeMl, price: price,
                          caffeineMg: n.caffeineMg, sugarG: n.sugarG)
        try await entries.add(entry)

        let start = Calendar.current.startOfDay(for: consumedAt)
        let day = try await entries.entries(from: start, to: start.addingTimeInterval(86_400))
        let total = day.reduce(0) { $0 + $1.caffeineMg }
        let limit = try await settings.dailyLimitMg()
        return AddEntryResult(entry: entry, todayTotalMg: total, isOverLimit: total > Double(limit))
    }
}
```

`GetRecentDrinksUseCase` (последние 5 разных напитков из записей) и `SearchDrinksUseCase` (поиск по каталогу) устроены так же: протокол + реализация поверх репозиториев.

### Presentation

```swift
@MainActor @Observable
final class AddEntryViewModel {
    var recent: [Drink] = []
    var results: [Drink] = []
    var query = ""
    var selected: Drink?
    var volumeMl = 500
    var consumedAt = Date.now
    var priceText = ""
    var error: AddEntryError?
    var overLimitWarning: Double?        // показываем алерт «уже 520 мг из 400»

    @ObservationIgnored private let addEntry: AddEntryUseCase
    @ObservationIgnored private let getRecent: GetRecentDrinksUseCase
    @ObservationIgnored private let search: SearchDrinksUseCase
    @ObservationIgnored private let calculator: NutritionCalculator
    @ObservationIgnored private let output: AddEntryOutput

    var preview: Double { selected.map { calculator.nutrition(of: $0, volumeMl: volumeMl).caffeineMg } ?? 0 }

    func onAppear() async { recent = (try? await getRecent.execute(limit: 5)) ?? [] }
    func queryChanged() async { results = (try? await search.execute(query)) ?? [] }

    func saveTapped() async {
        guard let selected else { return }
        let price = priceText.isEmpty ? nil : Decimal(string: priceText.replacingOccurrences(of: ",", with: "."))
        do {
            let result = try await addEntry.execute(drink: selected, volumeMl: volumeMl, consumedAt: consumedAt, price: price)
            if result.isOverLimit { overLimitWarning = result.todayTotalMg } else { output.finished() }
        } catch let e as AddEntryError {
            error = e
        } catch {
            self.error = nil   // ошибка хранилища: показать общий алерт
        }
    }
}
```

ViewModel здесь тоньше, чем в MVVM-модулях: в ней только состояние формы и перевод результатов use case-ов в UI.

### Сборка модуля

```swift
public struct AddEntryDependencies {
    public let entries: EntryRepository
    public let drinks: DrinkRepository
    public let settings: SettingsRepository
}

public enum AddEntryModule {
    @MainActor public static func make(deps: AddEntryDependencies, output: AddEntryOutput) -> some View {
        let calc = NutritionCalculator()
        let vm = AddEntryViewModel(
            addEntry: DefaultAddEntryUseCase(entries: deps.entries, settings: deps.settings, calculator: calc, now: { .now }),
            getRecent: DefaultGetRecentDrinksUseCase(entries: deps.entries, drinks: deps.drinks),
            search: DefaultSearchDrinksUseCase(drinks: deps.drinks),
            calculator: calc,
            output: output)
        return AddEntryView(model: vm)
    }
}
```

Нюанс со связью с «Сегодня»: экран «Сегодня» читает `EntryStore`. После сохранения в обход стора он сам не узнает о новой записи. Варианты: в Output передать `finished` и вызвать `entryStore.loadToday()` в координаторе (просто) или сделать так, чтобы `EntryRepository` публиковал изменения через `AsyncStream`, а стор на него подписывался (правильнее, хорошая практика конкурентности). Для начала первый вариант.

### Тесты

```swift
import Testing

@Test("Кофеин считается от объёма")
func nutrition() {
    let drink = Drink.fixture(caffeinePer100ml: 32)
    #expect(NutritionCalculator().nutrition(of: drink, volumeMl: 500).caffeineMg == 160)
}

@Test("Превышение лимита помечается", arguments: [(300.0, false), (450.0, true)])
func overLimit(existingMg: Double, expected: Bool) async throws {
    let repo = InMemoryEntryRepository(existingTodayMg: existingMg - 160)
    let sut = DefaultAddEntryUseCase(entries: repo, settings: FixedSettings(limit: 400),
                                     calculator: .init(), now: { .fixedNoon })
    let result = try await sut.execute(drink: .fixture(caffeinePer100ml: 32), volumeMl: 500, consumedAt: .fixedNoon, price: nil)
    #expect(result.isOverLimit == expected)
}

@Test func futureDateRejected() async {
    let sut = DefaultAddEntryUseCase(...)
    await #expect(throws: AddEntryError.dateInFuture) {
        try await sut.execute(drink: .fixture(), volumeMl: 500, consumedAt: .fixedNoon.addingTimeInterval(3600), price: nil)
    }
}
```

Что почувствовать на этом модуле: логика тестируется без UI и без базы; цена — больше файлов и протоколов. Use case `SearchDrinksUseCase`, скорее всего, окажется пустым пробросом в репозиторий: это нормальная плата Clean и повод подумать, нужен ли он.

---

## 2. «Настройки» на Redux

### Идея

Всё состояние экрана — одна структура `State`. Изменить её можно только отправив `Action`. Чистая функция `reduce(state, action)` меняет состояние и, если нужно, возвращает `Effect` — асинхронную работу (сеть, диск), которая по завершении отправит новый `Action`. View только читает `state` и шлёт действия.

```
View ──send(Action)──▶ Store ──▶ reduce(&State, Action) ──▶ Effect
  ▲                      │                                     │
  └────── state ─────────┘◀──────────── send(Action) ──────────┘
```

### Мини-фреймворк (общий, около 40 строк)

Можно положить в `Core/Redux`, чтобы при желании перевести на него ещё одну фичу.

```swift
public struct Effect<Action: Sendable>: Sendable {
    let run: @Sendable (_ send: @escaping @Sendable (Action) async -> Void) async -> Void

    public static var none: Self { .init { _ in } }
    public static func run(_ work: @escaping @Sendable (_ send: @escaping @Sendable (Action) async -> Void) async -> Void) -> Self {
        .init(run: work)
    }
}

public typealias Reducer<State, Action: Sendable> = (inout State, Action) -> Effect<Action>

@MainActor @Observable
public final class Store<State, Action: Sendable> {
    public private(set) var state: State
    @ObservationIgnored private let reducer: Reducer<State, Action>

    public init(initial: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initial
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        let effect = reducer(&state, action)
        Task { await effect.run { [weak self] next in await self?.send(next) } }
    }

    /// Биндинг для контролов: читаем из state, пишем через действие
    public func binding<V>(_ keyPath: KeyPath<State, V>, send action: @escaping (V) -> Action) -> Binding<V> {
        Binding(get: { self.state[keyPath: keyPath] }, set: { self.send(action($0)) })
    }
}
```

`@Observable` на сторе даёт точечные обновления: View перерисуется, только если изменилось поле `state`, которое она читала.

### State, Action, зависимости

```swift
struct SettingsState: Equatable {
    var dailyLimitMg = 400
    var account: Account = .loggedOut
    var sync: SyncStatus = .idle
    var lastSyncedAt: Date?
    var alert: String?

    enum Account: Equatable { case loggedOut, loggedIn(email: String) }
    enum SyncStatus: Equatable { case idle, syncing, failed }
}

enum SettingsAction: Sendable {
    // от пользователя
    case onAppear
    case limitChanged(Int)
    case syncTapped
    case logoutTapped
    case loginTapped
    case alertDismissed
    // результаты эффектов
    case loaded(limit: Int, email: String?, lastSync: Date?)
    case syncFinished(Result<Date, SyncError>)
    case loggedOut
}

struct SettingsEnvironment: Sendable {
    var loadSettings: @Sendable () async -> (limit: Int, email: String?, lastSync: Date?)
    var saveLimit: @Sendable (Int) async -> Void
    var sync: @Sendable () async throws(SyncError) -> Date
    var logout: @Sendable () async -> Void
    var openLogin: @MainActor @Sendable () -> Void     // навигация уходит наружу, в координатор
}
```

Зависимости — структура из замыканий, а не протоколы: так принято в Redux/TCA, и в тестах легко подменить одну функцию.

### Reducer

```swift
func settingsReducer(env: SettingsEnvironment) -> Reducer<SettingsState, SettingsAction> {
    { state, action in
        switch action {
        case .onAppear:
            return .run { send in
                let s = await env.loadSettings()
                await send(.loaded(limit: s.limit, email: s.email, lastSync: s.lastSync))
            }

        case let .loaded(limit, email, lastSync):
            state.dailyLimitMg = limit
            state.account = email.map { .loggedIn(email: $0) } ?? .loggedOut
            state.lastSyncedAt = lastSync
            return .none

        case .limitChanged(let value):
            state.dailyLimitMg = min(max(value, 50), 1000)
            let limit = state.dailyLimitMg
            return .run { _ in await env.saveLimit(limit) }

        case .syncTapped:
            guard state.sync != .syncing, case .loggedIn = state.account else { return .none }
            state.sync = .syncing
            return .run { send in
                do { await send(.syncFinished(.success(try await env.sync()))) }
                catch { await send(.syncFinished(.failure(error))) }
            }

        case .syncFinished(.success(let date)):
            state.sync = .idle
            state.lastSyncedAt = date
            return .none

        case .syncFinished(.failure):
            state.sync = .failed
            state.alert = "Не удалось синхронизироваться"
            return .none

        case .logoutTapped:
            return .run { send in await env.logout(); await send(.loggedOut) }

        case .loggedOut:
            state.account = .loggedOut
            state.lastSyncedAt = nil
            return .none

        case .loginTapped:
            return .run { _ in await env.openLogin() }

        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
}
```

Весь «сценарий» экрана читается в одном `switch`. Добавить новое поведение = новый case в `Action` и ветка в reducer; компилятор подскажет, что не обработано.

### View

```swift
struct SettingsView: View {
    @State var store: Store<SettingsState, SettingsAction>

    var body: some View {
        Form {
            Section("Дневной лимит кофеина") {
                Stepper("\(store.state.dailyLimitMg) мг",
                        value: store.binding(\.dailyLimitMg, send: SettingsAction.limitChanged),
                        step: 50)
            }
            Section("Аккаунт") {
                switch store.state.account {
                case .loggedOut: Button("Войти") { store.send(.loginTapped) }
                case .loggedIn(let email):
                    LabeledContent("Почта", value: email)
                    Button("Выйти", role: .destructive) { store.send(.logoutTapped) }
                }
            }
            Section("Синхронизация") {
                Button { store.send(.syncTapped) } label: {
                    HStack {
                        Text("Синхронизировать сейчас")
                        Spacer()
                        if store.state.sync == .syncing { ProgressView() }
                    }
                }
                if let date = store.state.lastSyncedAt {
                    LabeledContent("Последняя", value: date.formatted(.relative(presentation: .named)))
                }
            }
        }
        .navigationTitle("Настройки")
        .task { store.send(.onAppear) }
        .alert(store.state.alert ?? "", isPresented: .init(
            get: { store.state.alert != nil },
            set: { if !$0 { store.send(.alertDismissed) } })) {}
    }
}
```

### Тесты

Reducer — чистая функция, поэтому большая часть тестов не трогает асинхронность вообще:

```swift
@Test func limitIsClamped() {
    var state = SettingsState()
    _ = settingsReducer(env: .noop)(&state, .limitChanged(5000))
    #expect(state.dailyLimitMg == 1000)
}

@Test func syncIgnoredWhenLoggedOut() {
    var state = SettingsState(account: .loggedOut)
    _ = settingsReducer(env: .noop)(&state, .syncTapped)
    #expect(state.sync == .idle)
}

@Test func syncFailureShowsAlert() {
    var state = SettingsState(account: .loggedIn(email: "a@b.c"), sync: .syncing)
    _ = settingsReducer(env: .noop)(&state, .syncFinished(.failure(.network)))
    #expect(state.sync == .failed)
    #expect(state.alert != nil)
}
```

Что почувствовать на этом модуле: состояние предсказуемо и полностью видно в одном месте, любой баг воспроизводится последовательностью действий. Цена — многословность: даже `alertDismissed` требует своего действия. Это ровно то, что TCA решает макросами (`@Reducer`, `@ObservableState`, `@Bindable store`) и инструментами тестов (`TestStore`). Когда самописная версия заработает, перевести этот модуль на TCA — хороший следующий эксперимент для сравнения.

---

## 3. Как сравнивать

После того как все три подхода заработают, полезно ответить себе на вопросы на реальном коде:
- Сколько файлов и строк понадобилось на сопоставимый объём логики?
- Насколько легко было написать тесты и сколько в них моков?
- Что пришлось менять, когда добавилась новая фича (например, «повторить последнюю банку» в «Добавить» или «экспорт CSV» в «Настройках»)?
- Где проще разобраться через месяц?

Ожидаемый вывод, который стоит проверить, а не принимать на веру: MVVM — лучший баланс для большинства экранов, Clean окупается там, где правила сложнее CRUD, Redux/TCA — где много асинхронных событий и важна предсказуемость.
