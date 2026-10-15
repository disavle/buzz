# Бэкенд Buzz на Swift + Vapor

Гайд для iOS-разработчика, который раньше не писал сервер. Бэкенд для трекера энергетиков из [`app/idea.md`](../idea.md): авторизация по токену, каталог напитков, записи, синхронизация и статистика для Swift Charts.

- Код: [`skeleton/`](../../Backend/)
- **С чего начать изучение:** [STEPS.md](STEPS.md), путеводитель по коду с упражнениями
- Описание эндпоинтов: [API.md](API.md)

---

## 1. Что такое Vapor в терминах iOS

| На iOS | В Vapor |
|---|---|
| `AppDelegate` / `@main App` | `entrypoint.swift` + `configure.swift` — настройка приложения при старте |
| `UIViewController` на экран | `RouteCollection` (контроллер) на группу URL |
| `URLSession` делает запрос | Vapor **принимает** запрос (`Request`) и возвращает ответ (`Response` или любой `Content`) |
| `Codable` модели | `Content` = `Codable` + умение кодироваться в HTTP |
| Core Data / SwiftData | **Fluent** (ORM) + миграции |
| DI через init | `app.storage`, `req.application`, сервисы через расширения `Request` |

Сервер — это долгоживущий процесс: он стартует, слушает порт `8080` и на каждый HTTP-запрос вызывает твою функцию-обработчик.

## 2. Структура проекта

```
skeleton/
├── Package.swift              — зависимости (Vapor, Fluent, драйвер SQLite)
├── Shared/                    — общий Swift-пакет с DTO для клиента и сервера
│   └── Sources/Shared/        — Auth, Drink, Entry, Stats DTO, коды ошибок, JSON-кодеры
├── Sources/App/
│   ├── entrypoint.swift       — точка входа (@main)
│   ├── configure.swift        — БД, миграции, формат дат
│   ├── routes.swift           — открытые и закрытые токеном роуты
│   ├── Controllers/           — Auth, Me, Drink, Entry, Sync, Stats
│   ├── Errors/                — APIError и middleware, который отдаёт коды ошибок
│   ├── Models/                — User, UserToken, Drink, Entry (таблицы в БД)
│   ├── Migrations/            — схемы таблиц + стартовый каталог
│   └── DTOs/                  — Content и валидация для общих DTO
└── Tests/AppTests/AppTests.swift
```

Каркас написан вручную и ещё не собирался: при первой сборке на Mac возможны мелкие правки. Создать такой проект с нуля можно командой `vapor new <имя>` (Vapor Toolbox, `brew install vapor`). Каркас здесь повторяет этот шаблон, но урезан до сути.

## 3. Роуты и контроллеры

Простейший роут:

```swift
app.get("hello") { req async -> String in
    "Привет!"
}
```

Когда роутов много, их группируют в контроллер (`RouteCollection`):

```swift
struct EntryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let entries = routes.grouped("entries")
        entries.get(use: index)               // GET    /entries
        entries.post(use: create)             // POST   /entries
        entries.delete(":id", use: delete)    // DELETE /entries/:id
    }
}
```

Закрытые роуты оборачиваются в middleware: `app.grouped(UserToken.authenticator(), User.guardMiddleware())`. Внутри обработчика текущий пользователь берётся как `try req.auth.require(User.self)`.

Что важно понять:
- **Параметры пути**: `req.parameters.get("id", as: UUID.self)`.
- **Тело запроса**: `try req.content.decode(CreateEntryDTO.self)`.
- **Query**: `try req.query.decode(SomeFilter.self)`.
- **Ошибки**: `throw Abort(.notFound)` превращается в HTTP 404 с JSON `{"error": true, "reason": "Not Found"}`.
- **Валидация**: протокол `Validatable` проверяет поля до декодирования.

## 4. Fluent и выбор БД

Fluent — ORM от Vapor. Модель — это класс с property wrapper'ами:

