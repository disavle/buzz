# Конспект нового стека: сделай сам

Карточки по всему новому, что уже есть в проекте Buzz: инструменты, фреймворки и подходы. Конспект пополняется сам, когда в ветках проекта появляется новый инструмент, подход или код. Можно и вручную: напиши «обнови конспект» в ветке «Конспект нового стека». В конце файла журнал изменений.

**Как читать карточку.** В каждой одно и то же:
- **Что и зачем.** Одной-двумя фразами.
- **Было → стало.** Что это заменяет из UIKit-стека.
- **Руками.** Короткая инструкция: шаги в пустой песочнице и минимальный пример на игрушечном коде (счётчик, `Item`), чтобы понять инструмент отдельно от Buzz.
- **Разобрать в Buzz.** Что посмотреть и попробовать поправить в коде Buzz. Код пишут ветки проекта, а ты потом изучаешь и правишь его сам; эта строка подсказывает, на что смотреть.
- **Код в Buzz**: файлы и строки, где это используется. Ссылки ведут в репозиторий [disavle/buzz](https://github.com/disavle/buzz), ветка `main`; клонировать: `git clone https://github.com/disavle/buzz.git`.
- **Описание** и **документация**: документ проекта в `docs/` и официальная документация.

Отмечай `[x]`, когда прошёл карточку руками и разобрал это место в коде Buzz.

---

## Курс: 40 будних дней, одна новая фича

Справочник можно читать как wiki, а можно проходить как курс: 8 недель по будням, 30–60 минут в день, с открытым Buzz в Xcode. Каждый день — маленькое задание в одной-двух карточках, раздел **Уроки курса**. Код не удаляешь и не переписываешь по памяти: каждый день дописываешь в Buzz кусочек новой фичи. К концу курса она готова целиком и проходит через все технологии из справочника.

**Фича «Самочувствие».** Вечерняя отметка: настроение от 1 до 5, сколько часов спал, короткая заметка. Отдельная вкладка со списком отметок, формой, поиском по заметкам и графиком «настроение против кофеина». Отметки хранятся в SwiftData, синхронизируются с сервером на Vapor и работают офлайн. Новый модуль `WellbeingFeature`, новая таблица в базе, новые эндпоинты `/checkins`.

**Как проходить день.**
1. Прочитай карточку дня (5–10 минут). Если тема новая, сначала сделай шаг «Руками» в песочнице.
2. Сделай задание дня в ветке `learn/wellbeing`. В задании указано, где подсмотреть похожий код в Buzz: смотреть можно, копировать нельзя.
3. Проверь пункт «Готово, когда». Сделай коммит и запиши в журнал три строки: что сделал, что сломалось, что понял. Журнал — `docs/learning/journal.md` или страница в Notion; потом это готовый материал для резюме.

**Правила.**
- Пишешь сам, без Copilot и без Claude. Можно документацию Apple и Vapor, WWDC и этот справочник. Claude зови после, чтобы сравнить решение или разобрать ошибку.
- Застрял на 25 минут — запиши вопрос в журнал и закончи день. Завтра со свежей головой будет проще.
- Пропустил день или неделю — продолжай с того же места, догонять не надо. Курс без дат.
- Заканчивай день на понятном следующем шаге, тогда завтра легко начать.

**Неделя 1. Модуль и первый экран**

- [ ] День 1. Ветка и пустой модуль (H1, H2, H7)
- [ ] День 2. Модель в Domain (E5, H1)
- [ ] День 3. Первая вьюха и превью (B1, B11)
- [ ] День 4. ViewModel на @Observable (B2, E1)
- [ ] День 5. Список с секциями (B4)

**Неделя 2. Интерфейс**

- [ ] День 6. Форма: поток данных (B3)
- [ ] День 7. Поля ввода и фокус (B7)
- [ ] День 8. Навигация (B8)
- [ ] День 9. Новая вкладка через координатор (E2, B12)
- [ ] День 10. Цвет, анимация, хаптик (B9, B13)

**Неделя 3. Данные**

- [ ] День 11. Модель SwiftData (C2)
- [ ] День 12. Репозиторий в фоне (C3, A3)
- [ ] День 13. Миграция схемы (C2)
- [ ] День 14. Макросы изнутри (A7)
- [ ] День 15. Настройки в @AppStorage (C6)

**Неделя 4. Конкурентность и реактивность**

- [ ] День 16. async/await и отмена (A1)
- [ ] День 17. Параллельная загрузка (A2)
- [ ] День 18. Живые обновления (A4)
- [ ] День 19. Поиск: Combine и .task(id:) (A8, B5)
- [ ] День 20. Старый API и typed throws (A5, A6)

**Неделя 5. Архитектура, строки, тесты**

- [ ] День 21. Use case по Clean (E3)
- [ ] День 22. Мини-Redux для настроек (E4)
- [ ] День 23. Строки и плюрализация (D1, D2)
- [ ] День 24. Форматы (D3)
- [ ] День 25. Тесты на Swift Testing (F1)

**Неделя 6. График и сервер**

- [ ] День 26. График настроения и кофеина (B10)
- [ ] День 27. Готовые модификаторы (B6)
- [ ] День 28. Первый эндпоинт (G2, G1)
- [ ] День 29. Таблица в базе (G3)
- [ ] День 30. Общий DTO (G6)

**Неделя 7. Качество сервера и сеть**

- [ ] День 31. Авторизация и коды ошибок (G4, G5)
- [ ] День 32. Тесты сервера (G7)
- [ ] День 33. Клиент к API (C1)
- [ ] День 34. Фейковый сервер (C7)
- [ ] День 35. Офлайн-синхронизация (C4)

**Неделя 8. Синхронизация, инфраструктура, выпуск**

- [ ] День 36. Сеть пропала и вернулась (C5)
- [ ] День 37. Postgres локально (G8)
- [ ] День 38. Линт и CI (H5, H4)
- [ ] День 39. Деплой (G9, H6)
- [ ] День 40. Выпуск и итоги (H7, H3, H8)

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
- [ ] A8. Combine: Subject, операторы, AnyCancellable

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
- [ ] G9. Деплой: Docker multi-stage, GHCR, deploy hook, 12-factor

**H. Инфраструктура**
- [ ] H1. Tuist: проект как код
- [ ] H2. mise: версии инструментов и задачи
- [ ] H3. fastlane, match, App Store Connect API key
- [ ] H4. GitHub Actions
- [ ] H5. swift-format, SwiftLint, pre-commit
- [ ] H6. Renovate
- [ ] H7. GitHub Flow и защита main (rulesets)
- [ ] H8. Заведение репозитория: чек-лист

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 16. async/await и отмена.** Загружай отметки в `.task { await model.load() }`. Добавь в `InMemoryCheckinRepository` задержку `try await Task.sleep(for: .seconds(2))` и уйди с экрана до конца загрузки. Проверь `Task.isCancelled` и не обновляй состояние после отмены. *Готово, когда:* в консоли видно, что загрузка отменилась при уходе с экрана.

**Документация.** [Swift Book: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [Task](https://developer.apple.com/documentation/swift/task)

**Код в Buzz.** [`iOS/Modules/Networking/Sources/APIClient.swift:37`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L37) (`send` на async/await), обработчики [`Backend/Sources/App/Controllers/EntryController.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 4 (сеть); весь бэкенд ([`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 7).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 17. Параллельная загрузка.** Для карточки дня загрузи отметку и записи кофеина параллельно через `async let`. Для статистики по неделям посчитай средние значения через `withTaskGroup`, по задаче на неделю. *Готово, когда:* две загрузки по 1 секунде вместе занимают около 1 секунды, а не 2.

**Документация.** [Swift Book: Concurrency → Calling Asynchronous Functions in Parallel](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [TaskGroup](https://developer.apple.com/documentation/swift/taskgroup)

**Код в Buzz.** в коде пока не используется; удобное место попробовать `async let`: загрузка данных в [`iOS/Modules/StatsFeature/Sources/StatsViewModel.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsViewModel.swift).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 12. Репозиторий в фоне.** Задание в карточке C3, эта тема в нём тоже нужна.

**Документация.** [Swift Book: Actors](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors), [Swift 6 migration guide](https://www.swift.org/migration/documentation/migrationguide/), [Sendable](https://developer.apple.com/documentation/swift/sendable)

**Код в Buzz.** `actor SyncEngine` в [`iOS/Modules/Sync/Sources/SyncEngine.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L12), `actor SyncStore` в [`iOS/Modules/Sync/Sources/SyncStore.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L12), `actor KeychainTokenStore` в [`iOS/Modules/Networking/Sources/TokenStore.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L17), `@MainActor` ViewModel в [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L13), `Sendable`-класс [`iOS/Modules/Domain/Sources/Broadcaster.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L12).

**Описание.** Все ViewModel `@MainActor` ([`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5); `actor SyncEngine` ([`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md)); модели Fluent `@unchecked Sendable` ([`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 7); Swift 6 strict на весь проект ([`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 3).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 18. Живые обновления.** Пусть репозиторий после `save` и `delete` шлёт сигнал через `Broadcaster`, а ViewModel слушает его в `for await` и перезагружает список. Подсмотри: `Broadcaster.swift`, `EntryStore.swift`. *Готово, когда:* отметка, добавленная через диплинк, появляется в списке без ручного обновления.

**Документация.** [AsyncStream](https://developer.apple.com/documentation/swift/asyncstream), [AsyncSequence](https://developer.apple.com/documentation/swift/asyncsequence)

**Код в Buzz.** [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L28) (колбэк → `AsyncStream`), [`iOS/Modules/Sync/Sources/SyncEngine.swift:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L48) и [`:66`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L66), [`iOS/Modules/Domain/Sources/Broadcaster.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L12) (один источник, много подписчиков).

**Описание.** [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), разделы 2–3 и 5.

---

## A5. Мост со старым кодом: continuation

**Что и зачем.** Обернуть API на колбэках в `async`-функцию.

**Было → стало.** колбэк остаётся внутри, наружу торчит `async`.

**Руками.**
1. Возьми любую функцию с completion handler (или напиши свою с `DispatchQueue.asyncAfter`).
2. Оберни: `try await withCheckedThrowingContinuation { cont in old { result in cont.resume(with: result) } }`.
3. Специально вызови `resume` дважды и посмотри на краш в debug: checked-версия ловит эту ошибку.

**Разобрать в Buzz.** Если понадобится системный API без async-версии (например, запрос разрешения), оберни его так.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 20. Старый API и typed throws.** Напиши напоминание через `UNUserNotificationCenter`. Оберни callback-метод `getPendingNotificationRequests(completionHandler:)` в `withCheckedContinuation` (даже если есть async-версия, так ты увидишь, как она устроена). Ошибки сохранения опиши как `enum CheckinError: Error` и используй `throws(CheckinError)`. *Готово, когда:* напоминание приходит в выбранное время, `catch` знает точный тип ошибки без `as?`.

**Документация.** [withCheckedThrowingContinuation](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(isolation:function:_:))

**Код в Buzz.** `withCheckedContinuation` в коде нет; похожий мост «колбэк → async» сделан через `AsyncStream` в [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L7).

---

## A6. Typed throws

**Что и зачем.** Функция может объявить конкретный тип ошибки: `throws(SyncError)`. Тогда в `catch` сразу `SyncError`, без приведения типов.

**Было → стало.** `throws` + `catch let e as MyError` → `throws(MyError)`.

**Руками.**
1. Объяви `enum ParseError: Error { case empty, notNumber }`.
2. Напиши `func parse(_ s: String) throws(ParseError) -> Int`.
3. В `do { } catch { }` проверь, что `error` уже имеет тип `ParseError` (поставь `switch error` без `default`).

**Разобрать в Buzz.** Зависимость `sync` в Redux-окружении «Настроек» объявлена как `throws(SyncError)`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 20. Старый API и typed throws.** Задание в карточке A5, эта тема в нём тоже нужна.

**Документация.** [SE-0413 Typed throws](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md), [Swift Book: Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)

**Код в Buzz.** `throws(APIError)` в [`iOS/Modules/Networking/Sources/APIClient.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L19), use case в [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L10).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 2 (`SettingsEnvironment`).

---

## A7. Макросы

**Что и зачем.** `@Observable`, `@Model`, `#Predicate`, `#Preview`, `@Test`, `#expect`, `@Entry` — всё это макросы, которые генерируют код при компиляции. Понимание того, во что они раскрываются, помогает читать ошибки.

**Было → стало.** ручной бойлерплейт, кодогенерация Sourcery → макросы в языке.

**Руками.**
1. Поставь курсор на `@Observable` в своей модели → правый клик → **Expand Macro**. Посмотри на `_$observationRegistrar` и `access/withMutation`.
2. То же для `@Model` и `#Predicate`.
3. По желанию: File → New → Package → шаблон **Swift Macro**, напиши макрос `#URL("...")`, который проверяет строку при компиляции.

**Разобрать в Buzz.** Раскрыть `@Observable` у `TodayViewModel` и `@Model` у `EntryModel`, понять, что сгенерировано. Свой макрос `#URL` для базового адреса API.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 14. Макросы изнутри.** Напиши `#Predicate<CheckinModel>` для отметок за последние 7 дней. В Xcode нажми правой кнопкой на `@Model` и `#Predicate` → Expand Macro и прочитай, какой код они генерируют. *Готово, когда:* можешь своими словами объяснить, что `@Model` добавляет к классу.

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

**Руками.**
1. В Playground: `let subject = PassthroughSubject<String, Never>()`, `let c = subject.sink { print($0) }`, потом `subject.send("a")`. Убери `c`, отправь ещё раз и убедись, что ничего не печатается.
2. Добавь `.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)` и быстро отправь «c», «co», «col». Должно напечататься только «col».
3. Вставь `.removeDuplicates()` и отправь одно и то же дважды с паузой.
4. Напиши ViewModel с `var query = "" { didSet { subject.send(query) } }` и подпиской в `init`, которая вызывает async-метод через `Task`.
5. Тест: шпион считает вызовы поиска, быстрый ввод даёт ровно один вызов (debounce в тесте сделай 50 мс через параметр `init`).

**Разобрать в Buzz.** Сравни `CatalogViewModel` (Combine) с `AddEntryView` (`.task(id:)`): что короче, где проще отмена, как каждое тестируется. Куда ещё можно потренироваться (в Buzz не сделано): `NotificationCenter.default.publisher(for:)` для возврата из фона, `NetworkMonitor` на `CurrentValueSubject`, `Timer.publish` для снека.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 19. Поиск: Combine и .task(id:).** Добавь поиск по заметкам. Сначала через Combine: `PassthroughSubject` → `debounce` → `removeDuplicates` → `sink`, подписку держи в `AnyCancellable`. Потом в отдельном коммите перепиши на `.task(id: query)` и оставь тот вариант, который понятнее. *Готово, когда:* быстрый ввод даёт один поиск, а не по поиску на каждую букву.

**Документация.** [Combine](https://developer.apple.com/documentation/combine), [Receiving and Handling Events with Combine](https://developer.apple.com/documentation/combine/receiving-and-handling-events-with-combine), [debounce](https://developer.apple.com/documentation/combine/publisher/debounce(for:scheduler:options:)), [AnyCancellable](https://developer.apple.com/documentation/combine/anycancellable), [Using Combine (книга, бесплатно)](https://heckj.github.io/swiftui-notes/)

**Код в Buzz.** subject [`iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:40`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L40), `didSet` [`:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L28), `AnyCancellable` [`:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L45), цепочка с `debounce` [`:70`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L70), `sink` и `assumeIsolated` [`:75`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L75), отмена прошлого поиска [`:88`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L88); тест «быстрый ввод = один поиск» [`iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift:58`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift#L58). Влито в PR #10.

**Описание.** комментарии в самом `CatalogViewModel.swift`, они написаны как пошаговый разбор.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 3. Первая вьюха и превью.** Сделай `CheckinRow`: дата, эмодзи настроения, часы сна. Никакого состояния, только входные данные. Добавь три `#Preview`: хорошее настроение, плохое, сон 0 часов. Подсмотри: `DrinkCard` в `CatalogView.swift`. *Готово, когда:* в канвасе Xcode видно три варианта строки.

**Документация.** [SwiftUI](https://developer.apple.com/documentation/swiftui), [Туториалы SwiftUI](https://developer.apple.com/tutorials/swiftui)

**Код в Buzz.** [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift), `Identifiable`-модели в [`iOS/Modules/Domain/Sources/Models/Entry.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Entry.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 6 (таблица UIKit → SwiftUI).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 4. ViewModel на @Observable.** Создай `@Observable @MainActor final class WellbeingViewModel` со свойством `checkins: [Checkin]` и методом `load() async`, который берёт данные из `CheckinRepository`. Зависимость передавай в `init`. Подсмотри: `TodayViewModel.swift`. *Готово, когда:* превью экрана с `InMemoryCheckinRepository` показывает список из трёх отметок.

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

**Руками.**
1. Сделай `ToggleRow(isOn: Binding<Bool>)` и передай в неё `$flag` из родителя.
2. Добавь ключ окружения: `extension EnvironmentValues { @Entry var greeting = "Привет" }`, прочитай его через `@Environment(\.greeting)`, подмени через `.environment(\.greeting, "Hi")`.
3. Положи `@Observable`-объект через `.environment(obj)` и прочитай `@Environment(MyObj.self)`.

**Разобрать в Buzz.** `APIClient` положить в окружение через `@Entry` и подменять фейком в превью.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 6. Форма: поток данных.** Создай `CheckinForm`: экран держит черновик в `@State`, а дочерняя вьюха `MoodPicker` получает `@Binding var mood: Int`. Если форма работает с `@Observable` моделью, используй `@Bindable`. Подсмотри: `AddEntryView.swift`. *Готово, когда:* выбор настроения в `MoodPicker` сразу меняет значение в родителе.

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

**Руками.**
1. `List` из 20 элементов с двумя `Section` и свайпом удаления `.onDelete`.
2. Сетка: `LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))])` внутри `ScrollView`. Поверни симулятор и посмотри, как меняется число колонок.
3. Горизонтальная карусель с `.scrollTargetLayout()` и `.scrollTargetBehavior(.viewAligned)`.

**Разобрать в Buzz.** Сетка каталога банок и горизонтальная лента «Недавние» в шите «Добавить».

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 5. Список с секциями.** Покажи отметки в `List`, сгруппированные по неделям (`Section` на каждую неделю). Добавь удаление свайпом (`.onDelete` или `.swipeActions`), которое зовёт `repository.delete`. Сравни с тем, сколько кода это заняло бы на Diffable + CompositionalLayout. *Готово, когда:* строки удаляются свайпом и не возвращаются после повторного `load()`.

**Документация.** [Lists](https://developer.apple.com/documentation/swiftui/lists), [LazyVGrid](https://developer.apple.com/documentation/swiftui/lazyvgrid), [scrollTargetBehavior](https://developer.apple.com/documentation/swiftui/view/scrolltargetbehavior(_:))

**Код в Buzz.** `LazyVGrid` в [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:29`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L29), `List` в [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), разделы 4.1–4.3 и 5.

---

## B5. Жизненный цикл: .task, .task(id:), debounce без Combine

**Что и зачем.** `.task { }` запускает async-работу при появлении View и сам отменяет её при уходе. `.task(id: value)` перезапускает задачу при каждом изменении `value`, отменяя предыдущую.

**Было → стало.** `viewDidLoad` + ручная отмена запросов; `debounce` из Combine → `.task(id:)` + `Task.sleep`.

**Руками.**
1. Повесь `.task { await model.load() }` на экран и уйди с него во время загрузки: проверь, что задача отменилась.
2. Сделай поле поиска и `.task(id: text) { try? await Task.sleep(for: .milliseconds(300)); ... }`. Печатай в консоль, сколько раз реально выполнился поиск при быстром наборе.
3. Попробуй `.onChange(of: value, initial: true) { }` для синхронной реакции.

**Разобрать в Buzz.** Поиск по каталогу с debounce 300 мс. Поиск каталога переведён на Combine (A8), а на `.task(id:)` остался экран «Добавить банку». Сравни два подхода.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 19. Поиск: Combine и .task(id:).** Задание в карточке A8, эта тема в нём тоже нужна.

**Документация.** [task(id:priority:_:)](https://developer.apple.com/documentation/swiftui/view/task(id:priority:_:)), [onChange](https://developer.apple.com/documentation/swiftui/view/onchange(of:initial:_:))

**Код в Buzz.** debounce через `.task(id:)` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:35`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L35), автоскрытие снека в [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:70`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L70).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.3.

---

## B6. Готовые модификаторы: searchable, refreshable, ContentUnavailableView

**Было → стало.**
- `UISearchController` → `.searchable(text: $query)`.
- `UIRefreshControl` + target/action → `.refreshable { await reload() }` (индикатор крутится, пока функция не вернётся).
- своя пустая View в `backgroundView` → `ContentUnavailableView("Пусто", systemImage: "tray")`.

**Руками.** На одном экране со списком подключи все три. Для `refreshable` сделай функцию с `Task.sleep(for: .seconds(2))` и посмотри, как ведёт себя индикатор.

**Разобрать в Buzz.** Pull to refresh на «Сегодня» запускает синхронизацию; пустое состояние «Пока ни одной банки».

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 27. Готовые модификаторы.** Добавь `.searchable` для поиска из дня 19, `.refreshable` для ручной синхронизации и `ContentUnavailableView` для пустого списка и пустого поиска. *Готово, когда:* пустой экран выглядит как системный, pull-to-refresh работает.

**Документация.** [searchable](https://developer.apple.com/documentation/swiftui/view/searchable(text:placement:prompt:)), [refreshable](https://developer.apple.com/documentation/swiftui/view/refreshable(action:)), [ContentUnavailableView](https://developer.apple.com/documentation/swiftui/contentunavailableview)

**Код в Buzz.** [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L45) и [`:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L49), [`iOS/Modules/TodayFeature/Sources/TodayView.swift:43`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L43) и [`:71`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L71), [`iOS/Modules/StatsFeature/Sources/StatsView.swift:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L44).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), раздел «Синхронизация в интерфейсе».

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 7. Поля ввода и фокус.** В `CheckinForm` используй `Form`: `Stepper` или `Slider` для сна, `TextField(value:format:)` для часов, `TextField` для заметки. Через `@FocusState` переводи фокус с часов на заметку по Return и скрывай клавиатуру по кнопке «Готово». *Готово, когда:* в поле часов нельзя ввести буквы, Return переносит фокус на заметку.

**Документация.** [Form](https://developer.apple.com/documentation/swiftui/form), [TextField](https://developer.apple.com/documentation/swiftui/textfield), [FocusState](https://developer.apple.com/documentation/swiftui/focusstate)

**Код в Buzz.** `TextField(value:format:)` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:151`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L151) и [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L47), форма входа [`iOS/Modules/SettingsFeature/Sources/LoginView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/LoginView.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), разделы 4.2–4.5; [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 4.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 8. Навигация.** Оберни список в `NavigationStack`. По кнопке «+» открывай `CheckinForm` в `.sheet`, по тапу на строку переходи к деталям через `navigationDestination(for: Checkin.self)`. *Готово, когда:* форма закрывается после сохранения, детали открываются и закрываются свайпом назад.

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

**Руками.**
1. Нарисуй кольцо из двух `Circle`, вторая с `.trim` и `.rotationEffect(.degrees(-90))`. Кнопка добавляет 10% и анимирует.
2. Число в центре с `.contentTransition(.numericText(value: value))`.
3. Плашка внизу экрана, которая появляется по кнопке и сама исчезает через 3 секунды через `.task(id: isShown) { try? await Task.sleep(for: .seconds(3)); isShown = false }`.
4. `.sensoryFeedback(.warning, trigger: isOver)` и проверь на устройстве.

**Разобрать в Buzz.** Кольцо кофеина, снек «банка добавлена» с кнопкой «Отменить», хаптик при превышении лимита.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 10. Цвет, анимация, хаптик.** Раскрась эмодзи настроения токенами из `Theme.swift` (никаких `Color(red:...)`). При сохранении дай `.sensoryFeedback(.success, trigger:)`, а счётчик «дней подряд» анимируй через `.contentTransition(.numericText())`. Подсмотри: `CaffeineRing.swift`. *Готово, когда:* в тёмной теме цвета читаются, телефон вибрирует при сохранении.

**Документация.** [Animations](https://developer.apple.com/documentation/swiftui/animations), [sensoryFeedback](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)), [navigationTransition](https://developer.apple.com/documentation/swiftui/view/navigationtransition(_:))

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L38) (numericText) и [`:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L47) (хаптик), [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:59`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L59) и [`:62`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L62).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.1; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), разделы «Типографика» и «Снек»; эксперимент с зумом в [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 7.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 26. График настроения и кофеина.** На экране статистики самочувствия нарисуй `BarMark` с кофеином по дням и `LineMark` с настроением, плюс `RuleMark` со средним настроением. Подсмотри: `StatsView.swift`. *Готово, когда:* видно, совпадают ли плохие дни с днями, когда было много кофеина.

**Документация.** [Swift Charts](https://developer.apple.com/documentation/charts), [Creating a chart using Swift Charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)

**Код в Buzz.** [`iOS/Modules/StatsFeature/Sources/StatsView.swift:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L47) (Bar + Rule), [`:126`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L126) (Sector), [`:170`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L170) (Line + Point); данные в [`iOS/Modules/StatsFeature/Sources/StatsCalculator.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsCalculator.swift).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 4.4; [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 5.

---

## B11. #Preview

**Что и зачем.** Экран рендерится прямо в Xcode без запуска приложения, с любыми фейковыми данными, языком и темой.

**Было → стало.** запуск на симуляторе и проход до нужного экрана → `#Preview { MyView(model: .fake) }`.

**Руками.**
1. Сделай несколько превью одного экрана: `#Preview("Пусто")`, `#Preview("С данными")`, `#Preview("Ошибка")`.
2. Для SwiftData: in-memory контейнер `ModelContainer(for: X.self, configurations: .init(isStoredInMemoryOnly: true))` и `.modelContainer(container)`.
3. Превью на двух языках через `.environment(\.locale, Locale(identifier: "ru"))` и в тёмной теме через `.preferredColorScheme(.dark)`.

**Разобрать в Buzz.** Превью каждого экрана в трёх состояниях на фейковых репозиториях.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 3. Первая вьюха и превью.** Задание в карточке B1, эта тема в нём тоже нужна.

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

**Руками.**
1. В UIKit-проекте запушь `UIHostingController(rootView: Text("Привет"))` в `UINavigationController`. Поставь в SwiftUI `.navigationTitle` и проверь, что он попал в навбар.
2. В существующей коллекции на Diffable перепиши одну ячейку на `UIHostingConfiguration`, не трогая data source. Сравни объём кода.
3. Оберни `UITextView` в `UIViewRepresentable` с `@Binding var text` и `Coordinator` как делегатом.

**Разобрать в Buzz.** Все экраны Buzz показываются через хостинг из координаторов; на работе — одна ячейка на `UIHostingConfiguration`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 9. Новая вкладка через координатор.** Задание в карточке E2, эта тема в нём тоже нужна.

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UIHostingConfiguration](https://developer.apple.com/documentation/swiftui/uihostingconfiguration), [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)

**Код в Buzz.** хостинг экранов в [`iOS/App/Sources/AppDependencies.swift:89`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L89), координатор [`iOS/App/Sources/Coordinators/TodayCoordinator.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift); `UIHostingConfiguration` и `Representable` в Buzz не используются, пробуй на работе.

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 6 (тонкости гибрида).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 10. Цвет, анимация, хаптик.** Задание в карточке B9, эта тема в нём тоже нужна.

**Документация.** [Color](https://developer.apple.com/documentation/swiftui/color), [Human Interface Guidelines: Color](https://developer.apple.com/design/human-interface-guidelines/color), [Dynamic Type](https://developer.apple.com/documentation/swiftui/dynamictypesize)

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Theme.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L13), выбор акцента [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:15`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L15) и [`:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L44).

**Описание.** [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md); макеты: [холст Buzz](https://claude.ai/artifact/DBEh5DEASJSWRzgj8Bvp2W).

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

**Разобрать в Buzz.** Модуль `Networking` с `APIClient` и эндпоинтами из `app/backend/API.md`; ошибки сервера разбираются в `APIErrorCode` из `Shared`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 33. Клиент к API.** Добавь в `Endpoint.swift` и `APIClient.swift` методы `fetchCheckins()` и `send(_:)`. Ошибки сервера мапь в свой `enum`. Подсмотри: `DTOMapping.swift`. *Готово, когда:* приложение с локальным бэкендом показывает отметки с сервера.

**Документация.** [URLSession](https://developer.apple.com/documentation/foundation/urlsession), [Codable](https://developer.apple.com/documentation/swift/codable)

**Код в Buzz.** [`iOS/Modules/Networking/Sources/APIClient.swift:26`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L26), [`iOS/Modules/Networking/Sources/Endpoint.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L9), маппинг DTO [`iOS/Modules/Networking/Sources/DTOMapping.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/DTOMapping.swift).

**Описание.** [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 4; [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 11. Модель SwiftData.** В `Persistence/Sources/Models/` создай `@Model final class CheckinModel` пока без заметки (её сохранение добавишь в день 13) и добавь его в схему в `PersistenceContainer.swift`. Напиши маппинг `CheckinModel` ↔ `Checkin`. Подсмотри: `EntryModel.swift`. *Готово, когда:* отметка переживает перезапуск приложения.
- **День 13. Миграция схемы.** Добавь в `CheckinModel` поле `note: String`, чтобы заметка из формы сохранялась. Сначала без значения по умолчанию: запусти поверх старых данных и посмотри, что будет. Потом оформи `SchemaV1`/`SchemaV2` (`VersionedSchema`) и `SchemaMigrationPlan` со стадией, которая заполняет `note` пустой строкой. *Готово, когда:* старые отметки на месте, у новых есть заметка.

**Документация.** [SwiftData](https://developer.apple.com/documentation/swiftdata), [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches)

**Код в Buzz.** [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L6), [`iOS/Modules/Persistence/Sources/Models/DrinkModel.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/DrinkModel.swift#L9), контейнер [`iOS/Modules/Persistence/Sources/PersistenceContainer.swift:14`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/PersistenceContainer.swift#L14) (миграций схемы пока нет).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 3; [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 5 (SwiftData за протоколом репозитория).

---

## C3. @ModelActor: SwiftData в фоне

**Что и зачем.** Макрос `@ModelActor` делает актор со своим `ModelContext`, работающим не на главном потоке. Так репозиторий читает и пишет в фоне, а наружу отдаёт `Sendable`-структуры.

**Было → стало.** `NSPersistentContainer.performBackgroundTask`, дочерние контексты → `@ModelActor actor Repo`.

**Руками.**
1. `@ModelActor actor NoteRepository { func all() throws -> [NoteDTO] { try modelContext.fetch(FetchDescriptor<Note>()).map { ... } } }`.
2. Создай его как `NoteRepository(modelContainer: container)` и вызови из `@MainActor`-модели через `await`.
3. Попробуй вернуть наружу сам `Note` и прочитай ошибку компилятора про `Sendable`.

**Разобрать в Buzz.** `SwiftDataEntryRepository` и `SyncStore` в модуле `Persistence`/`Sync`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 12. Репозиторий в фоне.** Напиши `SwiftDataCheckinRepository` как `@ModelActor`-актор, реализующий `CheckinRepository`. Наружу отдавай только `Checkin` (Sendable), никогда `CheckinModel`. Подключи его в `AppDependencies.swift`. Подсмотри: `SwiftDataEntryRepository.swift`. *Готово, когда:* сборка без предупреждений Swift 6 о `Sendable`; попробуй вернуть `CheckinModel` наружу и прочитай ошибку.

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

**Руками.**
1. Нарисуй на бумаге состояния записи и переходы между ними.
2. Напиши `actor SyncEngine` с методом `syncNow()` и флагами `isRunning`/`needsAnotherPass`. Проверь тестом, что два параллельных вызова не дают параллельных проходов.
3. Напиши `apply(delta)` и тест «pending-запись не перезаписывается свежей версией с сервера».

**Подвох: бесконечный цикл (исправлено в PR #9).** Движок синхронизации слушал тот же сигнал «данные изменились», который сам и отправлял после `apply`, поэтому каждый проход через ~2 секунды запускал следующий, и статус мигал. Решение: отдельный сигнал `localEdits` (`Broadcaster<Void>`), который шлёт только репозиторий при правке пользователя и слушает только движок; пустой ответ `/sync` больше ничего не сохраняет. Урок: у события должен быть один смысл, «экран, перерисуйся» и «надо отправить» — разные сигналы. Код: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L17), подключение в [`iOS/App/Sources/AppDependencies.swift:77`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L77).

**Разобрать в Buzz.** Модуль `Sync` целиком, по шагам из раздела 7 `sync.md`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 35. Офлайн-синхронизация.** Добавь в `CheckinModel` поле `syncState` (`pending`/`synced`), а в `SyncEngine` и `SyncStore` отправку pending-отметок и приём новых с сервера. Правило: не перетирать то, что ещё не отправлено. Подсмотри: `SyncStore.swift`, `SyncEngine.swift`, тесты синхронизации. *Готово, когда:* отметка, сделанная на одном симуляторе, появляется на другом под тем же пользователем.

**Документация.** Готового фреймворка нет, это паттерн. Полезно: [WWDC23 «Sync to iCloud with CKSyncEngine»](https://developer.apple.com/videos/play/wwdc2023/10188/) для сравнения с тем, как Apple решает ту же задачу.

**Код в Buzz.** [`iOS/Modules/Sync/Sources/SyncEngine.swift:31`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L31) (`syncNow`), [`iOS/Modules/Sync/Sources/SyncStore.swift:96`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L96) (`apply`), [`iOS/Modules/Persistence/Sources/Models/SyncState.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/SyncState.swift), тесты [`iOS/Modules/Sync/Tests/SyncEngineTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift); сервер [`Backend/Sources/App/Controllers/SyncController.swift:24`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/SyncController.swift#L24).

**Описание.** [`docs/idea.md`](https://github.com/disavle/buzz/blob/main/docs/idea.md), «Зачем синхронизация»; [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md); сервер: `/sync` в [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md).

---

## C5. NWPathMonitor и триггеры синхронизации

**Что и зачем.** `NWPathMonitor` сообщает, когда появилась или пропала сеть. Вместе с жизненным циклом сцены это даёт триггеры синхронизации.

**Было → стало.** Reachability (сторонняя) → `NWPathMonitor` из Network.framework.

**Руками.**
1. Создай `NWPathMonitor()`, задай `pathUpdateHandler`, вызови `start(queue:)`.
2. Переведи колбэк в `AsyncStream<Bool>` (см. A4) и читай его `for await`.
3. Включи и выключи Wi-Fi на Mac при запущенном симуляторе, посмотри на события.

**Разобрать в Buzz.** Переход `.unsatisfied → .satisfied` запускает `syncNow()`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 36. Сеть пропала и вернулась.** Выключи сеть, добавь три отметки, включи сеть. Проследи, как `NetworkMonitor` запускает синхронизацию. Добавь в UI значок «не отправлено» для pending-отметок. *Готово, когда:* после включения сети значки исчезают сами.

**Документация.** [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor)

**Код в Buzz.** [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:15`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L15), возврат из фона [`iOS/App/Sources/SceneDelegate.swift:53`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L53).

**Описание.** [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 4. Дальше, вне MVP: [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks) (`BGAppRefreshTask`).

---

## C6. @AppStorage и Keychain

**Что и зачем.** `@AppStorage("key")` — обёртка над `UserDefaults`, которая обновляет View при изменении. Токен авторизации хранится в Keychain, не в `UserDefaults`.

**Было → стало.** `UserDefaults.standard.set` + ручное обновление UI → `@AppStorage`; Keychain остаётся Keychain (Security framework).

**Руками.**
1. `@AppStorage("limit") var limit = 400` и `Stepper` к нему; перезапусти приложение.
2. `@AppStorage` с `enum: String` (`RawRepresentable`).
3. Напиши маленькую обёртку над `SecItemAdd` / `SecItemCopyMatching` / `SecItemDelete` для строки-токена.

**Разобрать в Buzz.** Лимит и выбранный цвет в `@AppStorage`; токен в Keychain после логина.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 15. Настройки в @AppStorage.** Добавь два параметра: время напоминания и «показывать кофеин на графике». Храни их в `@AppStorage`, время — как `Double` (секунды от полуночи). Подсмотри: `AccentChoice.swift`. *Готово, когда:* значения сохраняются после перезапуска и меняют экран сразу.

**Документация.** [AppStorage](https://developer.apple.com/documentation/swiftui/appstorage), [Keychain services](https://developer.apple.com/documentation/security/keychain-services)

**Код в Buzz.** Keychain [`iOS/Modules/Networking/Sources/TokenStore.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L17), `@AppStorage` [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:39`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L39), лимит [`iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift#L9).

**Описание.** [`docs/client/screens.md`](https://github.com/disavle/buzz/blob/main/docs/client/screens.md), раздел 3; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), «Основной цвет».

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

**Адрес сервера (PR #9).** На iPhone `localhost` — это сам телефон, поэтому адрес бэкенда зашивается в сборку. В `mise.local.toml` (не в git) пишешь `TUIST_API_URL = "https://<сервис>.onrender.com"`, `mise run generate` кладёт его в `Info.plist` под ключом `BuzzAPIURL`, и приложение ходит на Render даже при запуске с иконки. По умолчанию устройство и TestFlight-сборка ходят на `https://buzz-backend-latest.onrender.com`, симулятор на `http://localhost:8080`, а `TUIST_API_URL` это переопределяет. Порядок выбора в `AppDependencies`: `BUZZ_MOCK_API = 1` (фейковый сервер) → `BUZZ_API_URL` из схемы (разовое переопределение, только из Xcode) → `BuzzAPIURL` из `Info.plist` → `http://localhost:8080`. Чтобы iPhone ходил на бэкенд, запущенный на Mac, в `TUIST_API_URL` можно указать IP Mac в той же Wi-Fi сети, например `http://192.168.1.5:8080` (в документах проекта этого нет, проверь сам; по http iOS может потребовать исключение ATS). Как это сделано: в [`iOS/Project.swift:81`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L81) build setting `BUZZ_SERVER_URL` имеет два значения, обычное и `[sdk=iphonesimulator*]` (условие по SDK, приём Xcode из xcconfig), а `Info.plist` подставляет его через `$(BUZZ_SERVER_URL)` ([`:48`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L48)). Порядок выбора в коде: [`iOS/App/Sources/AppDependencies.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L49). Описание в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md), шаг 6.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 34. Фейковый сервер.** Научи `MockAPIClient` хранить отметки в памяти, чтобы экран работал с `BUZZ_MOCK_API = 1` без бэкенда. Добавь задержку ответа, чтобы увидеть индикатор загрузки. *Готово, когда:* экран полностью работает без сервера и без интернета.

**Документация.** [Customizing the build schemes for a project](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project), [ProcessInfo.environment](https://developer.apple.com/documentation/foundation/processinfo/environment)

**Код в Buzz.** выбор реализации в [`iOS/App/Sources/AppDependencies.swift:54`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L54), фейковый сервер [`iOS/Modules/Networking/Sources/MockAPIClient.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L13), in-memory репозитории и данные для превью [`iOS/Modules/Domain/Sources/Fakes/`](https://github.com/disavle/buzz/tree/main/iOS/Modules/Domain/Sources/Fakes), примеры запросов и ответов [`Mocks/api/`](https://github.com/disavle/buzz/tree/main/Mocks/api), каталог [`Mocks/catalog.json`](https://github.com/disavle/buzz/blob/main/Mocks/catalog.json).

**Описание.** [`Mocks/README.md`](https://github.com/disavle/buzz/blob/main/Mocks/README.md).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 23. Строки и плюрализация.** Вынеси все строки экрана в `Localizable.xcstrings` модуля, используй `Text("wellbeing.title", bundle: .module)`. Добавь строку с формами множественного числа «N дней подряд» для ru и en. Подсмотри строки `StatsFeature`. *Готово, когда:* в русской схеме видно «1 день», «3 дня», «5 дней».

**Документация.** [Localizing and varying text with a string catalog](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog), [LocalizedStringResource](https://developer.apple.com/documentation/foundation/localizedstringresource)

**Код в Buzz.** каталоги [`iOS/App/Resources/Localizable.xcstrings`](https://github.com/disavle/buzz/blob/main/iOS/App/Resources/Localizable.xcstrings) и `iOS/Modules/<Модуль>/Resources/Localizable.xcstrings`.

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), разделы 1–3.

---

## D2. Строки в модулях: bundle .module и генерация символов

**Что и зачем.** В модуле `Text("key")` ищет строку в главном бандле приложения, а не в модуле, и перевод «пропадает». Нужно явно указывать `bundle: .module` или включить генерацию символов (Xcode 26), тогда строка вызывается как `Text(.todayTitle)` и опечатки ловит компилятор.

**Руками.**
1. В Swift-пакете или Tuist-модуле с ресурсами положи каталог и вызови `Text("hello")`. Убедись, что перевода нет.
2. Исправь на `Text("hello", bundle: .module)`.
3. Включи Build Settings → Generate String Catalog Symbols и перепиши на сгенерированный символ.
4. ViewModel отдаёт `LocalizedStringResource`, а не `String`: перевод делает View.

**Разобрать в Buzz.** Ошибки домена (`AddEntryError`) и коды сервера (`APIErrorCode`) переводятся в Presentation через `var message: LocalizedStringResource`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 23. Строки и плюрализация.** Задание в карточке D1, эта тема в нём тоже нужна.

**Документация.** [Bundle.module и ресурсы пакетов](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)

**Код в Buzz.** `bundle: .module` в [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L19), в Charts [`iOS/Modules/StatsFeature/Sources/StatsView.swift:67`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L67).

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), разделы 1–2.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 24. Форматы.** Показывай сон как `Measurement<UnitDuration>` («7,5 ч» / «7.5 hr»), даты как относительные («вчера») через `FormatStyle`. Никаких `DateFormatter` и ручной склейки строк. Подсмотри: `DesignSystem/Sources/Formatting.swift`. *Готово, когда:* смена языка устройства меняет формат без правок кода.

**Документация.** [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle), [Measurement](https://developer.apple.com/documentation/foundation/measurement)

**Код в Buzz.** [`iOS/Modules/DesignSystem/Sources/Formatting.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Formatting.swift#L10), тесты [`iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift).

**Описание.** [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), раздел 4; [`docs/design/README.md`](https://github.com/disavle/buzz/blob/main/docs/design/README.md), «Языки в макетах».

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 4. ViewModel на @Observable.** Задание в карточке B2, эта тема в нём тоже нужна.

**Документация.** [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)

**Код в Buzz.** [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L13), [`iOS/Modules/TodayFeature/Sources/TodayView.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift), тесты [`iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 2–5.

---

## E2. Координаторы + UIHostingController (гибрид)

**Что и зачем.** Навигацию держит знакомый UIKit (координаторы, `UITabBarController`, `UINavigationController`), каждый экран — `UIHostingController` со SwiftUI-View. Так учишь новое по одному слою.

**Руками.**
1. `SceneDelegate` создаёт `AppCoordinator` с `UITabBarController` и четырьмя `UINavigationController`.
2. Координатор вкладки создаёт ViewModel с `Output`-замыканиями и пушит `UIHostingController(rootView: View(model:))`.
3. Шит: `vc.sheetPresentationController?.detents = [.medium(), .large()]`.
4. Общий `environment` прокидывай в одном месте (`deps.host(view)`): каждый хостинг — отдельный корень SwiftUI.

**Разобрать в Buzz.** App-таргет с координаторами и четырьмя вкладками.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 9. Новая вкладка через координатор.** Создай `WellbeingCoordinator` по образцу `StatsCoordinator`: `UIHostingController` с `WellbeingView` внутри `UINavigationController`. Добавь вкладку в `AppCoordinator`. Добавь диплинк `buzz://checkin/new`, который открывает форму, и тест в `DeepLinkTests.swift`. *Готово, когда:* в приложении есть вкладка «Самочувствие», `xcrun simctl openurl booted buzz://checkin/new` открывает форму.

**Документация.** [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)

**Код в Buzz.** [`iOS/App/Sources/SceneDelegate.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift), [`iOS/App/Sources/Coordinators/AppCoordinator.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/AppCoordinator.swift#L11), [`iOS/App/Sources/Coordinators/TodayCoordinator.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift#L7), [`iOS/App/Sources/AppDependencies.swift:89`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L89), диплинки [`iOS/App/Tests/DeepLinkTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/App/Tests/DeepLinkTests.swift).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 1, 3 и 6.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 21. Use case по Clean.** Вынеси сохранение в `SaveCheckinUseCase`: проверка «одна отметка в день», «сон от 0 до 24», вызов репозитория. ViewModel зовёт только use case. Подсмотри: `AddEntryFeature/Sources/Domain/UseCases.swift`. *Готово, когда:* вторая отметка за день не сохраняется и показывает понятную ошибку.

**Документация.** Это паттерн, официальной документации нет. Первоисточник: статья Robert C. Martin [«The Clean Architecture»](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

**Код в Buzz.** [`iOS/Modules/AddEntryFeature/Sources/Domain/NutritionCalculator.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/NutritionCalculator.swift#L12), [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift), [`iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift), тесты [`iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 1.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 22. Мини-Redux для настроек.** Перенеси настройки напоминания в маленький стор: `State`, `enum Action`, чистая функция `reduce`. Подсмотри: `SettingsFeature/Sources/Redux/Store.swift` и `SettingsReducer.swift`. Сравни с тем, как то же сделано в MVVM, и запиши выводы в журнал. *Готово, когда:* reducer покрыт тестом без UI и без моков.

**Документация.** [TCA](https://github.com/pointfreeco/swift-composable-architecture), [документация TCA](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/)

**Код в Buzz.** [`iOS/Modules/SettingsFeature/Sources/Redux/Store.swift:18`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L18) и [`:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L38), [`iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift#L6), [`iOS/Modules/SettingsFeature/Sources/SettingsState.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsState.swift), тесты [`iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md), раздел 2.

---

## E5. Модули: фичи видят только Domain

**Что и зачем.** Приложение режется на модули (`Domain`, `Persistence`, `Networking`, `DesignSystem`, `Sync`, фичи). Фичи не импортируют друг друга, не знают про UIKit и SwiftData. Нарушение границы — ошибка компиляции, а не вопрос дисциплины.

**Было → стало.** один таргет с папками → модули (Tuist-таргеты или SPM-пакет).

**Руками.**
1. Сделай локальный Swift-пакет с двумя таргетами `Domain` и `FeatureA`, подключи к приложению (File → Add Package Dependencies → Add Local).
2. Попробуй импортировать в `FeatureA` то, что не объявлено в зависимостях.
3. Сделай типы в `Domain` `public` и посмотри, что без этого ничего не видно.
4. Потом то же самое через Tuist (H1) и `tuist inspect implicit-imports`.

**Разобрать в Buzz.** 10 модулей по графу из `docs/infra/README.md`, раздел 2.

**Зачем столько таргетов.** Фича-модулей всего пять, по одному на экран, остальное — слои и тесты. Хелпер [`Module`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift) создаёт на каждый модуль два таргета (код и тесты): 10 × 2 + приложение с тестами + пакет `Shared` = 23. Плюсы: границы проверяет компилятор, правка в одной фиче пересобирает только её, тесты модуля идут за секунды, и это любят спрашивать на собеседованиях. Минусы: много `public`, свой `Bundle.module` у каждого модуля, больше церемоний при новом экране. Для продукта такого размера хватило бы 4–5 таргетов, для учебника текущая разбивка полезна.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 2. Модель в Domain.** В `Domain/Sources/Models/` создай `public struct Checkin: Identifiable, Hashable, Sendable` с полями `id`, `day: Date`, `mood: Int` (1–5), `sleepHours: Double`, `note: String`, `updatedAt`. В `Repositories.swift` добавь `public protocol CheckinRepository: Sendable` с `all()`, `save(_:)`, `delete(id:)`. В `Fakes/InMemoryRepositories.swift` напиши `InMemoryCheckinRepository`. Подсмотри: `Entry.swift`, `EntryRepository`. *Готово, когда:* `WellbeingFeature` видит `Checkin`, но не может `import SwiftData` (проверь, что сборка падает, и убери импорт).

**Документация.** [Swift packages](https://developer.apple.com/documentation/xcode/swift-packages), [Organizing code with local packages](https://developer.apple.com/documentation/xcode/organizing-your-code-with-local-packages)

**Код в Buzz.** [`iOS/Project.swift`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift), [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift), протоколы в [`iOS/Modules/Domain/Sources/Repositories.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L11).

**Описание.** [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), разделы 3–4; [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), разделы 1–3.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 25. Тесты на Swift Testing.** Напиши тесты для `SaveCheckinUseCase` и `WellbeingViewModel`: `@Test`, `#expect`, `#require`, параметризованный `@Test(arguments: [-1, 0, 24, 25])` для часов сна. Подсмотри: `AddEntryUseCaseTests.swift`, `CatalogViewModelTests.swift`. *Готово, когда:* `mise run test` зелёный, в отчёте видно 4 прогона параметризованного теста.

**Документация.** [Swift Testing](https://developer.apple.com/documentation/testing), [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)

**Код в Buzz.** тесты клиента `iOS/Modules/<Модуль>/Tests/` (например [`iOS/Modules/Sync/Tests/SyncEngineTests.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift)), сервера [`Backend/Tests/AppTests/AppTests.swift:50`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L50).

**Описание.** [`docs/client/architecture-experiments.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture-experiments.md) (тесты обоих экспериментов).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 28. Первый эндпоинт.** Задание в карточке G2, эта тема в нём тоже нужна.

**Документация.** [Vapor docs](https://docs.vapor.codes), [Getting started](https://docs.vapor.codes/getting-started/hello-world/), [swift.org: Server](https://www.swift.org/documentation/server/)

**Код в Buzz.** [`Backend/Sources/App/entrypoint.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/entrypoint.swift), [`Backend/Sources/App/configure.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift); путеводитель с упражнениями [`docs/backend/STEPS.md`](https://github.com/disavle/buzz/blob/main/docs/backend/STEPS.md).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), разделы 1, 2 и 8; путеводитель по коду бэкенда с упражнениями: [`docs/backend/STEPS.md`](https://github.com/disavle/buzz/blob/main/docs/backend/STEPS.md).

---

## G2. Роуты, контроллеры, Content

**Руками.**
1. `app.get("hello", ":name") { req async throws -> String in ... }`, достань параметр `req.parameters.get("name")`.
2. `struct Greeting: Content { let text: String }` и верни его из POST-роута, тело читай `try req.content.decode(...)`.
3. Query: `try req.query.decode(Filter.self)`.
4. Вынеси роуты в `struct HelloController: RouteCollection` и зарегистрируй `try app.register(collection:)`.
5. Валидация: `extension Greeting: Validatable` и `try Greeting.validate(content: req)`.

**Разобрать в Buzz.** Прочитать `routes.swift` и `MeController`, затем самому написать `DrinkController` и сравнить с каркасом.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 28. Первый эндпоинт.** Запусти бэкенд `mise run backend:run`. Создай `CheckinController` с `GET /checkins`, который пока отдаёт пустой массив, и зарегистрируй его в `routes.swift`. Подсмотри: `EntryController.swift`. *Готово, когда:* `curl localhost:8080/checkins` отвечает `[]`.

**Документация.** [Routing](https://docs.vapor.codes/basics/routing/), [Content](https://docs.vapor.codes/basics/content/), [Controllers](https://docs.vapor.codes/basics/controllers/), [Validation](https://docs.vapor.codes/basics/validation/)

**Код в Buzz.** [`Backend/Sources/App/routes.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift), [`Backend/Sources/App/Controllers/`](https://github.com/disavle/buzz/tree/main/Backend/Sources/App/Controllers).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 3.

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 29. Таблица в базе.** Создай Fluent-модель `Checkin` и миграцию `CreateCheckin` со ссылкой на пользователя, добавь её в `configure.swift`. `POST /checkins` сохраняет запись, `GET` отдаёт записи из базы. Подсмотри: `Models/Entry.swift`, `Migrations/CreateEntry.swift`. *Готово, когда:* отправленная через `curl` отметка возвращается в `GET`.

**Документация.** [Fluent overview](https://docs.vapor.codes/fluent/overview/), [Model](https://docs.vapor.codes/fluent/model/), [Migrations](https://docs.vapor.codes/fluent/migration/), [Query](https://docs.vapor.codes/fluent/query/)

**Код в Buzz.** [`Backend/Sources/App/Models/Entry.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift), [`Backend/Sources/App/Migrations/CreateEntry.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Migrations/CreateEntry.swift), `withDeleted` в [`Backend/Sources/App/Controllers/EntryController.swift:47`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L47), упражнение с SQLKit в [`Backend/Sources/App/Controllers/StatsController.swift:20`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/StatsController.swift#L20).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 4.

---

## G4. Авторизация по bearer-токену

**Что и зачем.** При логине сервер создаёт случайный токен и сохраняет его (`UserToken`). Клиент шлёт `Authorization: Bearer <token>`, middleware находит пользователя.

**Руками.**
1. `User: ModelAuthenticatable` (email + хеш пароля через `Bcrypt`).
2. `UserToken: ModelTokenAuthenticatable`.
3. `/login` с `User.authenticator()` (basic) отдаёт новый токен.
4. Группа роутов `app.grouped(UserToken.authenticator(), User.guardMiddleware())`, внутри `try req.auth.require(User.self)`.

**Разобрать в Buzz.** Прочитать `AuthController`; затем добавить срок жизни токена (упражнение из README).

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 31. Авторизация и коды ошибок.** Закрой `/checkins` проверкой bearer-токена и отдавай только записи текущего пользователя. Для второй отметки за день отвечай кодом `checkin_duplicate_day` через `APIError`. Подсмотри: `Errors/APIError.swift`, `APIErrorMiddleware.swift`. *Готово, когда:* без токена приходит 401, дубль дня приходит как понятный код ошибки.

**Документация.** [Authentication](https://docs.vapor.codes/security/authentication/), [Passwords](https://docs.vapor.codes/security/passwords/)

**Код в Buzz.** [`Backend/Sources/App/Models/UserToken.swift:30`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/UserToken.swift#L30), [`Backend/Sources/App/Controllers/AuthController.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/AuthController.swift), [`Backend/Sources/App/routes.swift`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 3.

---

## G5. Ошибки кодами и свой middleware

**Что и зачем.** Сервер не пишет тексты для людей: отдаёт машинный код `{"error": "limit_invalid", "reason": "..."}`, а клиент переводит его через String Catalog. Неизвестный код раскодируется в `.unknown`, и старое приложение не падает.

**Руками.**
1. Брось `Abort(.notFound)` и посмотри на стандартный ответ.
2. Напиши свой `AsyncMiddleware`, который ловит ошибки из `next.respond(to:)` и превращает их в свой JSON.
3. Замени стандартный `ErrorMiddleware` своим в `configure.swift`.
4. В enum кодов реализуй `init(from:)` с запасным `.unknown`.

**Разобрать в Buzz.** Прочитать `Errors/` и `Shared/APIError.swift`; добавить новый код ошибки на обеих сторонах.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 31. Авторизация и коды ошибок.** Задание в карточке G4, эта тема в нём тоже нужна.

**Документация.** [Errors](https://docs.vapor.codes/basics/errors/), [Middleware](https://docs.vapor.codes/advanced/middleware/)

**Код в Buzz.** [`Backend/Sources/App/Errors/APIErrorMiddleware.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L6), коды [`Shared/Sources/Shared/APIError.swift`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/APIError.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 6; [`docs/backend/API.md`](https://github.com/disavle/buzz/blob/main/docs/backend/API.md), «Ошибки и языки».

---

## G6. Общий пакет Shared с DTO

**Что и зачем.** DTO (то, что летит по сети) лежат в маленьком Swift-пакете, который подключают и iOS-клиент, и Vapor. Контракт API проверяет компилятор с обеих сторон.

**Правила.** `Shared` зависит только от Foundation; типы `Codable`, `Sendable`, `Hashable`; на сервере `extension XDTO: @retroactive Content {}`; общие `JSONEncoder`/`JSONDecoder` с ISO 8601; модель БД и DTO — разные типы.

**Руками.**
1. File → New → Package `Shared` с одной структурой.
2. Подключи его локально в приложение и в Vapor-проект.
3. Переименуй поле и посмотри, как компилятор подсветил обе стороны.

**Разобрать в Buzz.** Посмотреть, как `Shared/` подключён к Tuist в `iOS/Tuist/Package.swift` и к Vapor в `Backend/Package.swift`; добавить поле в DTO и пройти по ошибкам компиляции на обеих сторонах.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 30. Общий DTO.** Создай `CheckinDTO` в `Shared/Sources/Shared/` и используй его и в контроллере Vapor, и в приложении. Подсмотри: `EntryDTO.swift`, `DTOs/Shared+Content.swift`. *Готово, когда:* переименуй поле в DTO и убедись, что не собираются обе стороны.

**Документация.** [Creating a standalone Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode). Альтернатива: [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) + [swift-openapi-vapor](https://github.com/swift-server/swift-openapi-vapor).

**Код в Buzz.** [`Shared/Sources/Shared/`](https://github.com/disavle/buzz/tree/main/Shared/Sources/Shared), на сервере [`Backend/Sources/App/DTOs/Shared+Content.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/Shared+Content.swift#L6), на клиенте [`iOS/Modules/Networking/Sources/DTOMapping.swift`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/DTOMapping.swift).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 5; [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 2.

---

## G7. Тесты Vapor (VaporTesting)

**Руками.**
1. Хелпер, который поднимает приложение в памяти с in-memory SQLite, мигрирует и откатывает.
2. `try await app.testing().test(.GET, "hello", afterResponse: { res in #expect(res.status == .ok) })`.
3. Тест с телом и заголовком `bearerAuthorization`.
4. В тестах `app.passwords.use(.plaintext)`, чтобы не ждать Bcrypt.

**Разобрать в Buzz.** Прочитать 8 тестов в `AppTests.swift`, затем написать тест на новый код ошибки из G5.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 32. Тесты сервера.** Напиши тесты VaporTesting: создание, чтение, 401 без токена, дубль дня. Подсмотри тесты в `Backend/Tests`. *Готово, когда:* `mise run backend:test` зелёный.

**Документация.** [Testing](https://docs.vapor.codes/advanced/testing/)

**Код в Buzz.** [`Backend/Tests/AppTests/AppTests.swift:28`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L28).

**Описание.** [`docs/backend/README.md`](https://github.com/disavle/buzz/blob/main/docs/backend/README.md), раздел 9.

---

## G8. Postgres в Docker и деплой

**Что и зачем.** SQLite для старта, PostgreSQL для настоящего сервера. Переход — замена драйвера и одной строки в `configure.swift`. Деплой — Docker-образ из шаблона Vapor на VPS или Fly.io.

**Куда деплоить бесплатно.** Ветка «Бесплатный хостинг бэкенда» рекомендует Render (Docker-образ с Vapor) и Neon (управляемый Postgres), оба без привязки карты. GitHub сам бэкенд не хостит. Как это устроено, смотри в G9. Документация: [Render: Docker](https://render.com/docs/docker), [Neon](https://neon.tech/docs).

**Руками.**
1. Установи Docker Desktop (или OrbStack), `docker run -e POSTGRES_PASSWORD=... -p 5432:5432 postgres`.
2. Подключи `FluentPostgresDriver`, читай настройки из переменных окружения (`Environment.get`).
3. `docker compose up` из шаблона `vapor new` с Postgres.
4. Собери образ из `Dockerfile` шаблона и запусти локально.

**Разобрать в Buzz.** Шаг 7 из README бэкенда: Postgres в Docker, затем деплой.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 37. Postgres локально.** Подними Postgres в Docker, запусти бэкенд с `DATABASE_URL` и проверь, что миграция `CreateCheckin` проходит на Postgres так же, как на SQLite. *Готово, когда:* таблица `checkins` видна в `psql`.

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

**Руками.**
1. Напиши `Dockerfile` в две стадии для игрушечного Vapor-приложения: `FROM swift:6.x AS build` → `swift build -c release`, потом `FROM swift:6.x-slim` и `COPY --from=build` бинарника.
2. `docker build -t hello .` и `docker run -p 8080:8080 -e PORT=8080 hello`, проверь `curl localhost:8080`.
3. В `configure.swift` прочитай `Environment.get("DATABASE_URL")` и подключи Postgres через `app.databases.use(try .postgres(url: ...), as: .psql)`.
4. Заведи бесплатную базу на Neon, передай её URL в `docker run -e DATABASE_URL=...` и убедись, что миграции прошли.
5. По желанию: создай сервис на Render из образа и дёрни его deploy hook через `curl -X POST`.

**Деплой не на каждый пуш.** Job `deploy` запускается только когда пуш в `main` меняет `Backend/Sources`, `Backend/Package.*`, `Backend/Dockerfile` или `Shared/` (фильтр `deploy` в `dorny/paths-filter`, PR #8). Тесты, документы и сам workflow сервер не перевыкатывают. Ещё деплой можно запустить руками: Actions → CI → Run workflow (`workflow_dispatch`, PR #7).

**Разобрать в Buzz.** `Backend/Dockerfile` (две стадии и почему контекст — корень), `.dockerignore`, ветку с `DATABASE_URL` в `configure.swift`, job `deploy` в `ci.yml` и пошаговую инструкцию `docs/backend/DEPLOY.md`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 39. Деплой.** После слияния бэкенд выкатится на Render сам: посмотри job `deploy` в Actions и проверь новый эндпоинт на сервере. Прочитай `renovate.json` и найди, какие обновления вливаются сами. *Готово, когда:* приложение на iPhone сохраняет отметку на сервер в Render.

**Документация.** [Docker: multi-stage builds](https://docs.docker.com/build/building/multi-stage/), [Vapor: Docker](https://docs.vapor.codes/deploy/docker/), [GitHub: Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry), [Render: Deploy hooks](https://render.com/docs/deploy-hooks), [Render: Free](https://render.com/docs/free), [Neon: Connect](https://neon.tech/docs/connect/connect-from-any-app), [The Twelve-Factor App: Config](https://12factor.net/config)

**Код в Buzz.** стадии сборки [`Backend/Dockerfile:14`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L14) и [`:51`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L51); `DATABASE_URL` [`Backend/Sources/App/configure.swift:17`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L17), `PORT` [`:27`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L27), `AUTO_MIGRATE` [`:50`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L50); фильтр [`.github/workflows/ci.yml:46`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L46) и job `deploy` [`:90`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L90).

**Описание.** [`docs/backend/DEPLOY.md`](https://github.com/disavle/buzz/blob/main/docs/backend/DEPLOY.md).

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

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 1. Ветка и пустой модуль.** Создай ветку `learn/wellbeing` от `main`. В `iOS/Project.swift` добавь модуль `WellbeingFeature` по образцу `StatsFeature` (те же `featureDeps`, `resources: true`, `tests: true`) и подключи его к таргету приложения. Создай файл `Sources/WellbeingView.swift` с `Text("Самочувствие")`. Выполни `mise run generate`. *Готово, когда:* проект собирается, в Xcode появились таргеты `WellbeingFeature` и `WellbeingFeatureTests`.
- **День 2. Модель в Domain.** Задание в карточке E5, эта тема в нём тоже нужна.

**Документация.** [Tuist docs](https://docs.tuist.dev)

**Код в Buzz.** [`iOS/Project.swift`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift), [`iOS/Tuist.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist.swift), [`iOS/Tuist/Package.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/Package.swift), [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift); пошаговый разбор [`docs/infra/HANDS-ON.md`](https://github.com/disavle/buzz/blob/main/docs/infra/HANDS-ON.md).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), разделы 1–3.

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

**Алиасы zsh.** Файл `scripts/buzz.zsh` подключается строкой `source <путь>/scripts/buzz.zsh` в `~/.zshrc` и даёт команды `buzz-ios` (приложение в симуляторе через новую задачу `mise run ios` = `tuist run Buzz`), `buzz-api` (бэкенд), `buzz-dev` (бэкенд в фоне плюс приложение), `buzz-stop`, а также `buzz`, `buzz-gen`, `buzz-open`, `buzz-test`, `buzz-lint`. Репозиторий скрипт находит по своему пути (`${${(%):-%x}:A:h:h}`) и вызывает `mise -C <репо>`, поэтому команды работают из любой папки. Чтобы разобраться, напиши свою функцию `myproj-run() { mise -C ~/code/myproj run dev }` в `~/.zshrc` и сравни со скриптом.

**Разобрать в Buzz.** Прочитать `mise.toml` и после клона репозитория поднять всё одной `mise run generate`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 1. Ветка и пустой модуль.** Задание в карточке H1, эта тема в нём тоже нужна.

**Документация.** [mise](https://mise.jdx.dev), [Tasks](https://mise.jdx.dev/tasks/)

**Код в Buzz.** [`mise.toml`](https://github.com/disavle/buzz/blob/main/mise.toml), задача `ios` [`mise.toml:82`](https://github.com/disavle/buzz/blob/main/mise.toml#L82), алиасы [`scripts/buzz.zsh:13`](https://github.com/disavle/buzz/blob/main/scripts/buzz.zsh#L13), `buzz-dev` [`:23`](https://github.com/disavle/buzz/blob/main/scripts/buzz.zsh#L23); [`docs/infra/HANDS-ON.md`](https://github.com/disavle/buzz/blob/main/docs/infra/HANDS-ON.md), шаг 1.

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4.

---

## H3. fastlane, match, App Store Connect API key

**Что и зачем.** fastlane описывает сборку и выкладку как Ruby-скрипт с «дорожками» (lanes). match хранит сертификаты и профили в отдельном приватном git-репозитории, зашифрованными. API-ключ App Store Connect даёт доступ без Apple ID и двухфакторки.

**Руками.**
1. `Gemfile` с fastlane, `bundle install`, всегда запускай через `bundle exec fastlane`.
2. Lane `test` с `run_tests(scheme:)`.
3. Когда будет Apple Developer Program: `match` в режиме `development`, затем `appstore`; `app_store_connect_api_key`; lane `beta` с `build_app` и `upload_to_testflight`.

**Разобрать в Buzz.** Lane `test` локально; `certs` и `beta` после покупки Developer Program.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 40. Выпуск и итоги.** Задание в карточке H7, эта тема в нём тоже нужна.

**Документация.** [fastlane docs](https://docs.fastlane.tools), [match](https://docs.fastlane.tools/actions/match/), [App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/)

**Код в Buzz.** [`iOS/fastlane/Fastfile`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile), [`iOS/fastlane/Matchfile`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Matchfile), [`iOS/Gemfile`](https://github.com/disavle/buzz/blob/main/iOS/Gemfile).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 5.

---

## H4. GitHub Actions

**Что и зачем.** CI в том же репозитории: YAML-файлы в `.github/workflows/`, запуск на PR и тегах.

**Руками.**
1. Workflow на `pull_request`, job на `macos-26`, шаги `actions/checkout`, `jdx/mise-action`, `mise run test`.
2. Фильтр `paths:`, чтобы iOS-job не запускался на изменения бэкенда.
3. Job на тег `ios-v*`, зависящий от тестов (`needs:`).
4. Секреты в Settings → Secrets and variables → Actions.
5. Бэкенд на Linux в контейнере `swift:6.2` с `swift test`.
6. `dorny/paths-filter` внутри одного workflow: job `changes` отдаёт флаги `ios`/`backend`/`deploy`, остальные job смотрят на них в `if:`. Плюс `workflow_dispatch` для ручного запуска.

**Разобрать в Buzz.** Зелёный CI на пустом проекте (шаг 4 порядка внедрения).

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 38. Линт и CI.** Задание в карточке H5, эта тема в нём тоже нужна.

**Документация.** [GitHub Actions](https://docs.github.com/actions)

**Код в Buzz.** [`.github/workflows/ci.yml`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml): job `Changes` решает, что запускать, `iOS` и `Backend` гоняют тесты, `TestFlight` только на теги `ios-v*`, `deploy` выкатывает бэкенд (см. G9).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 6.

---

## H5. swift-format, SwiftLint, pre-commit

**Что и зачем.** swift-format — официальный форматтер, с Xcode 16 входит в тулчейн (`xcrun swift-format`). SwiftLint оставлен только для смысловых правил. Pre-commit хук запускает линт перед коммитом.

**Руками.**
1. `xcrun swift-format format -i -r Sources/` и посмотри дифф.
2. `swiftlint` в корне проекта с конфигом `.swiftlint.yml`.
3. `mise generate git-pre-commit --write --task=lint` и попробуй закоммитить плохой код.
4. Вариант без генератора: положи скрипт `pre-commit` в папку `.githooks/` в репозитории и включи её командой `git config core.hooksPath .githooks`. Так хуки лежат в git и одинаковы у всех.

**В Buzz (PR #9).** Хуки `pre-commit` и `pre-push` в `.githooks/` запускают `mise run lint`; коммит, где только документация, линт пропускает. Включаются задачей `mise run setup:hooks`, она уже входит в `mise run generate`. Повод: CI падал на swift-format, теперь это ловится до пуша. Код: [`.githooks/pre-commit`](https://github.com/disavle/buzz/blob/main/.githooks/pre-commit), [`.githooks/run-lint`](https://github.com/disavle/buzz/blob/main/.githooks/run-lint), задача [`mise.toml:46`](https://github.com/disavle/buzz/blob/main/mise.toml#L46).

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 38. Линт и CI.** Закоммить и запушь ветку. Хуки из `.githooks/` прогонят линт; почини замечания swift-format и SwiftLint. Открой PR и посмотри, какие job запустил `Changes` в `ci.yml`. *Готово, когда:* все проверки в PR зелёные.

**Документация.** [swift-format](https://github.com/swiftlang/swift-format), [SwiftLint](https://github.com/realm/SwiftLint), [mise generate git-pre-commit](https://mise.jdx.dev/cli/generate/git-pre-commit.html)

**Код в Buzz.** [`.swift-format`](https://github.com/disavle/buzz/blob/main/.swift-format), [`.swiftlint.yml`](https://github.com/disavle/buzz/blob/main/.swiftlint.yml), задачи `lint` в [`mise.toml`](https://github.com/disavle/buzz/blob/main/mise.toml).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4a.

---

## H6. Renovate

**Что и зачем.** Бот раз в неделю открывает PR с обновлениями версий в `mise.toml`, Gemfile, GitHub Actions и SPM. В отличие от Dependabot, понимает `mise.toml`.

**Руками.** Установи GitHub App Renovate на репозиторий, положи `renovate.json`, дождись первого PR «Configure Renovate».

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 39. Деплой.** Задание в карточке G9, эта тема в нём тоже нужна.

**Документация.** [Renovate docs](https://docs.renovatebot.com)

**Код в Buzz.** [`renovate.json`](https://github.com/disavle/buzz/blob/main/renovate.json).

**Описание.** [`docs/infra/README.md`](https://github.com/disavle/buzz/blob/main/docs/infra/README.md), раздел 4a.

---

## H7. GitHub Flow и защита main (rulesets)

**Что и зачем.** Простой процесс для одной ветки `main`: любая работа идёт в короткой ветке (`feature/…`, `fix/…`, `chore/…`), через PR с зелёным CI и вливается squash-коммитом, так что в `main` один коммит на задачу. Релиз — тег `ios-v*`. Ruleset на `main` запрещает прямой пуш и вливание без зелёных проверок, а Renovate с auto-merge сам вливает мелкие обновления.

**Было → стало.** Git Flow с `develop`/`release`/`hotfix`, ручная дисциплина «не пушим в master» → GitHub Flow + ruleset, который проверяет правила за тебя.

**Руками.**
1. В тестовом репозитории: Settings → General → Pull Requests, оставь только **Allow squash merging**, включи **Allow auto-merge** и **Automatically delete head branches**.
2. Settings → Rules → Rulesets → New branch ruleset на `main`: **Require a pull request**, **Require status checks to pass**, **Block force pushes**.
3. Попробуй `git push origin main` напрямую и прочитай отказ.
4. Сделай ветку `feature/test`, открой PR, дождись зелёного CI, влей через **Squash and merge** и посмотри историю `main`.
5. Поставь тег `git tag v0.0.1 && git push origin v0.0.1` и проверь, что workflow с фильтром по тегам запустился.

**Ревью до пуша (с 2026-10-16).** Ветки Claude ничего не пушат в `disavle/buzz`, пока ты не посмотрел код. Изменения лежат патчем в `/mnt/project-files/review/` с коротким пояснением. Посмотреть и применить у себя: `git apply --stat x.patch` (что меняется), `git apply --check x.patch` (ляжет ли), `git am x.patch` (применить с сообщением коммита). Потом ты пишешь «ок», и ветка пушит и открывает PR.

**Разобрать в Buzz.** Пройти первый блок `SETUP.md` («Сейчас (бесплатно)»): поставить Renovate, настроить слияние и ruleset на `main`. Затем сделать первую свою правку в Buzz через ветку и PR по `CONTRIBUTING.md`.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 1. Ветка и пустой модуль.** Задание в карточке H1, эта тема в нём тоже нужна.
- **День 40. Выпуск и итоги.** Влей PR через squash и посмотри историю `main`. Нарисуй на бумаге путь отметки от нажатия «Сохранить» до строки в Postgres и обратно на второе устройство. Запиши в журнал 5 строк для резюме. Бонус, когда будет аккаунт разработчика: lane `beta` в fastlane и тег `ios-v*`. *Готово, когда:* фича «Самочувствие» в `main`, схема пути данных нарисована.

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

**Руками.**
1. Заведи пустой тестовый репозиторий на GitHub с README, лицензией MIT и `.gitignore` Swift прямо из формы создания.
2. Добавь `README.ru.md` и ссылки-переключатели языка в начале обоих файлов.
3. Заполни About и topics, посмотри, как репозиторий стал находиться в поиске по topic.
4. Пройди шаги из H7 (ruleset, squash) и H6 (Renovate).

**Разобрать в Buzz.** Отметить галочки в списке выше по мере настройки и сравнить, что в Buzz сделано файлами, а что только кнопками в Settings.

**Уроки курса** (фича «Самочувствие», см. «Курс» в начале).
- **День 40. Выпуск и итоги.** Задание в карточке H7, эта тема в нём тоже нужна.

**Документация.** [About README](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes), [Licensing a repository](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository), [Contributor guidelines](https://docs.github.com/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors), [Topics](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics)

**Код в Buzz.** корень репозитория [disavle/buzz](https://github.com/disavle/buzz).

**Описание.** [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md).

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
