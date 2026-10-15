# Учебный план: современный iOS-стек + серверный Swift

Для кого: iOS-разработчик с опытом UIKit, DiffableDataSource и CompositionalLayout.
Цель: освоить современный Swift и SwiftUI, а заодно написать своё мини-приложение: SwiftUI-клиент и бэкенд на Vapor.
Ориентир по версиям: Xcode 26, Swift 6.2, iOS 26, Vapor 4.

Идея и название приложения обсуждаются в ветке «Идея и название приложения». Пока они не выбраны, упражнения ниже описаны для условной сущности `Item` (заметка, задача, запись — что угодно со списком и деталями). Когда идея появится, просто подставьте свои модели.

## Как пользоваться планом

- Темы идут в порядке зависимостей: каждая опирается на предыдущие.
- Ориентир по времени: 8–10 недель по 5–7 часов в неделю. Это не жёсткий график.
- В каждой теме: **зачем**, **что изучить**, **упражнение**. Упражнения складываются в одно приложение, поэтому к концу плана у вас будет рабочий клиент и сервер.
- Сессии WWDC ищутся по названию на [developer.apple.com/videos](https://developer.apple.com/videos/) или в приложении Developer.

## Карта плана

| # | Тема | Неделя | Результат в мини-приложении |
|---|------|--------|-----------------------------|
| 0 | Подготовка проекта | 1 | Пустой SwiftUI-проект, Swift 6, git |
| 1 | Swift Concurrency и Swift 6 | 1–2 | Сетевой слой на async/await и actor |
| 2 | Observation (`@Observable`) | 2 | Модели экранов без Combine |
| 3 | SwiftUI: основы и мышление | 3 | Список и экран деталей |
| 4 | SwiftUI: навигация, состояние, архитектура | 4 | NavigationStack, формы, ошибки |
| 5 | SwiftUI и UIKit вместе | 5 | Интеграция в старый проект, ячейки на SwiftUI |
| 6 | SwiftData | 5–6 | Локальный кэш и офлайн-режим |
| 7 | Swift Testing | 6 | Тесты на модели и сетевой слой |
| 8 | Макросы | 7 | Понимание `@Observable`/`@Model`, свой простой макрос |
| 9 | Серверный Swift на Vapor | 7–9 | REST API, Fluent, база данных |
| 10 | Связка клиента и сервера | 9–10 | Общие модели, синхронизация, деплой |

---

## 0. Подготовка

**Зачем.** Начать сразу в правильных настройках, чтобы не мигрировать потом.

**Что сделать.**
- Создать проект в Xcode 26 (шаблон App, интерфейс SwiftUI, хранилище None, SwiftData добавим позже руками).
- В Build Settings убедиться, что Swift Language Version = Swift 6.
- Посмотреть, включены ли настройки «Approachable Concurrency» и «Default Actor Isolation = MainActor» (в новых проектах Xcode 26 они включены). Разберитесь, что они значат, в теме 1.
- Создать монорепозиторий: `App/` (Xcode-проект), `Server/` (Vapor), `Shared/` (Swift Package с общими моделями, появится в теме 10).

---

## 1. Swift Concurrency и Swift 6 strict concurrency

**Зачем.** Это фундамент всего остального: SwiftUI, SwiftData и Vapor написаны вокруг async/await и акторов. В Swift 6 проверка гонок данных стала ошибкой компиляции, а не предупреждением. Если вы привыкли к GCD, completion handlers и `DispatchQueue.main.async`, здесь главный сдвиг мышления: изоляция описывается в типах, а компилятор её проверяет.

**Ключевые понятия.**
- `async`/`await`, `Task`, отмена задач, `Task.checkCancellation()`.
- Structured concurrency: `async let`, `withTaskGroup`, `withThrowingTaskGroup`.
- `actor`, `@MainActor`, глобальные акторы, изоляция.
- `Sendable`, `@Sendable`-замыкания, `sending`, почему `class` не Sendable по умолчанию.
- `AsyncSequence`, `AsyncStream` (замена многим сценариям Combine).
- Swift 6.2: изоляция на MainActor по умолчанию, `nonisolated(nonsending)` по умолчанию для async-функций, атрибут `@concurrent` для явного ухода с актора.
- Мост со старым кодом: `withCheckedThrowingContinuation`.

**Что изучить.**
- WWDC21 «Meet async/await in Swift»
- WWDC21 «Protect mutable state with Swift actors»
- WWDC21 «Swift concurrency: Behind the scenes»
- WWDC22 «Eliminate data races using Swift Concurrency»
- WWDC23 «Beyond the basics of structured concurrency»
- WWDC24 «Migrate your app to Swift 6»
- WWDC25 «Embracing Swift concurrency» — главное видео про модель Swift 6.2
- WWDC25 «Code-along: Elevate an app with Swift concurrency»
- [The Swift Programming Language: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- [Swift 6 migration guide](https://www.swift.org/migration/documentation/migrationguide/)

**Упражнение.**
1. Написать `APIClient` на `URLSession` с `async throws`-методами `fetchItems()`, `fetchItem(id:)`, `create(_:)`. Пока бэкенда нет, отдавать JSON из бандла или с публичного мок-API.
2. Сделать `actor ImageCache`, который не скачивает одну и ту же картинку дважды при параллельных запросах (храните `Task` в словаре).
3. Загрузить три независимых ресурса параллельно через `async let` и сравнить с последовательной загрузкой.
4. Если есть свой UIKit-проект: включить в одном модуле `-strict-concurrency=complete` и разобрать первые 10 предупреждений. Это лучший способ понять, где в старом коде гонки.

---

## 2. Observation (`@Observable`)

**Зачем.** Начиная с iOS 17 это основной способ сделать модель, за которой следит UI. Он заменяет `ObservableObject` + `@Published` + Combine и работает точнее: представление перерисовывается только при изменении тех свойств, которые оно реально прочитало. В iOS 26 UIKit тоже умеет автоматически отслеживать `@Observable`-модели, так что это полезно и в старом коде.

**Ключевые понятия.**
- Макрос `@Observable`, `@ObservationIgnored`.
- `@State` для владения моделью, `@Bindable` для привязок, `@Environment` для внедрения.
- Отличия от `ObservableObject`: нет `@Published`, нет `objectWillChange`, отслеживание на уровне свойств.
- `withObservationTracking` и автоматическое отслеживание в UIKit (`viewWillLayoutSubviews`, `updateProperties()` в iOS 26).

**Что изучить.**
- WWDC23 «Discover Observation in SwiftUI»
- [Migrating from the ObservableObject protocol to the Observable macro](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)
- [Документация Observation](https://developer.apple.com/documentation/observation)
- WWDC25 «What's new in UIKit» (раздел про автоматическое отслеживание Observation)

**Упражнение.**
Сделать `@MainActor @Observable final class ItemListModel` с полями `items`, `isLoading`, `error` и методом `func load() async`, который вызывает `APIClient` из темы 1. Пока без UI: проверить в превью или в тесте, что состояние меняется правильно.

---

## 3. SwiftUI: основы и мышление

**Зачем.** Главное отличие от UIKit не в синтаксисе, а в модели: UI — это функция от состояния. Нет `reloadData`, `apply(snapshot)` и ручного обновления ячеек: вы меняете данные, SwiftUI сам считает разницу. Опыт с DiffableDataSource здесь помогает: идея идентичности элементов та же самая, только применена ко всему интерфейсу.

**Ключевые понятия.**
- `View` как значение, `body`, модификаторы и почему важен их порядок.
- Идентичность, время жизни и зависимости представления (структурная и явная идентичность, `id`).
- Компоновка: `VStack`/`HStack`/`ZStack`, `Grid`, `LazyVStack`, `LazyVGrid`, `Layout`-протокол. `List` и `LazyVGrid` здесь заменяют CompositionalLayout для большинства экранов.
- Превью (`#Preview`) как основной инструмент итерации.
- `task(id:)` вместо `viewDidLoad` + ручной отмены.
- Liquid Glass в iOS 26: что меняется в стандартных контролах автоматически.

**Что изучить.**
- WWDC24 «SwiftUI essentials» — лучший вход для тех, кто пришёл из UIKit
- WWDC21 «Demystify SwiftUI» — идентичность и время жизни
- WWDC23 «Demystify SwiftUI performance»
- WWDC24 «Demystify SwiftUI containers»
- WWDC25 «What's new in SwiftUI»
- [Туториалы SwiftUI от Apple](https://developer.apple.com/tutorials/swiftui)

**Упражнение.**
Экран списка `Item` на `List` с секциями, pull-to-refresh (`refreshable`), состоянием загрузки и пустым состоянием (`ContentUnavailableView`). Данные берёт `ItemListModel` из темы 2 через `.task { await model.load() }`. Отдельно сделать экран деталей. Для каждого экрана написать несколько `#Preview` с разными состояниями.

---

## 4. SwiftUI: навигация, состояние, архитектура

**Зачем.** Здесь большинство вопросов «а как это сделать правильно» у UIKit-разработчиков: где живёт навигация, как передавать зависимости, нужен ли MVVM.

**Ключевые понятия.**
- `NavigationStack` с `NavigationPath` и `navigationDestination(for:)`, навигация на данных вместо координаторов.
- `NavigationSplitView` для iPad.
- `sheet`, `fullScreenCover`, `alert`, `confirmationDialog` через состояние.
- Поток данных: `@State`, `@Binding`, `@Bindable`, `@Environment`, свои ключи окружения (макрос `@Entry`).
- Формы и ввод: `Form`, `TextField`, `@FocusState`, валидация.
- Архитектура: «модель на экран» как разумный дефолт; когда не нужна отдельная ViewModel.
- Анимации и переходы: `withAnimation`, `matchedGeometryEffect`, `navigationTransition(.zoom)`.

**Что изучить.**
- WWDC22 «The SwiftUI cookbook for navigation»
- WWDC20 «Data Essentials in SwiftUI» (основы потока данных, по-прежнему актуальны)
- WWDC23 «Explore SwiftUI animation», WWDC23 «Wind your way through advanced animations in SwiftUI»
- WWDC25 «Explore concurrency in SwiftUI»
- [Документация по навигации](https://developer.apple.com/documentation/swiftui/navigation)

**Упражнение.**
1. Экран создания и редактирования `Item` на `Form` с валидацией и сохранением через `APIClient`.
2. Навигация через `NavigationPath`: список → детали → редактирование, плюс открытие экрана деталей по диплинку (`onOpenURL`).
3. Внедрить `APIClient` через `@Environment` и подменять его на мок в превью.

---

## 5. SwiftUI и UIKit вместе

**Зачем.** В реальных проектах переписать всё сразу нельзя. Нужно уметь встраивать SwiftUI в UIKit и наоборот, и знать, где переход оправдан.

**Ключевые понятия.**
- `UIHostingController` для встраивания SwiftUI-экрана в UIKit-навигацию.
- `UIHostingConfiguration` для ячеек в `UICollectionView`: можно оставить DiffableDataSource и CompositionalLayout, а содержимое ячеек писать на SwiftUI. Это самый мягкий первый шаг миграции.
- `UIViewRepresentable` и `UIViewControllerRepresentable` (+ `Coordinator`) для использования UIKit-компонентов в SwiftUI.
- `@Observable`-модели, общие для UIKit и SwiftUI-частей.
- Стратегия миграции: новые экраны на SwiftUI, затем листовые экраны, затем ячейки, а сложные коллекции в последнюю очередь (или никогда).

**Что изучить.**
- WWDC22 «Use SwiftUI with UIKit»
- WWDC19/22 материалы по `UIViewRepresentable`: [документация](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)
- WWDC25 «What's new in UIKit»
- [UIHostingConfiguration](https://developer.apple.com/documentation/swiftui/uihostingconfiguration)

**Упражнение.**
1. В мини-приложении: обернуть один UIKit-компонент (например, экран с `UICollectionView` на CompositionalLayout для галереи) через `UIViewControllerRepresentable`.
2. В своём рабочем UIKit-проекте (или в отдельной песочнице): переписать одну ячейку на `UIHostingConfiguration`, не трогая DiffableDataSource. Сравнить объём кода.

---

## 6. SwiftData

**Зачем.** Современная замена Core Data с объявлением моделей прямо в Swift-коде. Для мини-приложения это локальный кэш: приложение открывается мгновенно и работает без сети, а с сервером синхронизируется в фоне.

**Ключевые понятия.**
- `@Model`, `@Attribute(.unique)`, `@Relationship` и правила удаления.
- `ModelContainer`, `ModelContext`, `@Query` с сортировкой и `#Predicate`.
- Миграции схемы: `VersionedSchema`, `SchemaMigrationPlan`.
- Работа в фоне: `@ModelActor`, почему `@Model`-объекты нельзя передавать между акторами и что передавать вместо них (`PersistentIdentifier`).
- Наследование моделей (iOS 26), `#Index`, `#Unique`.
- Ограничения и когда Core Data всё ещё уместнее.

**Что изучить.**
- WWDC23 «Meet SwiftData»
- WWDC23 «Model your schema with SwiftData»
- WWDC23 «Dive deeper into SwiftData»
- WWDC24 «What's new in SwiftData»
- WWDC24 «Create a custom data store with SwiftData»
- WWDC25 «SwiftData: Dive into inheritance and schema migration»
- [Документация SwiftData](https://developer.apple.com/documentation/swiftdata)

**Упражнение.**
1. Описать `@Model class CachedItem` и показывать список через `@Query`.
2. Написать `@ModelActor actor SyncService`, который загружает данные с сервера через `APIClient` и сохраняет их в базу в фоне. UI обновится сам через `@Query`.
3. Добавить новое поле в модель и сделать явную миграцию через `SchemaMigrationPlan`.

---

## 7. Swift Testing

**Зачем.** Новый фреймворк тестирования, встроенный в Xcode 16+. Короче XCTest, параметризованные тесты из коробки, нормальная поддержка async и параллельный запуск по умолчанию. Работает и в приложении, и в Vapor.

**Ключевые понятия.**
- `@Test`, `@Suite`, `#expect`, `#require`.
- Параметризованные тесты: `@Test(arguments:)`.
- Трейты: `.tags`, `.disabled`, `.timeLimit`, `.serialized`, `.bug`.
- Тесты async-кода, `confirmation` вместо `XCTestExpectation`.
- Сосуществование с XCTest в одном таргете, что пока остаётся в XCTest (UI-тесты, измерение производительности).
- Exit tests и attachments (Swift 6.2).

**Что изучить.**
- WWDC24 «Meet Swift Testing»
- WWDC24 «Go further with Swift Testing»
- [Документация Swift Testing](https://developer.apple.com/documentation/testing)
- [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)

**Упражнение.**
1. Тесты на `ItemListModel`: загрузка, ошибка, пустой список, с мок-`APIClient`.
2. Параметризованный тест валидации формы создания `Item` (пустое имя, слишком длинное, корректное).
3. Тест `ImageCache` из темы 1: при 10 параллельных запросах одной картинки загрузка происходит один раз.

---

## 8. Макросы

**Зачем.** `@Observable`, `@Model`, `#Predicate`, `#Preview`, `@Test`, `#expect`, `@Entry` — всё это макросы. Писать свои приходится редко, но понимать, во что они разворачиваются, нужно, чтобы читать ошибки компилятора и не удивляться поведению.

**Ключевые понятия.**
- Freestanding (`#…`) и attached (`@…`) макросы, их роли: `member`, `peer`, `accessor`, `extension`, `expression`.
- SwiftSyntax, пакет с макросом, тестирование макросов.
- Команда Xcode «Expand Macro», чтобы увидеть развёрнутый код.

**Что изучить.**
- WWDC23 «Expand on Swift macros»
- WWDC23 «Write Swift macros»
- [The Swift Programming Language: Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)
- [swift-syntax на GitHub](https://github.com/swiftlang/swift-syntax)

**Упражнение.**
1. Развернуть через «Expand Macro» `@Observable` на `ItemListModel` и `@Model` на `CachedItem`, разобраться, что сгенерировано.
2. Написать простой макрос `#URL("https://…")`, который проверяет строку на этапе компиляции и возвращает неопциональный `URL`. Использовать его в `APIClient` для базового адреса.

---

## 9. Серверный Swift на Vapor

**Зачем.** Свой бэкенд на том же языке: общие модели, общие знания о Concurrency, никакого переключения контекста. Vapor 4 полностью поддерживает async/await.

**Ключевые понятия.**
- Структура проекта Vapor, `configure.swift`, `routes.swift`, запуск через `swift run` и из Xcode.
- Маршруты, контроллеры (`RouteCollection`), `Content` для JSON.
- Fluent: модели, миграции, связи, запросы. Начать с SQLite, потом PostgreSQL в Docker.
- Валидация запросов (`Validatable`), обработка ошибок (`Abort`), middleware.
- Аутентификация: простой токен или JWT (`vapor/jwt`), Sign in with Apple как дальнейший шаг.
- Тестирование через `XCTVapor` / `VaporTesting` (с Swift Testing).
- Конфигурация через переменные окружения, логирование.
- Деплой: Docker-образ из шаблона Vapor, запуск на любом VPS или Fly.io/Railway.

**Что изучить.**
- [Документация Vapor](https://docs.vapor.codes) (есть разделы Getting Started, Fluent, Testing, Deploy)
- [Vapor Toolbox](https://docs.vapor.codes/install/macos/) для создания проекта: `vapor new Server`
- [swift.org: Server](https://www.swift.org/documentation/server/) — обзор серверной экосистемы
- WWDC23 «Meet Swift OpenAPI Generator» (пригодится в теме 10)
- Книга «Server-Side Swift with Vapor» (Kodeco) для системного прохода

**Упражнение.**
1. `vapor new Server` с Fluent и SQLite. Модель `Item` + миграция.
2. CRUD-эндпоинты: `GET /items`, `GET /items/:id`, `POST /items`, `PUT /items/:id`, `DELETE /items/:id`. Валидация входных данных и корректные HTTP-коды ошибок.
3. Пагинация и фильтр по дате изменения (`GET /items?updatedSince=…`), это понадобится для синхронизации.
4. Тесты эндпоинтов на Swift Testing.
5. Простая аутентификация по токену, чтобы у каждого пользователя были свои `Item`.
6. Перейти на PostgreSQL в Docker (`docker compose up`).

---

## 10. Связка клиента и сервера

**Зачем.** Собрать всё вместе в работающий продукт и прочувствовать полный цикл.

**Ключевые понятия.**
- Общий Swift Package `Shared` с DTO (Codable-структуры), используемый и приложением, и сервером.
- Альтернатива: описать API в OpenAPI и генерировать клиент и серверные заглушки через Swift OpenAPI Generator (есть интеграция с Vapor).
- Синхронизация: сервер как источник истины, SwiftData как кэш, `updatedSince` для инкрементальных обновлений, обработка конфликтов «последняя запись побеждает».
- Хранение токена в Keychain.
- Деплой сервера и сборка приложения в TestFlight.

**Что изучить.**
- WWDC23 «Meet Swift OpenAPI Generator»
- [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) и [swift-openapi-vapor](https://github.com/swift-server/swift-openapi-vapor)
- [Документация Vapor: Deploy → Docker](https://docs.vapor.codes/deploy/docker/)

**Упражнение.**
1. Вынести DTO в `Shared` и подключить пакет к обоим проектам.
2. Переключить `APIClient` с моков на локальный Vapor-сервер.
3. Довести `SyncService`: офлайн-создание `Item` с последующей отправкой на сервер.
4. Задеплоить сервер и собрать приложение в TestFlight.

---

## Чек-лист прогресса

- [ ] 0. Проект создан, Swift 6 включён
- [ ] 1. `APIClient` на async/await, `ImageCache` на actor
- [ ] 2. `ItemListModel` на `@Observable`
- [ ] 3. Список и детали на SwiftUI с превью
- [ ] 4. Навигация, форма, зависимости через Environment
- [ ] 5. UIKit-компонент в SwiftUI и ячейка на `UIHostingConfiguration`
- [ ] 6. Кэш на SwiftData с фоновой синхронизацией
- [ ] 7. Тесты на Swift Testing
- [ ] 8. Свой макрос `#URL`
- [ ] 9. Vapor API с Fluent, тестами и аутентификацией
- [ ] 10. Общие модели, синхронизация, деплой
