# Конспект нового стека: сделай сам

Карточки по всему новому, что уже есть в проекте Buzz: инструменты, фреймворки и подходы. Конспект пополняется сам, когда в ветках проекта появляется новый инструмент, подход или код. Можно и вручную: напиши «обнови конспект» в ветке «Конспект нового стека». В конце файла журнал изменений.

**Как читать карточку.** В каждой одно и то же:
- **Что и зачем.** Одной-двумя фразами.
- **Было → стало.** Что это заменяет из UIKit-стека.
- **Руками.** Короткая инструкция: шаги в пустой песочнице и минимальный пример на игрушечном коде (счётчик, `Item`), чтобы понять инструмент отдельно от Buzz.
- **Разобрать в Buzz.** Что посмотреть и попробовать поправить в коде Buzz. Код пишут ветки проекта, а ты потом изучаешь и правишь его сам; эта строка подсказывает, на что смотреть.
- **Код в Buzz**: файлы и строки, где это используется. Пути от корня репозитория Buzz (`iOS/`, `Backend/`, `Shared/`, `Mocks/`, `docs/`). Пока репозиторий не опубликован, его копия лежит в проекте как git bundle: `git clone /mnt/project-files/repo/buzz.bundle buzz`.
- **Описание** и **документация**: документ проекта в `docs/` и официальная документация.

Видео WWDC по темам собраны в [plan.md](plan.md), здесь только ссылки на документацию.

Отмечай `[x]`, когда прошёл карточку руками и разобрал это место в коде Buzz.

---

## Оглавление и прогресс

**A. Язык и конкурентность**
- [ ] A1. async/await и Task
- [ ] A2. Structured concurrency: async let и группы задач
- [ ] A3. actor, @MainActor, Sendable и Swift 6
- [ ] A4. AsyncStream и AsyncSequence
- [ ] A5. Мост со старым кодом: continuation
- [ ] A6. Typed throws
- [ ] A7. Макросы

**B. Интерфейс на SwiftUI**
- [ ] B1. Мышление SwiftUI: UI как функция от состояния
- [ ] B2. Observation (@Observable)
- [ ] B3. Поток данных: @State, @Binding, @Bindable, @Environment, @Entry
- [ ] B4. Списки и сетки вместо Diffable + CompositionalLayout
- [ ] B5. Жизненный цикл: .task, .task(id:), debounce без Combine
- [ ] B6. Готовые модификаторы: searchable, refreshable, ContentUnavailableView
- [ ] B7. Формы и ввод: Form, TextField(value:format:), @FocusState
- [ ] B8. Навигация: NavigationStack, TabView, sheet
- [ ] B9. Анимации, переходы и хаптики
- [ ] B10. Swift Charts
- [ ] B11. #Preview
- [ ] B12. SwiftUI внутри UIKit и наоборот
- [ ] B13. Дизайн-токены, системные цвета, tint

**C. Данные и сеть**
- [ ] C1. Сетевой слой на URLSession async/await
- [ ] C2. SwiftData
- [ ] C3. @ModelActor: SwiftData в фоне
- [ ] C4. Offline-first синхронизация (outbox)
- [ ] C5. NWPathMonitor и триггеры синхронизации
- [ ] C6. @AppStorage и Keychain
- [ ] C7. Моки и фейковый сервер (BUZZ_MOCK_API)

**D. Локализация**
- [ ] D1. String Catalog и плюрализация
- [ ] D2. Строки в модулях: bundle .module и генерация символов
- [ ] D3. FormatStyle и Measurement

**E. Архитектура**
- [ ] E1. MVVM на @Observable
- [ ] E2. Координаторы + UIHostingController (гибрид)
- [ ] E3. Clean Architecture в одной фиче
- [ ] E4. Самописный Redux (и потом TCA)
- [ ] E5. Модули: фичи видят только Domain

**F. Тесты**
- [ ] F1. Swift Testing

**G. Сервер на Swift**
- [ ] G1. Vapor: сервер как долгоживущий процесс
- [ ] G2. Роуты, контроллеры, Content
- [ ] G3. Fluent: модели, миграции, запросы
- [ ] G4. Авторизация по bearer-токену
- [ ] G5. Ошибки кодами и свой middleware
- [ ] G6. Общий пакет Shared с DTO
- [ ] G7. Тесты Vapor (VaporTesting)
- [ ] G8. Postgres в Docker и деплой

**H. Инфраструктура**
- [ ] H1. Tuist: проект как код
- [ ] H2. mise: версии инструментов и задачи
- [ ] H3. fastlane, match, App Store Connect API key
- [ ] H4. GitHub Actions
- [ ] H5. swift-format, SwiftLint, pre-commit
- [ ] H6. Renovate

---

# A. Язык и конкурентность

## A1. async/await и Task

**Что и зачем.** Асинхронный код пишется сверху вниз, как синхронный. `await` — точка, где функция может приостановиться и отдать поток. Отмена и ошибки работают через обычные `throws`.

**Было → стало.** completion handler, `DispatchQueue.main.async`, «пирамида» колбэков → `async throws` функции, `try await`, `Task {}`.

**Руками.**
1. Напиши функцию с `async throws` и вызови её из другой `async` функции через `try await`.
2. Из синхронного места (кнопка, `viewDidLoad`) запусти её в `Task { ... }`.
3. Сохрани `Task` в переменную, вызови `task.cancel()` и проверь `Task.isCancelled` / `try Task.checkCancellation()` внутри.
4. Попробуй `try await Task.sleep(for: .seconds(1))` и отмени задачу во время сна: сон бросит `CancellationError`.

```swift
func slowNumber() async throws -> Int {
    try await Task.sleep(for: .seconds(1))
    return 42
}

let task = Task {
    do { print(try await slowNumber()) }
    catch { print("отменено: \(error)") }
}
task.cancel()
```

**Разобрать в Buzz.** Метод загрузки каталога напитков `async throws`, вызываемый из ViewModel.

