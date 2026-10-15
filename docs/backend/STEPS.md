# Бэкенд Buzz: путеводитель по коду

Весь бэкенд уже написан в [`skeleton/`](../../Backend/). Этот файл подсказывает, в каком порядке его изучать. В каждом шаге: какую тему он раскрывает, где она в коде, как проверить и небольшое упражнение, чтобы поправить код руками. Теория по темам — в [README.md](README.md), контракт API — в [API.md](API.md).

Пути ниже даны от `skeleton/`. Если что-то непонятно, спроси в этом треде.

---

## Шаг 0. Запуск

**Тема:** как стартует Vapor-приложение и откуда берутся зависимости.
**Где в коде:** `Package.swift`, `Sources/App/entrypoint.swift`, `Sources/App/configure.swift`.
**Проверь:** `swift run App serve`, затем `curl localhost:8080/health` отвечает `ok`. Появится `db.sqlite` с каталогом.
**Упражнение:** создай рядом `vapor new Playground` и сравни его `configure.swift` с нашим.

## Шаг 1. Роуты

**Тема:** как URL превращается в вызов функции, открытые и закрытые роуты.
**Где в коде:** `Sources/App/routes.swift`.
**Упражнение:** добавь `GET /hello/:name`, который отвечает `"Привет, <name>"`. Подсказка: `req.parameters.get("name")`.

## Шаг 2. Общий пакет и DTO

**Тема:** одни и те же типы на клиенте и сервере, `Codable` против `Content`, `@retroactive`.
**Где в коде:** `Shared/Sources/Shared/*`, `Sources/App/DTOs/Shared+Content.swift`.
**Упражнение:** добавь поле в `DrinkDTO` и посмотри, где компилятор заставит его заполнить.

## Шаг 3. Fluent: каталог напитков

**Тема:** модель, миграция, сид-данные, запросы, фильтры и поиск.
**Где в коде:** `Models/Drink.swift`, `Migrations/CreateDrink.swift`, `Migrations/SeedDrinks.swift`, `Controllers/DrinkController.swift`.
**Проверь:** `curl "localhost:8080/drinks?query=Monster" -H "Authorization: Bearer $TOKEN"` (токен даёт `POST /auth/register`, см. README).
**Упражнение:** добавь свою любимую банку в `SeedDrinks`, удали `db.sqlite` и перезапусти.

## Шаг 4. Тесты

**Тема:** приложение в памяти, SQLite in-memory, Swift Testing.
**Где в коде:** `Tests/AppTests/AppTests.swift`, хелпер `withApp`.
**Проверь:** `swift test`.
**Упражнение:** напиши тест, что `?query=red` находит Red Bull.

## Шаг 5. Записи

**Тема:** связи `@Parent`, валидация, id от клиента, идемпотентный POST, расчёт кофеина.
**Где в коде:** `Models/Entry.swift`, `Migrations/CreateEntry.swift`, `Controllers/EntryController.swift`.
**Упражнение:** запрети `consumedAt` из будущего.

## Шаг 6. Мягкое удаление и синхронизация

**Тема:** `@Timestamp(on: .delete)`, `withDeleted()`, выборка по `updatedAt`.
**Где в коде:** `EntryController.delete`, `Controllers/SyncController.swift`.
**Упражнение:** удали запись через `curl` и найди её в ответе `/sync` с `deletedAt`.

## Шаг 7. Ошибки кодами

**Тема:** middleware, как ошибка становится ответом, почему сервер отдаёт коды, а не текст (два языка).
**Где в коде:** `Errors/APIError.swift`, `Errors/APIErrorMiddleware.swift`, `Shared/Sources/Shared/APIError.swift`.
**Упражнение:** заведи код ошибки для «время из будущего» из шага 5.

## Шаг 8. Авторизация

**Тема:** токены, `ModelTokenAuthenticatable`, `guardMiddleware`, `req.auth.require`, хеширование паролей, язык пользователя.
**Где в коде:** `Models/User.swift`, `Models/UserToken.swift`, `Controllers/AuthController.swift`, `Controllers/MeController.swift`, `routes.swift`.
**Упражнение:** добавь `POST /auth/logout`, который удаляет текущий токен.

## Шаг 9. Статистика

**Тема:** eager loading (`.with(\.$drink)`), `Calendar` и часовые пояса, агрегации.
**Где в коде:** `Controllers/StatsController.swift`, `Shared/Sources/Shared/StatsDTO.swift`.
**Упражнение:** перепиши «по дням» на SQL `GROUP BY` через SQLKit.

## Шаг 10. Клиент

**Тема:** как iOS-приложение ходит в этот API.
**Где в коде:** пакет `Shared` подключается в iOS-проект; клиентская часть живёт в ветке клиента.
**Упражнение:** вызови `GET /drinks` из приложения через `URLSession` и `async/await` (на симуляторе сервер доступен как `http://localhost:8080`).