```swift
final class Entry: Model, @unchecked Sendable {
    static let schema = "entries"
    @ID(key: .id) var id: UUID?
    @Parent(key: "user_id") var user: User
    @Parent(key: "drink_id") var drink: Drink
    @Field(key: "consumed_at") var consumedAt: Date
    @Field(key: "caffeine_mg") var caffeineMg: Double
    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?  // мягкое удаление
}
```

Схема таблицы создаётся **миграцией** (в отличие от SwiftData, где схема выводится из модели автоматически). Каждое изменение схемы — новая миграция, старые не правим.

Запросы асинхронные:

```swift
let entries = try await Entry.query(on: req.db)
    .filter(\.$user.$id == userID)
    .filter(\.$consumedAt >= from)
    .with(\.$drink)                 // подгрузить напиток одним запросом
    .sort(\.$consumedAt, .descending)
    .all()
```

Связи: `@Parent` / `@Children` (один-ко-многим), `@OptionalParent` (как `Drink.owner`: у общего каталога владельца нет), `@Siblings` (многие-ко-многим через pivot-модель).

Что в Buzz стоит посмотреть отдельно:
- **Мягкое удаление.** `@Timestamp(on: .delete)` превращает `delete(on:)` в запись даты, а обычные запросы такие строки пропускают. Чтобы их увидеть (нужно для `/sync`), добавляется `.withDeleted()`.
- **Id от клиента.** Запись создаётся офлайн с `UUID()` на телефоне, сервер принимает этот id. Повторная отправка возвращает уже сохранённую запись вместо дубля.
- **Деньги** хранятся целыми копейками, а не `Double`.

**Какую БД брать:**
- **SQLite** — для старта. Один файл `db.sqlite`, ничего ставить не нужно. В тестах — in-memory.
- **PostgreSQL** — когда захочется деплоя или серьёзных фич. Переход = замена драйвера (`FluentPostgresDriver`) и одной строки в `configure.swift`; модели и миграции остаются те же. Локально Postgres удобно поднимать через Docker.

## 5. DTO, общие с клиентом

Идея: модели обмена (что летит по сети) живут в отдельном маленьком Swift-пакете `Shared`, который подключают и Xcode-проект клиента, и Vapor-сервер. Так JSON-контракт проверяется компилятором с обеих сторон.

Правила:
- `Shared` зависит **только** от Foundation. Никакого Vapor и SwiftUI.
- Структуры там — `Codable`, `Sendable`, `Hashable`.
- На сервере им добавляется соответствие `Content` одной строкой: `extension EntryDTO: @retroactive Content {}`.
- Там же лежат общие `JSONEncoder.buzz` / `JSONDecoder.buzz` с датами в ISO 8601, чтобы клиент и сервер одинаково понимали даты.
- Модель Fluent (`Entry`) и DTO (`EntryDTO`) — разные типы. Модель — это таблица, DTO — это API. Не отдавай модель наружу напрямую: иначе любое изменение БД ломает клиента.

Подключение в клиенте: Xcode → File → Add Package Dependencies → Add Local… → папка `Shared`.

## 6. Ошибки и два языка

Приложение на русском и английском, поэтому сервер не пишет тексты для людей. Обработчик бросает `APIError(.conflict, .emailTaken)`, а `APIErrorMiddleware` (замена стандартного `ErrorMiddleware` в `configure.swift`) превращает любую ошибку в `{"error": "email_taken", "reason": "..."}`. Ошибки валидации маппятся в коды по имени поля, например `dailyCaffeineLimitMg` даёт `limit_invalid`.

Коды лежат в `Shared` как `enum APIErrorCode`, так что клиент разбирает ответ в тот же тип и переводит код через String Catalog. Неизвестный код раскодируется в `.unknown`, и старая версия приложения не падает на новых кодах сервера.