**Документация.** [Swift Book: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [Task](https://developer.apple.com/documentation/swift/task)

**Код в Buzz.** `iOS/Modules/Networking/Sources/APIClient.swift:37` (`send` на async/await), обработчики `Backend/Sources/App/Controllers/EntryController.swift`.

**Описание.** `docs/client/README.md`, раздел 4 (сеть); весь бэкенд (`docs/backend/README.md`, раздел 7).

---

## A2. Structured concurrency: async let и группы задач

**Что и зачем.** Параллельный запуск нескольких дочерних задач, которые гарантированно завершатся (или отменятся) вместе с родителем.

**Было → стало.** `DispatchGroup` + `enter/leave/notify` → `async let` для фиксированного числа задач, `withThrowingTaskGroup` для динамического.

**Руками.**
1. Напиши две `async` функции с разными задержками.
2. Вызови их последовательно и замерь время (`ContinuousClock().measure { }`).
3. Перепиши на `async let a = ...; async let b = ...; let (x, y) = try await (a, b)` и сравни время.
4. Для массива id сделай `withThrowingTaskGroup`, добавь `group.addTask` на каждый id и собери результаты циклом `for try await`.

```swift
let total = try await withThrowingTaskGroup(of: Int.self) { group in
    for n in 1...3 { group.addTask { try await slowNumber() + n } }
    return try await group.reduce(0, +)
}
```

**Разобрать в Buzz.** На экране статистики загрузить `/me` и `/stats` параллельно через `async let`.

**Документация.** [Swift Book: Concurrency → Calling Asynchronous Functions in Parallel](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [TaskGroup](https://developer.apple.com/documentation/swift/taskgroup)

**Код в Buzz.** в коде пока не используется; удобное место попробовать `async let`: загрузка данных в `iOS/Modules/StatsFeature/Sources/StatsViewModel.swift`.

**Описание.** `docs/learning/plan.md`, тема 1, упражнение 3.

---

## A3. actor, @MainActor, Sendable и Swift 6

**Что и зачем.** Компилятор Swift 6 сам проверяет гонки данных. `actor` защищает своё изменяемое состояние: снаружи к нему можно обратиться только через `await`. `@MainActor` — то же для главного потока. `Sendable` помечает типы, которые безопасно передавать между потоками.

**Было → стало.** серийные очереди, `NSLock`, «не забудь вернуться на main» → `actor`, `@MainActor` на типе, ошибки компиляции вместо крашей в рантайме.

**Swift 6.2 (Xcode 26).** В новых проектах включены «Default Actor Isolation = MainActor» и «Approachable Concurrency»: код по умолчанию живёт на главном акторе, а с него уходят явно через `@concurrent` или `nonisolated`.

**Руками.**
1. В Build Settings найди Swift Language Version, Default Actor Isolation, Approachable Concurrency и посмотри, что включено.
2. Напиши `class Counter { var value = 0 }` и вызови `increment()` из 1000 задач в `TaskGroup`. Посмотри на ошибку компилятора.
3. Замени `class` на `actor`, исправь вызовы на `await counter.increment()`.
4. Сделай struct с `let`-полями и пометь `Sendable`; затем добавь в неё поле-класс и прочитай ошибку.
5. Пометь свою ViewModel `@MainActor` и убедись, что `await api.load()` внутри неё не требует ручного возврата на main.

```swift
actor Counter {
    private(set) var value = 0
    func increment() { value += 1 }
}
```

**Разобрать в Buzz.** `actor`-кэш картинок банок: две параллельные загрузки одного URL должны дать один сетевой запрос (храни `Task` в словаре). Потом `actor SyncEngine` (см. C4).

**Документация.** [Swift Book: Actors](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors), [Swift 6 migration guide](https://www.swift.org/migration/documentation/migrationguide/), [Sendable](https://developer.apple.com/documentation/swift/sendable)

**Код в Buzz.** `actor SyncEngine` в `iOS/Modules/Sync/Sources/SyncEngine.swift:12`, `actor SyncStore` в `iOS/Modules/Sync/Sources/SyncStore.swift:12`, `actor KeychainTokenStore` в `iOS/Modules/Networking/Sources/TokenStore.swift:17`, `@MainActor` ViewModel в `iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`, `Sendable`-класс `iOS/Modules/Domain/Sources/Broadcaster.swift:12`.

**Описание.** Все ViewModel `@MainActor` (`docs/client/architecture.md`, раздел 5); `actor SyncEngine` (`docs/client/sync.md`); модели Fluent `@unchecked Sendable` (`docs/backend/README.md`, раздел 7); Swift 6 strict на весь проект (`docs/infra/README.md`, раздел 3).

---

## A4. AsyncStream и AsyncSequence

**Что и зачем.** Поток значений во времени, который читается циклом `for await`. Покрывает большую часть сценариев Combine: подписка на изменения, события, статусы.

**Было → стало.** `PassthroughSubject` / `NotificationCenter` / делегаты → `AsyncStream` + `for await`.

**Руками.**
1. Создай стрим через `let (stream, continuation) = AsyncStream.makeStream(of: Int.self)`.
2. В одной задаче читай `for await x in stream { print(x) }`.
3. В другой вызывай `continuation.yield(1)`, `yield(2)`, потом `continuation.finish()`. Убедись, что цикл завершился.
4. Отмени читающую задачу до `finish()` и посмотри, что цикл тоже выходит.

```swift
let (stream, cont) = AsyncStream.makeStream(of: String.self)
Task { for await s in stream { print(s) } }
cont.yield("привет"); cont.finish()
```

**Разобрать в Buzz.** У репозитория записей `changes: AsyncStream<Void>`, на который подписан стор экрана «Сегодня»: добавил запись в шите — список обновился без координатора. Плюс `status: AsyncStream<SyncStatus>` у `SyncEngine`.

**Документация.** [AsyncStream](https://developer.apple.com/documentation/swift/asyncstream), [AsyncSequence](https://developer.apple.com/documentation/swift/asyncsequence)

**Код в Buzz.** `iOS/Modules/Sync/Sources/NetworkMonitor.swift:28` (колбэк → `AsyncStream`), `iOS/Modules/Sync/Sources/SyncEngine.swift:48` и `:63`, `iOS/Modules/Domain/Sources/Broadcaster.swift:12` (один источник, много подписчиков).

**Описание.** `docs/client/sync.md`, разделы 2–3 и 5.

---

## A5. Мост со старым кодом: continuation

**Что и зачем.** Обернуть API на колбэках в `async`-функцию.

**Было → стало.** колбэк остаётся внутри, наружу торчит `async`.

**Руками.**
1. Возьми любую функцию с completion handler (или напиши свою с `DispatchQueue.asyncAfter`).
2. Оберни: `try await withCheckedThrowingContinuation { cont in old { result in cont.resume(with: result) } }`.
3. Специально вызови `resume` дважды и посмотри на краш в debug: checked-версия ловит эту ошибку.

**Разобрать в Buzz.** Если понадобится системный API без async-версии (например, запрос разрешения), оберни его так.

**Документация.** [withCheckedThrowingContinuation](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(isolation:function:_:))

**Код в Buzz.** `withCheckedContinuation` в коде нет; похожий мост «колбэк → async» сделан через `AsyncStream` в `iOS/Modules/Sync/Sources/NetworkMonitor.swift:7`.

**Описание.** `docs/learning/plan.md`, тема 1.

---

## A6. Typed throws

**Что и зачем.** Функция может объявить конкретный тип ошибки: `throws(SyncError)`. Тогда в `catch` сразу `SyncError`, без приведения типов.

**Было → стало.** `throws` + `catch let e as MyError` → `throws(MyError)`.

**Руками.**
1. Объяви `enum ParseError: Error { case empty, notNumber }`.
2. Напиши `func parse(_ s: String) throws(ParseError) -> Int`.
3. В `do { } catch { }` проверь, что `error` уже имеет тип `ParseError` (поставь `switch error` без `default`).

**Разобрать в Buzz.** Зависимость `sync` в Redux-окружении «Настроек» объявлена как `throws(SyncError)`.

**Документация.** [SE-0413 Typed throws](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md), [Swift Book: Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)

**Код в Buzz.** `throws(APIError)` в `iOS/Modules/Networking/Sources/APIClient.swift:19`, use case в `iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:10`.

**Описание.** `docs/client/architecture-experiments.md`, раздел 2 (`SettingsEnvironment`).

---

## A7. Макросы

**Что и зачем.** `@Observable`, `@Model`, `#Predicate`, `#Preview`, `@Test`, `#expect`, `@Entry` — всё это макросы, которые генерируют код при компиляции. Понимание того, во что они раскрываются, помогает читать ошибки.

**Было → стало.** ручной бойлерплейт, кодогенерация Sourcery → макросы в языке.

**Руками.**
1. Поставь курсор на `@Observable` в своей модели → правый клик → **Expand Macro**. Посмотри на `_$observationRegistrar` и `access/withMutation`.
2. То же для `@Model` и `#Predicate`.
3. По желанию: File → New → Package → шаблон **Swift Macro**, напиши макрос `#URL("...")`, который проверяет строку при компиляции.

**Разобрать в Buzz.** Раскрыть `@Observable` у `TodayViewModel` и `@Model` у `EntryModel`, понять, что сгенерировано. Свой макрос `#URL` для базового адреса API.

**Документация.** [Swift Book: Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/), [swift-syntax](https://github.com/swiftlang/swift-syntax)

**Код в Buzz.** `@Observable` в `iOS/Modules/Domain/Sources/EntryStore.swift:13`, `@Model` в `iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`, `#Predicate` в `iOS/Modules/Sync/Sources/SyncStore.swift:48`; что генерирует `@ModelActor`, расписано руками в `iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:10`.

**Описание.** `docs/learning/plan.md`, тема 8.

---

# B. Интерфейс на SwiftUI

## B1. Мышление SwiftUI: UI как функция от состояния

**Что и зачем.** View — лёгкое значение (`struct`), которое описывает, как выглядит экран при текущем состоянии. Поменял состояние — SwiftUI сам пересчитал разницу и обновил экран.

**Было → стало.** `reloadData`, `apply(snapshot)`, ручное обновление лейблов → меняешь данные, `body` вызывается заново. Идентичность элементов (как item identifiers в Diffable) остаётся ключевой: `Identifiable`, `id:`.

**Руками.**
1. Новый проект: App, интерфейс SwiftUI, Swift 6.
2. Сделай `@State private var count = 0`, `Text("\(count)")` и `Button("+1") { count += 1 }`. Обрати внимание: обновлять `Text` руками не нужно.
3. Поменяй порядок модификаторов `.padding().background(.yellow)` и `.background(.yellow).padding()` и посмотри разницу.
4. Сделай `ForEach` по массиву структур без `Identifiable`, получи ошибку, исправь через `id: \.self` и потом через `Identifiable`. Подумай, почему `id = UUID()` в инициализаторе модели ломает анимации (та же проблема, что в Diffable).

**Разобрать в Buzz.** Пустое приложение с одним экраном «Сегодня»: статический список и число кофеина.

**Документация.** [SwiftUI](https://developer.apple.com/documentation/swiftui), [Туториалы SwiftUI](https://developer.apple.com/tutorials/swiftui)

**Код в Buzz.** `iOS/Modules/TodayFeature/Sources/TodayView.swift`, `Identifiable`-модели в `iOS/Modules/Domain/Sources/Models/Entry.swift`.

**Описание.** `docs/client/README.md`, раздел 6 (таблица UIKit → SwiftUI).

---

## B2. Observation (@Observable)

**Что и зачем.** Класс, помеченный `@Observable`, сам сообщает UI, какие свойства изменились. View перерисовывается, только если прочитала изменившееся свойство.

**Было → стало.** `ObservableObject` + `@Published` + `@StateObject`/`@ObservedObject` (и Combine) → `@Observable` + `@State`/обычный параметр/`@Bindable`. В iOS 26 UIKit тоже автоматически отслеживает `@Observable` в `viewWillLayoutSubviews` и `updateProperties()`.

**Руками.**
1. Напиши `@Observable final class CounterModel { var count = 0; var title = "" }`.
2. Во View держи её как `@State private var model = CounterModel()`.
3. Поставь `let _ = Self._printChanges()` в `body` и убедись, что изменение `title` не перерисовывает View, которая читает только `count`.
4. Пометь зависимость (сервис) `@ObservationIgnored`, чтобы она не отслеживалась.
5. Передай модель в дочернюю View обычным `let model: CounterModel`, а там, где нужен `$`-биндинг, объяви `@Bindable var model`.

**Разобрать в Buzz.** `TodayViewModel` на `@Observable` с вычисляемыми `caffeine` и `isOverLimit`.

**Документация.** [Observation](https://developer.apple.com/documentation/observation), [Миграция с ObservableObject](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)

**Код в Buzz.** `iOS/Modules/Domain/Sources/EntryStore.swift:13`, `iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`, `iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:7`.

**Описание.** `docs/client/README.md`, раздел 2; `docs/client/architecture.md`, раздел 5.

---

## B3. Поток данных: @State, @Binding, @Bindable, @Environment, @Entry

**Что и зачем.** Кто владеет данными и как их передать вниз.

| Обёртка | Когда |
|---|---|
| `@State` | View владеет значением или `@Observable`-моделью |
| `@Binding` | дочерней View нужно читать и писать чужое значение |
| `@Bindable` | нужен `$`-биндинг к полю `@Observable`-модели |
| `@Environment(Type.self)` | общая `@Observable`-модель для всего поддерева |
| `@Environment(\.key)` + `@Entry` | общий сервис или настройка (APIClient, лимит) |

**Было → стало.** проброс через инициализаторы и делегаты, синглтоны → окружение.

**Руками.**
1. Сделай `ToggleRow(isOn: Binding<Bool>)` и передай в неё `$flag` из родителя.
2. Добавь ключ окружения: `extension EnvironmentValues { @Entry var greeting = "Привет" }`, прочитай его через `@Environment(\.greeting)`, подмени через `.environment(\.greeting, "Hi")`.
3. Положи `@Observable`-объект через `.environment(obj)` и прочитай `@Environment(MyObj.self)`.

**Разобрать в Buzz.** `APIClient` положить в окружение через `@Entry` и подменять фейком в превью.

**Документация.** [Model data](https://developer.apple.com/documentation/swiftui/model-data), [Entry()](https://developer.apple.com/documentation/swiftui/entry())

**Код в Buzz.** биндинг в `@Observable` `$model.query` в `iOS/Modules/CatalogFeature/Sources/CatalogView.swift:45`; зависимости через `init` из `iOS/App/Sources/AppDependencies.swift:13` (`@Entry` в коде не используется).

**Описание.** `docs/client/README.md`, разделы 2 и 4.

---

## B4. Списки и сетки вместо Diffable + CompositionalLayout

**Что и зачем.** Большинство экранов со списками и сетками собирается из `List`, `LazyVStack`, `LazyVGrid` и `ScrollView`.

**Было → стало.**
- `UICollectionView` + `DiffableDataSource` → `List` / `ForEach` по `Identifiable`, дифф считает SwiftUI.
- Секции CompositionalLayout → `Section` в `List`.
- Колонки от ширины экрана (`NSCollectionLayoutGroup`) → `GridItem(.adaptive(minimum:))`.
- `orthogonalScrollingBehavior` → `ScrollView(.horizontal) { LazyHStack }` + `.scrollTargetBehavior(.viewAligned)`.
- `CellRegistration` → обычная View.

**Руками.**
1. `List` из 20 элементов с двумя `Section` и свайпом удаления `.onDelete`.
2. Сетка: `LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))])` внутри `ScrollView`. Поверни симулятор и посмотри, как меняется число колонок.
3. Горизонтальная карусель с `.scrollTargetLayout()` и `.scrollTargetBehavior(.viewAligned)`.

**Разобрать в Buzz.** Сетка каталога банок и горизонтальная лента «Недавние» в шите «Добавить».

**Документация.** [Lists](https://developer.apple.com/documentation/swiftui/lists), [LazyVGrid](https://developer.apple.com/documentation/swiftui/lazyvgrid), [scrollTargetBehavior](https://developer.apple.com/documentation/swiftui/view/scrolltargetbehavior(_:))

**Код в Buzz.** `LazyVGrid` в `iOS/Modules/CatalogFeature/Sources/CatalogView.swift:29`, `List` в `iOS/Modules/TodayFeature/Sources/TodayView.swift`.

**Описание.** `docs/client/screens.md`, разделы 4.1–4.3 и 5.

---

## B5. Жизненный цикл: .task, .task(id:), debounce без Combine

**Что и зачем.** `.task { }` запускает async-работу при появлении View и сам отменяет её при уходе. `.task(id: value)` перезапускает задачу при каждом изменении `value`, отменяя предыдущую.

**Было → стало.** `viewDidLoad` + ручная отмена запросов; `debounce` из Combine → `.task(id:)` + `Task.sleep`.

**Руками.**
1. Повесь `.task { await model.load() }` на экран и уйди с него во время загрузки: проверь, что задача отменилась.
2. Сделай поле поиска и `.task(id: text) { try? await Task.sleep(for: .milliseconds(300)); ... }`. Печатай в консоль, сколько раз реально выполнился поиск при быстром наборе.
3. Попробуй `.onChange(of: value, initial: true) { }` для синхронной реакции.

**Разобрать в Buzz.** Поиск по каталогу с debounce 300 мс.

**Документация.** [task(id:priority:_:)](https://developer.apple.com/documentation/swiftui/view/task(id:priority:_:)), [onChange](https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:))

**Код в Buzz.** debounce в `iOS/Modules/CatalogFeature/Sources/CatalogView.swift:47` и `iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:35`, автоскрытие снека в `iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:70`.

**Описание.** `docs/client/screens.md`, раздел 4.3.

---

## B6. Готовые модификаторы: searchable, refreshable, ContentUnavailableView

**Было → стало.**
- `UISearchController` → `.searchable(text: $query)`.
- `UIRefreshControl` + target/action → `.refreshable { await reload() }` (индикатор крутится, пока функция не вернётся).
- своя пустая View в `backgroundView` → `ContentUnavailableView("Пусто", systemImage: "tray")`.

**Руками.** На одном экране со списком подключи все три. Для `refreshable` сделай функцию с `Task.sleep(for: .seconds(2))` и посмотри, как ведёт себя индикатор.

**Разобрать в Buzz.** Pull to refresh на «Сегодня» запускает синхронизацию; пустое состояние «Пока ни одной банки».

**Документация.** [searchable](https://developer.apple.com/documentation/swiftui/view/searchable(text:placement:prompt:)), [refreshable](https://developer.apple.com/documentation/swiftui/view/refreshable(action:)), [ContentUnavailableView](https://developer.apple.com/documentation/swiftui/contentunavailableview)

**Код в Buzz.** `iOS/Modules/CatalogFeature/Sources/CatalogView.swift:41` и `:45`, `iOS/Modules/TodayFeature/Sources/TodayView.swift:43` и `:63`, `iOS/Modules/StatsFeature/Sources/StatsView.swift:44`.

**Описание.** `docs/client/screens.md`, раздел 4; `docs/design/README.md`, раздел «Синхронизация в интерфейсе».

---

## B7. Формы и ввод: Form, TextField(value:format:), @FocusState

**Что и зачем.** `Form` сам рисует сгруппированную таблицу настроек. `TextField(value:format:)` парсит число или валюту по локали пользователя. `@FocusState` управляет клавиатурой.

**Было → стало.** статическая `UITableView`, `UITextFieldDelegate`, ручной парсинг с заменой запятой на точку, `becomeFirstResponder` → `Form`, форматы, `@FocusState`.

**Руками.**
1. `Form` с `Section`, `Stepper`, `Toggle`, `DatePicker`, `Picker`.
2. `TextField("Цена", value: $price, format: .currency(code: "RUB"))` с `@State var price: Decimal?`. Введи «12,5» с русской локалью.
3. `@FocusState private var focused: Bool`, `.focused($focused)`, кнопка «Готово», которая ставит `focused = false`.
4. Кнопка сохранения `.disabled(!isValid)`.

**Разобрать в Buzz.** Форма «Свой напиток» и поле цены в «Добавить» без ручного парсинга.

**Документация.** [Form](https://developer.apple.com/documentation/swiftui/form), [TextField](https://developer.apple.com/documentation/swiftui/textfield), [FocusState](https://developer.apple.com/documentation/swiftui/focusstate)

**Код в Buzz.** `TextField(value:format:)` в `iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:137` и `iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:43`, форма входа `iOS/Modules/SettingsFeature/Sources/LoginView.swift`.

**Описание.** `docs/client/screens.md`, разделы 4.2–4.5; `docs/client/localization.md`, раздел 4.

---

## B8. Навигация: NavigationStack, TabView, sheet

**Что и зачем.** Навигация описывается данными: стек — это массив значений, экраны строятся по значению.

**Было → стало.** `pushViewController`, `present`, координаторы → `NavigationStack(path:)` + `navigationDestination(for:)`, `.sheet(item:)`, `TabView` с `Tab`.

**Важно для Buzz.** Ты выбрал гибрид: навигация на UIKit-координаторах, экраны на SwiftUI (см. E2). `NavigationStack` пробуешь как эксперимент в одной вкладке («Статистика»). Внутри хостинга координатора `NavigationStack` не используй: получится навбар в навбаре.

**Руками.**
1. `enum Route: Hashable { case detail(Int) }`, `@State var path: [Route] = []`, `NavigationStack(path: $path)` и `.navigationDestination(for: Route.self)`.
2. Кнопки «открыть 3 экрана подряд» (`path = [.detail(1), .detail(2), .detail(3)]`) и «в корень» (`path.removeAll()`).
3. `.sheet(item: $selected)` с `.presentationDetents([.medium, .large])`.
4. `TabView(selection:)` с новым API `Tab("Имя", systemImage: ..., value: ...)`, свой `NavigationStack` в каждой вкладке.

**Разобрать в Buzz.** Вкладка «Статистика» целиком на `NavigationStack` внутри одного хостинга; сравни с координатором в других вкладках.

**Документация.** [Navigation](https://developer.apple.com/documentation/swiftui/navigation), [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack), [TabView](https://developer.apple.com/documentation/swiftui/tabview)

**Код в Buzz.** навигация на координаторах `iOS/App/Sources/Coordinators/`, шит в `iOS/App/Sources/Coordinators/TodayCoordinator.swift:54`; `NavigationStack` только для заголовка шита в `iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:13`.

**Описание.** `docs/client/README.md`, раздел 3; `docs/client/architecture.md`, разделы 1 и 7.

---

## B9. Анимации, переходы и хаптики

**Что и зачем.** Анимация в SwiftUI — это «измени состояние внутри анимации», а не «анимируй слой».

**Было → стало.** `CAShapeLayer` + `CABasicAnimation`, `UIView.animate`, `UIImpactFeedbackGenerator`, кастомный `UIViewControllerAnimatedTransitioning` → модификаторы.

| Что | Как |
|---|---|
| Кольцо прогресса | `Circle().trim(from: 0, to: progress).stroke(...)` + `.animation(.spring, value: progress)` |
| Плавная смена цифр | `.contentTransition(.numericText(value:))` + `.monospacedDigit()` |
| Появление/исчезновение | `.transition(.move(edge: .bottom).combined(with: .opacity))` внутри `withAnimation` |
| Хаптик | `.sensoryFeedback(.success, trigger: value)` |
| Зум-переход | `.matchedTransitionSource(id:in:)` + `.navigationTransition(.zoom(sourceID:in:))` |

**Руками.**
1. Нарисуй кольцо из двух `Circle`, вторая с `.trim` и `.rotationEffect(.degrees(-90))`. Кнопка добавляет 10% и анимирует.
2. Число в центре с `.contentTransition(.numericText(value: value))`.
3. Плашка внизу экрана, которая появляется по кнопке и сама исчезает через 3 секунды через `.task(id: isShown) { try? await Task.sleep(for: .seconds(3)); isShown = false }`.
4. `.sensoryFeedback(.warning, trigger: isOver)` и проверь на устройстве.

**Разобрать в Buzz.** Кольцо кофеина, снек «банка добавлена» с кнопкой «Отменить», хаптик при превышении лимита.

**Документация.** [Animations](https://developer.apple.com/documentation/swiftui/animations), [sensoryFeedback](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)), [navigationTransition](https://developer.apple.com/documentation/swiftui/view/navigationtransition(_:))

**Код в Buzz.** `iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:36` (numericText) и `:45` (хаптик), `iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:59` и `:62`.

**Описание.** `docs/client/screens.md`, раздел 4.1; `docs/design/README.md`, разделы «Типографика» и «Снек»; эксперимент с зумом в `docs/client/architecture.md`, раздел 7.

---

## B10. Swift Charts

**Что и зачем.** Декларативные графики от Apple: описываешь отметки (marks) по данным, оси и легенды строятся сами, с локализацией и VoiceOver.

**Было → стало.** DGCharts (Charts от Daniel Gindi) или своя отрисовка в `draw(_:)` → `Chart { BarMark ... }`.

**Руками.**
1. Массив `struct Sale: Identifiable { day: Date; value: Double }` на 7 дней.
2. `Chart(data) { BarMark(x: .value("День", $0.day, unit: .day), y: .value("Сумма", $0.value)) }`.
3. Добавь `RuleMark(y: .value("Цель", 100))` с пунктиром и `.annotation`.
4. Покрась столбики выше цели другим цветом через `.foregroundStyle`.
5. Попробуй `LineMark` + `PointMark`, затем `SectorMark(angle:innerRadius:)` (бублик).
6. Выбор пальцем: `.chartXSelection(value: $selectedDay)` и подсказка.

**Разобрать в Buzz.** Четыре графика статистики: кофеин по дням с линией лимита, распределение по часам, любимые бренды, траты по неделям.

**Документация.** [Swift Charts](https://developer.apple.com/documentation/charts), [Creating a chart using Swift Charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)

**Код в Buzz.** `iOS/Modules/StatsFeature/Sources/StatsView.swift:47` (Bar + Rule), `:122` (Sector), `:163` (Line + Point); данные в `iOS/Modules/StatsFeature/Sources/StatsCalculator.swift`.

**Описание.** `docs/client/screens.md`, раздел 4.4; `docs/client/localization.md`, раздел 5.

---

## B11. #Preview

**Что и зачем.** Экран рендерится прямо в Xcode без запуска приложения, с любыми фейковыми данными, языком и темой.

**Было → стало.** запуск на симуляторе и проход до нужного экрана → `#Preview { MyView(model: .fake) }`.

**Руками.**
1. Сделай несколько превью одного экрана: `#Preview("Пусто")`, `#Preview("С данными")`, `#Preview("Ошибка")`.
2. Для SwiftData: in-memory контейнер `ModelContainer(for: X.self, configurations: .init(isStoredInMemoryOnly: true))` и `.modelContainer(container)`.
3. Превью на двух языках через `.environment(\.locale, Locale(identifier: "ru"))` и в тёмной теме через `.preferredColorScheme(.dark)`.

**Разобрать в Buzz.** Превью каждого экрана в трёх состояниях на фейковых репозиториях.

**Документация.** [Previews in Xcode](https://developer.apple.com/documentation/swiftui/previews-in-xcode)

**Код в Buzz.** `iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:195`, `iOS/Modules/CatalogFeature/Sources/CatalogView.swift:108`; фейковые данные `iOS/Modules/Domain/Sources/Fakes/`.

**Описание.** `docs/client/screens.md`, раздел 3; `docs/client/localization.md`, раздел 7.

---

## B12. SwiftUI внутри UIKit и наоборот

**Что и зачем.** Переписывать всё сразу не нужно: SwiftUI встраивается в UIKit и обратно.

| Задача | Инструмент |
|---|---|
| SwiftUI-экран в UIKit-навигации | `UIHostingController(rootView:)` |
| SwiftUI-содержимое ячейки при живом Diffable | `cell.contentConfiguration = UIHostingConfiguration { ... }` |
| UIKit-вью в SwiftUI | `UIViewRepresentable` (+ `Coordinator` для делегатов) |
| UIKit-контроллер в SwiftUI | `UIViewControllerRepresentable` |

**Руками.**
1. В UIKit-проекте запушь `UIHostingController(rootView: Text("Привет"))` в `UINavigationController`. Поставь в SwiftUI `.navigationTitle` и проверь, что он попал в навбар.
2. В существующей коллекции на Diffable перепиши одну ячейку на `UIHostingConfiguration`, не трогая data source. Сравни объём кода.
3. Оберни `UITextView` в `UIViewRepresentable` с `@Binding var text` и `Coordinator` как делегатом.

**Разобрать в Buzz.** Все экраны Buzz показываются через хостинг из координаторов; на работе — одна ячейка на `UIHostingConfiguration`.

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UIHostingConfiguration](https://developer.apple.com/documentation/swiftui/uihostingconfiguration), [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)

**Код в Buzz.** хостинг экранов в `iOS/App/Sources/AppDependencies.swift:72`, координатор `iOS/App/Sources/Coordinators/TodayCoordinator.swift`; `UIHostingConfiguration` и `Representable` в Buzz не используются, пробуй на работе.

**Описание.** `docs/client/architecture.md`, раздел 6 (тонкости гибрида); `docs/learning/plan.md`, тема 5.

---

## B13. Дизайн-токены, системные цвета, tint

**Что и зачем.** Всё, что есть в системе (фоны, текст, контролы), берётся из системы: тогда тёмная тема, Dynamic Type и Liquid Glass в iOS 26 работают сами. Своих цветов мало, они лежат в Assets как Color Set с вариантами Any/Dark. Акцент задаётся одним `.tint` на корне.

**Было → стало.** `UIColor(named:)` + `traitCollectionDidChange`, `appearance()`-прокси → `Color("Name")`, `.tint`, `Color(.systemGroupedBackground)`, `Font.system(.title, design: .rounded)`.

**Руками.**
1. Добавь в Assets Color Set с двумя вариантами и используй `Color("BuzzAccent")`.
2. Поставь `.tint(.purple)` на корень и посмотри, какие контролы перекрасились сами.
3. Сделай `ViewModifier` «карточка» и `extension View { func card() }`.
4. Включи в симуляторе крупный шрифт (Environment Overrides в Xcode) и проверь вёрстку.

**Разобрать в Buzz.** `Theme.swift` в модуле `DesignSystem` и выбор основного цвета через `@AppStorage` + `.tint`.

**Документация.** [Color](https://developer.apple.com/documentation/swiftui/color), [Human Interface Guidelines: Color](https://developer.apple.com/design/human-interface-guidelines/color), [Dynamic Type](https://developer.apple.com/documentation/swiftui/dynamictypesize)

**Код в Buzz.** `iOS/Modules/DesignSystem/Sources/Theme.swift:13`, выбор акцента `iOS/Modules/DesignSystem/Sources/AccentChoice.swift:15` и `:44`.

**Описание.** `docs/design/README.md`; макеты: [холст Buzz](https://claude.ai/artifact/DBEh5DEASJSWRzgj8Bvp2W).

---

# C. Данные и сеть

## C1. Сетевой слой на URLSession async/await

**Что и зачем.** Тонкий клиент без Alamofire: `try await session.data(for:)` и `Codable`.

**Было → стало.** `dataTask` + колбэк + `DispatchQueue.main.async` → `async throws`; тип ответа зашит в описание эндпоинта (`Endpoint<Response>`).

**Руками.**
1. Сделай `struct Endpoint<Response: Decodable>` с `method`, `path`, `body`.
2. Метод `func send<R>(_ e: Endpoint<R>) async throws -> R`: собрать `URLRequest`, вызвать `session.data(for:)`, проверить статус, декодировать.
3. Вынеси `send` в протокол и сделай фейк для превью и тестов.
4. Проверь отмену: запусти запрос в `.task` и уйди с экрана.

**Разобрать в Buzz.** Модуль `Networking` с `APIClient` и эндпоинтами из `docs/backend/API.md`; ошибки сервера разбираются в `APIErrorCode` из `Shared`.

**Документация.** [URLSession](https://developer.apple.com/documentation/foundation/urlsession), [Codable](https://developer.apple.com/documentation/swift/codable)

**Код в Buzz.** `iOS/Modules/Networking/Sources/APIClient.swift:26`, `iOS/Modules/Networking/Sources/Endpoint.swift:9`, маппинг DTO `iOS/Modules/Networking/Sources/DTOMapping.swift`.

**Описание.** `docs/client/README.md`, раздел 4; `docs/backend/API.md`.

---

## C2. SwiftData

**Что и зачем.** Хранилище Apple, где схема описывается прямо Swift-классом с макросом `@Model`. Под капотом Core Data.

**Было → стало.** `.xcdatamodeld` + `NSManagedObject` + `NSFetchedResultsController` → `@Model` класс, `ModelContainer`, `@Query` (живой запрос, сам обновляет UI) или `FetchDescriptor` + `#Predicate`.

**Руками.**
1. `@Model final class Note { var text: String; var createdAt: Date; init(...) }`.
2. На `WindowGroup` повесь `.modelContainer(for: Note.self)`.
3. Во View `@Query(sort: \Note.createdAt, order: .reverse) var notes: [Note]` и `@Environment(\.modelContext) var context`; кнопка `context.insert(Note(...))`.
4. Фильтр: `#Predicate<Note> { $0.text.contains("a") }` через `Query(filter:sort:)` в `init`.
5. Добавь поле в модель, потом сделай явную миграцию через `VersionedSchema` + `SchemaMigrationPlan`.
6. `@Attribute(.unique)` на `id` и проверь, что вставка с тем же id обновляет запись.

**Правила.** `@Model` не `Sendable`: между потоками передавай DTO/структуры или `PersistentIdentifier`. DTO и `@Model` — разные типы. Enum в `#Predicate` ненадёжен, храни строкой.

**Разобрать в Buzz.** `DrinkModel` и `EntryModel`, сид каталога при первом запуске, «Сегодня» фильтрует записи за день.

**Документация.** [SwiftData](https://developer.apple.com/documentation/swiftdata), [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches)

**Код в Buzz.** `iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`, `iOS/Modules/Persistence/Sources/Models/DrinkModel.swift:9`, контейнер `iOS/Modules/Persistence/Sources/PersistenceContainer.swift:14` (миграций схемы пока нет).

**Описание.** `docs/client/screens.md`, раздел 3; `docs/client/architecture.md`, раздел 5 (SwiftData за протоколом репозитория).

---

## C3. @ModelActor: SwiftData в фоне

**Что и зачем.** Макрос `@ModelActor` делает актор со своим `ModelContext`, работающим не на главном потоке. Так репозиторий читает и пишет в фоне, а наружу отдаёт `Sendable`-структуры.

**Было → стало.** `NSPersistentContainer.performBackgroundTask`, дочерние контексты → `@ModelActor actor Repo`.

**Руками.**
1. `@ModelActor actor NoteRepository { func all() throws -> [NoteDTO] { try modelContext.fetch(FetchDescriptor<Note>()).map { ... } } }`.
2. Создай его как `NoteRepository(modelContainer: container)` и вызови из `@MainActor`-модели через `await`.
3. Попробуй вернуть наружу сам `Note` и прочитай ошибку компилятора про `Sendable`.

**Разобрать в Buzz.** `SwiftDataEntryRepository` и `SyncStore` в модуле `Persistence`/`Sync`.

**Документация.** [ModelActor](https://developer.apple.com/documentation/swiftdata/modelactor)

**Код в Buzz.** `iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:13`, `iOS/Modules/Sync/Sources/SyncStore.swift:12`.

**Описание.** `docs/client/architecture.md`, раздел 5; `docs/client/sync.md`, раздел 3.

---

## C4. Offline-first синхронизация (outbox)

**Что и зачем.** Экран читает только локальную базу; сеть его не касается. Каждое изменение пользователя помечается `pending` (очередь на отправку). Фоновый `actor` сначала отправляет очередь, потом забирает изменения с сервера и не затирает то, что ещё не отправлено.

**Было → стало.** «загрузил с сервера → показал, без сети пусто» → локальная база как источник для UI, сервер как источник правды.

**Ключевые идеи (запомнить, а не копировать).**
- id записи генерирует клиент, поэтому повторный POST не создаёт дубль (идемпотентность).
- `syncState`: `synced` / `pending` / `pendingDelete`; удаление мягкое (`deletedAt`).
- Помечать `synced` только если `updatedAt` не поменялся за время запроса.
- `lastSyncedAt` брать из `serverTime` ответа, а не из часов телефона.
- Конфликт: побеждает более свежий `updatedAt`.
- Два одновременных запуска склеиваются в «ещё один проход», а не идут параллельно.

**Руками.**
1. Нарисуй на бумаге состояния записи и переходы между ними.
2. Напиши `actor SyncEngine` с методом `syncNow()` и флагами `isRunning`/`needsAnotherPass`. Проверь тестом, что два параллельных вызова не дают параллельных проходов.
3. Напиши `apply(delta)` и тест «pending-запись не перезаписывается свежей версией с сервера».

**Разобрать в Buzz.** Модуль `Sync` целиком, по шагам из раздела 7 `sync.md`.

**Документация.** Готового фреймворка нет, это паттерн. Полезно: [WWDC23 «Sync to iCloud with CKSyncEngine»](https://developer.apple.com/videos/play/wwdc2023/10188/) для сравнения с тем, как Apple решает ту же задачу.

**Код в Buzz.** `iOS/Modules/Sync/Sources/SyncEngine.swift:31` (`syncNow`), `iOS/Modules/Sync/Sources/SyncStore.swift:94` (`apply`), `iOS/Modules/Persistence/Sources/Models/SyncState.swift`, тесты `iOS/Modules/Sync/Tests/SyncEngineTests.swift`; сервер `Backend/Sources/App/Controllers/SyncController.swift:24`.

**Описание.** `docs/idea.md`, «Зачем синхронизация»; `docs/client/sync.md`; сервер: `/sync` в `docs/backend/API.md`.

---

## C5. NWPathMonitor и триггеры синхронизации

**Что и зачем.** `NWPathMonitor` сообщает, когда появилась или пропала сеть. Вместе с жизненным циклом сцены это даёт триггеры синхронизации.

**Было → стало.** Reachability (сторонняя) → `NWPathMonitor` из Network.framework.

**Руками.**
1. Создай `NWPathMonitor()`, задай `pathUpdateHandler`, вызови `start(queue:)`.
2. Переведи колбэк в `AsyncStream<Bool>` (см. A4) и читай его `for await`.
3. Включи и выключи Wi-Fi на Mac при запущенном симуляторе, посмотри на события.

**Разобрать в Buzz.** Переход `.unsatisfied → .satisfied` запускает `syncNow()`.

**Документация.** [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor)

**Код в Buzz.** `iOS/Modules/Sync/Sources/NetworkMonitor.swift:15`, возврат из фона `iOS/App/Sources/SceneDelegate.swift:49`.

**Описание.** `docs/client/sync.md`, раздел 4. Дальше, вне MVP: [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) (`BGAppRefreshTask`).

---

## C6. @AppStorage и Keychain

**Что и зачем.** `@AppStorage("key")` — обёртка над `UserDefaults`, которая обновляет View при изменении. Токен авторизации хранится в Keychain, не в `UserDefaults`.

**Было → стало.** `UserDefaults.standard.set` + ручное обновление UI → `@AppStorage`; Keychain остаётся Keychain (Security framework).

**Руками.**
1. `@AppStorage("limit") var limit = 400` и `Stepper` к нему; перезапусти приложение.
2. `@AppStorage` с `enum: String` (`RawRepresentable`).
3. Напиши маленькую обёртку над `SecItemAdd` / `SecItemCopyMatching` / `SecItemDelete` для строки-токена.

**Разобрать в Buzz.** Лимит и выбранный цвет в `@AppStorage`; токен в Keychain после логина.

**Документация.** [AppStorage](https://developer.apple.com/documentation/swiftui/appstorage), [Keychain services](https://developer.apple.com/documentation/security/keychain-services)

**Код в Buzz.** Keychain `iOS/Modules/Networking/Sources/TokenStore.swift:17`, `@AppStorage` `iOS/Modules/DesignSystem/Sources/AccentChoice.swift:39`, лимит `iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift:9`.

**Описание.** `docs/client/screens.md`, раздел 3; `docs/design/README.md`, «Основной цвет»; `docs/learning/plan.md`, тема 10.

---

## C7. Моки и фейковый сервер (BUZZ_MOCK_API)

**Что и зачем.** Приложение можно запускать и тестировать без бэкенда: in-memory репозитории для превью и тестов и фейковый `APIClient`, который ведёт себя как сервер. Включается переменной окружения схемы, без отдельной сборки.

**Было → стало.** OHHTTPStubs, отдельный таргет «Mock», `#if DEBUG` по всему коду → протокол `APIClient` с двумя реализациями и выбор в одном месте сборки зависимостей.

**Руками.**
1. Вынеси сетевой вызов за протокол и сделай фейковую реализацию, которая хранит данные в словаре.
2. В Xcode: Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables, добавь `MY_MOCK = 1`.
3. В точке сборки зависимостей прочитай `ProcessInfo.processInfo.environment["MY_MOCK"]` и выбери реализацию.
4. Запусти приложение с переменной и без неё, проверь, что экраны работают в обоих случаях.

**Разобрать в Buzz.** Запустить приложение с `BUZZ_MOCK_API = 1` (любой email и пароль от 8 символов) и `BUZZ_IN_MEMORY = 1`; найти, где выбирается реализация, и добавить в фейковый сервер задержку ответа, чтобы увидеть индикаторы загрузки.

**Документация.** [Customizing the build schemes for a project](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project), [ProcessInfo.environment](https://developer.apple.com/documentation/foundation/processinfo/environment)

**Код в Buzz.** выбор реализации в `iOS/App/Sources/AppDependencies.swift:43`, фейковый сервер `iOS/Modules/Networking/Sources/MockAPIClient.swift:13`, in-memory репозитории и данные для превью `iOS/Modules/Domain/Sources/Fakes/`, примеры запросов и ответов `Mocks/api/`, каталог `Mocks/catalog.json`.

**Описание.** `Mocks/README.md`.

---

# D. Локализация

## D1. String Catalog и плюрализация

**Что и зачем.** Один файл `Localizable.xcstrings` вместо `.strings` и `.stringsdict`. Xcode сам собирает в него строки из кода, показывает процент перевода и формы множественного числа.

**Было → стало.** `NSLocalizedString` + `.strings` + `.stringsdict` (XML для плюралов) → String Catalog с редактором.

**Руками.**
1. File → New → String Catalog. Добавь язык Russian.
2. В коде `Text("cans.count \(n)")`, собери проект: ключ появится в каталоге как `cans.count %lld`.
3. В каталоге правый клик → **Vary by Plural**, заполни `one/few/many/other` для ru и `one/other` для en.
4. Схема → Run → Options → App Language: Russian, проверь «1 банка, 3 банки, 5 банок».
5. Попробуй псевдоязык Double-Length.

**Разобрать в Buzz.** Все строки фич в каталогах модулей; семантические ключи вида `today.empty.title`.

**Документация.** [Localizing and varying text with a string catalog](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog), [LocalizedStringResource](https://developer.apple.com/documentation/foundation/localizedstringresource)

**Код в Buzz.** каталоги `iOS/App/Resources/Localizable.xcstrings` и `iOS/Modules/<Модуль>/Resources/Localizable.xcstrings`.

**Описание.** `docs/client/localization.md`, разделы 1–3.

---

## D2. Строки в модулях: bundle .module и генерация символов

**Что и зачем.** В модуле `Text("key")` ищет строку в главном бандле приложения, а не в модуле, и перевод «пропадает». Нужно явно указывать `bundle: .module` или включить генерацию символов (Xcode 26), тогда строка вызывается как `Text(.todayTitle)` и опечатки ловит компилятор.

**Руками.**
1. В Swift-пакете или Tuist-модуле с ресурсами положи каталог и вызови `Text("hello")`. Убедись, что перевода нет.
2. Исправь на `Text("hello", bundle: .module)`.
3. Включи Build Settings → Generate String Catalog Symbols и перепиши на сгенерированный символ.
4. ViewModel отдаёт `LocalizedStringResource`, а не `String`: перевод делает View.

**Разобрать в Buzz.** Ошибки домена (`AddEntryError`) и коды сервера (`APIErrorCode`) переводятся в Presentation через `var message: LocalizedStringResource`.

**Документация.** [Bundle.module и ресурсы пакетов](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)

**Код в Buzz.** `bundle: .module` в `iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:19`, в Charts `iOS/Modules/StatsFeature/Sources/StatsView.swift:65`.

**Описание.** `docs/client/localization.md`, разделы 1–2.

---

## D3. FormatStyle и Measurement

**Что и зачем.** Числа, единицы, валюта и даты форматируются по локали одной цепочкой `.formatted(...)`. Никакой склейки `"\(value) мг"`.

**Было → стало.** `NumberFormatter`, `DateFormatter`, `MeasurementFormatter` (создать, настроить, закэшировать) → `value.formatted(.number.precision(.fractionLength(0)))`.

**Руками.**
1. `Measurement(value: 160, unit: UnitMass.milligrams).formatted(.measurement(width: .abbreviated))` в ru и en.
2. `Date.now.formatted(date: .omitted, time: .shortened)` и `.formatted(.relative(presentation: .named))`.
3. `0.42.formatted(.percent)`, `Decimal(99.9).formatted(.currency(code: "RUB"))`.
4. Тест на Swift Testing с `.locale(Locale(identifier: "ru_RU"))`, который фиксирует «160 мг».

**Разобрать в Buzz.** Все мг, мл, проценты, цены и время на экранах через `FormatStyle`.

**Документация.** [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle), [Measurement](https://developer.apple.com/documentation/foundation/measurement)

**Код в Buzz.** `iOS/Modules/DesignSystem/Sources/Formatting.swift:10`, тесты `iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift`.

**Описание.** `docs/client/localization.md`, раздел 4; `docs/design/README.md`, «Языки в макетах».

---

# E. Архитектура

## E1. MVVM на @Observable

**Что и зачем.** У экрана View и `@MainActor @Observable` модель с состоянием и действиями. View только рисует и вызывает методы. Основной подход Buzz.

**Было → стало.** MVVM с Combine/RxSwift и биндингами → MVVM на Observation, без `@Published` и подписок.

**Руками.**
1. Модель с `enum State { case loading, loaded([Item]), failed(String) }` и `func load() async`.
2. View делает `switch model.state`.
3. Зависимости через `init`, `@ObservationIgnored`.
4. Навигация уходит наружу через `Output`-замыкания (`addTapped: () -> Void`), модель не знает, кто её показывает.
5. Тест модели с фейковым репозиторием.

**Разобрать в Buzz.** `TodayFeature`, `CatalogFeature`, `StatsFeature`.

**Документация.** [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)

**Код в Buzz.** `iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`, `iOS/Modules/TodayFeature/Sources/TodayView.swift`, тесты `iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift`.

**Описание.** `docs/client/architecture.md`, разделы 2–5.

---

## E2. Координаторы + UIHostingController (гибрид)

**Что и зачем.** Навигацию держит знакомый UIKit (координаторы, `UITabBarController`, `UINavigationController`), каждый экран — `UIHostingController` со SwiftUI-View. Так учишь новое по одному слою.

**Руками.**
1. `SceneDelegate` создаёт `AppCoordinator` с `UITabBarController` и четырьмя `UINavigationController`.
2. Координатор вкладки создаёт ViewModel с `Output`-замыканиями и пушит `UIHostingController(rootView: View(model:))`.
3. Шит: `vc.sheetPresentationController?.detents = [.medium(), .large()]`.
4. Общий `environment` прокидывай в одном месте (`deps.host(view)`): каждый хостинг — отдельный корень SwiftUI.

**Разобрать в Buzz.** App-таргет с координаторами и четырьмя вкладками.

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)

**Код в Buzz.** `iOS/App/Sources/SceneDelegate.swift`, `iOS/App/Sources/Coordinators/AppCoordinator.swift:11`, `iOS/App/Sources/Coordinators/TodayCoordinator.swift:7`, `iOS/App/Sources/AppDependencies.swift:72`, диплинки `iOS/App/Tests/DeepLinkTests.swift`.

**Описание.** `docs/client/architecture.md`, разделы 1, 3 и 6.

---

## E3. Clean Architecture в одной фиче

**Что и зачем.** Слои View → ViewModel → UseCase → Repository. Бизнес-правила живут в use case-ах без UI и базы и тестируются чистыми функциями. Время (`now`) тоже зависимость.

**Руками.**
1. Чистая функция расчёта (без зависимостей) и её тест.
2. Протокол use case-а и реализация поверх протоколов репозиториев.
3. ViewModel знает только use case-ы.
4. Модуль-фабрика `enum XModule { static func make(deps:output:) -> some View }`.
5. Честно посчитай, сколько use case-ов оказались пустым пробросом.

**Разобрать в Buzz.** `AddEntryFeature`: `NutritionCalculator`, `AddEntryUseCase` с валидацией и проверкой лимита.

**Документация.** Это паттерн, официальной документации нет. Первоисточник: статья Robert C. Martin [«The Clean Architecture»](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

**Код в Buzz.** `iOS/Modules/AddEntryFeature/Sources/Domain/NutritionCalculator.swift:12`, `iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift`, `iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift`, тесты `iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift`.

**Описание.** `docs/client/architecture-experiments.md`, раздел 1.

---

## E4. Самописный Redux (и потом TCA)

**Что и зачем.** Всё состояние экрана — одна структура `State`. Меняется только через `Action` в чистой функции `reduce(&state, action)`, которая возвращает `Effect` (асинхронную работу, присылающую новый `Action`). Зависимости — структура замыканий.

**Было → стало.** разбросанное по VC состояние → один `switch` со всем сценарием экрана. TCA — промышленная версия того же с макросами `@Reducer`, `@ObservableState` и `TestStore`.

**Руками.**
1. Напиши мини-фреймворк сам: `Effect`, `Reducer`, `@Observable Store` с `send(_:)` и `binding(_:send:)` (около 40 строк).
2. Счётчик на нём: `increment`, `decrement`, `loadRandom` (эффект с `Task.sleep`).
3. Тесты reducer-а без async.
4. Потом подключи [TCA](https://github.com/pointfreeco/swift-composable-architecture) и перепиши тот же счётчик, сравни.

**Разобрать в Buzz.** `SettingsFeature` на своём Redux; позже перевод на TCA как эксперимент.

**Документация.** [TCA](https://github.com/pointfreeco/swift-composable-architecture), [документация TCA](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/)

**Код в Buzz.** `iOS/Modules/SettingsFeature/Sources/Redux/Store.swift:18` и `:38`, `iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift:6`, `iOS/Modules/SettingsFeature/Sources/SettingsState.swift`, тесты `iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift`.

**Описание.** `docs/client/architecture-experiments.md`, раздел 2.

---

## E5. Модули: фичи видят только Domain

**Что и зачем.** Приложение режется на модули (`Domain`, `Persistence`, `Networking`, `DesignSystem`, `Sync`, фичи). Фичи не импортируют друг друга, не знают про UIKit и SwiftData. Нарушение границы — ошибка компиляции, а не вопрос дисциплины.

**Было → стало.** один таргет с папками → модули (Tuist-таргеты или SPM-пакет).

**Руками.**
1. Сделай локальный Swift-пакет с двумя таргетами `Domain` и `FeatureA`, подключи к приложению (File → Add Package Dependencies → Add Local).
2. Попробуй импортировать в `FeatureA` то, что не объявлено в зависимостях.
3. Сделай типы в `Domain` `public` и посмотри, что без этого ничего не видно.
4. Потом то же самое через Tuist (H1) и `tuist inspect implicit-imports`.

**Разобрать в Buzz.** 10 модулей по графу из `app/infra/README.md`, раздел 2.

**Документация.** [Swift packages](https://developer.apple.com/documentation/xcode/swift-packages), [Organizing code with local packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages)

**Код в Buzz.** `iOS/Project.swift`, `iOS/Tuist/ProjectDescriptionHelpers/Module.swift`, протоколы в `iOS/Modules/Domain/Sources/Repositories.swift:11`.

**Описание.** `docs/client/architecture.md`, разделы 3–4; `docs/infra/README.md`, разделы 1–3.

---

# F. Тесты

## F1. Swift Testing

**Что и зачем.** Новый фреймворк тестов: `@Test`-функции вместо классов, `#expect` вместо десятка `XCTAssert*`, параметризация, нормальный async, параллельный запуск. Работает и в приложении, и в Vapor.

**Было → стало.** `XCTestCase`, `XCTAssertEqual`, `XCTestExpectation` → `@Test`, `#expect`, `#require`, `confirmation`. UI-тесты и замеры производительности пока остаются в XCTest.

**Руками.**
1. `import Testing`, `@Test func sum() { #expect(1 + 1 == 2) }`. Сломай тест и посмотри, как подробно выводится разница.
2. `@Test(arguments: [(300.0, false), (450.0, true)])` для параметризации.
3. `let x = try #require(optional)` вместо `XCTUnwrap`.
4. `await #expect(throws: MyError.bad) { try await f() }`.
5. `@Suite` со свойствами (общая настройка в `init`), трейты `.tags`, `.disabled`, `.serialized`.

**Разобрать в Buzz.** Тесты `NutritionCalculator`, use case-а «Добавить», reducer-а «Настроек», `SyncEngine` (список сценариев в `sync.md`, раздел 6).

**Документация.** [Swift Testing](https://developer.apple.com/documentation/testing), [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)

**Код в Buzz.** тесты клиента `iOS/Modules/<Модуль>/Tests/` (например `iOS/Modules/Sync/Tests/SyncEngineTests.swift`), сервера `Backend/Tests/AppTests/AppTests.swift:50`.

**Описание.** `docs/client/architecture-experiments.md` (тесты обоих экспериментов).

---

# G. Сервер на Swift

## G1. Vapor: сервер как долгоживущий процесс

**Что и зачем.** Веб-фреймворк на Swift поверх SwiftNIO. Процесс стартует, слушает порт 8080 и на каждый HTTP-запрос вызывает твой обработчик. Всё на async/await.

**Аналогии.** `@main App` → `entrypoint.swift` + `configure.swift`; `UIViewController` → `RouteCollection`; `URLSession` отправляет запрос → Vapor принимает `Request`; SwiftData → Fluent.

**Руками.**
1. `brew install vapor`, `vapor new Hello -n`, `cd Hello && swift run`.
2. `curl http://127.0.0.1:8080/hello`.
3. Открой `Package.swift` в Xcode и запусти схему; поставь брейкпоинт в обработчике и дерни его curl-ом.
4. Не учи `EventLoopFuture`, `.map`, `.flatMap`: это стиль до async.

**Разобрать в Buzz.** Запустить `Backend/` у себя на Mac (`swift run App serve` или `mise run backend:run`) и пройти curl-сценарий из `docs/backend/README.md`, раздел 8.

**Документация.** [Vapor docs](https://docs.vapor.codes), [Getting started](https://docs.vapor.codes/getting-started/hello-world/), [swift.org: Server](https://www.swift.org/documentation/server/)

**Код в Buzz.** `Backend/Sources/App/entrypoint.swift`, `Backend/Sources/App/configure.swift`; путеводитель с упражнениями `docs/backend/STEPS.md`.

**Описание.** `docs/backend/README.md`, разделы 1, 2 и 8; путеводитель по коду бэкенда с упражнениями: `docs/backend/STEPS.md`.

---

## G2. Роуты, контроллеры, Content

**Руками.**
1. `app.get("hello", ":name") { req async throws -> String in ... }`, достань параметр `req.parameters.get("name")`.
2. `struct Greeting: Content { let text: String }` и верни его из POST-роута, тело читай `try req.content.decode(...)`.
3. Query: `try req.query.decode(Filter.self)`.
4. Вынеси роуты в `struct HelloController: RouteCollection` и зарегистрируй `try app.register(collection:)`.
5. Валидация: `extension Greeting: Validatable` и `try Greeting.validate(content: req)`.

**Разобрать в Buzz.** Прочитать `routes.swift` и `MeController`, затем самому написать `DrinkController` и сравнить с каркасом.

**Документация.** [Routing](https://docs.vapor.codes/basics/routing/), [Content](https://docs.vapor.codes/basics/content/), [Controllers](https://docs.vapor.codes/basics/controllers/), [Validation](https://docs.vapor.codes/basics/validation/)

**Код в Buzz.** `Backend/Sources/App/routes.swift`, `Backend/Sources/App/Controllers/`.

**Описание.** `docs/backend/README.md`, раздел 3.

---

## G3. Fluent: модели, миграции, запросы

**Что и зачем.** ORM Vapor. Модель — класс с обёртками `@ID`, `@Field`, `@Parent`, `@Timestamp`. В отличие от SwiftData, схема создаётся миграциями: каждое изменение — новая миграция, старые не трогаются.

**Руками.**
1. Модель `Todo` с `@ID`, `@Field(key: "title")`, `@Timestamp(key: "created_at", on: .create)`.
2. Миграция `CreateTodo: AsyncMigration` с `prepare` и `revert`; `app.migrations.add(CreateTodo())`, `swift run App migrate`.
3. Запрос: `Todo.query(on: req.db).filter(\.$title == "x").sort(\.$createdAt, .descending).all()`.
4. Связь `@Parent`/`@Children` и подгрузка `.with(\.$parent)`.
5. Мягкое удаление `@Timestamp(on: .delete)` и `.withDeleted()`.
6. Добавь поле новой миграцией, а не правкой старой.

**Разобрать в Buzz.** Модели `Drink` (с `@OptionalParent` владельца), `Entry` (id от клиента, деньги в копейках), упражнение из README: переписать статистику «по дням» на SQL `GROUP BY` через SQLKit.

**Документация.** [Fluent overview](https://docs.vapor.codes/fluent/overview/), [Model](https://docs.vapor.codes/fluent/model/), [Migrations](https://docs.vapor.codes/fluent/migration/), [Query](https://docs.vapor.codes/fluent/query/)

**Код в Buzz.** `Backend/Sources/App/Models/Entry.swift`, `Backend/Sources/App/Migrations/CreateEntry.swift`, `withDeleted` в `Backend/Sources/App/Controllers/EntryController.swift:46`, упражнение с SQLKit в `Backend/Sources/App/Controllers/StatsController.swift:20`.

**Описание.** `docs/backend/README.md`, раздел 4.

---

## G4. Авторизация по bearer-токену

**Что и зачем.** При логине сервер создаёт случайный токен и сохраняет его (`UserToken`). Клиент шлёт `Authorization: Bearer <token>`, middleware находит пользователя.

**Руками.**
1. `User: ModelAuthenticatable` (email + хеш пароля через `Bcrypt`).
2. `UserToken: ModelTokenAuthenticatable`.
3. `/login` с `User.authenticator()` (basic) отдаёт новый токен.
4. Группа роутов `app.grouped(UserToken.authenticator(), User.guardMiddleware())`, внутри `try req.auth.require(User.self)`.

**Разобрать в Buzz.** Прочитать `AuthController`; затем добавить срок жизни токена (упражнение из README).

**Документация.** [Authentication](https://docs.vapor.codes/security/authentication/), [Passwords](https://docs.vapor.codes/security/passwords/)

**Код в Buzz.** `Backend/Sources/App/Models/UserToken.swift:30`, `Backend/Sources/App/Controllers/AuthController.swift`, `Backend/Sources/App/routes.swift`.

**Описание.** `docs/backend/README.md`, раздел 3.

---

## G5. Ошибки кодами и свой middleware

**Что и зачем.** Сервер не пишет тексты для людей: отдаёт машинный код `{"error": "limit_invalid", "reason": "..."}`, а клиент переводит его через String Catalog. Неизвестный код раскодируется в `.unknown`, и старое приложение не падает.

**Руками.**
1. Брось `Abort(.notFound)` и посмотри на стандартный ответ.
2. Напиши свой `AsyncMiddleware`, который ловит ошибки из `next.respond(to:)` и превращает их в свой JSON.
3. Замени стандартный `ErrorMiddleware` своим в `configure.swift`.
4. В enum кодов реализуй `init(from:)` с запасным `.unknown`.

**Разобрать в Buzz.** Прочитать `Errors/` и `Shared/APIError.swift`; добавить новый код ошибки на обеих сторонах.

**Документация.** [Errors](https://docs.vapor.codes/basics/errors/), [Middleware](https://docs.vapor.codes/advanced/middleware/)

**Код в Buzz.** `Backend/Sources/App/Errors/APIErrorMiddleware.swift:6`, коды `Shared/Sources/Shared/APIError.swift`.

**Описание.** `docs/backend/README.md`, раздел 6; `docs/backend/API.md`, «Ошибки и языки».

---

## G6. Общий пакет Shared с DTO

**Что и зачем.** DTO (то, что летит по сети) лежат в маленьком Swift-пакете, который подключают и iOS-клиент, и Vapor. Контракт API проверяет компилятор с обеих сторон.

**Правила.** `Shared` зависит только от Foundation; типы `Codable`, `Sendable`, `Hashable`; на сервере `extension XDTO: @retroactive Content {}`; общие `JSONEncoder`/`JSONDecoder` с ISO 8601; модель БД и DTO — разные типы.

**Руками.**
1. File → New → Package `Shared` с одной структурой.
2. Подключи его локально в приложение и в Vapor-проект.
3. Переименуй поле и посмотри, как компилятор подсветил обе стороны.

**Разобрать в Buzz.** Посмотреть, как `Shared/` подключён к Tuist в `iOS/Tuist/Package.swift` и к Vapor в `Backend/Package.swift`; добавить поле в DTO и пройти по ошибкам компиляции на обеих сторонах.

**Документация.** [Creating a standalone Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode). Альтернатива: [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) + [swift-openapi-vapor](https://github.com/swift-server/swift-openapi-vapor).

**Код в Buzz.** `Shared/Sources/Shared/`, на сервере `Backend/Sources/App/DTOs/Shared+Content.swift:6`, на клиенте `iOS/Modules/Networking/Sources/DTOMapping.swift`.

**Описание.** `docs/backend/README.md`, раздел 5; `docs/infra/README.md`, раздел 2.

---

## G7. Тесты Vapor (VaporTesting)

**Руками.**
1. Хелпер, который поднимает приложение в памяти с in-memory SQLite, мигрирует и откатывает.
2. `try await app.testing().test(.GET, "hello", afterResponse: { res in #expect(res.status == .ok) })`.
3. Тест с телом и заголовком `bearerAuthorization`.
4. В тестах `app.passwords.use(.plaintext)`, чтобы не ждать Bcrypt.

**Разобрать в Buzz.** Прочитать 8 тестов в `AppTests.swift`, затем написать тест на новый код ошибки из G5.

**Документация.** [Testing](https://docs.vapor.codes/advanced/testing/)

**Код в Buzz.** `Backend/Tests/AppTests/AppTests.swift:28`.

**Описание.** `docs/backend/README.md`, раздел 9.

---

## G8. Postgres в Docker и деплой

**Что и зачем.** SQLite для старта, PostgreSQL для настоящего сервера. Переход — замена драйвера и одной строки в `configure.swift`. Деплой — Docker-образ из шаблона Vapor на VPS или Fly.io.

**Руками.**
1. Установи Docker Desktop (или OrbStack), `docker run -e POSTGRES_PASSWORD=... -p 5432:5432 postgres`.
2. Подключи `FluentPostgresDriver`, читай настройки из переменных окружения (`Environment.get`).
3. `docker compose up` из шаблона `vapor new` с Postgres.
4. Собери образ из `Dockerfile` шаблона и запусти локально.

**Разобрать в Buzz.** Шаг 7 из README бэкенда: Postgres в Docker, затем деплой.

**Документация.** [Docker deploy](https://docs.vapor.codes/deploy/docker/), [Fluent: Postgres](https://docs.vapor.codes/fluent/overview/#postgresql), [Environment](https://docs.vapor.codes/basics/environment/)

**Код в Buzz.** пока не сделано; база выбирается в `Backend/Sources/App/configure.swift`.

**Описание.** `docs/backend/README.md`, разделы 4 и 10.

---

# H. Инфраструктура

## H1. Tuist: проект как код

**Что и зачем.** Xcode-проект генерируется из Swift-манифестов (`Project.swift`). `.xcodeproj` не хранится в git: нет конфликтов в `project.pbxproj`, модуль добавляется одной строкой.

**Было → стало.** клики в Xcode и конфликты pbxproj → `tuist generate`.

**Руками.**
1. Поставь Tuist через mise (H2): `mise use tuist@latest`.
2. `tuist init` в пустой папке, открой `Project.swift`, `tuist generate`.
3. `tuist edit`: манифесты открываются в Xcode с автодополнением.
4. Добавь второй таргет-фреймворк и зависимость `.target(name:)`.
5. Вынеси создание модуля в хелпер в `Tuist/ProjectDescriptionHelpers/`.
6. `tuist graph`, `tuist inspect implicit-imports`.

**Разобрать в Buzz.** Прочитать `iOS/Project.swift` и `Module.swift`, добавить пустой модуль одной строкой и выполнить `tuist graph`. Для сборки с нуля руками есть `docs/infra/HANDS-ON.md`.

**Документация.** [Tuist docs](https://docs.tuist.dev)

**Код в Buzz.** `iOS/Project.swift`, `iOS/Tuist.swift`, `iOS/Tuist/Package.swift`, `iOS/Tuist/ProjectDescriptionHelpers/Module.swift`; пошаговый разбор `docs/infra/HANDS-ON.md`.

**Описание.** `docs/infra/README.md`, разделы 1–3.

---

## H2. mise: версии инструментов и задачи

**Что и зачем.** Один файл `mise.toml` в репозитории фиксирует версии tuist, ruby, swiftlint и описывает задачи. Те же версии у тебя и в CI. Замена brew для проектных инструментов и Makefile для команд.

**Руками.**
1. `brew install mise`, добавь активацию в shell (`mise activate zsh`).
2. В пустой папке `mise use tuist@latest` и посмотри, что записалось в `mise.toml`.
3. Добавь задачу `[tasks.hello] run = "echo hi"` и вызови `mise run hello`.
4. Задача с зависимостями `depends = [...]`.
5. Секреты в `mise.local.toml` (в `.gitignore`).

**Подвох.** `mise generate` — встроенная команда mise, поэтому своя задача вызывается как `mise run generate`.

**Разобрать в Buzz.** Прочитать `mise.toml` и после клона репозитория поднять всё одной `mise run generate`.

**Документация.** [mise](https://mise.jdx.dev), [Tasks](https://mise.jdx.dev/tasks/)

**Код в Buzz.** `mise.toml`; `docs/infra/HANDS-ON.md`, шаг 1.

**Описание.** `docs/infra/README.md`, раздел 4.

---

## H3. fastlane, match, App Store Connect API key

**Что и зачем.** fastlane описывает сборку и выкладку как Ruby-скрипт с «дорожками» (lanes). match хранит сертификаты и профили в отдельном приватном git-репозитории, зашифрованными. API-ключ App Store Connect даёт доступ без Apple ID и двухфакторки.

**Руками.**
1. `Gemfile` с fastlane, `bundle install`, всегда запускай через `bundle exec fastlane`.
2. Lane `test` с `run_tests(scheme:)`.
3. Когда будет Apple Developer Program: `match` в режиме `development`, затем `appstore`; `app_store_connect_api_key`; lane `beta` с `build_app` и `upload_to_testflight`.

**Разобрать в Buzz.** Lane `test` локально; `certs` и `beta` после покупки Developer Program.

**Документация.** [fastlane docs](https://docs.fastlane.tools), [match](https://docs.fastlane.tools/actions/match/), [App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/)

**Код в Buzz.** `iOS/fastlane/Fastfile`, `iOS/fastlane/Matchfile`, `iOS/Gemfile`.

**Описание.** `docs/infra/README.md`, раздел 5.

---

## H4. GitHub Actions

**Что и зачем.** CI в том же репозитории: YAML-файлы в `.github/workflows/`, запуск на PR и тегах.

**Руками.**
1. Workflow на `pull_request`, job на `macos-26`, шаги `actions/checkout`, `jdx/mise-action`, `mise run test`.
2. Фильтр `paths:`, чтобы iOS-job не запускался на изменения бэкенда.
3. Job на тег `ios-v*`, зависящий от тестов (`needs:`).
4. Секреты в Settings → Secrets and variables → Actions.
5. Бэкенд на Linux в контейнере `swift:6.2` с `swift test`.

**Разобрать в Buzz.** Зелёный CI на пустом проекте (шаг 4 порядка внедрения).

**Документация.** [GitHub Actions](https://docs.github.com/actions)

**Код в Buzz.** `.github/workflows/ios.yml`, `.github/workflows/backend.yml`.

**Описание.** `docs/infra/README.md`, раздел 6.

---

## H5. swift-format, SwiftLint, pre-commit

**Что и зачем.** swift-format — официальный форматтер, с Xcode 16 входит в тулчейн (`xcrun swift-format`). SwiftLint оставлен только для смысловых правил. Pre-commit хук запускает линт перед коммитом.

**Руками.**
1. `xcrun swift-format format -i -r Sources/` и посмотри дифф.
2. `swiftlint` в корне проекта с конфигом `.swiftlint.yml`.
3. `mise generate git-pre-commit --write --task=lint` и попробуй закоммитить плохой код.

**Документация.** [swift-format](https://github.com/swiftlang/swift-format), [SwiftLint](https://github.com/realm/SwiftLint), [mise generate git-pre-commit](https://mise.jdx.dev/cli/generate/git-pre-commit.html)

**Код в Buzz.** `.swift-format`, `.swiftlint.yml`, задачи `lint` в `mise.toml`.

**Описание.** `docs/infra/README.md`, раздел 4a.

---

## H6. Renovate

**Что и зачем.** Бот раз в неделю открывает PR с обновлениями версий в `mise.toml`, Gemfile, GitHub Actions и SPM. В отличие от Dependabot, понимает `mise.toml`.

**Руками.** Установи GitHub App Renovate на репозиторий, положи `renovate.json`, дождись первого PR «Configure Renovate».

**Документация.** [Renovate docs](https://docs.renovatebot.com)

**Код в Buzz.** `renovate.json`.

**Описание.** `docs/infra/README.md`, раздел 4a.

---

## Журнал изменений

- **2026-10-15.** Первая версия: 49 карточек по материалам веток «План изучения», «Идея», «SwiftUI-клиент», «Бэкенд на Vapor», «Дизайн», «Архитектура и инфраструктура».
- **2026-10-15.** Появился настоящий код Buzz (ветка «Публичный репозиторий Buzz»): во всех карточках «Где в Buzz» заменено на «Код в Buzz» с путями и строками в репозитории. Новая карточка C7 про моки и фейковый сервер.
