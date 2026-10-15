# Buzz: архитектура клиента

Навигация на UIKit, экраны на SwiftUI, приложение режется на модули так, чтобы в любую фичу можно было подставить новый подход и сравнить. Экраны и графики описаны в [screens.md](screens.md), основы SwiftUI в [README.md](README.md).

> Офлайн-синхронизация: [sync.md](sync.md). Локализация (ru + en): [localization.md](localization.md). Русские строки в примерах ниже — для наглядности, в коде это ключи String Catalog.

---

## 1. Про навигацию в SwiftUI честно

С iOS 16 `NavigationStack(path:)` закрыл большую часть старых проблем `NavigationView`: программный пуш, pop to root и диплинки теперь работают. Что болит до сих пор:
- **Время жизни модели экрана.** SwiftUI может пересоздать View, и модель, созданная не в `@State`, теряется. Легко получить двойную загрузку или сброс состояния.
- **Модалки поверх модалок и навигация из глубины.** Каждая `.sheet` привязана к своей View, и открыть шит «откуда угодно» без общего роутера неудобно.
- **Мало контроля.** Свои переходы, перехват свайпа назад, скрытый навбар с рабочим жестом назад, поведение при повторном тапе на вкладку: в UIKit это пара строк, в SwiftUI это обходные пути.
- **Баги разных версий iOS** с `navigationDestination` внутри ленивых контейнеров и в обёртках.

Гибрид «UIKit держит навигацию, SwiftUI рисует экраны» — нормальный промышленный вариант, так живут многие большие приложения. Для тебя у него ещё бонус: координаторы уже знакомы, и новое учишь по одному слою за раз.

Чтобы не закрыть дверь в нативную навигацию, экраны не знают, кто их показывает: они сообщают «пользователь хочет X» наружу. Тогда одну вкладку позже можно перевести на `NavigationStack` и сравнить (см. раздел 7).

---

## 2. Какие архитектуры бывают под SwiftUI

| Подход | Суть | Плюсы | Минусы | Когда брать |
|---|---|---|---|---|
| **MV** («как у Apple») | View + `@Observable` сервисы/сторы в `environment`, `@Query` прямо во View | Минимум кода, максимум возможностей SwiftUI | Логику трудно тестировать, View разрастается, жёсткая связь с SwiftData | Маленькие приложения, прототипы |
| **MVVM на @Observable** | У экрана своя модель с состоянием и действиями, View только рисует | Знакомо после UIKit, тестируется, Observation даёт точечные обновления | Риск «модель на каждую кнопку», нужно решить, кто владеет моделью | Основной выбор для большинства приложений |
| **MVVM + Coordinator** | То же, плюс навигацией управляют координаторы | Экраны независимы, навигация в одном месте, диплинки | Больше кода на связку | Средние и большие приложения, гибрид с UIKit |
| **Clean Architecture** (слоями) | View → ViewModel → UseCase → Repository → DataSource | Чёткие границы, легко менять источники данных | Много церемоний, в маленьком приложении UseCase часто пустой проброс | Большие команды и сложная бизнес-логика |
| **TCA** (The Composable Architecture) | Однонаправленный поток: State, Action, Reducer, Effects, Store | Предсказуемо, отличные тесты, навигация как состояние | Сторонняя зависимость, высокий порог, своя экосистема | Когда важна тестируемость всего и команда готова к фреймворку |
| **Redux-подобный самописный** | Единый стор + reducer без TCA | Понимаешь, как устроен TCA изнутри | Всё пишешь сам | Как учебный эксперимент |
| VIPER | Пять сущностей на экран | Строгое разделение | Против природы SwiftUI, огромный бойлерплейт | Не советую для нового SwiftUI-кода |

---

## 3. Что выбираю для Buzz

**MVVM на `@Observable` + координаторы на UIKit + репозитории + модули на SPM.**

```
┌──────────────── App (таргет приложения) ────────────────┐
│ SceneDelegate → AppCoordinator (UITabBarController)      │
│   ├─ TodayCoordinator     (UINavigationController)       │
│   ├─ CatalogCoordinator   (UINavigationController)       │
│   ├─ StatsCoordinator     (UINavigationController)       │
│   └─ SettingsCoordinator  (UINavigationController)       │
│ AppDependencies: собирает репозитории, сторы, API        │
└──────────────────────────────────────────────────────────┘
         │ создаёт UIHostingController(rootView:)
┌──────── Feature-модули (SwiftUI) ────────┐
│ TodayFeature  AddEntryFeature  CatalogFeature                │
│ StatsFeature  SettingsFeature                                │
│   View + ViewModel (@Observable) + Output (замыкания)       │
└──────────────────────────────────────────┘
         │ зависят только от протоколов
┌──────── Core-модули ─────────────────────┐
│ Domain       модели Drink/Entry, протоколы репозиториев      │
│ Persistence  SwiftData-реализации репозиториев               │
│ Networking   APIClient, DTO из Shared                        │
│ DesignSystem цвета, шрифты, CaffeineRing, DrinkCard          │
└──────────────────────────────────────────┘
```

