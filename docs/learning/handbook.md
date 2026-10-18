# Справочник нового стека

Справочник по всему новому, что есть в проекте Buzz: инструменты, фреймворки и подходы. Здесь только теория: что это, зачем, чем заменяет привычное из UIKit, где лежит в коде Buzz и где читать подробнее. Практика — в отдельном курсе [course.md](course.md): там по блокам примерно на 30 минут ты сам пишешь новую фичу в Buzz, а каждый блок ссылается на нужные карточки отсюда.

Справочник пополняется, когда в проекте появляется новый инструмент, подход или код. Можно и вручную: напиши «обнови конспект» в ветке «Конспект нового стека». В конце файла журнал изменений.

**Как читать карточку.**
- **Что и зачем.** Суть одной-двумя фразами.
- **Было → стало.** Что это заменяет из UIKit-стека.
- **Ключевые идеи, подвохи** — там, где они есть.
- **Документация.** Официальная документация Apple, Swift, Vapor и других.
- **Код в Buzz.** Файлы и строки, где это используется. Ссылки ведут в репозиторий [disavle/buzz](https://github.com/disavle/buzz), ветка `main`.
- **Описание.** Документ проекта в `docs/`.

---

## Оглавление

**A. Язык и конкурентность**
- A1. async/await и Task
- A2. Structured concurrency: async let и группы задач
- A3. actor, @MainActor, Sendable и Swift 6
- A4. AsyncStream и AsyncSequence
- A5. Мост со старым кодом: continuation
- A6. Typed throws
- A7. Макросы
- A8. Combine: Subject, операторы, AnyCancellable
- A9. Mutex и Synchronization: защита данных без актора

**B. Интерфейс на SwiftUI**
- B1. Мышление SwiftUI: UI как функция от состояния
- B2. Observation (@Observable)
- B3. Поток данных: @State, @Binding, @Bindable, @Environment, @Entry
- B4. Списки и сетки вместо Diffable + CompositionalLayout
- B5. Жизненный цикл: .task, .task(id:), debounce без Combine
- B6. Готовые модификаторы: searchable, refreshable, ContentUnavailableView
- B7. Формы и ввод: Form, TextField(value:format:), @FocusState
- B8. Навигация: NavigationStack, TabView, sheet
- B9. Анимации, переходы и хаптики
- B10. Swift Charts
- B11. #Preview
- B12. SwiftUI внутри UIKit и наоборот
- B13. Дизайн-токены, системные цвета, tint
- B14. Доступность: VoiceOver и Dynamic Type

**C. Данные и сеть**
- C1. Сетевой слой на URLSession async/await
- C2. SwiftData
- C3. @ModelActor: SwiftData в фоне
- C4. Offline-first синхронизация (outbox)
- C5. NWPathMonitor и триггеры синхронизации
- C6. @AppStorage и Keychain
- C7. Моки и фейковый сервер (BUZZ_MOCK_API)
- C8. Codable, JSON и деньги в Decimal

**D. Локализация**
- D1. String Catalog и плюрализация
- D2. Строки в модулях: bundle .module и генерация символов
- D3. FormatStyle и Measurement

**E. Архитектура**
- E1. MVVM на @Observable
- E2. Координаторы + UIHostingController (гибрид)
- E3. Clean Architecture в одной фиче
- E4. Самописный Redux (и потом TCA)
- E5. Модули: фичи видят только Domain

**F. Тесты**
- F1. Swift Testing

**G. Сервер на Swift**
- G1. Vapor: сервер как долгоживущий процесс
- G2. Роуты, контроллеры, Content
- G3. Fluent: модели, миграции, запросы
- G4. Авторизация по bearer-токену
- G5. Ошибки кодами и свой middleware
- G6. Общий пакет Shared с DTO
- G7. Тесты Vapor (VaporTesting)
- G8. Postgres в Docker и деплой
- G9. Деплой: Docker multi-stage, GHCR, deploy hook, 12-factor

**H. Инфраструктура**
- H1. Tuist: проект как код
- H2. mise: версии инструментов и задачи
- H3. fastlane, match, App Store Connect API key
- H4. GitHub Actions
- H5. swift-format, SwiftLint, pre-commit
- H6. Renovate
- H7. GitHub Flow и защита main (rulesets)
- H8. Заведение репозитория: чек-лист
- H9. Релизы: CHANGELOG и GitHub Release по тегу

---

# A. Язык и конкурентность

## A1. async/await и Task

**Что и зачем.** Асинхронный код пишется сверху вниз, как синхронный. `await` — точка, где функция может приостановиться и отдать поток. Отмена и ошибки работают через обычные `throws`.

**Было → стало.** completion handler, `DispatchQueue.main.async`, «пирамида» колбэков → `async throws` функции, `try await`, `Task {}`.

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

**Документация.** [Swift Book: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [Task](https://developer.apple.com/documentation/swift/task)

**Код в Buzz.** [`iOS/Modules/Networking/Sources/APIClient.swift:37`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L37) (`send` на async/await), обработчики [`Backend/Sources/App/Controllers/EntryController.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 4 (сеть); весь бэкенд ([`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 7).

---

## A2. Structured concurrency: async let и группы задач

**Что и зачем.** Параллельный запуск нескольких дочерних задач, которые гарантированно завершатся (или отменятся) вместе с родителем.

**Было → стало.** `DispatchGroup` + `enter/leave/notify` → `async let` для фиксированного числа задач, `withThrowingTaskGroup` для динамического.

```swift
let total = try await withThrowingTaskGroup(of: Int.self) { group in
    for n in 1...3 { group.addTask { try await slowNumber() + n } }
    return try await group.reduce(0, +)
}
```

**Документация.** [Swift Book: Concurrency → Calling Asynchronous Functions in Parallel](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [TaskGroup](https://developer.apple.com/documentation/swift/taskgroup)

**Код в Buzz.** в коде пока не используется; удобное место попробовать `async let`: загрузка данных в [`iOS/Modules/StatsFeature/Sources/StatsViewModel.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsViewModel.swift).

---

## A3. actor, @MainActor, Sendable и Swift 6

**Что и зачем.** Компилятор Swift 6 сам проверяет гонки данных. `actor` защищает своё изменяемое состояние: снаружи к нему можно обратиться только через `await`. `@MainActor` — то же для главного потока. `Sendable` помечает типы, которые безопасно передавать между потоками.

**Было → стало.** серийные очереди, `NSLock`, «не забудь вернуться на main» → `actor`, `@MainActor` на типе, ошибки компиляции вместо крашей в рантайме.

**Swift 6.2 (Xcode 26).** В новых проектах включены «Default Actor Isolation = MainActor» и «Approachable Concurrency»: код по умолчанию живёт на главном акторе, а с него уходят явно через `@concurrent` или `nonisolated`.

```swift
actor Counter {
    private(set) var value = 0
    func increment() { value += 1 }
}
```

**Документация.** [Swift Book: Actors](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors), [Swift 6 migration guide](https://www.swift.org/migration/documentation/migrationguide/), [Sendable](https://developer.apple.com/documentation/swift/sendable)

**Код в Buzz.** `actor SyncEngine` в [`iOS/Modules/Sync/Sources/SyncEngine.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L12), `actor SyncStore` в [`iOS/Modules/Sync/Sources/SyncStore.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L12), `actor KeychainTokenStore` в [`iOS/Modules/Networking/Sources/TokenStore.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L17), `@MainActor` ViewModel в [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L13), `Sendable`-класс [`iOS/Modules/Domain/Sources/Broadcaster.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L12).

**Описание.** Все ViewModel `@MainActor` ([`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5); `actor SyncEngine` ([`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md)); модели Fluent `@unchecked Sendable` ([`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 7); Swift 6 strict на весь проект ([`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 3).

---

## A4. AsyncStream и AsyncSequence

**Что и зачем.** Поток значений во времени, который читается циклом `for await`. Покрывает большую часть сценариев Combine: подписка на изменения, события, статусы.

**Было → стало.** `PassthroughSubject` / `NotificationCenter` / делегаты → `AsyncStream` + `for await`.

```swift
let (stream, cont) = AsyncStream.makeStream(of: String.self)
Task { for await s in stream { print(s) } }
cont.yield("привет"); cont.finish()
```

**Документация.** [AsyncStream](https://developer.apple.com/documentation/swift/asyncstream), [AsyncSequence](https://developer.apple.com/documentation/swift/asyncsequence)

**Код в Buzz.** [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L28) (колбэк → `AsyncStream`), [`iOS/Modules/Sync/Sources/SyncEngine.swift:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L48) и [`:66`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L66), [`iOS/Modules/Domain/Sources/Broadcaster.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L12) (один источник, много подписчиков).

**Описание.** [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), разделы 2–3 и 5.

---

## A5. Мост со старым кодом: continuation

**Что и зачем.** Обернуть API на колбэках в `async`-функцию.

**Было → стало.** колбэк остаётся внутри, наружу торчит `async`.

**Документация.** [withCheckedThrowingContinuation](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(isolation:function:_:))

**Код в Buzz.** `withCheckedContinuation` в коде нет; похожий мост «колбэк → async» сделан через `AsyncStream` в [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L7).

---

## A6. Typed throws

**Что и зачем.** Функция может объявить конкретный тип ошибки: `throws(SyncError)`. Тогда в `catch` сразу `SyncError`, без приведения типов.

**Было → стало.** `throws` + `catch let e as MyError` → `throws(MyError)`.

**Документация.** [SE-0413 Typed throws](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md), [Swift Book: Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)

**Код в Buzz.** `throws(APIError)` в [`iOS/Modules/Networking/Sources/APIClient.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L19), use case в [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L10).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 2 (`SettingsEnvironment`).

---

## A7. Макросы

**Что и зачем.** `@Observable`, `@Model`, `#Predicate`, `#Preview`, `@Test`, `#expect`, `@Entry` — всё это макросы, которые генерируют код при компиляции. Понимание того, во что они раскрываются, помогает читать ошибки.

**Было → стало.** ручной бойлерплейт, кодогенерация Sourcery → макросы в языке.

**Документация.** [Swift Book: Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/), [swift-syntax](https://github.com/swiftlang/swift-syntax)

**Код в Buzz.** `@Observable` в [`iOS/Modules/Domain/Sources/EntryStore.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/EntryStore.swift#L13), `@Model` в [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L6), `#Predicate` в [`iOS/Modules/Sync/Sources/SyncStore.swift:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L48); что генерирует `@ModelActor`, расписано руками в [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L10).

---

## A8. Combine: Subject, операторы, AnyCancellable

**Что и зачем.** Combine — реактивный фреймворк Apple (iOS 13+): значения текут по цепочке «издатель → операторы → подписчик». Новый код Buzz живёт на async/await и `@Observable`, но Combine до сих пор встречается в большинстве рабочих проектов и на собеседованиях. Поэтому один экран (поиск в каталоге) специально переведён на Combine, а «Добавить банку» оставлен на `.task(id:)` (B5). Два подхода к одной задаче лежат рядом, их удобно сравнить.

**Было → стало (UIKit).** `UISearchBar` delegate + `NSObject.cancelPreviousPerformRequests` / `Timer` для задержки → `PassthroughSubject` + `debounce` + `removeDuplicates` + `sink`. Если ты знаешь RxSwift: `Subject` ≈ `PublishSubject`, `AnyCancellable` ≈ `DisposeBag`.

**Ключевые идеи.**
- `PassthroughSubject<String, Never>` — «трубка», в которую код сам кладёт значения через `send`. `CurrentValueSubject` ещё и помнит последнее значение.
- Операторы: `map` (преобразовать), `debounce(for:scheduler:)` (ждать паузу в вводе), `removeDuplicates` (не повторять тот же запрос).
- `sink` подписывается и возвращает `AnyCancellable`. Пока он хранится в свойстве, подписка жива; освободился — подписка отменилась.
- Мост в async/await: в `sink` запускается `Task { await repository.search(...) }`, а прошлая задача отменяется, чтобы медленный старый ответ не перетёр новый.
- С `@Observable` нет `@Published`, поэтому значение в subject отправляется из `didSet` свойства `query`.
- В Swift 6 `debounce` на `DispatchQueue.main` не доказывает компилятору главный поток, отсюда `MainActor.assumeIsolated` внутри `sink`.

**Документация.** [Combine](https://developer.apple.com/documentation/combine), [Receiving and Handling Events with Combine](https://developer.apple.com/documentation/combine/receiving-and-handling-events-with-combine), [debounce](https://developer.apple.com/documentation/combine/publisher/debounce(for:scheduler:options:)), [AnyCancellable](https://developer.apple.com/documentation/combine/anycancellable), [Using Combine (книга, бесплатно)](https://heckj.github.io/swiftui-notes/)

**Код в Buzz.** subject [`iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:40`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L40), `didSet` [`:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L28), `AnyCancellable` [`:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L45), цепочка с `debounce` [`:70`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L70), `sink` и `assumeIsolated` [`:75`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L75), отмена прошлого поиска [`:88`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L88); тест «быстрый ввод = один поиск» [`iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift:58`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift#L58). Влито в PR #10.

**Описание.** комментарии в самом `CatalogViewModel.swift`, они написаны как пошаговый разбор.

---

## A9. Mutex и Synchronization: защита данных без актора

**Что и зачем.** `Mutex<Value>` из фреймворка Synchronization (iOS 18+, Swift 6) — замок вокруг значения. Достать или поменять значение можно только внутри `withLock { ... }`, поэтому забыть про блокировку нельзя. Тип с `Mutex` внутри становится `Sendable` без `actor` и без `await`. Это нужно там, где вызов должен быть синхронным: например, `AsyncStream` вызывает `onTermination` из любого потока, и там нельзя ждать актор.

**Было → стало (UIKit).** `DispatchQueue(label:)` с `sync`, `NSLock` или `os_unfair_lock` и `@unchecked Sendable` «на честном слове» → `Mutex`, который проверяет компилятор.

**Когда что брать.**
- Состояние с асинхронной логикой и несколькими шагами → `actor`.
- Маленькое состояние, которое надо читать и менять синхронно и мгновенно → `Mutex`.
- Значение, которое только читают после создания → `let` и `Sendable`, без замков.
- `@unchecked Sendable` — последний вариант, с комментарием, почему это безопасно.

**Документация.** [Mutex](https://developer.apple.com/documentation/synchronization/mutex), [SE-0433: Synchronous Mutual Exclusion Lock](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0433-mutex.md), [Sendable](https://developer.apple.com/documentation/swift/sendable)

**Код в Buzz.** словарь подписчиков под замком [`iOS/Modules/Domain/Sources/Broadcaster.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L13), фейковый сервер [`iOS/Modules/Networking/Sources/MockAPIClient.swift:21`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L21), объяснение про `@unchecked` в [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L13).

**Описание.** комментарии в `Broadcaster.swift`.

---

# B. Интерфейс на SwiftUI

## B1. Мышление SwiftUI: UI как функция от состояния

**Что и зачем.** View — лёгкое значение (`struct`), которое описывает, как выглядит экран при текущем состоянии. Поменял состояние — SwiftUI сам пересчитал разницу и обновил экран.

**Было → стало.** `reloadData`, `apply(snapshot)`, ручное обновление лейблов → меняешь данные, `body` вызывается заново. Идентичность элементов (как item identifiers в Diffable) остаётся ключевой: `Identifiable`, `id:`.

**Документация.** [SwiftUI](https://developer.apple.com/documentation/swiftui), [Туториалы SwiftUI](https://developer.apple.com/tutorials/swiftui)

**Код в Buzz.** [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift), `Identifiable`-модели в [`iOS/Modules/Domain/Sources/Models/Entry.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Entry.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 6 (таблица UIKit → SwiftUI).

---

## B2. Observation (@Observable)

**Что и зачем.** Класс, помеченный `@Observable`, сам сообщает UI, какие свойства изменились. View перерисовывается, только если прочитала изменившееся свойство.

**Было → стало.** `ObservableObject` + `@Published` + `@StateObject`/`@ObservedObject` (и Combine) → `@Observable` + `@State`/обычный параметр/`@Bindable`. В iOS 26 UIKit тоже автоматически отслеживает `@Observable` в `viewWillLayoutSubviews` и `updateProperties()`.

**Документация.** [Observation](https://developer.apple.com/documentation/observation), [Миграция с ObservableObject](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)

**Код в Buzz.** [`iOS/Modules/Domain/Sources/EntryStore.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/EntryStore.swift#L13), [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L13), [`iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L12).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 2; [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5.

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

**Документация.** [Model data](https://developer.apple.com/documentation/swiftui/model-data), [Entry()](https://developer.apple.com/documentation/swiftui/entry())

**Код в Buzz.** биндинг в `@Observable` `$model.query` в [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L49); зависимости через `init` из [`iOS/App/Sources/AppDependencies.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L13) (`@Entry` в коде не используется).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), разделы 2 и 4.

---

## B4. Списки и сетки вместо Diffable + CompositionalLayout

**Что и зачем.** Большинство экранов со списками и сетками собирается из `List`, `LazyVStack`, `LazyVGrid` и `ScrollView`.

**Было → стало.**
- `UICollectionView` + `DiffableDataSource` → `List` / `ForEach` по `Identifiable`, дифф считает SwiftUI.
- Секции CompositionalLayout → `Section` в `List`.
- Колонки от ширины экрана (`NSCollectionLayoutGroup`) → `GridItem(.adaptive(minimum:))`.
- `orthogonalScrollingBehavior` → `ScrollView(.horizontal) { LazyHStack }` + `.scrollTargetBehavior(.viewAligned)`.
- `CellRegistration` → обычная View.

**Документация.** [Lists](https://developer.apple.com/documentation/swiftui/lists), [LazyVGrid](https://developer.apple.com/documentation/swiftui/lazyvgrid), [scrollTargetBehavior](https://developer.apple.com/documentation/swiftui/view/scrolltargetbehavior(_:))

**Код в Buzz.** `LazyVGrid` в [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:29`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L29), `List` в [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), разделы 4.1–4.3 и 5.

---

## B5. Жизненный цикл: .task, .task(id:), debounce без Combine

**Что и зачем.** `.task { }` запускает async-работу при появлении View и сам отменяет её при уходе. `.task(id: value)` перезапускает задачу при каждом изменении `value`, отменяя предыдущую.

**Было → стало.** `viewDidLoad` + ручная отмена запросов; `debounce` из Combine → `.task(id:)` + `Task.sleep`.

**Документация.** [task(id:priority:_:)](https://developer.apple.com/documentation/swiftui/view/task(id:priority:_:)), [onChange](https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:))

**Код в Buzz.** debounce через `.task(id:)` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:35`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L35), автоскрытие снека в [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:70`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L70).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.3.

---

## B6. Готовые модификаторы: searchable, refreshable, ContentUnavailableView

**Было → стало.**
- `UISearchController` → `.searchable(text: $query)`.
- `UIRefreshControl` + target/action → `.refreshable { await reload() }` (индикатор крутится, пока функция не вернётся).
- своя пустая View в `backgroundView` → `ContentUnavailableView("Пусто", systemImage: "tray")`.

**Документация.** [searchable](https://developer.apple.com/documentation/swiftui/view/searchable(text:placement:prompt:)), [refreshable](https://developer.apple.com/documentation/swiftui/view/refreshable(action:)), [ContentUnavailableView](https://developer.apple.com/documentation/swiftui/contentunavailableview)

**Код в Buzz.** [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L45) и [`:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L49), [`iOS/Modules/TodayFeature/Sources/TodayView.swift:43`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L43) и [`:71`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L71), [`iOS/Modules/StatsFeature/Sources/StatsView.swift:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L44).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), раздел «Синхронизация в интерфейсе».

---

## B7. Формы и ввод: Form, TextField(value:format:), @FocusState

**Что и зачем.** `Form` сам рисует сгруппированную таблицу настроек. `TextField(value:format:)` парсит число или валюту по локали пользователя. `@FocusState` управляет клавиатурой.

**Было → стало.** статическая `UITableView`, `UITextFieldDelegate`, ручной парсинг с заменой запятой на точку, `becomeFirstResponder` → `Form`, форматы, `@FocusState`.

**Документация.** [Form](https://developer.apple.com/documentation/swiftui/form), [TextField](https://developer.apple.com/documentation/swiftui/textfield), [FocusState](https://developer.apple.com/documentation/swiftui/focusstate)

**Код в Buzz.** `TextField(value:format:)` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:151`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L151) и [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L47), форма входа [`iOS/Modules/SettingsFeature/Sources/LoginView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/LoginView.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), разделы 4.2–4.5; [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 4.

---

## B8. Навигация: NavigationStack, TabView, sheet

**Что и зачем.** Навигация описывается данными: стек — это массив значений, экраны строятся по значению.

**Было → стало.** `pushViewController`, `present`, координаторы → `NavigationStack(path:)` + `navigationDestination(for:)`, `.sheet(item:)`, `TabView` с `Tab`.

**Важно для Buzz.** Ты выбрал гибрид: навигация на UIKit-координаторах, экраны на SwiftUI (см. E2). `NavigationStack` пробуешь как эксперимент в одной вкладке («Статистика»). Внутри хостинга координатора `NavigationStack` не используй: получится навбар в навбаре.

**Документация.** [Navigation](https://developer.apple.com/documentation/swiftui/navigation), [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack), [TabView](https://developer.apple.com/documentation/swiftui/tabview)

**Код в Buzz.** навигация на координаторах [`iOS/App/Sources/Coordinators/`](https://github.com/disavle/buzz/tree/main/iOS/App/Sources/Coordinators), шит в [`iOS/App/Sources/Coordinators/TodayCoordinator.swift:54`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift#L54); `NavigationStack` только для заголовка шита в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L13).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 3; [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 1 и 7.

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

**Документация.** [Animations](https://developer.apple.com/documentation/swiftui/animations), [sensoryFeedback](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)), [navigationTransition](https://developer.apple.com/documentation/swiftui/view/navigationtransition(_:))

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L38) (numericText) и [`:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L47) (хаптик), [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:59`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L59) и [`:62`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L62).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.1; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), разделы «Типографика» и «Снек»; эксперимент с зумом в [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 7.

---

## B10. Swift Charts

**Что и зачем.** Декларативные графики от Apple: описываешь отметки (marks) по данным, оси и легенды строятся сами, с локализацией и VoiceOver.

**Было → стало.** DGCharts (Charts от Daniel Gindi) или своя отрисовка в `draw(_:)` → `Chart { BarMark ... }`.

**Документация.** [Swift Charts](https://developer.apple.com/documentation/charts), [Creating a chart using Swift Charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)

**Код в Buzz.** [`iOS/Modules/StatsFeature/Sources/StatsView.swift:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L47) (Bar + Rule), [`:126`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L126) (Sector), [`:170`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L170) (Line + Point); данные в [`iOS/Modules/StatsFeature/Sources/StatsCalculator.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsCalculator.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.4; [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 5.

---

## B11. #Preview

**Что и зачем.** Экран рендерится прямо в Xcode без запуска приложения, с любыми фейковыми данными, языком и темой.

**Было → стало.** запуск на симуляторе и проход до нужного экрана → `#Preview { MyView(model: .fake) }`.

**Документация.** [Previews in Xcode](https://developer.apple.com/documentation/swiftui/previews-in-xcode)

**Код в Buzz.** [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:212`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L212), [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:115`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L115); фейковые данные [`iOS/Modules/Domain/Sources/Fakes/`](https://github.com/disavle/buzz/tree/main/iOS/Modules/Domain/Sources/Fakes).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 3; [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 7.

---

## B12. SwiftUI внутри UIKit и наоборот

**Что и зачем.** Переписывать всё сразу не нужно: SwiftUI встраивается в UIKit и обратно.

| Задача | Инструмент |
|---|---|
| SwiftUI-экран в UIKit-навигации | `UIHostingController(rootView:)` |
| SwiftUI-содержимое ячейки при живом Diffable | `cell.contentConfiguration = UIHostingConfiguration { ... }` |
| UIKit-вью в SwiftUI | `UIViewRepresentable` (+ `Coordinator` для делегатов) |
| UIKit-контроллер в SwiftUI | `UIViewControllerRepresentable` |

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UIHostingConfiguration](https://developer.apple.com/documentation/swiftui/uihostingconfiguration), [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)

**Код в Buzz.** хостинг экранов в [`iOS/App/Sources/AppDependencies.swift:89`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L89), координатор [`iOS/App/Sources/Coordinators/TodayCoordinator.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift); `UIHostingConfiguration` и `Representable` в Buzz не используются, пробуй на работе.

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 6 (тонкости гибрида).

---

## B13. Дизайн-токены, системные цвета, tint

**Что и зачем.** Всё, что есть в системе (фоны, текст, контролы), берётся из системы: тогда тёмная тема, Dynamic Type и Liquid Glass в iOS 26 работают сами. Своих цветов мало, они лежат в Assets как Color Set с вариантами Any/Dark. Акцент задаётся одним `.tint` на корне.

**Было → стало.** `UIColor(named:)` + `traitCollectionDidChange`, `appearance()`-прокси → `Color("Name")`, `.tint`, `Color(.systemGroupedBackground)`, `Font.system(.title, design: .rounded)`.

**Документация.** [Color](https://developer.apple.com/documentation/swiftui/color), [Human Interface Guidelines: Color](https://developer.apple.com/design/human-interface-guidelines/color), [Dynamic Type](https://developer.apple.com/documentation/swiftui/dynamictypesize)

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Theme.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L13), выбор акцента [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:15`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L15) и [`:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L44).

**Описание.** [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md); макеты: [холст Buzz](https://claude.ai/artifact/DBEh5DEASJSWRzgj8Bvp2W).

---

## B14. Доступность: VoiceOver и Dynamic Type

**Что и зачем.** VoiceOver читает экран вслух, Dynamic Type увеличивает шрифты. В SwiftUI многое работает само: системные шрифты масштабируются, `Button` и `Toggle` уже озвучиваются. Помогать руками нужно там, где картинка или свой компонент: склеить элементы в один (`accessibilityElement(children: .combine)`), дать понятную подпись (`accessibilityLabel`), отметить состояние (`accessibilityAddTraits(.isSelected)`), спрятать декор (`accessibilityHidden`).

**Было → стало (UIKit).** `isAccessibilityElement`, `accessibilityLabel`, `accessibilityTraits` на `UIView` и `adjustsFontForContentSizeCategory` → модификаторы SwiftUI; шрифты `.font(.body)` масштабируются сами.

**Что проверять.**
- Каждая картинка без текста рядом либо подписана, либо скрыта.
- Карточка из нескольких `Text` читается одной фразой, а не пятью.
- На самом крупном размере шрифта ничего не обрезается.
- Цвет — не единственный признак состояния: «лимит превышен» сказано и словами.

**Инструменты.** Accessibility Inspector (Xcode → Open Developer Tool), переключатель Dynamic Type в канвасе превью, VoiceOver в симуляторе (Settings → Accessibility).

**Документация.** [Accessibility fundamentals](https://developer.apple.com/documentation/swiftui/accessibility-fundamentals), [accessibilityElement(children:)](https://developer.apple.com/documentation/swiftui/view/accessibilityelement(children:)), [Scaling fonts automatically](https://developer.apple.com/documentation/uikit/scaling-fonts-automatically), [HIG: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

**Код в Buzz.** кольцо кофеина одной фразой [`iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L49), выбранный цвет с `.isSelected` [`iOS/Modules/SettingsFeature/Sources/SettingsView.swift:90`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsView.swift#L90), значок «не отправлено» [`iOS/Modules/TodayFeature/Sources/TodayView.swift:125`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L125), скрытый декор [`iOS/Modules/DesignSystem/Sources/Components/BrandTile.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/BrandTile.swift#L19).

**Описание.** [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md).

---

# C. Данные и сеть

## C1. Сетевой слой на URLSession async/await

**Что и зачем.** Тонкий клиент без Alamofire: `try await session.data(for:)` и `Codable`.

**Было → стало.** `dataTask` + колбэк + `DispatchQueue.main.async` → `async throws`; тип ответа зашит в описание эндпоинта (`Endpoint<Response>`).

**Документация.** [URLSession](https://developer.apple.com/documentation/foundation/urlsession), [Codable](https://developer.apple.com/documentation/swift/codable)

**Код в Buzz.** [`iOS/Modules/Networking/Sources/APIClient.swift:26`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L26), [`iOS/Modules/Networking/Sources/Endpoint.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L9), маппинг DTO [`iOS/Modules/Networking/Sources/DTOMapping.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/DTOMapping.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 4; [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md).

---

## C2. SwiftData

**Что и зачем.** Хранилище Apple, где схема описывается прямо Swift-классом с макросом `@Model`. Под капотом Core Data.

**Было → стало.** `.xcdatamodeld` + `NSManagedObject` + `NSFetchedResultsController` → `@Model` класс, `ModelContainer`, `@Query` (живой запрос, сам обновляет UI) или `FetchDescriptor` + `#Predicate`.

**Правила.** `@Model` не `Sendable`: между потоками передавай DTO/структуры или `PersistentIdentifier`. DTO и `@Model` — разные типы. Enum в `#Predicate` ненадёжен, храни строкой.

**Документация.** [SwiftData](https://developer.apple.com/documentation/swiftdata), [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches)

**Код в Buzz.** [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L6), [`iOS/Modules/Persistence/Sources/Models/DrinkModel.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/DrinkModel.swift#L9), контейнер [`iOS/Modules/Persistence/Sources/PersistenceContainer.swift:14`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/PersistenceContainer.swift#L14) (миграций схемы пока нет).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 3; [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5 (SwiftData за протоколом репозитория).

---

## C3. @ModelActor: SwiftData в фоне

**Что и зачем.** Макрос `@ModelActor` делает актор со своим `ModelContext`, работающим не на главном потоке. Так репозиторий читает и пишет в фоне, а наружу отдаёт `Sendable`-структуры.

**Было → стало.** `NSPersistentContainer.performBackgroundTask`, дочерние контексты → `@ModelActor actor Repo`.

**Документация.** [ModelActor](https://developer.apple.com/documentation/swiftdata/modelactor)

**Код в Buzz.** [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L13), [`iOS/Modules/Sync/Sources/SyncStore.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L12).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5; [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 3.

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

**Подвох: бесконечный цикл (исправлено в PR #9).** Движок синхронизации слушал тот же сигнал «данные изменились», который сам и отправлял после `apply`, поэтому каждый проход через ~2 секунды запускал следующий, и статус мигал. Решение: отдельный сигнал `localEdits` (`Broadcaster<Void>`), который шлёт только репозиторий при правке пользователя и слушает только движок; пустой ответ `/sync` больше ничего не сохраняет. Урок: у события должен быть один смысл, «экран, перерисуйся» и «надо отправить» — разные сигналы. Код: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L17), подключение в [`iOS/App/Sources/AppDependencies.swift:77`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L77).

**Документация.** Готового фреймворка нет, это паттерн. Полезно: [WWDC23 «Sync to iCloud with CKSyncEngine»](https://developer.apple.com/videos/play/wwdc2023/10188/) для сравнения с тем, как Apple решает ту же задачу.

**Код в Buzz.** [`iOS/Modules/Sync/Sources/SyncEngine.swift:31`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L31) (`syncNow`), [`iOS/Modules/Sync/Sources/SyncStore.swift:96`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L96) (`apply`), [`iOS/Modules/Persistence/Sources/Models/SyncState.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/SyncState.swift), тесты [`iOS/Modules/Sync/Tests/SyncEngineTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift); сервер [`Backend/Sources/App/Controllers/SyncController.swift:24`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/SyncController.swift#L24).

**Описание.** [`docs/idea.md`](https://github.com/disavle/buzz/blob/main/docs/idea.md), «Зачем синхронизация»; [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md); сервер: `/sync` в [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md).

---

## C5. NWPathMonitor и триггеры синхронизации

**Что и зачем.** `NWPathMonitor` сообщает, когда появилась или пропала сеть. Вместе с жизненным циклом сцены это даёт триггеры синхронизации.

**Было → стало.** Reachability (сторонняя) → `NWPathMonitor` из Network.framework.

**Документация.** [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor)

**Код в Buzz.** [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:15`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L15), возврат из фона [`iOS/App/Sources/SceneDelegate.swift:53`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L53).

**Описание.** [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 4. Дальше, вне MVP: [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) (`BGAppRefreshTask`).

---

## C6. @AppStorage и Keychain

**Что и зачем.** `@AppStorage("key")` — обёртка над `UserDefaults`, которая обновляет View при изменении. Токен авторизации хранится в Keychain, не в `UserDefaults`.

**Было → стало.** `UserDefaults.standard.set` + ручное обновление UI → `@AppStorage`; Keychain остаётся Keychain (Security framework).

**Документация.** [AppStorage](https://developer.apple.com/documentation/swiftui/appstorage), [Keychain services](https://developer.apple.com/documentation/security/keychain-services)

**Код в Buzz.** Keychain [`iOS/Modules/Networking/Sources/TokenStore.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L17), `@AppStorage` [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:39`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L39), лимит [`iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift#L9).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 3; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), «Основной цвет».

---

## C7. Моки и фейковый сервер (BUZZ_MOCK_API)

**Что и зачем.** Приложение можно запускать и тестировать без бэкенда: in-memory репозитории для превью и тестов и фейковый `APIClient`, который ведёт себя как сервер. Включается переменной окружения схемы, без отдельной сборки.

**Было → стало.** OHHTTPStubs, отдельный таргет «Mock», `#if DEBUG` по всему коду → протокол `APIClient` с двумя реализациями и выбор в одном месте сборки зависимостей.

**Адрес сервера (PR #9).** На iPhone `localhost` — это сам телефон, поэтому адрес бэкенда зашивается в сборку. В `mise.local.toml` (не в git) пишешь `TUIST_API_URL = "https://<сервис>.onrender.com"`, `mise run generate` кладёт его в `Info.plist` под ключом `BuzzAPIURL`, и приложение ходит на Render даже при запуске с иконки. По умолчанию устройство и TestFlight-сборка ходят на `https://buzz-backend-latest.onrender.com`, симулятор на `http://localhost:8080`, а `TUIST_API_URL` это переопределяет. Порядок выбора в `AppDependencies`: `BUZZ_MOCK_API = 1` (фейковый сервер) → `BUZZ_API_URL` из схемы (разовое переопределение, только из Xcode) → `BuzzAPIURL` из `Info.plist` → `http://localhost:8080`. Чтобы iPhone ходил на бэкенд, запущенный на Mac, в `TUIST_API_URL` можно указать IP Mac в той же Wi-Fi сети, например `http://192.168.1.5:8080` (в документах проекта этого нет, проверь сам; по http iOS может потребовать исключение ATS). Как это сделано: в [`iOS/Project.swift:81`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L81) build setting `BUZZ_SERVER_URL` имеет два значения, обычное и `[sdk=iphonesimulator*]` (условие по SDK, приём Xcode из xcconfig), а `Info.plist` подставляет его через `$(BUZZ_SERVER_URL)` ([`:48`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L48)). Порядок выбора в коде: [`iOS/App/Sources/AppDependencies.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L49). Описание в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md), шаг 6.

**Документация.** [Customizing the build schemes for a project](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project), [ProcessInfo.environment](https://developer.apple.com/documentation/foundation/processinfo/environment)

**Код в Buzz.** выбор реализации в [`iOS/App/Sources/AppDependencies.swift:54`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L54), фейковый сервер [`iOS/Modules/Networking/Sources/MockAPIClient.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L13), in-memory репозитории и данные для превью [`iOS/Modules/Domain/Sources/Fakes/`](https://github.com/disavle/buzz/tree/main/iOS/Modules/Domain/Sources/Fakes), примеры запросов и ответов [`Mocks/api/`](https://github.com/disavle/buzz/tree/main/Mocks/api), каталог [`Mocks/catalog.json`](https://github.com/disavle/buzz/blob/main/Mocks/catalog.json).

**Описание.** [`Mocks/README.md`](https://github.com/disavle/buzz/blob/main/Mocks/README.md).

---

## C8. Codable, JSON и деньги в Decimal

**Что и зачем.** `Codable` превращает структуру в JSON и обратно без ручного разбора словарей. Клиент и сервер Buzz договорились об одном формате дат (ISO 8601) и держат его в одном месте: `JSONEncoder.buzz` и `JSONDecoder.buzz` в пакете `Shared`. Деньги хранятся в `Decimal`, а не в `Double`: в `Double` `0.1 + 0.2` не равно `0.3`, а копейки должны сходиться.

**Было → стало (UIKit).** `JSONSerialization` и `as? [String: Any]` или ObjectMapper → `Codable` с общими стратегиями кодирования; `NSDecimalNumber` → `Decimal` и `.currency(code:)` для вывода.

**Ключевые идеи.**
- Ключи JSON совпадают с именами свойств; если нет, помогает `CodingKeys`.
- Стратегия дат задаётся один раз на кодировщике (`.iso8601`), а не в каждой модели.
- Необязательные поля — `Optional`, тогда их отсутствие в JSON не ошибка.
- `DecodingError` подробно говорит, какой ключ и почему не подошёл: печатай ошибку целиком.
- `Decimal` в JSON кодируется числом; в Postgres для денег подходит тип `numeric`.

**Документация.** [Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/encoding-and-decoding-custom-types), [JSONDecoder.DateDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/datedecodingstrategy), [Decimal](https://developer.apple.com/documentation/foundation/decimal), [Vapor: Content](https://docs.vapor.codes/basics/content/)

**Код в Buzz.** общие кодировщики [`Shared/Sources/Shared/Coding.swift:4`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/Coding.swift#L4), цена в `Decimal` [`iOS/Modules/Domain/Sources/Models/Entry.swift:16`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Entry.swift#L16), траты в статистике [`Shared/Sources/Shared/StatsDTO.swift:82`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/StatsDTO.swift#L82), DTO становятся `Content` на сервере в [`Backend/Sources/App/DTOs/Shared+Content.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/Shared+Content.swift).

**Описание.** [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md).

---

# D. Локализация

## D1. String Catalog и плюрализация

**Что и зачем.** Один файл `Localizable.xcstrings` вместо `.strings` и `.stringsdict`. Xcode сам собирает в него строки из кода, показывает процент перевода и формы множественного числа.

**Было → стало.** `NSLocalizedString` + `.strings` + `.stringsdict` (XML для плюралов) → String Catalog с редактором.

**Документация.** [Localizing and varying text with a string catalog](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog), [LocalizedStringResource](https://developer.apple.com/documentation/foundation/localizedstringresource)

**Код в Buzz.** каталоги [`iOS/App/Resources/Localizable.xcstrings`](https://github.com/disavle/buzz/blob/main/iOS/App/Resources/Localizable.xcstrings) и `iOS/Modules/<Модуль>/Resources/Localizable.xcstrings`.

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), разделы 1–3.

---

## D2. Строки в модулях: bundle .module и генерация символов

**Что и зачем.** В модуле `Text("key")` ищет строку в главном бандле приложения, а не в модуле, и перевод «пропадает». Нужно явно указывать `bundle: .module` или включить генерацию символов (Xcode 26), тогда строка вызывается как `Text(.todayTitle)` и опечатки ловит компилятор.

**Документация.** [Bundle.module и ресурсы пакетов](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)

**Код в Buzz.** `bundle: .module` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L19), в Charts [`iOS/Modules/StatsFeature/Sources/StatsView.swift:67`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L67).

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), разделы 1–2.

---

## D3. FormatStyle и Measurement

**Что и зачем.** Числа, единицы, валюта и даты форматируются по локали одной цепочкой `.formatted(...)`. Никакой склейки `"\(value) мг"`.

**Было → стало.** `NumberFormatter`, `DateFormatter`, `MeasurementFormatter` (создать, настроить, закэшировать) → `value.formatted(.number.precision(.fractionLength(0)))`.

**Документация.** [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle), [Measurement](https://developer.apple.com/documentation/foundation/measurement)

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Formatting.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Formatting.swift#L10), тесты [`iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift).

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 4; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), «Языки в макетах».

---

# E. Архитектура

## E1. MVVM на @Observable

**Что и зачем.** У экрана View и `@MainActor @Observable` модель с состоянием и действиями. View только рисует и вызывает методы. Основной подход Buzz.

**Было → стало.** MVVM с Combine/RxSwift и биндингами → MVVM на Observation, без `@Published` и подписок.

**Документация.** [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)

**Код в Buzz.** [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L13), [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift), тесты [`iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 2–5.

---

## E2. Координаторы + UIHostingController (гибрид)

**Что и зачем.** Навигацию держит знакомый UIKit (координаторы, `UITabBarController`, `UINavigationController`), каждый экран — `UIHostingController` со SwiftUI-View. Так учишь новое по одному слою.

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)

**Код в Buzz.** [`iOS/App/Sources/SceneDelegate.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift), [`iOS/App/Sources/Coordinators/AppCoordinator.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/AppCoordinator.swift#L11), [`iOS/App/Sources/Coordinators/TodayCoordinator.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift#L7), [`iOS/App/Sources/AppDependencies.swift:89`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L89), диплинки [`iOS/App/Tests/DeepLinkTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Tests/DeepLinkTests.swift).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 1, 3 и 6.

---

## E3. Clean Architecture в одной фиче

**Что и зачем.** Слои View → ViewModel → UseCase → Repository. Бизнес-правила живут в use case-ах без UI и базы и тестируются чистыми функциями. Время (`now`) тоже зависимость.

**Документация.** Это паттерн, официальной документации нет. Первоисточник: статья Robert C. Martin [«The Clean Architecture»](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

**Код в Buzz.** [`iOS/Modules/AddEntryFeature/Sources/Domain/NutritionCalculator.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/NutritionCalculator.swift#L12), [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift), [`iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift), тесты [`iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 1.

---

## E4. Самописный Redux (и потом TCA)

**Что и зачем.** Всё состояние экрана — одна структура `State`. Меняется только через `Action` в чистой функции `reduce(&state, action)`, которая возвращает `Effect` (асинхронную работу, присылающую новый `Action`). Зависимости — структура замыканий.

**Было → стало.** разбросанное по VC состояние → один `switch` со всем сценарием экрана. TCA — промышленная версия того же с макросами `@Reducer`, `@ObservableState` и `TestStore`.

**Документация.** [TCA](https://github.com/pointfreeco/swift-composable-architecture), [документация TCA](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/)

**Код в Buzz.** [`iOS/Modules/SettingsFeature/Sources/Redux/Store.swift:18`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L18) и [`:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L38), [`iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift#L6), [`iOS/Modules/SettingsFeature/Sources/SettingsState.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsState.swift), тесты [`iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 2.

---

## E5. Модули: фичи видят только Domain

**Что и зачем.** Приложение режется на модули (`Domain`, `Persistence`, `Networking`, `DesignSystem`, `Sync`, фичи). Фичи не импортируют друг друга, не знают про UIKit и SwiftData. Нарушение границы — ошибка компиляции, а не вопрос дисциплины.

**Было → стало.** один таргет с папками → модули (Tuist-таргеты или SPM-пакет).

**Зачем столько таргетов.** Фича-модулей всего пять, по одному на экран, остальное — слои и тесты. Хелпер [`Module`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift) создаёт на каждый модуль два таргета (код и тесты): 10 × 2 + приложение с тестами + пакет `Shared` = 23. Плюсы: границы проверяет компилятор, правка в одной фиче пересобирает только её, тесты модуля идут за секунды, и это любят спрашивать на собеседованиях. Минусы: много `public`, свой `Bundle.module` у каждого модуля, больше церемоний при новом экране. Для продукта такого размера хватило бы 4–5 таргетов, для учебника текущая разбивка полезна.

**Документация.** [Swift packages](https://developer.apple.com/documentation/xcode/swift-packages), [Organizing code with local packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages)

**Код в Buzz.** [`iOS/Project.swift`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift), [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift), протоколы в [`iOS/Modules/Domain/Sources/Repositories.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L11).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 3–4; [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), разделы 1–3.

---

# F. Тесты

## F1. Swift Testing

**Что и зачем.** Новый фреймворк тестов: `@Test`-функции вместо классов, `#expect` вместо десятка `XCTAssert*`, параметризация, нормальный async, параллельный запуск. Работает и в приложении, и в Vapor.

**Было → стало.** `XCTestCase`, `XCTAssertEqual`, `XCTestExpectation` → `@Test`, `#expect`, `#require`, `confirmation`. UI-тесты и замеры производительности пока остаются в XCTest.

**Документация.** [Swift Testing](https://developer.apple.com/documentation/testing), [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)

**Код в Buzz.** тесты клиента `iOS/Modules/<Модуль>/Tests/` (например [`iOS/Modules/Sync/Tests/SyncEngineTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift)), сервера [`Backend/Tests/AppTests/AppTests.swift:50`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L50).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md) (тесты обоих экспериментов).

---

# G. Сервер на Swift

## G1. Vapor: сервер как долгоживущий процесс

**Что и зачем.** Веб-фреймворк на Swift поверх SwiftNIO. Процесс стартует, слушает порт 8080 и на каждый HTTP-запрос вызывает твой обработчик. Всё на async/await.

**Аналогии.** `@main App` → `entrypoint.swift` + `configure.swift`; `UIViewController` → `RouteCollection`; `URLSession` отправляет запрос → Vapor принимает `Request`; SwiftData → Fluent.

**Документация.** [Vapor docs](https://docs.vapor.codes), [Getting started](https://docs.vapor.codes/getting-started/hello-world/), [swift.org: Server](https://www.swift.org/documentation/server/)

**Код в Buzz.** [`Backend/Sources/App/entrypoint.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/entrypoint.swift), [`Backend/Sources/App/configure.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift); путеводитель с упражнениями [`docs/backend/STEPS.md`](https://github.com/disavle/buzz/blob/main/docs/backend/STEPS.md).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), разделы 1, 2 и 8; путеводитель по коду бэкенда с упражнениями: [`docs/backend/STEPS.md`](https://github.com/disavle/buzz/blob/main/docs/backend/STEPS.md).

---

## G2. Роуты, контроллеры, Content

**Документация.** [Routing](https://docs.vapor.codes/basics/routing/), [Content](https://docs.vapor.codes/basics/content/), [Controllers](https://docs.vapor.codes/basics/controllers/), [Validation](https://docs.vapor.codes/basics/validation/)

**Код в Buzz.** [`Backend/Sources/App/routes.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift), [`Backend/Sources/App/Controllers/`](https://github.com/disavle/buzz/tree/main/Backend/Sources/App/Controllers).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 3.

---

## G3. Fluent: модели, миграции, запросы

**Что и зачем.** ORM Vapor. Модель — класс с обёртками `@ID`, `@Field`, `@Parent`, `@Timestamp`. В отличие от SwiftData, схема создаётся миграциями: каждое изменение — новая миграция, старые не трогаются.

**Документация.** [Fluent overview](https://docs.vapor.codes/fluent/overview/), [Model](https://docs.vapor.codes/fluent/model/), [Migrations](https://docs.vapor.codes/fluent/migration/), [Query](https://docs.vapor.codes/fluent/query/)

**Код в Buzz.** [`Backend/Sources/App/Models/Entry.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift), [`Backend/Sources/App/Migrations/CreateEntry.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Migrations/CreateEntry.swift), `withDeleted` в [`Backend/Sources/App/Controllers/EntryController.swift:47`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L47), упражнение с SQLKit в [`Backend/Sources/App/Controllers/StatsController.swift:20`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/StatsController.swift#L20).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 4.

---

## G4. Авторизация по bearer-токену

**Что и зачем.** При логине сервер создаёт случайный токен и сохраняет его (`UserToken`). Клиент шлёт `Authorization: Bearer <token>`, middleware находит пользователя.

**Документация.** [Authentication](https://docs.vapor.codes/security/authentication/), [Passwords](https://docs.vapor.codes/security/passwords/)

**Код в Buzz.** [`Backend/Sources/App/Models/UserToken.swift:30`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/UserToken.swift#L30), [`Backend/Sources/App/Controllers/AuthController.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/AuthController.swift), [`Backend/Sources/App/routes.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 3.

---

## G5. Ошибки кодами и свой middleware

**Что и зачем.** Сервер не пишет тексты для людей: отдаёт машинный код `{"error": "limit_invalid", "reason": "..."}`, а клиент переводит его через String Catalog. Неизвестный код раскодируется в `.unknown`, и старое приложение не падает.

**Документация.** [Errors](https://docs.vapor.codes/basics/errors/), [Middleware](https://docs.vapor.codes/advanced/middleware/)

**Код в Buzz.** [`Backend/Sources/App/Errors/APIErrorMiddleware.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L6), коды [`Shared/Sources/Shared/APIError.swift`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/APIError.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 6; [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md), «Ошибки и языки».

---

## G6. Общий пакет Shared с DTO

**Что и зачем.** DTO (то, что летит по сети) лежат в маленьком Swift-пакете, который подключают и iOS-клиент, и Vapor. Контракт API проверяет компилятор с обеих сторон.

**Правила.** `Shared` зависит только от Foundation; типы `Codable`, `Sendable`, `Hashable`; на сервере `extension XDTO: @retroactive Content {}`; общие `JSONEncoder`/`JSONDecoder` с ISO 8601; модель БД и DTO — разные типы.

**Документация.** [Creating a standalone Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode). Альтернатива: [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) + [swift-openapi-vapor](https://github.com/swift-server/swift-openapi-vapor).

**Код в Buzz.** [`Shared/Sources/Shared/`](https://github.com/disavle/buzz/tree/main/Shared/Sources/Shared), на сервере [`Backend/Sources/App/DTOs/Shared+Content.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/Shared+Content.swift#L6), на клиенте [`iOS/Modules/Networking/Sources/DTOMapping.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/DTOMapping.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 5; [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 2.

---

## G7. Тесты Vapor (VaporTesting)

**Документация.** [Testing](https://docs.vapor.codes/advanced/testing/)

**Код в Buzz.** [`Backend/Tests/AppTests/AppTests.swift:28`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L28).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 9.

---

## G8. Postgres в Docker и деплой

**Что и зачем.** SQLite для старта, PostgreSQL для настоящего сервера. Переход — замена драйвера и одной строки в `configure.swift`. Деплой — Docker-образ из шаблона Vapor на VPS или Fly.io.

**Куда деплоить бесплатно.** Ветка «Бесплатный хостинг бэкенда» рекомендует Render (Docker-образ с Vapor) и Neon (управляемый Postgres), оба без привязки карты. GitHub сам бэкенд не хостит. Как это устроено, смотри в G9. Документация: [Render: Docker](https://render.com/docs/docker), [Neon](https://neon.tech/docs).

**Документация.** [Docker deploy](https://docs.vapor.codes/deploy/docker/), [Fluent: Postgres](https://docs.vapor.codes/fluent/overview/#postgresql), [Environment](https://docs.vapor.codes/basics/environment/)

**Код в Buzz.** пока не сделано; база выбирается в [`Backend/Sources/App/configure.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), разделы 4 и 10.

---

## G9. Деплой: Docker multi-stage, GHCR, deploy hook, 12-factor

**Что и зачем.** Бэкенд живёт бесплатно на связке Render + Neon. CI собирает Docker-образ, кладёт его в GitHub Container Registry и дёргает Render, а тот скачивает образ и перезапускает сервер. Настройки сервер берёт из переменных окружения, поэтому один и тот же образ работает и локально, и в облаке.

**Было → стало (UIKit).** В iOS ты собирал `.ipa` и отдавал в TestFlight. Здесь то же самое: Docker-образ — это «сборка» сервера, GHCR — «TestFlight» для образов, а deploy hook — кнопка «выпустить».

**Ограничения бесплатных тарифов.**
- Render Free: Docker без карты, 750 часов в месяц, засыпает после 15 минут без запросов (первый запрос после сна идёт долго). Диск временный, поэтому SQLite там не подходит. Свой бесплатный Postgres у Render удаляется через 30 дней, его не используем.
- Neon Free: Postgres на 1 ГБ и 100 CU-часов, засыпает после 5 минут простоя.
- GitHub бэкенд не хостит: Pages только для статики, Codespaces и Actions не для постоянного сервера.

**Новые понятия.**
- *Multi-stage build*: первая стадия собирает Swift-код в тяжёлом образе с компилятором, вторая копирует только готовый бинарник в лёгкий образ. Итоговый образ маленький.
- *Контекст сборки = корень репо*: бэкенду нужен пакет `Shared/`, поэтому `docker build` запускается из корня, а лишнее отсекает `.dockerignore`.
- *GitHub Container Registry (ghcr.io)*: хранилище Docker-образов при репозитории, в CI пушится по `GITHUB_TOKEN`.
- *Deploy hook*: секретный URL Render; POST-запрос на него с `imgURL` запускает выкатку нужного образа. Хранится в секрете `RENDER_DEPLOY_HOOK`.
- *12-factor config*: всё, что меняется между окружениями (`DATABASE_URL`, `PORT`, `AUTO_MIGRATE`), читается из env, а не зашивается в код.

**Деплой не на каждый пуш.** Job `deploy` запускается только когда пуш в `main` меняет `Backend/Sources`, `Backend/Package.*`, `Backend/Dockerfile` или `Shared/` (фильтр `deploy` в `dorny/paths-filter`, PR #8). Тесты, документы и сам workflow сервер не перевыкатывают. Ещё деплой можно запустить руками: Actions → CI → Run workflow (`workflow_dispatch`, PR #7).

**Документация.** [Docker: multi-stage builds](https://docs.docker.com/build/building/multi-stage/), [Vapor: Docker](https://docs.vapor.codes/deploy/docker/), [GitHub: Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry), [Render: Deploy hooks](https://render.com/docs/deploy-hooks), [Render: Free](https://render.com/docs/free), [Neon: Connect](https://neon.tech/docs/connect/connect-from-any-app), [The Twelve-Factor App: Config](https://12factor.net/config)

**Код в Buzz.** стадии сборки [`Backend/Dockerfile:14`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L14) и [`:51`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L51); `DATABASE_URL` [`Backend/Sources/App/configure.swift:17`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L17), `PORT` [`:27`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L27), `AUTO_MIGRATE` [`:50`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L50); фильтр [`.github/workflows/ci.yml:46`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L46) и job `deploy` [`:90`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L90).

**Описание.** [`docs/backend/DEPLOY.md`](https://github.com/disavle/buzz/blob/main/docs/backend/DEPLOY.md).

---

# H. Инфраструктура

## H1. Tuist: проект как код

**Что и зачем.** Xcode-проект генерируется из Swift-манифестов (`Project.swift`). `.xcodeproj` не хранится в git: нет конфликтов в `project.pbxproj`, модуль добавляется одной строкой.

**Было → стало.** клики в Xcode и конфликты pbxproj → `tuist generate`.

**Документация.** [Tuist docs](https://docs.tuist.dev)

**Код в Buzz.** [`iOS/Project.swift`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift), [`iOS/Tuist.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist.swift), [`iOS/Tuist/Package.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/Package.swift), [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift); пошаговый разбор [`docs/infra/HANDS-ON.md`](https://github.com/disavle/buzz/blob/main/docs/infra/HANDS-ON.md).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), разделы 1–3.

---

## H2. mise: версии инструментов и задачи

**Что и зачем.** Один файл `mise.toml` в репозитории фиксирует версии tuist, ruby, swiftlint и описывает задачи. Те же версии у тебя и в CI. Замена brew для проектных инструментов и Makefile для команд.

**Подвох.** `mise generate` — встроенная команда mise, поэтому своя задача вызывается как `mise run generate`.

**Алиасы zsh.** Файл `scripts/buzz.zsh` подключается строкой `source <путь>/scripts/buzz.zsh` в `~/.zshrc` и даёт команды `buzz-ios` (приложение в симуляторе через новую задачу `mise run ios` = `tuist run Buzz`), `buzz-api` (бэкенд), `buzz-dev` (бэкенд в фоне плюс приложение), `buzz-stop`, а также `buzz`, `buzz-gen`, `buzz-open`, `buzz-test`, `buzz-lint`. Репозиторий скрипт находит по своему пути (`${${(%):-%x}:A:h:h}`) и вызывает `mise -C <репо>`, поэтому команды работают из любой папки. Чтобы разобраться, напиши свою функцию `myproj-run() { mise -C ~/code/myproj run dev }` в `~/.zshrc` и сравни со скриптом.

**Документация.** [mise](https://mise.jdx.dev), [Tasks](https://mise.jdx.dev/tasks/)

**Код в Buzz.** [`mise.toml`](https://github.com/disavle/buzz/blob/main/mise.toml), задача `ios` [`mise.toml:82`](https://github.com/disavle/buzz/blob/main/mise.toml#L82), алиасы [`scripts/buzz.zsh:13`](https://github.com/disavle/buzz/blob/main/scripts/buzz.zsh#L13), `buzz-dev` [`:23`](https://github.com/disavle/buzz/blob/main/scripts/buzz.zsh#L23); [`docs/infra/HANDS-ON.md`](https://github.com/disavle/buzz/blob/main/docs/infra/HANDS-ON.md), шаг 1.

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4.

---

## H3. fastlane, match, App Store Connect API key

**Что и зачем.** fastlane описывает сборку и выкладку как Ruby-скрипт с «дорожками» (lanes). match хранит сертификаты и профили в отдельном приватном git-репозитории, зашифрованными. API-ключ App Store Connect даёт доступ без Apple ID и двухфакторки.

**Документация.** [fastlane docs](https://docs.fastlane.tools), [match](https://docs.fastlane.tools/actions/match/), [App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/)

**Код в Buzz.** [`iOS/fastlane/Fastfile`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile), [`iOS/fastlane/Matchfile`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Matchfile), [`iOS/Gemfile`](https://github.com/disavle/buzz/blob/main/iOS/Gemfile).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 5.

---

## H4. GitHub Actions

**Что и зачем.** CI в том же репозитории: YAML-файлы в `.github/workflows/`, запуск на PR и тегах.

**Документация.** [GitHub Actions](https://docs.github.com/actions)

**Код в Buzz.** [`.github/workflows/ci.yml`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml): job `Changes` решает, что запускать, `iOS` и `Backend` гоняют тесты, `TestFlight` только на теги `ios-v*`, `deploy` выкатывает бэкенд (см. G9).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 6.

---

## H5. swift-format, SwiftLint, pre-commit

**Что и зачем.** swift-format — официальный форматтер, с Xcode 16 входит в тулчейн (`xcrun swift-format`). SwiftLint оставлен только для смысловых правил. Pre-commit хук запускает линт перед коммитом.

**В Buzz (PR #9).** Хуки `pre-commit` и `pre-push` в `.githooks/` запускают `mise run lint`; коммит, где только документация, линт пропускает. Включаются задачей `mise run setup:hooks`, она уже входит в `mise run generate`. Повод: CI падал на swift-format, теперь это ловится до пуша. Код: [`.githooks/pre-commit`](https://github.com/disavle/buzz/blob/main/.githooks/pre-commit), [`.githooks/run-lint`](https://github.com/disavle/buzz/blob/main/.githooks/run-lint), задача [`mise.toml:46`](https://github.com/disavle/buzz/blob/main/mise.toml#L46).

**Документация.** [swift-format](https://github.com/swiftlang/swift-format), [SwiftLint](https://github.com/realm/SwiftLint), [mise generate git-pre-commit](https://mise.jdx.dev/cli/generate/git-pre-commit.html)

**Код в Buzz.** [`.swift-format`](https://github.com/disavle/buzz/blob/main/.swift-format), [`.swiftlint.yml`](https://github.com/disavle/buzz/blob/main/.swiftlint.yml), задачи `lint` в [`mise.toml`](https://github.com/disavle/buzz/blob/main/mise.toml).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4a.

---

## H6. Renovate

**Что и зачем.** Бот раз в неделю открывает PR с обновлениями версий в `mise.toml`, Gemfile, GitHub Actions и SPM. В отличие от Dependabot, понимает `mise.toml`.

**Документация.** [Renovate docs](https://docs.renovatebot.com)

**Код в Buzz.** [`renovate.json`](https://github.com/disavle/buzz/blob/main/renovate.json).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4a.

---

## H7. GitHub Flow и защита main (rulesets)

**Что и зачем.** Простой процесс для одной ветки `main`: любая работа идёт в короткой ветке (`feature/…`, `fix/…`, `chore/…`), через PR с зелёным CI и вливается squash-коммитом, так что в `main` один коммит на задачу. Релиз — тег `ios-v*`. Ruleset на `main` запрещает прямой пуш и вливание без зелёных проверок, а Renovate с auto-merge сам вливает мелкие обновления.

**Было → стало.** Git Flow с `develop`/`release`/`hotfix`, ручная дисциплина «не пушим в master» → GitHub Flow + ruleset, который проверяет правила за тебя.

**Ревью до пуша (с 2026-10-16).** Ветки Claude ничего не пушат в `disavle/buzz`, пока ты не посмотрел код. Изменения лежат патчем в `/mnt/project-files/review/` с коротким пояснением. Посмотреть и применить у себя: `git apply --stat x.patch` (что меняется), `git apply --check x.patch` (ляжет ли), `git am x.patch` (применить с сообщением коммита). Потом ты пишешь «ок», и ветка пушит и открывает PR.

**Документация.** [GitHub Flow](https://docs.github.com/get-started/using-github/github-flow), [Rulesets](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets), [Squash merging](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/configuring-commit-squashing-for-pull-requests), [Auto-merge](https://docs.github.com/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)

**Код в Buzz.** [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md) (ветки, цикл PR, коммиты), [`.github/workflows/ci.yml`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml), [`renovate.json`](https://github.com/disavle/buzz/blob/main/renovate.json).

**Описание.** [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md) (чек-лист ручных шагов).

---

## H8. Заведение репозитория: чек-лист

**Что и зачем.** Список того, что делается один раз при создании репозитория, чтобы проект выглядел и работал как настоящий: описание, лицензия, правила работы, CI, защита веток, автообновления. В новом проекте повторяй по этому списку.

**Было → стало.** Репозиторий «просто с кодом» → репозиторий, который сам проверяет PR, обновляет зависимости и объясняет новичку, как запустить проект одной командой.

**Что уже сделано в Buzz (коммитами).**
- [x] README на двух языках: [`README.md`](https://github.com/disavle/buzz/blob/main/README.md) (английский) и [`README.ru.md`](https://github.com/disavle/buzz/blob/main/README.ru.md), ссылки друг на друга вверху.
- [x] Лицензия [`LICENSE`](https://github.com/disavle/buzz/blob/main/LICENSE).
- [x] Правила работы [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md): GitHub Flow, префиксы веток, squash, формат коммитов.
- [x] `.gitignore` без `*.xcodeproj` (проект генерирует Tuist).
- [x] Единый CI [`.github/workflows/ci.yml`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml).
- [x] Линтеры [`.swift-format`](https://github.com/disavle/buzz/blob/main/.swift-format), [`.swiftlint.yml`](https://github.com/disavle/buzz/blob/main/.swiftlint.yml) и pre-commit хук через mise.
- [x] Версии инструментов и задачи в [`mise.toml`](https://github.com/disavle/buzz/blob/main/mise.toml), конфиг Renovate [`renovate.json`](https://github.com/disavle/buzz/blob/main/renovate.json).
- [x] Документация в [`docs/`](https://github.com/disavle/buzz/tree/main/docs), моки в [`Mocks/`](https://github.com/disavle/buzz/tree/main/Mocks).

**Что делается руками в настройках GitHub** (коммитом не сделать, подробности в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md)):
- [ ] About: описание, сайт, topics (`ios`, `swiftui`, `vapor`, `swift`, `tuist`). Кнопка ⚙ справа от About на главной странице репозитория.
- [ ] Установить GitHub App Renovate на репозиторий.
- [ ] Settings → General → Pull Requests: только Squash merging, Allow auto-merge, Automatically delete head branches.
- [ ] Ruleset на `main`: обязательный PR, проверки `iOS` и `Backend`, запрет force push.
- [ ] Позже, с Apple Developer Program: секреты для CI и match (шаги 8–13 в `SETUP.md`).

**Документация.** [About README](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes), [Licensing a repository](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository), [Contributor guidelines](https://docs.github.com/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors), [Topics](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics)

**Код в Buzz.** корень репозитория [disavle/buzz](https://github.com/disavle/buzz).

**Описание.** [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md).

---

## H9. Релизы: CHANGELOG и GitHub Release по тегу

**Что и зачем.** `CHANGELOG.md` — человеческий список изменений по версиям в формате Keep a Changelog: сверху `[Unreleased]`, ниже версии с датой, внутри разделы. Версии по SemVer (`MAJOR.MINOR.PATCH`). Тег `v*` запускает workflow, который берёт раздел нужной версии из `CHANGELOG.md` и создаёт **черновик** GitHub Release; ты проверяешь текст и жмёшь «Publish release». Тег `ios-v*` — отдельная история, он отправляет сборку в TestFlight (H4), так что релиз на GitHub ничего не выкладывает в Apple.

**Было → стало.** Release notes вручную в App Store Connect и в чате команды → один файл в репозитории, из которого текст попадает в релиз автоматически.

**Документация.** [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/), [Semantic Versioning](https://semver.org/lang/ru/), [GitHub: About releases](https://docs.github.com/repositories/releasing-projects-on-github/about-releases), [gh release create](https://cli.github.com/manual/gh_release_create)

**Код в Buzz.** [`CHANGELOG.md`](https://github.com/disavle/buzz/blob/main/CHANGELOG.md), [`.github/workflows/release.yml`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml): вырезка раздела через `awk` [`:31`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml#L31), черновик релиза [`:45`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml#L45). Первый релиз — `v0.1.0` (PR #13).

**Описание.** комментарии в начале `release.yml` и в шапке `CHANGELOG.md`.

---

## Журнал изменений

- **2026-10-15.** Первая версия: 49 карточек по материалам веток «План изучения», «Идея», «SwiftUI-клиент», «Бэкенд на Vapor», «Дизайн», «Архитектура и инфраструктура».
- **2026-10-15.** Появился настоящий код Buzz (ветка «Публичный репозиторий Buzz»): во всех карточках «Где в Buzz» заменено на «Код в Buzz» с путями и строками в репозитории. Новая карточка C7 про моки и фейковый сервер.
- **2026-10-15.** Репозиторий опубликован: пути в «Код в Buzz» стали ссылками на GitHub.
- **2026-10-15.** Ветка «Архитектура и инфраструктура»: карточка H7 про GitHub Flow, squash и rulesets; в H4 отмечен переход на единый `ci.yml` (PR #1).
- **2026-10-15.** PR #1 влит: H4 и H7 ссылаются на `ci.yml`, `CONTRIBUTING.md` и `docs/infra/SETUP.md` в `main`. Новая карточка H8: чек-лист заведения репозитория (что сделано файлами, что руками в Settings).
- **2026-10-15.** G8: добавлена рекомендация по бесплатному хостингу (Render + Neon), пока без деплоя.
- **2026-10-15.** H2: алиасы zsh `buzz-ios`/`buzz-api`/`buzz-dev` и задача `mise run ios` (PR #4, пока открыт).
- **2026-10-15.** Новая карточка G9: бесплатный деплой бэкенда (Render + Neon), Docker multi-stage, GHCR, deploy hook, конфиг через env (PR #5, пока открыт).
- **2026-10-16.** PR #4, #5, #7, #8 влиты: G9 и H2 со ссылками на код; G9 и H4: деплой только при изменениях `Backend/` и `Shared/`, ручной запуск. C7: адрес сервера для iPhone (`TUIST_API_URL`, `BUZZ_API_URL`). C4: подвох с бесконечной синхронизацией и `localEdits`. H7: ревью патчей до пуша. Последние два пункта пока на ревью.
- **2026-10-16.** H5: git-хуки в `.githooks/` и `mise run setup:hooks`. C7: адрес сервера по умолчанию для устройства и симулятора. Оба пункта на ревью.
- **2026-10-18.** Новая карточка A8: Combine (Subject, debounce, removeDuplicates, AnyCancellable, мост в async/await) на примере поиска каталога. В B5 отмечено сравнение. Пока на ревью.
- **2026-10-18.** PR #9 и #10 влиты: у A8 (Combine), C4 (`localEdits`), C7 (адрес сервера, условие `[sdk=iphonesimulator*]`), H5 (git-хуки) появились ссылки на код. Ссылки на строки во всём конспекте перепроверены по текущему `main` и сдвинуты там, где код поменялся.
- **2026-10-18.** Отдельный план обучения (`plan.md`) убран по просьбе пользователя. Вместо него в начале справочника курс на 40 будних дней: каждый день пишешь кусочек новой фичи «Самочувствие» в Buzz, задание дня лежит в разделе «Уроки курса» нужной карточки. Объяснение «Зачем столько таргетов» перенесено в E5.
- **2026-10-18.** Новая карточка H9: `CHANGELOG.md` по Keep a Changelog и черновик GitHub Release по тегу `v*` (PR #13). В день 40 добавлен выпуск версии `v0.2.0` с фичей «Самочувствие».
- **2026-10-18.** Справочник и курс разделены по просьбе пользователя. Отсюда убраны шаги «Руками», «Разобрать в Buzz» и уроки, они переехали в [course.md](course.md). Новые карточки: A9 (Mutex), B14 (доступность), C8 (Codable, JSON, Decimal).