У пользователя есть поле `locale` (`ru`/`en`) на будущее для пушей. Если клиент не передал его при регистрации, сервер смотрит на `Accept-Language`. Полный список кодов в [API.md](API.md#ошибки-и-языки).

## 7. async/await и Sendable

Vapor 4 полностью поддерживает Swift Concurrency: обработчики пишутся как `async throws`, Fluent-запросы — через `await`. Под капотом работает SwiftNIO (event loops), но в повседневном коде ты его почти не видишь. Старые примеры в интернете с `EventLoopFuture`, `.map`, `.flatMap` — это до-async стиль, его можно не учить.

С Swift 6 строгая проверка конкурентности требует `Sendable`: DTO делаем `struct ... : Sendable`, модели Fluent помечаем `@unchecked Sendable` (так делает официальный шаблон).

Этот же опыт напрямую пригодится в клиенте: те же `async`, `Task`, `Sendable`, actors.

## 8. Запуск локально

Нужен Xcode 16+ (Swift 6) на Mac.

```bash
cd skeleton
swift run App serve   # сервер на http://127.0.0.1:8080
```

В режиме разработки миграции применяются сами при старте (см. `configure.swift`), появится файл `db.sqlite` с каталогом из 6 напитков. Можно и через Xcode: открыть `Package.swift` и запустить схему `App`. Первый запуск долгий, SwiftPM скачивает зависимости.

Проверка:

```bash
# регистрация, в ответе token
curl -X POST http://127.0.0.1:8080/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"me@buzz.app","password":"password123"}'

TOKEN=<token из ответа>
curl http://127.0.0.1:8080/drinks?query=Monster -H "Authorization: Bearer $TOKEN"
curl "http://127.0.0.1:8080/stats?period=week&tz=Europe/Moscow" -H "Authorization: Bearer $TOKEN"
```

**Симулятор iOS** видит Mac как `localhost`, так что клиент ходит на `http://localhost:8080` без настроек. Для реального iPhone нужен IP Mac в локальной сети и `--hostname 0.0.0.0`. Для `http` (не `https`) в Info.plist клиента понадобится исключение ATS для локальной разработки.

## 9. Тесты

Vapor даёт модуль `VaporTesting` для Swift Testing (`@Test`, `#expect`). Тест поднимает приложение в памяти, без реального порта, с in-memory SQLite:

```swift
@Test func registerAndMe() async throws {
    try await withApp { app in   // хелпер: поднять app, мигрировать, прогнать, откатить
        let token = try await register(app)
        try await app.testing().test(.GET, "me", beforeRequest: { req in
            req.headers.bearerAuthorization = .init(token: token)
        }, afterResponse: { res async throws in
            #expect(try res.content.decode(UserDTO.self).dailyCaffeineLimitMg == 400)
        })
    }
}
```

В тестах пароли не хешируются (`app.passwords.use(.plaintext)`), чтобы не ждать Bcrypt.

Запуск: `swift test` или ⌘U в Xcode. Сейчас там 8 тестов: авторизация и коды ошибок, язык из `Accept-Language`, каталог и чужие напитки, идемпотентное создание записей, мягкое удаление и `/sync`, статистика.

## 10. Порядок изучения

По плану из idea.md бэкенд нужен на третьем шаге, после офлайн-клиента и графиков. Читать код удобно в таком порядке:

1. `routes.swift`, `MeController`: как устроен роут и авторизация.
2. `Errors/`: как ошибка превращается в код для клиента.
3. `DrinkController` + `Drink`: запросы, фильтры, поиск, `@OptionalParent`.
4. `EntryController` + `Entry`: id от клиента, расчёт кофеина, мягкое удаление.
5. `SyncController`: `withDeleted`, выборка по `updatedAt`.
6. `StatsController`: агрегации. Упражнение: переписать «по дням» на SQL `GROUP BY` через SQLKit.
7. Дальше: Postgres в Docker, срок жизни токенов, деплой (Fly.io или VPS).

## Ссылки

- Документация Vapor: https://docs.vapor.codes
- Fluent: https://docs.vapor.codes/fluent/overview/
- Тестирование: https://docs.vapor.codes/advanced/testing/