Правила, которые делают это масштабируемым:
1. **Фичи не знают друг о друге.** «Сегодня» не импортирует «Добавить». Переход «нажали +» уходит наружу как событие, координатор решает, что показать.
2. **Фичи не знают про UIKit и SwiftData.** Они видят `Domain` (структуры и протоколы). Значит, их можно показать в `NavigationStack`, в виджете или в превью с фейками.
3. **Зависимости приходят через `init`.** Никаких синглтонов: один контейнер `AppDependencies` в App-таргете.
4. **Общее состояние — `@Observable` стор.** Записи живут в `EntryStore`; «Сегодня» и «Статистика» читают его, Observation сам обновляет оба экрана после добавления банки.

---

## 4. Модули на SPM

Один локальный пакет `BuzzKit` рядом с `.xcodeproj` (File → Add Package Dependencies → Add Local) и общий с бэкендом `Shared`.

```swift
// BuzzKit/Package.swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BuzzKit",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Persistence", targets: ["Persistence"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "TodayFeature", targets: ["TodayFeature"]),
        .library(name: "AddEntryFeature", targets: ["AddEntryFeature"]),
        .library(name: "CatalogFeature", targets: ["CatalogFeature"]),
        .library(name: "StatsFeature", targets: ["StatsFeature"]),
        .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    ],
    dependencies: [.package(path: "../backend/skeleton/Shared")],
    targets: [
        .target(name: "Domain"),
        .target(name: "Persistence", dependencies: ["Domain"]),
        .target(name: "Networking", dependencies: ["Domain", .product(name: "Shared", package: "Shared")]),
        .target(name: "DesignSystem"),
        .target(name: "TodayFeature", dependencies: ["Domain", "DesignSystem"]),
        .target(name: "AddEntryFeature", dependencies: ["Domain", "DesignSystem"]),
        .target(name: "CatalogFeature", dependencies: ["Domain", "DesignSystem"]),
        .target(name: "StatsFeature", dependencies: ["Domain", "DesignSystem"]),
        .target(name: "SettingsFeature", dependencies: ["Domain", "DesignSystem"]),
        .testTarget(name: "TodayFeatureTests", dependencies: ["TodayFeature"]),
        .testTarget(name: "StatsFeatureTests", dependencies: ["StatsFeature"]),
    ]
)
```

Плюсы: компилятор не даст фиче импортировать другую фичу; модули собираются и тестируются отдельно (`swift test` / схема на модуль); превью собираются быстрее. Путь к `Shared` поправить под то, где окажутся проекты.

Те же модули уже описаны как Tuist-проект в `iOS/Project.swift`. Если собираешь через Tuist, этот `Package.swift` не нужен, он здесь для варианта без Tuist.

Начинать можно с одного таргета приложения и папок, а на модули резать, когда заработают первые экраны. Но границы (фича видит только Domain) лучше соблюдать с первого дня.

---

## 5. Слои в коде

### Domain: простые типы и протоколы

```swift
// Domain
public struct Drink: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var brand, name: String
    public var volumeMl: Int
    public var caffeinePer100ml, sugarPer100ml: Double
    public var isCustom: Bool
}

public struct Entry: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var drinkId: UUID, brand: String, drinkName: String
    public var consumedAt: Date, volumeMl: Int, price: Decimal?
    public var caffeineMg, sugarG: Double
}

public protocol EntryRepository: Sendable {
    func entries(from: Date, to: Date) async throws -> [Entry]
    func add(_ entry: Entry) async throws
    func delete(id: UUID) async throws
}

public protocol DrinkRepository: Sendable {
    func all() async throws -> [Drink]
    func add(_ drink: Drink) async throws
}
```

Это ответ на вопрос «где SwiftData»: только в `Persistence`, за протоколом. Фичи работают со структурами `Entry`, а не с `@Model`. Цена: теряем удобный `@Query` во View. Взамен: тестируемость, `Sendable`-данные, возможность заменить хранилище или подставить сеть.

### Persistence: SwiftData за протоколом

```swift
// Persistence
@ModelActor
public actor SwiftDataEntryRepository: EntryRepository {
    public func entries(from: Date, to: Date) async throws -> [Entry] {
        let d = FetchDescriptor<EntryModel>(
            predicate: #Predicate { $0.consumedAt >= from && $0.consumedAt < to && $0.deletedAt == nil },
            sortBy: [SortDescriptor(\.consumedAt, order: .reverse)])
        return try modelContext.fetch(d).map(\.asDomain)
    }
    public func add(_ entry: Entry) async throws {
        modelContext.insert(EntryModel(entry)); try modelContext.save()
    }
    public func delete(id: UUID) async throws { /* deletedAt = .now; save */ }
}
```

`@ModelActor` даёт свой `ModelContext` на фоне: заодно практика акторов из Swift Concurrency.

### Стор: общее состояние для нескольких экранов

```swift
// Domain (или отдельный модуль Stores)
@MainActor @Observable
public final class EntryStore {
    public private(set) var today: [Entry] = []
    @ObservationIgnored private let repo: EntryRepository

    public init(repo: EntryRepository) { self.repo = repo }

    public func loadToday() async throws {
        let start = Calendar.current.startOfDay(for: .now)
        today = try await repo.entries(from: start, to: start.addingTimeInterval(86_400))
    }
    public func add(_ e: Entry) async throws { try await repo.add(e); try await loadToday() }
    public func delete(_ id: UUID) async throws { try await repo.delete(id: id); try await loadToday() }
}
```

### Feature: ViewModel + View + Output

```swift
// TodayFeature
@MainActor @Observable
public final class TodayViewModel {
    public struct Output {
        public var addTapped: () -> Void
        public var entryTapped: (Entry) -> Void
        public init(addTapped: @escaping () -> Void, entryTapped: @escaping (Entry) -> Void) { ... }
    }

    @ObservationIgnored private let store: EntryStore
    @ObservationIgnored private let output: Output
    public let limit: Int

    public init(store: EntryStore, limit: Int, output: Output) { ... }

    var entries: [Entry] { store.today }                       // Observation отследит store.today
    var caffeine: Double { entries.reduce(0) { $0 + $1.caffeineMg } }
    var isOverLimit: Bool { caffeine > Double(limit) }

    func onAppear() async { try? await store.loadToday() }
    func addTapped() { output.addTapped() }
    func delete(_ e: Entry) async { try? await store.delete(e.id) }
}

public struct TodayView: View {
    @State private var model: TodayViewModel
    public init(model: TodayViewModel) { _model = State(initialValue: model) }

    public var body: some View {
        List { ... }
            .task { await model.onAppear() }
            .toolbar { Button("Добавить", systemImage: "plus") { model.addTapped() } }
            .navigationTitle("Сегодня")
    }
}
```

ViewModel создаёт координатор и держит его через хостинг, поэтому проблема «SwiftUI пересоздал View и потерял модель» уходит: `UIHostingController` живёт, пока экран в стеке.

---

## 6. Навигация: координаторы на UIKit

```swift
// App
@MainActor
protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    func start()
}

@MainActor
final class AppCoordinator {
    let tabBar = UITabBarController()
    private let deps: AppDependencies
    private var children: [Coordinator] = []

    init(deps: AppDependencies) { self.deps = deps }

    func start() {
        children = [TodayCoordinator(deps: deps), CatalogCoordinator(deps: deps),
                    StatsCoordinator(deps: deps), SettingsCoordinator(deps: deps)]
        children.forEach { $0.start() }
        tabBar.viewControllers = children.map(\.rootViewController)
    }
}
```

```swift
@MainActor
final class TodayCoordinator: Coordinator {
    private let nav = UINavigationController()
    private let deps: AppDependencies
    var rootViewController: UIViewController { nav }

    init(deps: AppDependencies) {
        self.deps = deps
        nav.tabBarItem = UITabBarItem(title: "Сегодня", image: UIImage(systemName: "bolt.fill"), tag: 0)
        nav.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let model = TodayViewModel(
            store: deps.entryStore,
            limit: deps.settings.dailyLimit,
            output: .init(
                addTapped: { [weak self] in self?.showAddEntry() },
                entryTapped: { [weak self] in self?.showEntry($0) }))
        nav.setViewControllers([deps.host(TodayView(model: model))], animated: false)
    }

    private func showAddEntry() {
        let model = AddEntryViewModel(drinks: deps.drinkRepo, store: deps.entryStore,
                                      output: .init(finished: { [weak self] in self?.nav.dismiss(animated: true) }))
        let vc = deps.host(AddEntryView(model: model))
        vc.sheetPresentationController?.detents = [.medium(), .large()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        nav.present(vc, animated: true)
    }

    private func showEntry(_ e: Entry) {
        nav.pushViewController(deps.host(EntryDetailView(entry: e)), animated: true)
    }
}
```

Контейнер зависимостей и одна важная деталь про хостинг:

```swift
@MainActor
final class AppDependencies {
    let container: ModelContainer
    let entryRepo: EntryRepository
    let drinkRepo: DrinkRepository
    let entryStore: EntryStore
    let settings: SettingsStore

    init() throws {
        container = try ModelContainer(for: EntryModel.self, DrinkModel.self)
        entryRepo = SwiftDataEntryRepository(modelContainer: container)
        drinkRepo = SwiftDataDrinkRepository(modelContainer: container)
        entryStore = EntryStore(repo: entryRepo)
        settings = SettingsStore()
    }

    /// Каждый UIHostingController — отдельный корень SwiftUI, environment сам не протекает между ними.
    /// Всё общее для экранов прокидываем здесь, в одном месте.
    func host<V: View>(_ view: V) -> UIHostingController<some View> {
        UIHostingController(rootView: view.environment(settings).tint(.green))
    }
}
```

```swift
// SceneDelegate
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
    guard let ws = scene as? UIWindowScene else { return }
    let deps = try! AppDependencies()
    let app = AppCoordinator(deps: deps)
    app.start()
    window = UIWindow(windowScene: ws)
    window?.rootViewController = app.tabBar
    window?.makeKeyAndVisible()
    self.appCoordinator = app
}
```

Тонкости гибрида, на которых спотыкаются:
- `.navigationTitle` и `.toolbar` из SwiftUI попадают в `navigationItem` хостинг-контроллера, когда он лежит в `UINavigationController` (iOS 16+). Если где-то заголовок не подхватился, задай `vc.title` в координаторе.
- Не используй внутри хостинга `NavigationStack`: получится навбар в навбаре. Хочешь стек внутри одной фичи — это и есть эксперимент из раздела 7, только тогда эта вкладка целиком на SwiftUI.
- `.sheet` внутри SwiftUI-экрана работать будет, но тогда половина модалок в UIKit, половина в SwiftUI. Правило: всё, что меняет экран, идёт через Output в координатор; локальные алерты и `confirmationDialog` остаются в SwiftUI.
- Размер хостинга в ячейках и `sizingOptions = .preferredContentSize` нужны, только если встраиваешь SwiftUI внутрь UIKit-экрана; для целых экранов не нужно.
- Диплинк `buzz://add`: `AppCoordinator.handle(url)` выбирает вкладку и вызывает `todayCoordinator.showAddEntry()`.

---

## 7. Buzz как полигон: что пробовать и где

**Уже решено:** «Добавить» делаем на Clean Architecture, «Настройки» на самописном Redux, остальные фичи на MVVM. Подробности и код в [architecture-experiments.md](architecture-experiments.md).

Архитектура выше позволяет менять одну фичу, не трогая остальные. Идеи экспериментов по порядку сложности:

| Эксперимент | Где | Чему учит |
|---|---|---|
| Вкладка «Статистика» целиком на `NavigationStack(path:)` вместо координатора | `StatsCoordinator` возвращает один хостинг с `NavigationStack` внутри | Сравнить нативную навигацию с UIKit на одном приложении |
| `@Query` прямо во View в одной фиче (MV-подход) | «Каталог» | Понять, когда MV проще MVVM и где он упирается |
| Перевести «Настройки» с самописного Redux на TCA | «Настройки» | Однонаправленный поток, тесты reducer-ов, сравнение с MVVM |
| Фоновая синхронизация через `BGAppRefreshTask` | Sync | Фоновые задачи iOS |
| Тесты ViewModel на Swift Testing с фейковыми репозиториями | все фичи | `@Test`, `#expect`, параметризованные тесты |
| Snapshot-тесты экранов | DesignSystem | Регресс UI |
| Виджет и Live Activity на тех же `Domain` + `Persistence` | новый таргет | Переиспользование модулей, App Groups |
| Зум-переход из каталога в деталь | `.matchedTransitionSource` + `.navigationTransition(.zoom)` (в SwiftUI-вкладке) или кастомный `UIViewControllerAnimatedTransitioning` (в UIKit) | Сравнить анимации переходов в двух мирах |

---

## 8. Порядок

1. App-таргет на UIKit (`SceneDelegate`, `AppCoordinator`, четыре пустых хостинга во вкладках).
2. `Domain` и `Persistence` с SwiftData за протоколами, сид каталога.
3. «Сегодня» и «Добавить» через координатор, `EntryStore` связывает их.
4. «Каталог», «Статистика», «Настройки».
5. Выделение модулей в `BuzzKit`, если начинал с папок.
6. Эксперименты из раздела 7 по одному.

Что меняется в [screens.md](screens.md): вёрстка экранов и графики те же, но вместо `TabView` и `NavigationStack` навигацию держат координаторы, а вместо `@Query` во View данные приходят из ViewModel через сторы.
