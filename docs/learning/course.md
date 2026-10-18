# Курс: пишем новую фичу в Buzz руками

Курс для того, чтобы освоить стек Buzz, а не просто прочитать готовый код. Он состоит из блоков примерно по 30 минут. Дат и дедлайнов нет: проходи блоки в своём темпе, по одному за раз или по несколько. Каждый блок устроен одинаково: сначала изучаешь тему по справочнику, документации и коду Buzz, потом пишешь кусок кода сам.

Теория живёт в справочнике [handbook.md](handbook.md): что это за инструмент, зачем он и чем заменяет привычное из UIKit. Курс на эту теорию ссылается и не повторяет её.

## Что получится в конце

Новая фича **«Самочувствие»** внутри Buzz. Вечером ты отмечаешь настроение от 1 до 5, сколько часов спал и пишешь короткую заметку. На отдельной вкладке есть:
- список отметок по неделям;
- форма и экран деталей;
- поиск по заметкам;
- график «настроение против кофеина»;
- напоминание в выбранное время.

Отметки хранятся в SwiftData, работают без сети и синхронизируются с сервером на Vapor. По пути ты затронешь каждую технологию проекта: от Tuist и SwiftUI до Fluent, Docker, CI и релиза.

## Как проходить блок

1. **Изучи (≈10 минут).** Прочитай карточку справочника и посмотри на указанный код Buzz. Если тема новая, сначала сделай маленькую песочницу из блока.
2. **Сделай руками (≈20 минут).** Работай в ветке `learn/wellbeing`. В заготовках кода места для тебя помечены `// TODO:`. Подглядывать в Buzz можно, копировать нельзя.
3. **Проверь «Готово, когда».** Сделай коммит и отметь блок `[x]` в оглавлении ниже.
4. **Запиши в журнал три строки:** что сделал, что сломалось, что понял. Журнал лежит в `docs/learning/journal.md`. Через пару месяцев это готовый материал для резюме и собеседований.

## Правила

- Пиши сам, без Copilot и без Claude. Можно пользоваться документацией Apple и Vapor, видео WWDC и справочником. Claude зови после, чтобы сравнить решение или разобрать ошибку.
- Застрял на 25 минут — запиши вопрос в журнал и закончи блок. Со свежей головой будет проще.
- Шаги «Сломай и почини» не пропускай. Ошибку, которую ты вызвал сам, запоминаешь лучше любой статьи.
- Заканчивай на понятном следующем шаге, тогда в следующий раз легко начать.
- Блок не обязан занимать ровно 30 минут. Если тема пошла, продолжай; если нет, раздели блок на два захода.

## Оглавление и прогресс


**Часть 0. Старт**
- [ ] [Блок 1. Собрать Buzz и запустить на моках](#блок-1-собрать-buzz-и-запустить-на-моках)
- [ ] [Блок 2. Бэкенд и приложение вместе](#блок-2-бэкенд-и-приложение-вместе)
- [ ] [Блок 3. Ветка, журнал и порядок работы](#блок-3-ветка-журнал-и-порядок-работы)

**Часть 1. Модуль и модель**
- [ ] [Блок 4. Tuist: как описан проект](#блок-4-tuist-как-описан-проект)
- [ ] [Блок 5. Новый модуль WellbeingFeature](#блок-5-новый-модуль-wellbeingfeature)
- [ ] [Блок 6. Границы модулей](#блок-6-границы-модулей)
- [ ] [Блок 7. Модель Checkin в Domain](#блок-7-модель-checkin-в-domain)
- [ ] [Блок 8. Протокол репозитория и фейк](#блок-8-протокол-репозитория-и-фейк)

**Часть 2. SwiftUI**
- [ ] [Блок 9. Мышление SwiftUI в песочнице](#блок-9-мышление-swiftui-в-песочнице)
- [ ] [Блок 10. CheckinRow и #Preview](#блок-10-checkinrow-и-preview)
- [ ] [Блок 11. Observation в песочнице](#блок-11-observation-в-песочнице)
- [ ] [Блок 12. WellbeingViewModel](#блок-12-wellbeingviewmodel)
- [ ] [Блок 13. List, ForEach и идентичность](#блок-13-list-foreach-и-идентичность)
- [ ] [Блок 14. Секции по неделям и удаление](#блок-14-секции-по-неделям-и-удаление)
- [ ] [Блок 15. @State и @Binding: MoodPicker](#блок-15-state-и-binding-moodpicker)
- [ ] [Блок 16. @Bindable, @Environment и @Entry](#блок-16-bindable-environment-и-entry)
- [ ] [Блок 17. Form и поля ввода](#блок-17-form-и-поля-ввода)
- [ ] [Блок 18. TextField(value:format:) и @FocusState](#блок-18-textfieldvalueformat-и-focusstate)
- [ ] [Блок 19. NavigationStack и sheet](#блок-19-navigationstack-и-sheet)
- [ ] [Блок 20. navigationDestination и детали](#блок-20-navigationdestination-и-детали)
- [ ] [Блок 21. Дизайн-токены и tint](#блок-21-дизайн-токены-и-tint)
- [ ] [Блок 22. Анимации и хаптики](#блок-22-анимации-и-хаптики)
- [ ] [Блок 23. Доступность](#блок-23-доступность)

**Часть 3. UIKit-мост**
- [ ] [Блок 24. UIHostingController в песочнице](#блок-24-uihostingcontroller-в-песочнице)
- [ ] [Блок 25. WellbeingCoordinator и вкладка](#блок-25-wellbeingcoordinator-и-вкладка)
- [ ] [Блок 26. Диплинк buzz://checkin/new](#блок-26-диплинк-buzzcheckinnew)

**Часть 4. Данные**
- [ ] [Блок 27. SwiftData в песочнице](#блок-27-swiftdata-в-песочнице)
- [ ] [Блок 28. CheckinModel и контейнер](#блок-28-checkinmodel-и-контейнер)
- [ ] [Блок 29. Репозиторий на @ModelActor](#блок-29-репозиторий-на-modelactor)
- [ ] [Блок 30. Sendable и границы акторов](#блок-30-sendable-и-границы-акторов)
- [ ] [Блок 31. Миграция: сначала сломать](#блок-31-миграция-сначала-сломать)
- [ ] [Блок 32. VersionedSchema и план миграции](#блок-32-versionedschema-и-план-миграции)
- [ ] [Блок 33. #Predicate и макросы изнутри](#блок-33-predicate-и-макросы-изнутри)
- [ ] [Блок 34. @AppStorage](#блок-34-appstorage)
- [ ] [Блок 35. Keychain: как Buzz хранит токен](#блок-35-keychain-как-buzz-хранит-токен)

**Часть 5. Конкурентность и реактивность**
- [ ] [Блок 36. async/await и Task в песочнице](#блок-36-asyncawait-и-task-в-песочнице)
- [ ] [Блок 37. .task и отмена на экране](#блок-37-task-и-отмена-на-экране)
- [ ] [Блок 38. async let](#блок-38-async-let)
- [ ] [Блок 39. Группа задач](#блок-39-группа-задач)
- [ ] [Блок 40. actor и @MainActor](#блок-40-actor-и-mainactor)
- [ ] [Блок 41. AsyncStream в песочнице](#блок-41-asyncstream-в-песочнице)
- [ ] [Блок 42. Живые обновления через Broadcaster](#блок-42-живые-обновления-через-broadcaster)
- [ ] [Блок 43. Mutex и Synchronization](#блок-43-mutex-и-synchronization)
- [ ] [Блок 44. continuation в песочнице](#блок-44-continuation-в-песочнице)
- [ ] [Блок 45. Напоминание через UNUserNotificationCenter](#блок-45-напоминание-через-unusernotificationcenter)
- [ ] [Блок 46. Typed throws](#блок-46-typed-throws)
- [ ] [Блок 47. Combine в песочнице](#блок-47-combine-в-песочнице)
- [ ] [Блок 48. Поиск по заметкам на Combine](#блок-48-поиск-по-заметкам-на-combine)
- [ ] [Блок 49. Тот же поиск на .task(id:)](#блок-49-тот-же-поиск-на-taskid)
- [ ] [Блок 50. searchable, refreshable, ContentUnavailableView](#блок-50-searchable-refreshable-contentunavailableview)

**Часть 6. Архитектура, строки, тесты, графики**
- [ ] [Блок 51. Clean: SaveCheckinUseCase](#блок-51-clean-savecheckinusecase)
- [ ] [Блок 52. Redux в Buzz: разбор](#блок-52-redux-в-buzz-разбор)
- [ ] [Блок 53. Мини-стор напоминаний](#блок-53-мини-стор-напоминаний)
- [ ] [Блок 54. String Catalog и плюрализация](#блок-54-string-catalog-и-плюрализация)
- [ ] [Блок 55. Строки в модуле: bundle .module](#блок-55-строки-в-модуле-bundle-module)
- [ ] [Блок 56. FormatStyle и Measurement](#блок-56-formatstyle-и-measurement)
- [ ] [Блок 57. Swift Testing: первые тесты](#блок-57-swift-testing-первые-тесты)
- [ ] [Блок 58. Параметры и ошибки в тестах](#блок-58-параметры-и-ошибки-в-тестах)
- [ ] [Блок 59. Swift Charts: столбцы кофеина](#блок-59-swift-charts-столбцы-кофеина)
- [ ] [Блок 60. Настроение поверх кофеина](#блок-60-настроение-поверх-кофеина)

**Часть 7. Сервер на Vapor**
- [ ] [Блок 61. Как устроен сервер](#блок-61-как-устроен-сервер)
- [ ] [Блок 62. Первый маршрут: CheckinController](#блок-62-первый-маршрут-checkincontroller)
- [ ] [Блок 63. Fluent: модель и миграция](#блок-63-fluent-модель-и-миграция)
- [ ] [Блок 64. POST и запросы Fluent](#блок-64-post-и-запросы-fluent)
- [ ] [Блок 65. Общий DTO в Shared](#блок-65-общий-dto-в-shared)
- [ ] [Блок 66. Codable и даты](#блок-66-codable-и-даты)
- [ ] [Блок 67. Валидация запроса](#блок-67-валидация-запроса)
- [ ] [Блок 68. Авторизация по токену](#блок-68-авторизация-по-токену)
- [ ] [Блок 69. Коды ошибок и middleware](#блок-69-коды-ошибок-и-middleware)
- [ ] [Блок 70. Тесты сервера](#блок-70-тесты-сервера)

**Часть 8. Сеть и синхронизация**
- [ ] [Блок 71. APIClient для отметок](#блок-71-apiclient-для-отметок)
- [ ] [Блок 72. Фейковый сервер для отметок](#блок-72-фейковый-сервер-для-отметок)
- [ ] [Блок 73. Outbox: состояние синхронизации](#блок-73-outbox-состояние-синхронизации)
- [ ] [Блок 74. Синхронизация отметок](#блок-74-синхронизация-отметок)
- [ ] [Блок 75. Офлайн-сценарий и NWPathMonitor](#блок-75-офлайн-сценарий-и-nwpathmonitor)

**Часть 9. Инфраструктура и выпуск**
- [ ] [Блок 76. Postgres в Docker](#блок-76-postgres-в-docker)
- [ ] [Блок 77. Docker-образ сервера](#блок-77-docker-образ-сервера)
- [ ] [Блок 78. Линт и форматирование](#блок-78-линт-и-форматирование)
- [ ] [Блок 79. PR и CI](#блок-79-pr-и-ci)
- [ ] [Блок 80. Деплой на Render](#блок-80-деплой-на-render)
- [ ] [Блок 81. Renovate и обновления](#блок-81-renovate-и-обновления)
- [ ] [Блок 82. CHANGELOG и релиз](#блок-82-changelog-и-релиз)
- [ ] [Блок 83. fastlane и TestFlight (когда будет аккаунт разработчика)](#блок-83-fastlane-и-testflight-когда-будет-аккаунт-разработчика)
- [ ] [Блок 84. Итоги курса](#блок-84-итоги-курса)

---

## Часть 0. Старт

Здесь ты собираешь Buzz, запускаешь его с фейковым сервером и с настоящим бэкендом, заводишь ветку и журнал. После этой части у тебя есть рабочее окружение и понятный ритм прохождения блоков.

### Блок 1. Собрать Buzz и запустить на моках

*≈30 мин · Справочник: [H2](handbook.md#h2-mise-версии-инструментов-и-задачи), [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api)*

**Цель.** Buzz собран из исходников одной командой и работает в симуляторе с фейковым сервером в памяти.

**Изучи (≈10 мин).**
- Карточка [H2](handbook.md#h2-mise-версии-инструментов-и-задачи) — что такое mise и почему своя задача вызывается `mise run generate`, а не `mise generate`.
- Карточка [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api) — абзац «Адрес сервера»: порядок, в котором приложение выбирает сервер.
- Документация: [mise: Getting Started](https://mise.jdx.dev/getting-started.html), [Customizing the build schemes for a project](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project).
- Код Buzz: [`mise.toml:29`](https://github.com/disavle/buzz/blob/main/mise.toml#L29) — задача `generate` и её зависимости `setup:gems` и `setup:hooks`. Прочитай комментарий в начале файла.
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:54`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L54) — одна строка решает, какой `APIClient` получит всё приложение.

**Сделай руками (≈20 мин).**
1. Поставь mise, если его ещё нет: `brew install mise`, затем добавь `eval "$(mise activate zsh)"` в `~/.zshrc` и открой новую вкладку терминала.
2. В корне клона выполни `mise run generate`. Первый раз команда ставит tuist, ruby, гемы fastlane и git-хуки, поэтому идёт несколько минут. Посмотри в выводе, в каком порядке запускаются задачи.
3. Открой проект: `mise run open`. Обрати внимание, что `Buzz.xcworkspace` нет в git: его сгенерировал Tuist (это тема блока 4).
4. В Xcode: Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables. Добавь `BUZZ_MOCK_API` со значением `1`. Схему генерирует Tuist, поэтому после следующего `mise run generate` переменную придётся добавить снова.
5. Запусти схему `Buzz` на симуляторе iPhone. Пройди по четырём вкладкам: добавь банку на «Сегодня», найди напиток в «Каталоге», посмотри «Статистику».
6. Во вкладке «Настройки» войди с любым email и паролем от 8 символов. Проверка пароля на клиенте живёт в [`iOS/Modules/SettingsFeature/Sources/LoginView.swift:22`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/LoginView.swift#L22), а фейковый сервер [`iOS/Modules/Networking/Sources/MockAPIClient.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L13) принимает любой вход.
7. Добавь вторую переменную `BUZZ_IN_MEMORY = 1` ([`AppDependencies.swift:35`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L35)), перезапусти и убедись, что история пропала: база теперь живёт только в памяти. Выключи эту переменную галочкой.

**Готово, когда.** Приложение запускается в симуляторе с `BUZZ_MOCK_API = 1`, банка добавляется, вход в «Настройках» проходит без бэкенда.

**Если застрял.** `mise run generate` ругается на версию Xcode — проверь `xcode-select -p`, должен быть выбран Xcode 26. Задачи mise видны командой `mise tasks`.

### Блок 2. Бэкенд и приложение вместе

*≈30 мин · Справочник: [G1](handbook.md#g1-vapor-сервер-как-долгоживущий-процесс), [H2](handbook.md#h2-mise-версии-инструментов-и-задачи)*

**Цель.** Сервер на Vapor работает на твоём Mac, приложение в симуляторе ходит в него, и ты видишь каждый запрос в логе.

**Изучи (≈10 мин).**
- Карточка [G1](handbook.md#g1-vapor-сервер-как-долгоживущий-процесс) — чем сервер отличается от приложения: это процесс, который живёт часами и обслуживает много запросов.
- Карточка [H2](handbook.md#h2-mise-версии-инструментов-и-задачи) — абзац «Алиасы zsh».
- Документация: [Vapor docs](https://docs.vapor.codes).
- Код Buzz: [`mise.toml:100`](https://github.com/disavle/buzz/blob/main/mise.toml#L100) — задача `backend:run`; `--hostname 0.0.0.0` нужен, чтобы сервер был виден и с iPhone в той же сети.
- Код Buzz: [`iOS/Project.swift:85`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L85) — симулятор по умолчанию ходит на `http://localhost:8080`.
- Код Buzz: [`Backend/Sources/App/configure.swift:33`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L33) — middleware, который пишет каждый запрос в лог; [`:23`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L23) — база в файле `db.sqlite`.
- Код Buzz: [`scripts/buzz.zsh:23`](https://github.com/disavle/buzz/blob/main/scripts/buzz.zsh#L23) — функция `buzz-dev`.

**Сделай руками (≈20 мин).**
1. В отдельной вкладке терминала выполни `mise run backend:run`. Первая сборка долгая: SwiftPM скачивает Vapor и Fluent.
2. Проверь, что сервер жив: `curl http://localhost:8080/health`. Маршрут описан в [`Backend/Sources/App/routes.swift:4`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift#L4).
3. В схеме Xcode сними галочку с `BUZZ_MOCK_API` и запусти приложение. Теперь оно ходит на `localhost:8080`.
4. Во вкладке «Настройки» переключись на режим регистрации и заведи аккаунт. Смотри в лог сервера: появится `POST /auth/register`.
5. Добавь банку на «Сегодня» и потяни список вниз. В логе увидишь запросы синхронизации. Найди их пути в [`iOS/Modules/Networking/Sources/Endpoint.swift:58`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L58) и ниже.
6. Остановь сервер (`Ctrl+C`) и добавь ещё банку. Приложение не падает: запись осталась на устройстве с серым значком «не отправлено». Запусти сервер снова и потяни список, значок исчезнет.
7. Подключи алиасы: добавь в `~/.zshrc` строку `source <путь к клону>/scripts/buzz.zsh`, выполни `exec zsh`, затем `buzz-dev`. Лог теперь в файле: `tail -f Backend/server.log`. Останови сервер командой `buzz-stop`.
8. Загляни в базу: `sqlite3 Backend/db.sqlite "select count(*) from entries;"`.

**Готово, когда.** В логе сервера видны регистрация и запросы синхронизации, а банка, добавленная без сервера, уходит на сервер после его запуска.

**Если застрял.** Приложение не видит сервер — проверь, что `BUZZ_MOCK_API` выключен и что в схеме нет `BUZZ_API_URL` с другим адресом ([`AppDependencies.swift:57`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L57)).

### Блок 3. Ветка, журнал и порядок работы

*≈30 мин · Справочник: [H7](handbook.md#h7-github-flow-и-защита-main-rulesets), [H5](handbook.md#h5-swift-format-swiftlint-pre-commit)*

**Цель.** Работа над курсом идёт в ветке `learn/wellbeing`, есть журнал, и ты видел, как хук линтера останавливает плохой коммит.

**Изучи (≈10 мин).**
- Карточка [H7](handbook.md#h7-github-flow-и-защита-main-rulesets) — GitHub Flow: короткие ветки, PR, squash-слияние.
- Карточка [H5](handbook.md#h5-swift-format-swiftlint-pre-commit) — абзац «В Buzz»: какие хуки и когда срабатывают.
- Документация: [GitHub flow](https://docs.github.com/get-started/using-github/github-flow).
- Код Buzz: [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md) — разделы «Цикл» и «Коммиты».
- Код Buzz: [`.githooks/pre-commit:10`](https://github.com/disavle/buzz/blob/main/.githooks/pre-commit#L10) — коммит без `.swift`-файлов линтер пропускает; [`.githooks/run-lint:24`](https://github.com/disavle/buzz/blob/main/.githooks/run-lint#L24) — сам запуск `mise run lint`.

**Сделай руками (≈20 мин).**
1. Создай ветку от свежего `main`: `git switch main && git pull && git switch -c learn/wellbeing`. Это длинная учебная ветка; в PR она уйдёт в блоке 79.
2. Проверь, что хуки включены: `git config core.hooksPath` должен вывести `.githooks`. Если пусто, выполни `mise run setup:hooks`.
3. Создай журнал `docs/learning/journal.md`:

   ```markdown
   # Learning journal

   <!-- After each block: three lines. What I did, what broke, what I understood. -->

   ## Block 3. Branch, journal, workflow
   - Did:
   - Broke:
   - Understood:
   ```
4. Закоммить его: `git add docs/learning/journal.md && git commit -m "docs(learning): start the journal"`. Коммит пройдёт мгновенно: в нём нет Swift-файлов, и хук ничего не проверяет.
5. Сломай и почини. Открой любой Swift-файл, например `iOS/Modules/TodayFeature/Sources/TodayViewModel.swift`, и сдвинь одну строку на 7 пробелов вместо 8. Сделай `git add` и попробуй закоммитить. Прочитай, что напечатал хук и почему коммит не создан.
6. Выполни `mise run format` и посмотри `git diff`: swift-format вернул отступ. Верни файл как было: сначала `git restore --staged iOS/Modules/TodayFeature/Sources/TodayViewModel.swift`, затем `git restore iOS/Modules/TodayFeature/Sources/TodayViewModel.swift`.
7. Запиши в журнал порядок прохождения блока, чтобы он был перед глазами:
   - прочитать «Изучи», открыть ссылки на код Buzz;
   - набрать код руками, не копировать заготовку целиком;
   - проверить «Готово, когда»;
   - коммит вида `feat(wellbeing): ...`, три строки в журнал.

**Готово, когда.** Ты на ветке `learn/wellbeing`, в ней коммит с журналом, и ты видел сообщение хука «Linters failed».

**Если застрял.** Хук пишет, что mise не найден, — Xcode и GUI-клиенты запускают хуки с коротким `PATH`; коммить из терминала или посмотри, какие пути добавляет `.githooks/run-lint`.

## Часть 1. Модуль и модель

Ты разбираешься, как Tuist описывает проект, добавляешь новый модуль `WellbeingFeature` и кладёшь в `Domain` модель отметки, протокол репозитория и фейк для превью и тестов.

### Блок 4. Tuist: как описан проект

*≈30 мин · Справочник: [H1](handbook.md#h1-tuist-проект-как-код)*

**Цель.** Ты понимаешь, откуда в Xcode берутся все таргеты Buzz, и можешь найти в манифесте любой из них.

**Изучи (≈10 мин).**
- Карточка [H1](handbook.md#h1-tuist-проект-как-код) целиком, она короткая.
- Карточка [E5](handbook.md#e5-модули-фичи-видят-только-domain) — только абзац «Зачем столько таргетов».
- Документация: [Tuist docs](https://docs.tuist.dev).
- Код Buzz: [`iOS/Project.swift:8`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L8) — модули описаны по одной строке; [`:27`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L27) — список всех модулей; [`:72`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L72) — приложение зависит от каждого модуля из списка.
- Код Buzz: [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift:32`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift#L32) — из одного `Module` получаются таргет фреймворка и таргет тестов.
- Код Buzz: [`iOS/Tuist/Package.swift`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/Package.swift) — как подключается внешний пакет `Shared`.

**Сделай руками (≈20 мин).**
1. Выполни `cd iOS && tuist edit`. Манифесты откроются в отдельном проекте Xcode с автодополнением. Нажми на `Module(` в `Project.swift` с зажатым Cmd и дойди до хелпера.
2. Посчитай таргеты на бумаге: сколько модулей в списке `modules`, у скольких `tests: true`, какие два таргета объявлены отдельно (`app` и `appTests`), что добавляет `Tuist/Package.swift`. Сверь итог с цифрой из карточки E5.
3. Выполни `mise run graph` ([`mise.toml:90`](https://github.com/disavle/buzz/blob/main/mise.toml#L90)). Откроется картинка графа. Найди на ней правило из комментария [`iOS/Project.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L5): стрелки от фич идут только в `Domain` и `DesignSystem`.
4. Найди в манифесте, где задаются Swift 6 и строгая проверка конкурентности для всех таргетов ([`iOS/Project.swift:113`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L113)). Открой Build Settings любого модуля в Xcode и найди там те же значения.
5. Найди, как в схему попадают тесты всех модулей ([`iOS/Project.swift:102`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L102)). Запиши в журнал, что произойдёт со схемой, если добавить модуль с `tests: true`.
6. Закрой окно `tuist edit`, ничего не сохраняя.

**Готово, когда.** Ты можешь назвать число таргетов и объяснить, из каких строк манифеста получается каждый.

**Если застрял.** `tuist edit` не открывается — запусти его из папки `iOS`, где лежит `Project.swift`.

### Блок 5. Новый модуль WellbeingFeature

*≈30 мин · Справочник: [H1](handbook.md#h1-tuist-проект-как-код)*

**Цель.** В проекте есть модуль `WellbeingFeature` с пустым экраном, тестами и своим String Catalog, и приложение с ним собирается.

**Изучи (≈10 мин).**
- Карточка [H1](handbook.md#h1-tuist-проект-как-код) — раздел «Код в Buzz», ссылка на `docs/infra/HANDS-ON.md`, шаг про второй таргет.
- Документация: [Tuist docs](https://docs.tuist.dev) — раздел про проекты и таргеты.
- Код Buzz: [`iOS/Project.swift:20`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L20) — общий список зависимостей фич; [`:21`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L21) — так объявлен `TodayFeature`.
- Код Buzz: [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift:40`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift#L40) — какие папки хелпер ждёт от модуля: `Sources`, `Resources`, `Tests`.
- Код Buzz: [`iOS/Modules/TodayFeature/Resources/Localizable.xcstrings`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Resources/Localizable.xcstrings) — как выглядит каталог строк изнутри (это JSON).

**Сделай руками (≈20 мин).**
1. В `iOS/Project.swift` после строки с `settings` добавь модуль и допиши его в массив `modules`:

   ```swift
   let wellbeing = Module("WellbeingFeature", dependencies: featureDeps, resources: true, tests: true)

   let modules = [domain, persistence, networking, designSystem, sync, today, addEntry, catalog, stats, settings, wellbeing]
   ```
2. Создай папки `iOS/Modules/WellbeingFeature/Sources`, `Resources` и `Tests`.
3. Создай `iOS/Modules/WellbeingFeature/Resources/Localizable.xcstrings` с пустым каталогом. С ресурсами Tuist создаёт для модуля `Bundle.module`, через него экран будет искать свои строки.

   ```json
   {
     "sourceLanguage" : "en",
     "strings" : {},
     "version" : "1.0"
   }
   ```
4. Создай `iOS/Modules/WellbeingFeature/Sources/WellbeingView.swift`:

   ```swift
   import DesignSystem
   import SwiftUI

   /// The "Wellbeing" tab: evening check-ins with mood, sleep and a short note.
   /// For now it is an empty screen, so we can check that the module builds.
   public struct WellbeingView: View {
       public init() {}

       public var body: some View {
           // TODO: show an empty state for now:
           // ContentUnavailableView with Text("wellbeing.empty.title", bundle: .module)
           // and the system image "heart.text.square".
       }
   }

   #Preview {
       WellbeingView()
           .buzzTheme()
   }
   ```
5. Создай `iOS/Modules/WellbeingFeature/Tests/WellbeingFeatureTests.swift`, чтобы у тестового таргета были исходники:

   ```swift
   import SwiftUI
   import Testing

   @testable import WellbeingFeature

   // A smoke test: the module builds and its test target runs.
   @MainActor
   @Test("The Wellbeing screen can be created")
   func wellbeingViewCreates() {
       // TODO: create WellbeingView() and check something simple about it,
       // for example that `_ = WellbeingView().body` does not crash.
   }
   ```
6. Выполни `mise run generate`. Tuist собирает список файлов по маскам в момент генерации, поэтому каждый новый файл, созданный не через Xcode, требует повторного `mise run generate`.
7. Открой проект, найди модуль `WellbeingFeature` в навигаторе, открой превью `WellbeingView`. Собери схему `Buzz` (Cmd+B) и запусти тест ромбиком рядом с функцией.
8. Открой `Localizable.xcstrings` в Xcode. Если ключ `wellbeing.empty.title` не появился после сборки, добавь его кнопкой «+», впиши английское значение и русский перевод. Подробно каталог строк разберём в блоке 54.
9. Выполни `mise run graph` и найди новый узел.

**Готово, когда.** Превью показывает пустое состояние «Самочувствие», схема `Buzz` собирается, тест `wellbeingViewCreates` зелёный, на графе есть `WellbeingFeature` со стрелками в `Domain` и `DesignSystem`.

**Если застрял.** Xcode не видит новые файлы — перегенерируй проект. Ошибка `Bundle.module` не найден — проверь, что `resources: true` и что в `Resources` есть хотя бы один файл.

### Блок 6. Границы модулей

*≈30 мин · Справочник: [E5](handbook.md#e5-модули-фичи-видят-только-domain)*

**Цель.** Ты своими глазами видел, как граница модуля ловит лишний импорт и непубличный тип, и знаешь, какая проверка это делает.

**Изучи (≈10 мин).**
- Карточка [E5](handbook.md#e5-модули-фичи-видят-только-domain) целиком.
- Документация: [Access Control в Swift Book](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/).
- Код Buzz: [`iOS/Project.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L5) — правила модулей словами.
- Код Buzz: [`mise.toml:70`](https://github.com/disavle/buzz/blob/main/mise.toml#L70) — задача `lint:imports`; [`.github/workflows/ci.yml:66`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L66) — CI запускает её на каждом PR.
- Код Buzz: [`iOS/Modules/Domain/Sources/Repositories.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L49) — публичная константа, которую возьмём для опыта.

**Сделай руками (≈20 мин).**
1. Сломай и почини: лишний импорт. В `WellbeingView.swift` добавь `import Persistence` и собери проект. Возможно, сборка пройдёт: `Persistence` всё равно собирается для приложения, и компилятор находит модуль. Именно поэтому нужна отдельная проверка.
2. Выполни `mise run lint:imports`. Прочитай отчёт: Tuist нашёл импорт модуля, которого нет в зависимостях `WellbeingFeature`. Убери импорт и запусти проверку снова.
3. Сломай и почини: невидимый тип. В `body` временно выведи `Text(verbatim: "Limit: \(defaultDailyLimitMg)")` и добавь `import Domain`. Собери.
4. В `Repositories.swift` убери `public` у `defaultDailyLimitMg` и собери снова. Прочитай ошибку в `WellbeingView.swift`. В одном таргете приложения такой ошибки не было бы: там всё по умолчанию `internal` и видно везде.
5. Верни `public`, убери временный `Text`. В тестах модулей используется `@testable import` (посмотри [`iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift#L5)): он открывает тестам `internal`, но не `private`.
6. Запиши в журнал ответ на вопрос: какие модули может импортировать `WellbeingFeature` и почему фича не должна видеть SwiftData.

**Готово, когда.** `mise run lint:imports` проходит без замечаний, а в журнале записаны две ошибки, которые ты видел.

**Если застрял.** `lint:imports` долго работает в первый раз — он делает `tuist install`, потом быстрее.

### Блок 7. Модель Checkin в Domain

*≈30 мин · Справочник: [E5](handbook.md#e5-модули-фичи-видят-только-domain), [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6)*

**Цель.** В `Domain` есть `struct Checkin` и превью-данные `Checkin.previewWeek`, и ты понимаешь, зачем ей `Sendable` и `Hashable`.

**Изучи (≈10 мин).**
- Карточка [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6) — что такое `Sendable` и почему Swift 6 проверяет его при компиляции.
- Документация: [Sendable](https://developer.apple.com/documentation/swift/sendable), [Identifiable](https://developer.apple.com/documentation/swift/identifiable).
- Код Buzz: [`iOS/Modules/Domain/Sources/Models/Drink.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Drink.swift#L5) — комментарий, почему модели домена это структуры, а не `@Model`-классы.
- Код Buzz: [`iOS/Modules/Domain/Sources/Models/Entry.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Entry.swift#L5) — зачем `id` создаёт клиент.
- Код Buzz: [`iOS/Modules/Domain/Sources/Fakes/PreviewData.swift:22`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Fakes/PreviewData.swift#L22) — превью-данные по формуле вместо `random()`.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/Domain/Sources/Models/Checkin.swift`:

   ```swift
   import Foundation

   /// One evening check-in: mood, hours of sleep and a short note.
   ///
   /// A plain struct, like `Entry`: `Sendable` lets it cross actors (repositories are actors),
   /// `Hashable` lets SwiftUI compare it and use it as a navigation value.
   public struct Checkin: Identifiable, Hashable, Sendable {
       /// Created on the device, so sending it twice to the server does not create a duplicate.
       public let id: UUID
       /// The start of the day (00:00 in the user's calendar). One check-in per day.
       public var day: Date
       /// 1...5, where 1 is a bad day and 5 is a great one.
       public var mood: Int
       public var sleepHours: Double
       public var note: String
       /// When the user last changed it. Sync uses it later to pick the newer copy.
       public var updatedAt: Date

       public init(
           id: UUID = UUID(),
           day: Date,
           mood: Int,
           sleepHours: Double,
           note: String = "",
           updatedAt: Date = .now,
           calendar: Calendar = .current
       ) {
           self.id = id
           // TODO: store the start of the day, not the exact time: calendar.startOfDay(for:)
           // TODO: assign the other fields
       }
   }
   ```
2. В конец `iOS/Modules/Domain/Sources/Fakes/PreviewData.swift` добавь превью-данные:

   ```swift
   public extension Checkin {
       /// `count` days back from today, newest first.
       /// A simple formula instead of random(), so previews look the same every time.
       static func preview(days count: Int, calendar: Calendar = .current) -> [Checkin] {
           (0..<count).compactMap { offset in
               guard let day = calendar.date(byAdding: .day, value: -offset, to: .now) else { return nil }
               // TODO: mood in 1...5 and sleepHours in 5...9 from `offset`,
               // for example 1 + (offset * 3) % 5 and 5 + Double((offset * 5) % 9) / 2.
               // TODO: a note on every third day, an empty note otherwise.
               return Checkin(day: day, mood: 3, sleepHours: 8)
           }
       }

       /// Seven days for previews and tests.
       static let previewWeek: [Checkin] = preview(days: 7)
   }
   ```
3. Выполни `mise run generate` и собери проект.
4. Сломай и почини. Добавь в `Checkin` поле `public var draft = NoteDraft()` и рядом класс `public final class NoteDraft { public var text = ""; public init() {} }`. Собери и прочитай ошибку: в `Sendable`-структуре не может лежать изменяемый класс. Подумай, какая гонка данных тут возможна. Удали поле и класс.
5. Сломай и почини ещё раз: убери `Sendable` из списка протоколов. Публичные структуры не получают `Sendable` автоматически, поэтому ошибка появится там, где `Checkin` пересекает границу актора; это будет в следующем блоке. Верни `Sendable`.
6. Ответь в журнале: где в SwiftUI пригодится `Hashable` (подсказка: значения для навигации в блоке 20 и `.animation(value:)` в блоке 22).

**Готово, когда.** Модуль `Domain` собирается, а `Checkin.previewWeek` содержит 7 отметок с разными настроением и сном.

**Если застрял.** Ошибка «static property is not concurrency-safe» на `previewWeek` значит, что `Checkin` потерял `Sendable`.

### Блок 8. Протокол репозитория и фейк

*≈30 мин · Справочник: [E5](handbook.md#e5-модули-фичи-видят-только-domain), [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api)*

**Цель.** В `Domain` есть протокол `CheckinRepository` и фейк `InMemoryCheckinRepository`, и первый тест на него зелёный.

**Изучи (≈10 мин).**
- Карточка [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api) — идея «протокол с двумя реализациями и выбор в одном месте».
- Документация: [Actors в Swift Book](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors).
- Код Buzz: [`iOS/Modules/Domain/Sources/Repositories.swift:3`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L3) — комментарий, почему все методы `async`; [`:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L11) — протокол `EntryRepository`.
- Код Buzz: [`iOS/Modules/Domain/Sources/Fakes/InMemoryRepositories.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Fakes/InMemoryRepositories.swift#L11) — фейк на акторе со словарём.
- Код Buzz: [`iOS/Modules/Domain/Tests/DomainTests.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Tests/DomainTests.swift#L17) — так выглядит async-тест на фейк.

**Сделай руками (≈20 мин).**
1. В `iOS/Modules/Domain/Sources/Repositories.swift` после `SettingsRepository` добавь протокол:

   ```swift
   /// Evening check-ins. One check-in per day.
   public protocol CheckinRepository: Sendable {
       /// All check-ins, newest day first.
       func all() async throws -> [Checkin]
       /// Insert or update by `id` (an "upsert").
       func save(_ checkin: Checkin) async throws
       func delete(id: UUID) async throws
   }
   ```
2. В `iOS/Modules/Domain/Sources/Fakes/InMemoryRepositories.swift` добавь фейк:

   ```swift
   public actor InMemoryCheckinRepository: CheckinRepository {
       private var storage: [UUID: Checkin]

       public init(checkins: [Checkin] = []) {
           storage = Dictionary(uniqueKeysWithValues: checkins.map { ($0.id, $0) })
       }

       public func all() async throws -> [Checkin] {
           // TODO: storage.values sorted by `day`, newest first
       }

       public func save(_ checkin: Checkin) async throws {
           // TODO: one line, the same id replaces the old value
       }

       public func delete(id: UUID) async throws {
           storage[id] = nil
       }
   }
   ```
3. Создай `iOS/Modules/Domain/Tests/CheckinRepositoryTests.swift`:

   ```swift
   import Foundation
   import Testing

   @testable import Domain

   @Test("Saving the same id twice keeps one check-in")
   func checkinUpsert() async throws {
       let repo = InMemoryCheckinRepository()
       var checkin = Checkin(day: .now, mood: 2, sleepHours: 6)
       try await repo.save(checkin)
       // TODO: change mood to 4, save again,
       // then #expect that all() has one item and its mood is 4
   }

   @Test("all() returns the newest day first")
   func checkinOrder() async throws {
       // TODO: create the repo with Checkin.previewWeek.shuffled()
       // and #expect that the first day is later than the last one
   }
   ```
4. Выполни `mise run generate`, открой тест и запусти оба ромбиком.
5. Сломай и почини. Убери `Sendable` у `Checkin` и собери. Теперь ошибка появится в акторе: массив `[Checkin]` нельзя вернуть из актора наружу. Прочитай текст ошибки целиком и верни `Sendable`.
6. Подумай и запиши в журнал: почему фейк сделан актором, а не классом. Подсказка в комментарии [`InMemoryRepositories.swift:5`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Fakes/InMemoryRepositories.swift#L5).

**Готово, когда.** Тесты `checkinUpsert` и `checkinOrder` зелёные, схема `Buzz` собирается.

**Если застрял.** Тест не виден в навигаторе тестов — перегенерируй проект, новый файл ещё не попал в таргет `DomainTests`.

## Часть 2. SwiftUI

Ты пишешь экраны фичи на SwiftUI: строку, список по неделям, форму с собственным контролом настроения, навигацию, цвета, анимации и доступность. Каждая новая идея сначала пробуется в песочнице, потом применяется в Buzz.

### Блок 9. Мышление SwiftUI в песочнице

*≈30 мин · Справочник: [B1](handbook.md#b1-мышление-swiftui-ui-как-функция-от-состояния)*

**Цель.** У тебя есть отдельный проект-песочница, а в нём счётчик и список, на которых видно, что UI это функция от состояния.

**Изучи (≈10 мин).**
- Карточка [B1](handbook.md#b1-мышление-swiftui-ui-как-функция-от-состояния) целиком.
- Документация: [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui), первый урок раздела «SwiftUI essentials».
- Код Buzz: [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 6 — таблица «UIKit → SwiftUI». Прочитай строки про список, состояние и реактивность.
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L28) — список без `reloadData`.

**Сделай руками (≈20 мин).**
1. Создай в Xcode новый проект `Sandbox` вне репозитория Buzz (iOS App, интерфейс SwiftUI). В Build Settings поставь Swift Language Version = Swift 6. Эта песочница пригодится во всех следующих блоках.
2. В `ContentView.swift` напиши счётчик:

   ```swift
   import SwiftUI

   struct ContentView: View {
       @State private var count = 0

       var body: some View {
           VStack(spacing: 16) {
               Text("\(count)")
                   .font(.largeTitle)
               Button("+1") {
                   // TODO: change only the state. Do not touch the Text.
               }
           }
       }
   }

   #Preview { ContentView() }
   ```
3. Поменяй местами модификаторы: `.padding().background(.yellow)` и `.background(.yellow).padding()` на `Text`. Каждый модификатор оборачивает View в новую, поэтому порядок важен.
4. Сделай `struct Item { let title: String }`, массив из трёх элементов и `ForEach(items) { Text($0.title) }`. Прочитай ошибку компилятора. Почини через `ForEach(items, id: \.title)`, затем через `Identifiable`.
5. Запиши в журнал, как это выглядело бы в UIKit: лейбл, `IBAction`, ручное `label.text = ...`; для списка — снапшот Diffable и `apply`. Чем item identifier в Diffable похож на `id` в `ForEach`?

**Готово, когда.** Превью счётчика обновляет число без единой строки, которая трогает `Text`, а `ForEach` работает с `Identifiable`-структурой.

### Блок 10. CheckinRow и #Preview

*≈30 мин · Справочник: [B1](handbook.md#b1-мышление-swiftui-ui-как-функция-от-состояния), [B11](handbook.md#b11-preview)*

**Цель.** В модуле есть строка `CheckinRow` без состояния и три превью: обычная отметка, отметка без заметки и длинная заметка на русском в тёмной теме.

**Изучи (≈10 мин).**
- Карточка [B11](handbook.md#b11-preview).
- Документация: [Previews in Xcode](https://developer.apple.com/documentation/swiftui/previews-in-xcode).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:112`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L112) — `EntryRow`, образец строки.
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:150`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L150) — превью с языком через `.environment(\.locale, ...)`.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Theme.swift:22`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L22) — готовые шрифты для чисел.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Sources/CheckinRow.swift`:

   ```swift
   import DesignSystem
   import Domain
   import SwiftUI

   /// One row in the list: mood badge, day and note, hours of sleep on the right.
   /// No state: the row only draws the check-in it gets.
   struct CheckinRow: View {
       let checkin: Checkin

       var body: some View {
           HStack(spacing: 12) {
               // Mood badge: the number in a circle. Colors come in block 21.
               Text(checkin.mood, format: .number)
                   .font(.buzzNumber)
                   .frame(width: 44, height: 44)
                   .background(Color.buzzFill, in: .circle)

               VStack(alignment: .leading, spacing: 2) {
                   // "Monday, 13 October" in the user's language.
                   Text(checkin.day.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                       .font(.headline)
                   // TODO: the note in one line (.lineLimit(1)), .footnote, .secondary,
                   // only when the note is not empty
               }

               Spacer()

               // TODO: Label with the "bed.double" symbol and the hours:
               // Text(checkin.sleepHours, format: .number.precision(.fractionLength(0...1)))
               // Use .monospacedDigit(), so the numbers line up in a column.
           }
           .padding(.vertical, 4)
       }
   }
   ```
2. Ниже добавь три превью. Строку показывай внутри `List`, чтобы видеть её как в приложении:

   ```swift
   #Preview("With a note") {
       List { CheckinRow(checkin: Checkin.previewWeek[0]) }
           .buzzTheme()
   }

   #Preview("No note") {
       // TODO: a Checkin with an empty note
   }

   #Preview("Long note, ru, dark") {
       // TODO: a Checkin with a long note,
       // .environment(\.locale, Locale(identifier: "ru")) and .preferredColorScheme(.dark)
   }
   ```
3. Выполни `mise run generate` и открой превью. Переключай их вкладками над канвасом.
4. Проверь в русском превью, что день недели и месяц пришли на русском без единой строки перевода: это делает `FormatStyle`.
5. В канвасе включи Variants → Color Scheme Variants и Dynamic Type Variants. Посмотри, что строка не ломается на крупном шрифте; если ломается, запиши, где именно (вернёмся в блоке 23).

**Готово, когда.** Три превью `CheckinRow` открываются без запуска приложения, заметка обрезается в одну строку, часы сна стоят ровным столбиком.

**Если застрял.** Превью пишет, что не может собрать модуль, — сначала собери схему `Buzz` (Cmd+B) и посмотри настоящую ошибку компилятора.

### Блок 11. Observation в песочнице

*≈30 мин · Справочник: [B2](handbook.md#b2-observation-observable)*

**Цель.** Ты видел в консоли, что View с `@Observable`-моделью перерисовывается только от тех свойств, которые читает.

**Изучи (≈10 мин).**
- Карточка [B2](handbook.md#b2-observation-observable) целиком.
- Документация: [Migrating from the Observable Object protocol to the Observable macro](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L11) — `@MainActor @Observable` и `@ObservationIgnored` у зависимостей ([`:26`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L26)).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L13) — модель в `@State`, а не в `@StateObject`.

**Сделай руками (≈20 мин).**
1. В песочнице создай файл `CounterModel.swift`:

   ```swift
   import Observation

   @Observable
   final class CounterModel {
       var count = 0
       var title = "Counter"
       // TODO: add a dependency, for example `let logger = Logger()`,
       // mark it @ObservationIgnored and explain in a comment why
   }
   ```
2. Сделай две View: `CountLabel` читает только `model.count`, `TitleLabel` только `model.title`. Обе получают модель обычным `let model: CounterModel`. В `body` каждой поставь первой строкой `let _ = Self._printChanges()`.
3. В родительской View держи модель как `@State private var model = CounterModel()` и сделай две кнопки: одна меняет `count`, другая `title`. Запусти в симуляторе (в превью консоль не видна) и посмотри в консоль Xcode, какая View перерисовалась от какой кнопки.
4. Для сравнения перепиши модель на старый лад: `final class OldModel: ObservableObject` с `@Published var count` и `@Published var title`, во View `@StateObject`. Повтори опыт и сравни вывод `_printChanges`.
5. Добавь дочернюю View с `TextField` для `title`. Попробуй написать `$model.title` при `let model` и прочитай ошибку. Почини, объявив `@Bindable var model: CounterModel` (подробнее в блоке 16).

**Готово, когда.** В консоли видно: кнопка `count` перерисовывает только `CountLabel`, а со старой моделью перерисовывается всё, что держит `@StateObject`.

**Если застрял.** `_printChanges` ничего не печатает — он работает при запуске приложения, а не в канвасе превью.

### Блок 12. WellbeingViewModel

*≈30 мин · Справочник: [B2](handbook.md#b2-observation-observable), [E1](handbook.md#e1-mvvm-на-observable)*

**Цель.** У экрана есть `WellbeingViewModel`, который загружает отметки из репозитория, и превью показывает, сколько их.

**Изучи (≈10 мин).**
- Карточка [E1](handbook.md#e1-mvvm-на-observable).
- Документация: [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:32`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L32) — зависимости приходят через `init`; [`:52`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L52) — загрузка в `async`-методе.
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:16`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L16) — как View принимает модель снаружи; [`:166`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L166) — фабрика `preview` для превью и тестов.
- Код Buzz: [`iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift#L9) — тест модели на фейке.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Sources/WellbeingViewModel.swift`:

   ```swift
   import Domain
   import Foundation
   import Observation

   /// "Wellbeing" screen logic. MVVM on `@Observable`, like TodayViewModel.
   /// `@MainActor`: the view reads these properties on the main thread,
   /// and `await` inside the methods comes back to the main actor by itself.
   @MainActor
   @Observable
   public final class WellbeingViewModel {
       public private(set) var checkins: [Checkin] = []
       public private(set) var isLoading = false
       public private(set) var errorMessage: String?

       // A dependency, not screen state: Observation does not need to track it.
       @ObservationIgnored private let repository: any CheckinRepository

       public init(repository: any CheckinRepository) {
           self.repository = repository
       }

       func load() async {
           // TODO: isLoading = true at the start and false at the end (defer)
           // TODO: checkins = try await repository.all()
           // TODO: on error put error.localizedDescription into errorMessage
       }
   }
   ```
2. В `WellbeingView.swift` замени пустой `init()` на модель, как в `TodayView`:

   ```swift
   public struct WellbeingView: View {
       /// `@State` keeps the model alive for the whole life of the view.
       @State private var model: WellbeingViewModel

       public init(model: WellbeingViewModel) {
           _model = State(initialValue: model)
       }

       public var body: some View {
           Group {
               // TODO: ProgressView() while loading,
               // the error text if there is one,
               // otherwise a temporary Text(verbatim: "Check-ins: \(model.checkins.count)")
           }
           .task { await model.load() }
       }
   }

   extension WellbeingViewModel {
       static func preview(checkins: [Checkin] = Checkin.previewWeek) -> WellbeingViewModel {
           WellbeingViewModel(repository: InMemoryCheckinRepository(checkins: checkins))
       }
   }
   ```
3. Обнови превью: `WellbeingView(model: .preview())` и второе превью с `.preview(checkins: [])`. Поправь smoke-тест из блока 5, он больше не соберётся без модели.
4. Допиши тест в `WellbeingFeatureTests.swift` по образцу `TodayViewModelTests`:

   ```swift
   @MainActor
   @Test("load() puts all check-ins on screen")
   func loadShowsCheckins() async {
       let model = WellbeingViewModel.preview()
       await model.load()
       // TODO: #expect the count is 7 and isLoading is false
   }
   ```
5. Подумай и запиши в журнал: почему `checkins` объявлены `private(set)`, и кто, кроме View, может вызвать `load()`.

**Готово, когда.** Превью показывает «Check-ins: 7», пустое превью показывает 0, тест `loadShowsCheckins` зелёный.

**Если застрял.** Ошибка про `@MainActor` в тесте — пометь тестовую функцию `@MainActor`, как в `TodayViewModelTests`.

### Блок 13. List, ForEach и идентичность

*≈30 мин · Справочник: [B4](handbook.md#b4-списки-и-сетки-вместо-diffable--compositionallayout)*

**Цель.** Экран показывает отметки списком, и ты своими глазами видел, что ломается, когда у элементов плохие идентификаторы.

**Изучи (≈10 мин).**
- Карточка [B4](handbook.md#b4-списки-и-сетки-вместо-diffable--compositionallayout) — список «Было → стало».
- Документация: [List](https://developer.apple.com/documentation/swiftui/list), [ForEach](https://developer.apple.com/documentation/swiftui/foreach).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L28) — `ForEach` по `Identifiable`-записям внутри `List`.

**Сделай руками (≈20 мин).**
1. В `WellbeingView` замени временный `Text` на список:

   ```swift
   List {
       ForEach(model.checkins) { checkin in
           CheckinRow(checkin: checkin)
       }
   }
   .listStyle(.insetGrouped)
   ```
   Состояния загрузки и ошибки пока оставь как есть, пустое состояние доделаем в блоке 50.
2. Открой превью и сравни с тем, что пришлось бы написать в UIKit: регистрация ячейки, data source, снапшот, `apply`.
3. Сломай и почини: одинаковые id. В превью передай массив, где две отметки имеют один `id`: `let c = Checkin.previewWeek[0]; let copy = Checkin(id: c.id, day: c.day, mood: 1, sleepHours: 4)`. Запусти в симуляторе и найди в консоли предупреждение о повторяющемся ID. Посмотри, какая строка показалась. Это та же проблема, что дубликаты в снапшоте Diffable.
4. Сломай и почини: новый id на каждый рендер. Временно оберни данные: `ForEach(model.checkins.map { Wrapped(id: UUID(), checkin: $0) })` со структурой `struct Wrapped: Identifiable { let id: UUID; let checkin: Checkin }`. В `CheckinRow` добавь `.onAppear { print("appear", checkin.day) }`. Добавь в `WellbeingView` временную кнопку в тулбаре, которая меняет любой `@State`-счётчик, и нажимай её: с новыми UUID каждое нажатие заново создаёт все строки. Верни `ForEach(model.checkins)` и убедись, что вывод пропал.
5. Попробуй `ForEach(model.checkins, id: \.self)`. Это собирается, потому что `Checkin` это `Hashable`. Запиши в журнал, чем это плохо: при изменении настроения у отметки поменяется идентичность, и SwiftUI покажет удаление и вставку вместо обновления строки.
6. Убери временную кнопку и `print`.

**Готово, когда.** Превью показывает список из 7 строк, а в журнале описаны оба опыта с идентичностью.

**Если застрял.** Консоль не видна в превью — эти опыты запускай на симуляторе, временно поставив `WellbeingView` в превью-приложение или в любой экран песочницы.

### Блок 14. Секции по неделям и удаление

*≈30 мин · Справочник: [B4](handbook.md#b4-списки-и-сетки-вместо-diffable--compositionallayout)*

**Цель.** Отметки разбиты на секции по неделям, и любую можно удалить свайпом.

**Изучи (≈10 мин).**
- Карточка [B4](handbook.md#b4-списки-и-сетки-вместо-diffable--compositionallayout) — строка про секции CompositionalLayout.
- Документация: [Section](https://developer.apple.com/documentation/swiftui/section), [swipeActions](https://developer.apple.com/documentation/swiftui/view/swipeactions(edge:allowsfullswipe:content:)).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:32`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L32) — удаление через `.onDelete`, для сравнения.
- Код Buzz: [`iOS/Modules/Domain/Sources/Repositories.swift:41`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Repositories.swift#L41) — работа с днями через `Calendar`.

**Сделай руками (≈20 мин).**
1. В `WellbeingViewModel` добавь группировку и удаление:

   ```swift
   /// One section of the list: a week and its check-ins.
   struct WeekSection: Identifiable {
       let start: Date
       let checkins: [Checkin]
       var id: Date { start }
   }

   /// The calendar knows where a week starts: Monday in Russia, Sunday in the US.
   @ObservationIgnored var calendar = Calendar.current

   var weeks: [WeekSection] {
       // TODO: Dictionary(grouping: checkins) by
       //       calendar.dateInterval(of: .weekOfYear, for: $0.day)?.start ?? $0.day
       // TODO: map to WeekSection, newest week first, check-ins inside newest first
   }

   func delete(_ checkin: Checkin) async {
       // TODO: try await repository.delete(id:), then await load()
       // On error, set errorMessage.
   }
   ```
2. В `WellbeingView` перейди на секции:

   ```swift
   ForEach(model.weeks) { week in
       Section {
           ForEach(week.checkins) { checkin in
               CheckinRow(checkin: checkin)
                   .swipeActions(edge: .trailing) {
                       Button(role: .destructive) {
                           // TODO: Task { await model.delete(checkin) }
                       } label: {
                           Label {
                               Text("wellbeing.delete", bundle: .module)
                           } icon: {
                               Image(systemName: "trash")
                           }
                       }
                   }
           }
       } header: {
           // TODO: "Week of 13 October": a key with the date inside,
           // Text("wellbeing.week \(week.start.formatted(.dateTime.day().month(.wide)))", bundle: .module)
       }
   }
   ```
3. Обнови превью: `.preview(checkins: Checkin.preview(days: 21))`. Добавь ключи `wellbeing.delete` и `wellbeing.week %@` в каталог с английским и русским значениями.
4. В превью удали несколько отметок свайпом. Если в живом превью свайп неудобен, запусти превью на симуляторе кнопкой в канвасе.
5. Добавь превью с `.environment(\.locale, Locale(identifier: "en_US"))` и посмотри, как сдвинулись границы недель. Объясни в журнале, почему календарь берётся у пользователя, а не захардкожен.

**Готово, когда.** В превью три-четыре секции с заголовками недель, свайп удаляет строку, и после удаления секция без отметок исчезает.

**Если застрял.** Порядок секций прыгает — словарь не хранит порядок, сортируй секции после `map`.

### Блок 15. @State и @Binding: MoodPicker

*≈30 мин · Справочник: [B3](handbook.md#b3-поток-данных-state-binding-bindable-environment-entry)*

**Цель.** Есть свой контрол `MoodPicker`, который меняет чужое значение через `@Binding`, и начало формы `CheckinForm` с черновиком в `@State`.

**Изучи (≈10 мин).**
- Карточка [B3](handbook.md#b3-поток-данных-state-binding-bindable-environment-entry) — первые две строки таблицы: `@State` и `@Binding`.
- Документация: [Binding](https://developer.apple.com/documentation/swiftui/binding), [Previewable()](https://developer.apple.com/documentation/swiftui/previewable()).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L11) — форма держит черновик в `@State`, потому что он больше никому не нужен.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsView.swift:68`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsView.swift#L68) — ряд кругов выбора цвета, похожий на будущий `MoodPicker`.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: сделай `struct ToggleRow: View { @Binding var isOn: Bool }` и передай в неё `$flag` из родителя с `@State private var flag = false`. Убедись, что переключатель в дочерней View меняет текст в родителе.
2. Создай `iOS/Modules/WellbeingFeature/Sources/MoodPicker.swift`:

   ```swift
   import DesignSystem
   import SwiftUI

   /// Five circles, 1...5. The picker does not own the mood:
   /// it reads and writes the parent's value through a binding.
   struct MoodPicker: View {
       @Binding var mood: Int

       var body: some View {
           HStack(spacing: 8) {
               ForEach(1...5, id: \.self) { value in
                   Button {
                       // TODO: write the new value into the binding
                   } label: {
                       Text(value, format: .number)
                           .font(.buzzNumber)
                           .frame(width: 44, height: 44)
                           // TODO: a filled circle for the selected value,
                           // Color.buzzFill for the others
                   }
                   .buttonStyle(.plain)
                   .frame(maxWidth: .infinity)
               }
           }
       }
   }

   #Preview {
       // @Previewable lets a preview own @State, so the picker can be tapped.
       @Previewable @State var mood = 3
       VStack {
           MoodPicker(mood: $mood)
           Text(verbatim: "Mood: \(mood)")
       }
       .padding()
       .buzzTheme()
   }
   ```
3. Создай `iOS/Modules/WellbeingFeature/Sources/CheckinForm.swift` с черновиком:

   ```swift
   import DesignSystem
   import Domain
   import SwiftUI

   /// Form for a new or an edited check-in.
   /// The draft is local `@State`: the list does not change until the user taps Save.
   struct CheckinForm: View {
       @State private var draft: Checkin
       let onSave: (Checkin) -> Void

       init(checkin: Checkin, onSave: @escaping (Checkin) -> Void) {
           _draft = State(initialValue: checkin)
           self.onSave = onSave
       }

       var body: some View {
           VStack(spacing: 24) {
               // TODO: MoodPicker bound to draft.mood
               // TODO: a temporary Text showing draft.mood, to see the binding work
           }
           .padding()
       }
   }

   #Preview {
       CheckinForm(checkin: Checkin.previewWeek[0]) { print("saved", $0) }
           .buzzTheme()
   }
   ```
4. Выполни `mise run generate`, открой оба превью и потыкай круги.
5. Ответь в журнале: почему `MoodPicker` берёт `@Binding`, а не `@State`. Что будет, если объявить в нём `@State var mood` и передать начальное значение?

**Готово, когда.** В превью формы нажатие на круг меняет `draft.mood`, и выбранный круг подсвечен.

**Если застрял.** `$draft.mood` не находится — проверь, что `draft` объявлен через `@State`, а не `let`.

### Блок 16. @Bindable, @Environment и @Entry

*≈30 мин · Справочник: [B3](handbook.md#b3-поток-данных-state-binding-bindable-environment-entry)*

**Цель.** Дочерняя View меняет поле модели через `@Bindable`, а строка списка читает свой стиль из окружения через собственный ключ `@Entry`.

**Изучи (≈10 мин).**
- Карточка [B3](handbook.md#b3-поток-данных-state-binding-bindable-environment-entry) — строки таблицы про `@Bindable`, `@Environment` и `@Entry`.
- Документация: [Bindable](https://developer.apple.com/documentation/swiftui/bindable), [Entry()](https://developer.apple.com/documentation/swiftui/entry()).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:20`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L20) — `$model.filter` работает, потому что модель лежит в `@State` этой же View.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L38) — модификатор, который кладёт акцент в окружение через `.tint`. В Buzz `@Entry` пока не используется, ты будешь первым.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: `extension EnvironmentValues { @Entry var greeting = "Привет" }`, прочитай через `@Environment(\.greeting)`, подмени на родителе `.environment(\.greeting, "Hi")`.
2. В `WellbeingViewModel` добавь фильтр «только трудные дни»:

   ```swift
   /// Show only days with mood 1 or 2.
   var onlyLowMood = false

   // TODO: make `weeks` group `visibleCheckins` instead of `checkins`
   var visibleCheckins: [Checkin] {
       // TODO: all check-ins, or only mood <= 2 when the filter is on
   }
   ```
3. Создай дочернюю View с переключателем. Модель приходит параметром, но для `$` ей нужен `@Bindable`:

   ```swift
   /// A child view that edits one field of the screen model.
   struct WellbeingFilterRow: View {
       @Bindable var model: WellbeingViewModel

       var body: some View {
           // TODO: Toggle bound to $model.onlyLowMood,
           // label Text("wellbeing.filter.low", bundle: .module)
       }
   }
   ```
   Поставь её первой секцией в `List` экрана: `Section { WellbeingFilterRow(model: model) }`.
4. Сломай и почини: замени `@Bindable var model` на `let model` и прочитай ошибку на `$model`. Верни.
5. Сделай свой ключ окружения для стиля строки в `CheckinRow.swift`:

   ```swift
   /// How much a row shows. A compact row is for small cards later.
   enum CheckinRowStyle: Sendable {
       case full, compact
   }

   extension EnvironmentValues {
       // @Entry writes the EnvironmentKey boilerplate for us.
       @Entry var checkinRowStyle: CheckinRowStyle = .full
   }
   ```
   В `CheckinRow` прочитай `@Environment(\.checkinRowStyle) private var style` и в режиме `.compact` не показывай заметку.
6. Добавь превью списка с `.environment(\.checkinRowStyle, .compact)` на `List`. Значение доходит до всех строк без единого параметра в `init`.
7. Запиши в журнал, когда выбрать параметр `init`, а когда окружение. Подсказка: из [`iOS/App/Sources/AppDependencies.swift:87`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L87) — у каждого хостинга своё окружение.

**Готово, когда.** Переключатель в превью прячет хорошие дни, а компактное превью показывает строки без заметок.

**Если застрял.** Ошибка «Cannot find '$model' in scope» — у `let`-свойства нет проекции `$`, нужен `@Bindable`.

### Блок 17. Form и поля ввода

*≈30 мин · Справочник: [B7](handbook.md#b7-формы-и-ввод-form-textfieldvalueformat-focusstate)*

**Цель.** `CheckinForm` стал настоящей формой: настроение, день, сон через `Stepper` и многострочная заметка, а кнопка сохранения выключена при неверных данных.

**Изучи (≈10 мин).**
- Карточка [B7](handbook.md#b7-формы-и-ввод-form-textfieldvalueformat-focusstate) — первый абзац и «Было → стало».
- Документация: [Form](https://developer.apple.com/documentation/swiftui/form), [Stepper](https://developer.apple.com/documentation/swiftui/stepper).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:31`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L31) — форма целиком: секции, `Stepper` с `LabeledContent` ([`:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L38)), кнопки в тулбаре ([`:64`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L64)).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:23`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L23) — проверка `isValid` вычисляемым свойством.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: `Form` с двумя `Section`, `Stepper`, `Toggle`, `DatePicker` и `Picker`. Посмотри, как одни и те же контролы выглядят внутри `Form` и в обычном `VStack`.
2. Перепиши `body` в `CheckinForm`:

   ```swift
   private var isValid: Bool {
       // TODO: mood in 1...5 and sleepHours in 0...24
   }

   var body: some View {
       NavigationStack {
           Form {
               Section {
                   MoodPicker(mood: $draft.mood)
               } header: {
                   Text("wellbeing.form.mood", bundle: .module)
               }

               Section {
                   // TODO: DatePicker for draft.day, only the date, not later than today:
                   // DatePicker(selection: $draft.day, in: ...Date.now, displayedComponents: .date)
                   Stepper(value: $draft.sleepHours, in: 0...24, step: 0.5) {
                       LabeledContent {
                           Text(draft.sleepHours, format: .number.precision(.fractionLength(0...1)))
                       } label: {
                           Text("wellbeing.form.sleep", bundle: .module)
                       }
                   }
               }

               Section {
                   // TODO: TextField bound to $draft.note with axis: .vertical
                   // and .lineLimit(3...6), placeholder "wellbeing.form.note"
               }
           }
           .navigationTitle(Text("wellbeing.form.title", bundle: .module))
           .navigationBarTitleDisplayMode(.inline)
           .toolbar {
               ToolbarItem(placement: .confirmationAction) {
                   Button {
                       // TODO: the day must stay the start of the day after DatePicker:
                       // normalize draft.day, then call onSave(draft)
                   } label: {
                       Text("wellbeing.form.save", bundle: .module)
                   }
                   .disabled(!isValid)
               }
           }
       }
   }
   ```
   Свой `NavigationStack` здесь нужен только для заголовка и кнопок шита, как в `CustomDrinkForm`.
3. Попробуй вместо `Stepper` `Slider(value: $draft.sleepHours, in: 0...24, step: 0.5)`. Сравни на превью, что удобнее для часов сна, и оставь одно.
4. Добавь все новые ключи `wellbeing.form.*` в каталог.
5. В превью напиши заметку в несколько строк и посмотри, как поле растёт до шести строк и дальше прокручивается.

**Готово, когда.** Превью формы показывает три секции, сон меняется шагом 0,5, а кнопка «Сохранить» неактивна, если вручную поставить в черновике `mood = 0`.

**Если застрял.** `DatePicker` пишет в `draft.day` время, а не начало дня — поэтому нормализуй день перед `onSave`.

### Блок 18. TextField(value:format:) и @FocusState

*≈30 мин · Справочник: [B7](handbook.md#b7-формы-и-ввод-form-textfieldvalueformat-focusstate)*

**Цель.** Часы сна можно ввести с клавиатуры числом по правилам локали, а фокус переходит от поля сна к заметке и убирается кнопкой «Готово».

**Изучи (≈10 мин).**
- Карточка [B7](handbook.md#b7-формы-и-ввод-form-textfieldvalueformat-focusstate) — вторая половина: форматы и `@FocusState`.
- Документация: [TextField](https://developer.apple.com/documentation/swiftui/textfield), [FocusState](https://developer.apple.com/documentation/swiftui/focusstate).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CustomDrinkForm.swift#L45) — число без ручного парсинга строки.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:151`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L151) — то же для денег через `.currency`.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: `@State var price: Decimal?` и `TextField("Price", value: $price, format: .currency(code: "RUB"))`. Под полем выведи `Text(price?.description ?? "nil")`. Введи «12,5» и нажми Return; потом введи «abc». Заметь: значение в биндинг попадает при подтверждении или потере фокуса, а неверный ввод не меняет его.
2. В `CheckinForm` добавь поле сна рядом со `Stepper`, по образцу `CustomDrinkForm`:

   ```swift
   /// Which field has the keyboard. nil = no keyboard.
   enum Field: Hashable {
       case sleep, note
   }

   @FocusState private var focus: Field?

   // In the sleep section:
   LabeledContent {
       TextField(value: $draft.sleepHours, format: .number.precision(.fractionLength(0...1))) {
           Text(verbatim: "8")
       }
       .keyboardType(.decimalPad)
       .multilineTextAlignment(.trailing)
       .focused($focus, equals: .sleep)
   } label: {
       Text("wellbeing.form.sleepTyped", bundle: .module)
   }
   ```
3. Привяжи заметку: `.focused($focus, equals: .note)`.
4. На `decimalPad` нет клавиши Return, поэтому добавь панель над клавиатурой:

   ```swift
   .toolbar {
       ToolbarItemGroup(placement: .keyboard) {
           Spacer()
           // TODO: when focus == .sleep show "Next", which sets focus = .note
           // TODO: always show "Done", which sets focus = nil
       }
   }
   ```
5. Сделай так, чтобы при открытии формы клавиатура не выскакивала сама, а при нажатии «Сохранить» фокус сбрасывался. Подумай, где поставить `focus = nil`.
6. Запусти превью на симуляторе с русской локалью и введи «7,5», затем с английской и введи «7.5». Посмотри, что `Stepper` и поле показывают одно и то же значение.

**Готово, когда.** Ввод «7,5» в русской локали даёт 7,5 часа, «Далее» переводит курсор в заметку, «Готово» прячет клавиатуру.

**Если застрял.** Значение из поля не доходит до `Stepper` — это ожидаемо до подтверждения ввода; нажми «Далее» или «Готово».

### Блок 19. NavigationStack и sheet

*≈30 мин · Справочник: [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet)*

**Цель.** На экране есть кнопка «+», она открывает `CheckinForm` в шите, а после сохранения шит закрывается и новая отметка появляется в списке.

**Изучи (≈10 мин).**
- Карточка [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet) — особенно абзац «Важно для Buzz».
- Документация: [NavigationStack](https://developer.apple.com/documentation/swiftui/navigationstack), [sheet(item:onDismiss:content:)](https://developer.apple.com/documentation/swiftui/view/sheet(item:ondismiss:content:)).
- Код Buzz: [`iOS/App/Sources/Coordinators/TodayCoordinator.swift:53`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/TodayCoordinator.swift#L53) — в других вкладках шит показывает UIKit-координатор.
- Код Buzz: [`iOS/App/Sources/Coordinators/StatsCoordinator.swift:4`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/StatsCoordinator.swift#L4) — идея эксперимента: вкладка целиком на `NavigationStack` в одном хостинге. Вкладка «Самочувствие» станет этим экспериментом.
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:57`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L57) — кнопка «+» в тулбаре.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: `@State var selected: Item?` и `.sheet(item: $selected) { ... }` с `.presentationDetents([.medium, .large])`. Шит открывается, когда значение не `nil`, и закрывается, когда снова `nil`.
2. В `WellbeingViewModel` добавь состояние шита и сохранение:

   ```swift
   /// The check-in in the open form. nil = the form is closed.
   var formDraft: Checkin?

   /// Public: the deep link buzz://checkin/new will call it later (block 26).
   public func addTapped() {
       // TODO: formDraft = a new Checkin for today with mood 3 and 8 hours of sleep
   }

   func save(_ checkin: Checkin) async {
       // TODO: copy the check-in with updatedAt = .now
       // TODO: try await repository.save(...), on error set errorMessage
       // TODO: formDraft = nil closes the sheet, then await load()
   }
   ```
3. В `WellbeingView` оберни список в `NavigationStack` и подключи тулбар и шит:

   ```swift
   NavigationStack {
       List { /* sections from block 14 */ }
           .navigationTitle(Text("wellbeing.title", bundle: .module))
           .toolbar {
               ToolbarItem(placement: .primaryAction) {
                   // TODO: a Button with Label "wellbeing.add" and the "plus" symbol,
                   // the action calls model.addTapped()
               }
           }
           .sheet(item: $model.formDraft) { draft in
               CheckinForm(checkin: draft) { saved in
                   Task { await model.save(saved) }
               }
           }
   }
   ```
   `NavigationStack` здесь, а не в координаторе: вкладку покажет хостинг без `UINavigationController` (блок 25), иначе получится навбар в навбаре.
4. В `CheckinForm` добавь кнопку отмены через системное окружение:

   ```swift
   @Environment(\.dismiss) private var dismiss

   ToolbarItem(placement: .cancellationAction) {
       Button { dismiss() } label: { Text("wellbeing.form.cancel", bundle: .module) }
   }
   ```
5. Сломай и почини: убери из `save` строку `formDraft = nil`. Сохрани отметку в превью: данные в списке появились, а шит остался открытым. Верни строку. Запиши в журнал два способа закрыть шит: через данные (`formDraft = nil`) и через `dismiss`.
6. Добавь в тест модели проверку: после `addTapped()` черновик не `nil`, после `save` он снова `nil`, а отметок стало на одну больше.

**Готово, когда.** В превью «+» открывает форму, «Сохранить» закрывает её и добавляет строку в нужную неделю, «Отмена» закрывает без изменений.

**Если застрял.** Ошибка на `$model.formDraft` — у свойства должен быть открытый сеттер внутри модуля, `private(set)` тут не подойдёт.

### Блок 20. navigationDestination и детали

*≈30 мин · Справочник: [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet)*

**Цель.** По тапу на строку открывается `CheckinDetailView`, стек навигации описан данными, и детали не показывают устаревшие значения после редактирования.

**Изучи (≈10 мин).**
- Карточка [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet) — «Было → стало».
- Документация: [navigationDestination(for:destination:)](https://developer.apple.com/documentation/swiftui/view/navigationdestination(for:destination:)), [Navigation](https://developer.apple.com/documentation/swiftui/navigation).
- Код Buzz: [`docs/client/README.md`](https://github.com/disavle/buzz/blob/main/docs/client/README.md), раздел 3 — маршруты-значения.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Theme.swift:53`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L53) — модификатор `.card()` для экрана деталей.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: `enum Route: Hashable { case detail(Int) }`, `@State var path: [Route] = []`, `NavigationStack(path: $path)`, кнопка «открыть три экрана подряд» (`path = [.detail(1), .detail(2), .detail(3)]`) и «в корень» (`path.removeAll()`).
2. Создай `iOS/Modules/WellbeingFeature/Sources/CheckinDetailView.swift`:

   ```swift
   import DesignSystem
   import Domain
   import SwiftUI

   /// One check-in on a full screen: the day, a big mood number, sleep and the note.
   struct CheckinDetailView: View {
       let checkin: Checkin
       let onEdit: () -> Void

       var body: some View {
           ScrollView {
               VStack(alignment: .leading, spacing: 16) {
                   // TODO: the day as a title (.dateTime.weekday(.wide).day().month(.wide))
                   // TODO: mood in .buzzHero, sleep hours, the note; all inside .card()
               }
               .padding(BuzzMetrics.screenPadding)
           }
           .background(Color.buzzBackground)
           .toolbar {
               // TODO: an "Edit" button that calls onEdit()
           }
       }
   }
   ```
3. Первый вариант: маршрут это сама отметка. В `WellbeingView` оберни строку в `NavigationLink(value: checkin) { CheckinRow(checkin: checkin) }` и добавь в `NavigationStack` `.navigationDestination(for: Checkin.self) { checkin in CheckinDetailView(checkin: checkin, onEdit: { model.edit(checkin) }) }`. В модели `func edit(_ checkin: Checkin) { formDraft = checkin }`.
4. Сломай и почини: открой детали, нажми «Изменить», поменяй настроение и сохрани. Экран деталей показывает старое настроение: в стеке лежит копия значения. Это не баг SwiftUI, это следствие маршрута-значения.
5. Почини: маршрутом сделай `id`. В модели `var path: [Checkin.ID] = []` и `func checkin(id: Checkin.ID) -> Checkin?`. В View `NavigationStack(path: $model.path)`, `NavigationLink(value: checkin.id)` и `.navigationDestination(for: Checkin.ID.self) { id in ... }`, где по `id` берётся свежая отметка из модели. Если отметку удалили, покажи `ContentUnavailableView`.
6. Добавь в модель `func openLatest()`, которая кладёт в `path` id самой свежей отметки, и временную кнопку, которая её вызывает. Так из кода открывается любой экран; диплинк в блоке 26 сделает то же.

**Готово, когда.** Тап по строке открывает детали, после редактирования детали показывают новое значение, а `openLatest()` открывает экран без тапа.

**Если застрял.** Тап по строке ничего не делает — `navigationDestination` должен висеть внутри `NavigationStack`, на `List`, а не снаружи стека.

### Блок 21. Дизайн-токены и tint

*≈30 мин · Справочник: [B13](handbook.md#b13-дизайн-токены-системные-цвета-tint)*

**Цель.** У настроения есть свои цвета из `DesignSystem`, построенные на токенах Buzz, и экран правильно выглядит в тёмной теме и с любым акцентом.

**Изучи (≈10 мин).**
- Карточка [B13](handbook.md#b13-дизайн-токены-системные-цвета-tint) целиком.
- Документация: [Color](https://developer.apple.com/documentation/swiftui/color), [HIG: Color](https://developer.apple.com/design/human-interface-guidelines/color).
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Theme.swift:3`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L3) — правило: всё системное берём из системы, своих цветов мало; [`:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Theme.swift#L11) — почему «превышение» оранжевое, а не красное.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L44) — акцент применяется одним `.tint`.
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsView.swift:107`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L107) — `.tint.opacity(0.45)` как стиль.

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: добавь в Assets Color Set с вариантами Any и Dark, используй `Color("MyColor")`, поставь `.tint(.purple)` на корень и посмотри, какие контролы перекрасились сами.
2. В `iOS/Modules/DesignSystem/Sources/Theme.swift` добавь токен настроения:

   ```swift
   /// Mood colors, 1...5. Built from existing tokens, so they follow dark mode
   /// and the user's accent color by themselves.
   /// Low mood is orange (like "over the limit"), high mood is the accent.
   public enum BuzzMood {
       public static func style(for mood: Int) -> AnyShapeStyle {
           switch mood {
           case ...1: AnyShapeStyle(Color.buzzOver)
           // TODO: 2 -> buzzOver with opacity 0.6
           // TODO: 3 -> a neutral system style, for example Color.secondary
           // TODO: 4 -> .tint with opacity 0.6
           default: AnyShapeStyle(.tint)
           }
       }
   }
   ```
3. Используй токен в `CheckinRow` (фон кружка настроения), в `MoodPicker` (выбранный круг) и на экране деталей. Цифру на цветном фоне сделай белой и проверь, что она читается на всех пяти цветах.
4. Добавь превью списка с тёмной темой (`.preferredColorScheme(.dark)`) и превью с другим акцентом: `.tint(AccentChoice.pink.color)` вместо `.buzzTheme()`.
5. Проверь в журнале правило из карточки: цвет не единственный признак. Настроение и так подписано цифрой; запиши, где ещё на экране смысл передаётся только цветом.

**Готово, когда.** В превью пять разных цветов настроения, в тёмной теме и с розовым акцентом всё читается, а цвета 4 и 5 меняются вместе с акцентом.

**Если застрял.** `.tint` не хочет становиться `Color` — это `ShapeStyle`, поэтому токен возвращает `AnyShapeStyle`, а не `Color`.

### Блок 22. Анимации и хаптики

*≈30 мин · Справочник: [B9](handbook.md#b9-анимации-переходы-и-хаптики)*

**Цель.** Выбор настроения отзывается хаптиком и пружинкой, часы сна меняются «счётчиком», список анимирует удаление и фильтр, а сохранение подтверждается хаптиком.

**Изучи (≈10 мин).**
- Карточка [B9](handbook.md#b9-анимации-переходы-и-хаптики) целиком.
- Документация: [Animations](https://developer.apple.com/documentation/swiftui/animations), [sensoryFeedback(_:trigger:)](https://developer.apple.com/documentation/swiftui/view/sensoryfeedback(_:trigger:)).
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:32`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L32) — пружина по значению; [`:38`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L38) — `numericText`; [`:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L47) — хаптик только при переходе через лимит.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:80`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L80) — переход появления и `withAnimation` ([`:84`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L84)).

**Сделай руками (≈20 мин).**
1. Песочница, 5 минут: кольцо из двух `Circle`, второе с `.trim(from: 0, to: progress)` и `.rotationEffect(.degrees(-90))`; кнопка добавляет 10 % с `withAnimation`. Число в центре с `.contentTransition(.numericText(value: progress))`.
2. В `MoodPicker`:

   ```swift
   // On the circle label:
   .scaleEffect(mood == value ? 1.15 : 1)

   // On the whole HStack:
   .animation(.spring(duration: 0.3), value: mood)
   // TODO: .sensoryFeedback(.selection, trigger: mood)
   ```
3. В `CheckinForm` на тексте часов сна в `LabeledContent` добавь `.contentTransition(.numericText(value: draft.sleepHours))` и `.animation(.default, value: draft.sleepHours)`. Понажимай `Stepper`: цифры прокручиваются. Шрифт с `.monospacedDigit()` не даёт числу прыгать по ширине.
4. В `WellbeingView` на `List` добавь `.animation(.default, value: model.checkins)`. Здесь работает `Equatable` из `Hashable` у `Checkin`. Удали строку свайпом и посмотри, как секция схлопывается.
5. В `WellbeingFilterRow` замени биндинг на анимированный: `Toggle(isOn: $model.onlyLowMood.animation())`.
6. Хаптик сохранения: в модели `private(set) var savedCount = 0`, увеличивай его в конце успешного `save`. В `WellbeingView` добавь `.sensoryFeedback(.success, trigger: model.savedCount)`.
7. Хаптики в симуляторе не ощущаются. Если есть iPhone, запусти на нём (настройка подписи в `mise.local.toml`, см. комментарий в [`mise.toml:19`](https://github.com/disavle/buzz/blob/main/mise.toml#L19)); если нет, отложи проверку до блока 80.

**Готово, когда.** В превью выбранный круг пружинит, часы сна прокручиваются цифрами, удаление и фильтр анимированы.

**Если застрял.** Анимация не срабатывает — `.animation(_:value:)` реагирует только на изменение именно этого значения; проверь, что меняется то свойство, которое передано в `value`.

### Блок 23. Доступность

*≈30 мин · Справочник: [B14](handbook.md#b14-доступность-voiceover-и-dynamic-type)*

**Цель.** VoiceOver читает строку одной фразой, `MoodPicker` работает как регулируемый элемент, а на самом крупном шрифте ничего не обрезается.

**Изучи (≈10 мин).**
- Карточка [B14](handbook.md#b14-доступность-voiceover-и-dynamic-type) целиком, особенно «Что проверять».
- Документация: [Accessibility fundamentals](https://developer.apple.com/documentation/swiftui/accessibility-fundamentals), [accessibilityAdjustableAction(_:)](https://developer.apple.com/documentation/swiftui/view/accessibilityadjustableaction(_:)).
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift:49`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/CaffeineRing.swift#L49) — свой компонент читается одной фразой.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsView.swift:90`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsView.swift#L90) — подпись и признак `.isSelected` у круга.
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Components/MetricTile.swift:33`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/MetricTile.swift#L33) — склейка детей через `.combine`.

**Сделай руками (≈20 мин).**
1. Запусти приложение-песочницу или превью на симуляторе и открой Xcode → Open Developer Tool → Accessibility Inspector. Наведи прицел на строку `CheckinRow` и посмотри, на сколько элементов она распадается.
2. В `CheckinRow` склей строку в одну фразу:

   ```swift
   .accessibilityElement(children: .ignore)
   // TODO: one sentence with a key that has arguments, for example
   // Text("wellbeing.row.a11y \(dayText) \(checkin.mood) \(sleepText)", bundle: .module)
   // -> "Monday, 13 October. Mood 4 of 5. Slept 7.5 hours."
   ```
   Иконку кровати спрячь от VoiceOver: смысл уже есть в тексте.
3. Сделай `MoodPicker` одним регулируемым элементом, как системный слайдер: свайп вверх и вниз меняет значение.

   ```swift
   .accessibilityElement(children: .ignore)
   .accessibilityLabel(Text("wellbeing.form.mood", bundle: .module))
   // TODO: .accessibilityValue with "4 of 5"
   .accessibilityAdjustableAction { direction in
       switch direction {
       case .increment:
           // TODO: mood + 1, not more than 5
           break
       case .decrement:
           // TODO: mood - 1, not less than 1
           break
       @unknown default:
           break
       }
   }
   ```
4. Dynamic Type: в `CheckinRow` прочитай `@Environment(\.dynamicTypeSize) private var typeSize` и на `typeSize.isAccessibilitySize` раскладывай строку вертикально:

   ```swift
   let layout = typeSize.isAccessibilitySize
       ? AnyLayout(VStackLayout(alignment: .leading))
       : AnyLayout(HStackLayout(spacing: 12))
   // TODO: use `layout { ... }` instead of HStack
   ```
   Кружок настроения фиксированного размера на крупном шрифте обрежет цифру; замени `frame(width: 44, height: 44)` на `@ScaledMetric private var badge: CGFloat = 44`.
5. Добавь превью с `.environment(\.dynamicTypeSize, .accessibility3)` и проверь, что ничего не обрезано.
6. Включи VoiceOver в симуляторе (Settings → Accessibility → VoiceOver) или запусти Audit в Accessibility Inspector. Пройди экран: строка, переключатель фильтра, кнопка «+», форма, `MoodPicker`.

**Готово, когда.** Inspector показывает строку одним элементом с понятной фразой, `MoodPicker` меняется жестом вверх и вниз, а превью с `.accessibility3` читается целиком.

**Если застрял.** Фраза читается на английском при русской системе — проверь, что ключ `wellbeing.row.a11y` с аргументами переведён в каталоге на оба языка.

---

## Часть 3. UIKit-мост

В Buzz навигацию держит UIKit: координаторы, `UITabBarController` и `UINavigationController`, а каждый экран — это SwiftUI внутри `UIHostingController`. В этой части ты разберёшь, как два мира стыкуются, добавишь вкладку «Самочувствие» и диплинк, который открывает вечернюю форму.

### Блок 24. UIHostingController в песочнице

*≈30 мин · Справочник: [B12](handbook.md#b12-swiftui-внутри-uikit-и-наоборот)*

**Цель.** В песочнице SwiftUI-экран живёт внутри `UINavigationController`, а SwiftUI-строки рисуются в ячейках коллекции на Diffable.

**Изучи (≈10 мин).**
- Карточка [B12](handbook.md#b12-swiftui-внутри-uikit-и-наоборот) — таблица «задача → инструмент». Остальные строки таблицы (`Representable`) пригодятся на работе, здесь они по желанию.
- Документация: [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller), [UIHostingConfiguration](https://developer.apple.com/documentation/swiftui/uihostingconfiguration).
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:89`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L89) — через этот метод проходит каждый экран Buzz. Прочитай комментарий над ним (строки 85–88): каждый хостинг — отдельный корень SwiftUI, поэтому общий `.buzzTheme()` навешивается здесь, один раз.

**Сделай руками (≈20 мин).**
1. Xcode → File → New → Playground → iOS → Blank. Назови `HostingSandbox` и сохрани вне репозитория.
2. Вставь SwiftUI-экран в UIKit-навигацию:

   ```swift
   import PlaygroundSupport
   import SwiftUI
   import UIKit

   struct HelloView: View {
       var body: some View {
           Text("Hello from SwiftUI")
               // This title goes into the navigationItem of the hosting controller.
               .navigationTitle("Hosted")
               // TODO: add a .toolbar with one Button and check that it shows up in the UIKit nav bar
       }
   }

   let hosting = UIHostingController(rootView: HelloView())
   let navigation = UINavigationController(rootViewController: hosting)
   PlaygroundPage.current.liveView = navigation
   ```

   Запусти и проверь, что заголовок и кнопка из SwiftUI оказались в навбаре UIKit.
3. Теперь обратная ситуация с работы: живой Diffable-список, в котором одна ячейка нарисована на SwiftUI. Замени содержимое playground на заготовку:

   ```swift
   import PlaygroundSupport
   import SwiftUI
   import UIKit

   /// A tiny SwiftUI row: mood from 1 to 5.
   struct MoodRow: View {
       let mood: Int
       var body: some View {
           HStack {
               Text("Mood")
               Spacer()
               // TODO: show `mood` as filled and empty circles (Image(systemName: "circle.fill"))
           }
       }
   }

   final class ListController: UIViewController {
       enum Section { case main }
       private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!

       override func viewDidLoad() {
           super.viewDidLoad()
           let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
           let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
           collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           view.addSubview(collectionView)

           let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { cell, _, mood in
               // TODO: cell.contentConfiguration = UIHostingConfiguration { MoodRow(mood: mood) }
               // Try .margins(.horizontal, 20) on the configuration too.
           }
           dataSource = .init(collectionView: collectionView) { collectionView, indexPath, mood in
               collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: mood)
           }

           var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
           snapshot.appendSections([.main])
           snapshot.appendItems(Array(1...5))
           dataSource.apply(snapshot)
       }
   }

   PlaygroundPage.current.liveView = UINavigationController(rootViewController: ListController())
   ```

   Сравни объём кода с тем, сколько заняла бы та же ячейка на `UIListContentConfiguration` или своём подклассе `UICollectionViewCell`.
4. Сломай и почини. Верни шаг 2 и оберни `HelloView` внутри хостинга в `NavigationStack { ... }`. Посмотри на два навбара друг над другом. Запомни эту картинку: в следующем блоке ты выберешь, где живёт навигация вкладки, чтобы её не повторить.

**Готово, когда.** В live view видно навбар с заголовком и кнопкой из SwiftUI, а на втором шаге — список из пяти ячеек, где содержимое нарисовано SwiftUI, а данные пришли из `NSDiffableDataSourceSnapshot`.

**Если застрял.** Если live view пустой, включи его: Editor → Live View. Если playground долго «крутится», перезапусти его кнопкой Run внизу редактора.

### Блок 25. WellbeingCoordinator и вкладка

*≈30 мин · Справочник: [E2](handbook.md#e2-координаторы--uihostingcontroller-гибрид)*

**Цель.** В Buzz появилась пятая вкладка «Самочувствие», которую собирает `WellbeingCoordinator`.

**Изучи (≈10 мин).**
- Карточка [E2](handbook.md#e2-координаторы--uihostingcontroller-гибрид) целиком, она короткая.
- Код Buzz: [`iOS/App/Sources/Coordinators/StatsCoordinator.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/StatsCoordinator.swift#L7) — самый маленький координатор. Над ним, на [строке 4](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/StatsCoordinator.swift#L4), записана идея эксперимента: вкладка целиком на `NavigationStack` внутри одного хостинга. Вкладка «Самочувствие» будет именно такой.
- Код Buzz: [`iOS/App/Sources/Coordinators/AppCoordinator.swift:33`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/AppCoordinator.swift#L33) — как дочерние координаторы стартуют и попадают в таб-бар.
- Описание: [`docs/client/architecture.md`](https://github.com/disavle/buzz/blob/main/docs/client/architecture.md), раздел 6, список «Тонкости гибрида». Там объяснено, почему в хостинге внутри `UINavigationController` не должно быть `NavigationStack`.

**Сделай руками (≈20 мин).**
1. Реши, где живёт навигация. В блоках 19–20 форма и детали уже открываются средствами SwiftUI (`.sheet`, `navigationDestination`). Значит, вкладке не нужен `UINavigationController`: координатор отдаёт в таб-бар один `UIHostingController`, а внутри него `NavigationStack`. Остальные вкладки остаются на UIKit-навигации, и у тебя в одном приложении два подхода для сравнения.
2. Создай `iOS/App/Sources/Coordinators/WellbeingCoordinator.swift`:

   ```swift
   import Domain
   import SwiftUI
   import UIKit
   import WellbeingFeature

   /// The "Wellbeing" tab. Unlike the other tabs, navigation here is pure SwiftUI:
   /// one hosting controller with a NavigationStack inside (the experiment from StatsCoordinator).
   @MainActor
   final class WellbeingCoordinator: Coordinator {
       private let deps: AppDependencies
       /// Kept so the coordinator can talk to the screen later (deep link in the next block).
       private var model: WellbeingViewModel?

       /// Replaced in `start()`. The tab bar reads it after `start()`.
       private(set) var rootViewController: UIViewController = UIViewController()

       init(deps: AppDependencies) {
           self.deps = deps
       }

       func start() {
           // For now the fake repository from block 8. Block 29 replaces it with SwiftData.
           let model = WellbeingViewModel(repository: InMemoryCheckinRepository(checkins: Checkin.previewWeek))
           self.model = model

           // TODO: wrap WellbeingView in a NavigationStack (skip it if WellbeingView already has one inside)
           let controller = deps.host(/* TODO */)
           // TODO: controller.tabBarItem = UITabBarItem(title: String(localized: "tab.wellbeing"),
           //       image: UIImage(systemName: "heart.text.square"), selectedImage: ... ".fill")
           rootViewController = controller
       }
   }
   ```

   Если у `WellbeingView` или у инициализатора модели нет `public`, добавь: приложение — другой модуль, и `internal` оно не видит.
3. В `iOS/App/Sources/Coordinators/AppCoordinator.swift` добавь `private lazy var wellbeing = WellbeingCoordinator(deps: deps)` рядом с остальными и поставь его в массив `children` между `stats` и `settings`. Индекс «Статистики» (2) при этом не меняется, и диплинк `buzz://stats` продолжает работать.
4. Открой `iOS/App/Resources/Localizable.xcstrings`. После сборки там появится ключ `tab.wellbeing`. Заполни английский (`Wellbeing`) и русский (`Самочувствие`) варианты.
5. Запусти приложение. Пройди по вкладке: список, «+», форма, детали.
6. Сломай и почини. Временно положи хостинг в `UINavigationController(rootViewController: controller)` и посмотри на двойной навбар, как в прошлом блоке. Верни как было.

**Готово, когда.** В таб-баре пять вкладок, «Самочувствие» показывает список из превью-данных, форма и детали открываются, лишнего навбара нет.

**Если застрял.** Если вкладка пустая, проверь, что `tabBarItem` задан у того же контроллера, который ты кладёшь в `rootViewController`, и что `start()` вызывается до `children.map(\.rootViewController)`.

### Блок 26. Диплинк buzz://checkin/new

*≈30 мин · Справочник: [E2](handbook.md#e2-координаторы--uihostingcontroller-гибрид), [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet)*

**Цель.** Ссылка `buzz://checkin/new` открывает вкладку «Самочувствие» и сразу показывает форму, а разбор ссылки покрыт тестом.

**Изучи (≈10 мин).**
- Карточка [B8](handbook.md#b8-навигация-navigationstack-tabview-sheet) — пункт про `.sheet`: шит в SwiftUI показывается от состояния, а не от вызова `present`.
- Документация: [Defining a custom URL scheme for your app](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app).
- Код Buzz: [`iOS/App/Sources/Coordinators/Coordinator.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/Coordinator.swift#L13) — `enum DeepLink`, разбор отдельно от координатора, чтобы его можно было тестировать.
- Код Buzz: [`iOS/App/Sources/SceneDelegate.swift:38`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L38) и [`:47`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L47) — две точки входа ссылки: холодный старт и уже запущенное приложение.
- Код Buzz: [`iOS/App/Tests/DeepLinkTests.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/App/Tests/DeepLinkTests.swift#L6) — параметризованный тест разбора.

**Сделай руками (≈20 мин).**
1. Схема `buzz` уже объявлена в `iOS/Project.swift` (`CFBundleURLTypes`), трогать её не нужно. Начни с теста: в `iOS/App/Tests/DeepLinkTests.swift` добавь в `arguments` пару `("buzz://checkin/new", DeepLink.newCheckin)`, а в тест неизвестных ссылок — `"buzz://checkin"` и `"buzz://checkin/old"`. Тест пока не соберётся, это нормально.
2. В `iOS/App/Sources/Coordinators/Coordinator.swift` добавь случай и разбор. Для `buzz://checkin/new` хост — `checkin`, путь — `/new`:

   ```swift
   enum DeepLink: Equatable {
       case add
       case stats
       /// buzz://checkin/new — open the evening check-in form.
       case newCheckin

       init?(url: URL) {
           guard url.scheme == "buzz" else { return nil }
           // Match host and path together. For buzz://add the path is "".
           switch (url.host(), url.path()) {
           case ("add", _): self = .add
           case ("stats", _): self = .stats
           // TODO: case ("checkin", "/new"): ...
           default: return nil
           }
       }
   }
   ```

   Запусти тесты (⌘U на схеме Buzz или `mise run test`). Все случаи должны пройти, включая старые.
3. Форма уже открывается из модели: в блоке 19 ты сделал `formDraft` и публичный `addTapped()`, а вью показывает `.sheet(item: $model.formDraft)`. Координатору этого хватает, новый флаг не нужен. Проверь, что `addTapped()` объявлен `public`: координатор живёт в другом модуле.
4. В `WellbeingCoordinator` добавь метод `func showNewCheckin() { model?.addTapped() }`. В `AppCoordinator.handle(_:)` добавь ветку:

   ```swift
   case .newCheckin:
       // Select the tab by its controller, not by a magic index.
       tabBar.selectedViewController = wellbeing.rootViewController
       // TODO: ask the wellbeing coordinator to show the form
   ```

5. Проверь вживую. Приложение запущено в симуляторе: в терминале `xcrun simctl openurl booted "buzz://checkin/new"`. Потом закрой приложение свайпом и повтори команду: это холодный старт через `connectionOptions`.

**Готово, когда.** Тесты `DeepLinkTests` зелёные, а команда `simctl openurl` и при запущенном приложении, и при холодном старте открывает вкладку «Самочувствие» с формой.

**Если застрял.** Если при холодном старте форма не открывается, проверь порядок в `SceneDelegate`: `coordinator.start()` вызывается до `coordinator.handle(url)`, значит модель уже создана. Распечатай `url.host()` и `url.path()` в `init?(url:)`, чтобы увидеть, что реально приходит.

## Часть 4. Данные

Отметки переезжают из фейка в настоящую базу на SwiftData: модель, репозиторий на фоновом акторе, версии схемы и миграция. В конце части — маленькие настройки в `@AppStorage` и разбор того, как Buzz хранит токен в Keychain.

### Блок 27. SwiftData в песочнице

*≈30 мин · Справочник: [C2](handbook.md#c2-swiftdata)*

**Цель.** Отдельное маленькое приложение хранит заметки в SwiftData и показывает их через `@Query`.

**Изучи (≈10 мин).**
- Карточка [C2](handbook.md#c2-swiftdata) — особенно блок «Правила»: `@Model` не `Sendable`, enum в `#Predicate` ненадёжен.
- Документация: [SwiftData](https://developer.apple.com/documentation/swiftdata), [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches).
- Код Buzz: [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L6) — как выглядит модель в Buzz. Сравни с `NSManagedObject`: нет `.xcdatamodeld`, схема — это сам класс.

**Сделай руками (≈20 мин).**
1. Xcode → File → New → Project → iOS App, интерфейс SwiftUI, Storage: None (модель напишешь сам рукой, без шаблона). Назови `NotesSandbox`, сохрани вне репозитория.
2. Модель и контейнер:

   ```swift
   import SwiftData
   import SwiftUI

   @Model
   final class Note {
       var text: String
       var createdAt: Date
       init(text: String, createdAt: Date = .now) {
           self.text = text
           self.createdAt = createdAt
       }
   }

   @main
   struct NotesSandboxApp: App {
       var body: some Scene {
           WindowGroup { NotesView() }
               // TODO: .modelContainer(for: Note.self)
       }
   }
   ```

3. Экран со списком:

   ```swift
   struct NotesView: View {
       // A live query: the list updates by itself after insert or delete.
       @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]
       @Environment(\.modelContext) private var context

       var body: some View {
           NavigationStack {
               List(notes) { note in
                   Text(note.text)
               }
               .toolbar {
                   Button("Add") {
                       // TODO: context.insert(Note(text: "Note \(notes.count + 1)"))
                   }
               }
           }
       }
   }
   ```

4. Запусти, добавь пять заметок, останови приложение и запусти снова. Заметки на месте: автосохранение контекста сработало без явного `save()`.
5. Добавь удаление `.onDelete { offsets in ... context.delete(...) }` и проверь, что список обновился сам, без `reloadData` и без `NSFetchedResultsController`.

**Готово, когда.** Заметки переживают перезапуск приложения, а список сам реагирует на добавление и удаление.

**Если застрял.** Ошибка «No ModelContainer in environment» значит, что `.modelContainer(for:)` не навешен на `WindowGroup`. Тот же модификатор нужен в `#Preview`.

### Блок 28. CheckinModel и контейнер

*≈30 мин · Справочник: [C2](handbook.md#c2-swiftdata)*

**Цель.** В модуле `Persistence` есть `CheckinModel`, она входит в схему контейнера и превращается в `Checkin`, а тест это проверяет.

**Изучи (≈10 мин).**
- Код Buzz: [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L9) — `@Attribute(.unique)` на `id`, и [`:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L48) — `asDomain`: фичи никогда не видят `@Model`, только структуру из Domain.
- Код Buzz: [`iOS/Modules/Persistence/Sources/PersistenceContainer.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/PersistenceContainer.swift#L10) — схема со всеми моделями, и [`:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/PersistenceContainer.swift#L13) — `inMemory` для тестов.
- Код Buzz: [`iOS/Modules/Persistence/Tests/PersistenceTests.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Tests/PersistenceTests.swift#L12) — каждый тест создаёт свежую базу в памяти.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/Persistence/Sources/Models/CheckinModel.swift`. Поле `note` пока не добавляй: в блоках 31–32 оно придёт вместе с миграцией схемы.

   ```swift
   import Domain
   import Foundation
   import SwiftData

   /// SwiftData version of `Checkin`. Features never see this class, only `Checkin`.
   @Model
   public final class CheckinModel {
       /// Generated on the device, so saving the same check-in twice updates one row.
       @Attribute(.unique) public var id: UUID
       /// Start of the day. "One check-in per day" is a business rule, not a database rule.
       public var day: Date
       public var mood: Int
       public var sleepHours: Double
       public var updatedAt: Date

       public init(_ checkin: Checkin) {
           // TODO: copy every field from `checkin`
       }

       /// Copy new values into an existing row (used by "save" when the id already exists).
       public func update(from checkin: Checkin) {
           // TODO: day, mood, sleepHours, updatedAt
       }

       public var asDomain: Checkin {
           // `note` is not stored yet, so it is always empty for now.
           // TODO: Checkin(id: ..., day: ..., mood: ..., sleepHours: ..., note: "", updatedAt: ...)
       }
   }
   ```

2. В `iOS/Modules/Persistence/Sources/PersistenceContainer.swift` добавь `CheckinModel.self` в `Schema([...])`.
3. Создай `iOS/Modules/Persistence/Tests/CheckinModelTests.swift`:

   ```swift
   import Domain
   import Foundation
   import SwiftData
   import Testing

   @testable import Persistence

   @Test("CheckinModel round trip keeps every stored field")
   func checkinRoundTrip() throws {
       let container = try PersistenceContainer.make(inMemory: true)
       let context = ModelContext(container)
       let checkin = Checkin(id: UUID(), day: .now, mood: 4, sleepHours: 7.5, note: "", updatedAt: .now)

       // TODO: insert CheckinModel(checkin), save, fetch all CheckinModel rows
       // TODO: #expect that the first row's asDomain equals `checkin`
   }
   ```

   Подставь свои метки инициализатора `Checkin`, если в блоке 7 они получились другими.
4. Запусти тест. Если он падает на сравнении дат, вспомни, что `Checkin.day` — начало дня: передай в тест `Calendar.current.startOfDay(for: .now)`.

**Готово, когда.** Модуль собирается, тест `checkinRoundTrip` зелёный, приложение запускается (новая таблица добавилась к старой базе сама).

**Если застрял.** Сообщение «Cannot create the database» из `SceneDelegate` значит, что контейнер не открылся. Удали приложение с симулятора и запусти снова; настоящую миграцию разберёшь в блоке 31.

### Блок 29. Репозиторий на @ModelActor

*≈30 мин · Справочник: [C3](handbook.md#c3-modelactor-swiftdata-в-фоне)*

**Цель.** `SwiftDataCheckinRepository` читает и пишет отметки в фоне, а вкладка «Самочувствие» работает на нём вместо фейка.

**Изучи (≈10 мин).**
- Карточка [C3](handbook.md#c3-modelactor-swiftdata-в-фоне).
- Документация: [ModelActor](https://developer.apple.com/documentation/swiftdata/modelactor).
- Код Buzz: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L10) — комментарий: в Buzz этот репозиторий написан без макроса, чтобы было видно, что макрос генерирует. Ты сейчас сделаешь наоборот: с макросом. Посмотри ещё `fetch(id:)` на [строке 89](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L89).
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:41`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L41) — где создаются настоящие репозитории.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/Persistence/Sources/SwiftDataCheckinRepository.swift`:

   ```swift
   import Domain
   import Foundation
   import SwiftData

   /// `CheckinRepository` on top of SwiftData.
   /// `@ModelActor` gives the actor its own ModelContext that works off the main thread,
   /// plus `modelContainer`, `modelExecutor` and `init(modelContainer:)`.
   @ModelActor
   public actor SwiftDataCheckinRepository: CheckinRepository {
       public func all() async throws -> [Checkin] {
           let descriptor = FetchDescriptor<CheckinModel>(sortBy: [SortDescriptor(\.day, order: .reverse)])
           // Map to plain structs here, inside the actor. Models never leave it.
           return try modelContext.fetch(descriptor).map(\.asDomain)
       }

       public func save(_ checkin: Checkin) async throws {
           // TODO: if a row with this id exists, call update(from:); otherwise insert a new CheckinModel
           try modelContext.save()
       }

       public func delete(id: UUID) async throws {
           // TODO: find the row and delete it (real delete for now; soft delete comes with sync in block 73)
       }

       private func fetch(id: UUID) throws -> CheckinModel? {
           var descriptor = FetchDescriptor<CheckinModel>(predicate: #Predicate { $0.id == id })
           descriptor.fetchLimit = 1
           return try modelContext.fetch(descriptor).first
       }
   }
   ```

2. Поставь курсор на `@ModelActor` → правый клик → Expand Macro. Найди сгенерированные `modelExecutor`, `modelContainer` и `init(modelContainer:)` и сравни с тем, что в Buzz написано руками в `SwiftDataEntryRepository`.
3. В `iOS/App/Sources/AppDependencies.swift` добавь свойство `let checkins: any CheckinRepository` и создай его рядом с `entries`: `checkins = SwiftDataCheckinRepository(modelContainer: container)`.
4. В `WellbeingCoordinator.start()` замени фейк на `deps.checkins`.
5. Добавь в `CheckinModelTests.swift` тест репозитория по образцу `PersistenceTests.swift`: сохранить отметку, сохранить её же с другим `mood`, проверить, что `all()` вернул одну запись с новым настроением.
6. Запусти приложение, добавь две отметки, перезапусти. Отметки на месте.

**Готово, когда.** Тест «сохранить дважды = одна запись» зелёный, а отметки во вкладке переживают перезапуск.

**Если застрял.** Если компилятор пишет, что тип не соответствует `CheckinRepository`, проверь, что сигнатуры методов совпадают с протоколом буква в букву, включая `async throws`.

### Блок 30. Sendable и границы акторов

*≈30 мин · Справочник: [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6)*

**Цель.** Ты своими глазами видишь, почему репозиторий отдаёт `Checkin`, а не `CheckinModel`, и умеешь читать ошибки Swift 6 про `Sendable`.

**Изучи (≈10 мин).**
- Карточка [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6) — абзацы «Что и зачем» и «Было → стало».
- Документация: [Sendable](https://developer.apple.com/documentation/swift/sendable).
- Код Buzz: в `iOS/Project.swift` найди `SWIFT_VERSION` и `SWIFT_STRICT_CONCURRENCY`: весь проект собирается в режиме Swift 6 с полной проверкой.
- Код Buzz: [`iOS/Modules/Domain/Sources/Models/Entry.swift:4`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Models/Entry.swift#L4) — структура с одними значениями, поэтому `Sendable` достаётся почти даром.

**Сделай руками (≈20 мин).**
1. Сломай. Добавь в `SwiftDataCheckinRepository` временный метод:

   ```swift
   // TEMPORARY: never do this. A @Model object must not leave its actor.
   public func rawModels() throws -> [CheckinModel] {
       try modelContext.fetch(FetchDescriptor<CheckinModel>())
   }
   ```

   Вызови его из `@MainActor`-кода, например в `WellbeingCoordinator.start()`: `Task { let rows = try await (deps.checkins as! SwiftDataCheckinRepository).rawModels() }`. Прочитай ошибку целиком. Найди в ней три вещи: какой тип не `Sendable`, из какой изоляции в какую он пытается перейти, и где это происходит.
2. Подумай и запиши в журнал одной строкой, что случилось бы без этой проверки: `CheckinModel` привязана к `ModelContext` актора, а читать её стал бы главный поток.
3. Удали метод и вызов.
4. Сломай второй раз, теперь в Domain. Добавь в `Checkin` поле `var tag: NSMutableString?` и посмотри, что компилятор скажет про `Sendable`. Сравни с полем `var tags: [String]`. Удали поле.
5. Найди в Buzz место, где проверку `Sendable` осознанно отключили, и прочитай объяснение: [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L11). Запомни правило: `@unchecked` — только с комментарием, почему это безопасно.

**Готово, когда.** Ты можешь своими словами объяснить ошибку из шага 1, временный код удалён, проект собирается без предупреждений.

**Если застрял.** Если ошибка не появилась, проверь, что вызов идёт через `await` из `@MainActor`-контекста, а метод объявлен внутри актора, а не в расширении с `nonisolated`.

### Блок 31. Миграция: сначала сломать

*≈30 мин · Справочник: [C2](handbook.md#c2-swiftdata)*

**Цель.** Ты видишь, что происходит с существующей базой, когда в модель добавляют поле без версии схемы.

**Изучи (≈10 мин).**
- Карточка [C2](handbook.md#c2-swiftdata) — строка «Код в Buzz»: миграций схемы в Buzz пока нет, ты добавишь первую.
- Документация: [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches).
- Код Buzz: [`iOS/App/Sources/SceneDelegate.swift:18`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L18) — что делает приложение, если база не открылась.

**Сделай руками (≈20 мин).**
1. Убедись, что в симуляторе есть две-три отметки, сохранённые в прошлых блоках. Это «старые данные пользователя».
2. Добавь в `CheckinModel` поле без значения по умолчанию: `public var note: String`. Заполни его в `init`, `update(from:)` и `asDomain` (вместо `""`).
3. Запусти приложение поверх старой установки, не удаляя её. Скорее всего, ты увидишь `fatalError` «Cannot create the database» с ошибкой SwiftData о том, что у старых строк нет значения для обязательного поля. Прочитай ошибку целиком. Если приложение запустилось, открой старые отметки и посмотри, что лежит в заметке.
4. Теперь дай полю значение по умолчанию: `public var note: String = ""`. Запусти снова. SwiftData сама сделала лёгкую миграцию: добавила колонку и заполнила старые строки.
5. Подумай, чем опасен шаг 4 в реальном приложении: миграция случилась молча, в коде её не видно, и следующая, более сложная правка (переименование, перенос данных) так уже не сработает. Запиши вывод в журнал.
6. Подготовь базу для следующего блока. Верни `CheckinModel` к виду без `note` (`git checkout` этого файла или убери поле руками), удали приложение с симулятора, запусти и добавь две-три отметки. Это данные «версии 1».

**Готово, когда.** Ты видел ошибку открытия базы (или пустые заметки у старых строк), понимаешь, почему так вышло, а в симуляторе лежит свежая база без поля `note`.

**Если застрял.** Ошибка SwiftData длинная. Ищи в ней слова `mandatory`, `migration` и имя поля.

### Блок 32. VersionedSchema и план миграции

*≈30 мин · Справочник: [C2](handbook.md#c2-swiftdata)*

**Цель.** У базы Buzz есть явные версии `BuzzSchemaV1` и `BuzzSchemaV2` и план `BuzzMigrationPlan`, а отметки «версии 1» переживают обновление.

**Изучи (≈10 мин).**
- Документация: [VersionedSchema](https://developer.apple.com/documentation/swiftdata/versionedschema), [SchemaMigrationPlan](https://developer.apple.com/documentation/swiftdata/schemamigrationplan).
- Код Buzz: [`iOS/Modules/Persistence/Sources/PersistenceContainer.swift:14`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/PersistenceContainer.swift#L14) — сюда подключится план миграции.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/Persistence/Sources/Migrations.swift`. Версия 1 — это ровно то, что лежит на диске сейчас: `DrinkModel`, `EntryModel` и `CheckinModel` без `note`. Старую `CheckinModel` нужно «заморозить» копией внутри версии:

   ```swift
   import Foundation
   import SwiftData

   /// Version 1: the database before `note` (blocks 28-31).
   /// Properties are computed (`{ }`), not `static let`: Swift 6 accepts them without Sendable checks.
   public enum BuzzSchemaV1: VersionedSchema {
       public static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }
       public static var models: [any PersistentModel.Type] {
           [DrinkModel.self, EntryModel.self, BuzzSchemaV1.CheckinModel.self]
       }

       /// A frozen copy of CheckinModel as it was in V1. Never edit it again.
       @Model
       public final class CheckinModel {
           @Attribute(.unique) public var id: UUID
           public var day: Date
           public var mood: Int
           public var sleepHours: Double
           public var updatedAt: Date

           init(id: UUID, day: Date, mood: Int, sleepHours: Double, updatedAt: Date) {
               // TODO: assign the fields
           }
       }
   }

   /// Version 2: CheckinModel gets `note`. The top-level CheckinModel is always the newest one.
   public enum BuzzSchemaV2: VersionedSchema {
       public static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }
       public static var models: [any PersistentModel.Type] {
           // TODO: DrinkModel, EntryModel and the top-level CheckinModel
       }
   }

   public enum BuzzMigrationPlan: SchemaMigrationPlan {
       public static var schemas: [any VersionedSchema.Type] { [BuzzSchemaV1.self, BuzzSchemaV2.self] }
       public static var stages: [MigrationStage] { [migrateV1toV2] }

       /// `.lightweight(fromVersion:toVersion:)` would be enough here.
       /// We use `.custom` to practise: `didMigrate` runs after the new column exists.
       static var migrateV1toV2: MigrationStage {
           .custom(
               fromVersion: BuzzSchemaV1.self,
               toVersion: BuzzSchemaV2.self,
               willMigrate: nil,
               didMigrate: { context in
                   // TODO: fetch all CheckinModel rows, set an empty note where needed,
                   // print how many rows were migrated, then save the context
                   try context.save()
               }
           )
       }
   }
   ```

2. Верни в `CheckinModel` поле `public var note: String = ""` и заполни его в `init`, `update(from:)` и `asDomain`.
3. В `PersistenceContainer` замени схему и создание контейнера:

   ```swift
   public static let schema = Schema(versionedSchema: BuzzSchemaV2.self)

   public static func make(inMemory: Bool = false) throws -> ModelContainer {
       let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
       // TODO: pass `migrationPlan: BuzzMigrationPlan.self` to the ModelContainer init
   }
   ```

4. Запусти поверх базы «версии 1» из прошлого блока, не удаляя приложение. В консоли — строка из `didMigrate`, отметки на месте, у них пустая заметка. Добавь отметку с заметкой и перезапусти.
5. Сломай и почини. Добавь в замороженную `BuzzSchemaV1.CheckinModel` лишнее поле и запусти поверх текущей базы. Прочитай ошибку: SwiftData не находит версию, которая совпадает с базой на диске. Убери поле.
6. Запусти все тесты `PersistenceTests`: база в памяти тоже создаётся через план.

**Готово, когда.** Отметки, созданные до появления `note`, видны после обновления, в консоли есть строка из `didMigrate`, тесты зелёные.

**Если застрял.** Если `ModelContainer` пишет про дубликат версии или одинаковые контрольные суммы, проверь, что V1 и V2 действительно различаются: в V1 должна быть вложенная `CheckinModel` без `note`, в V2 — верхнеуровневая с `note`.

### Блок 33. #Predicate и макросы изнутри

*≈30 мин · Справочник: [A7](handbook.md#a7-макросы)*

**Цель.** Репозиторий умеет выбирать отметки за период через `#Predicate`, экран показывает среднее настроение за 7 дней, а ты видел, во что раскрываются `@Model` и `#Predicate`.

**Изучи (≈10 мин).**
- Карточка [A7](handbook.md#a7-макросы).
- Документация: [Swift Book: Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/), [Predicate](https://developer.apple.com/documentation/foundation/predicate).
- Код Buzz: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:40`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L40) — выборка за период; комментарий над ней объясняет, почему значения захватываются локальными константами.
- Код Buzz: [`iOS/Modules/Persistence/Sources/SwiftDataDrinkRepository.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataDrinkRepository.swift#L28) — какие функции строк работают внутри предиката.

**Сделай руками (≈20 мин).**
1. Добавь в протокол `CheckinRepository` (`iOS/Modules/Domain/Sources/Repositories.swift`) требование и реализацию по умолчанию:

   ```swift
   public protocol CheckinRepository: Sendable {
       // ... all(), save(_:), delete(id:)
       /// Check-ins with `day` in `[from, to)`, newest first.
       func checkins(from: Date, to: Date) async throws -> [Checkin]
   }

   public extension CheckinRepository {
       /// Default for fakes: filter `all()` in memory. The SwiftData repository overrides it.
       /// The method must ALSO be declared in the protocol above. Without that, a call through
       /// `any CheckinRepository` would always use this version, never the override.
       func checkins(from: Date, to: Date) async throws -> [Checkin] {
           // TODO: try await all().filter { ... }
       }
   }
   ```

2. В `SwiftDataCheckinRepository` напиши свою версию:

   ```swift
   public func checkins(from: Date, to: Date) async throws -> [Checkin] {
       let descriptor = FetchDescriptor<CheckinModel>(
           // TODO: predicate: #Predicate { $0.day >= from && $0.day < to }
           sortBy: [SortDescriptor(\.day, order: .reverse)]
       )
       return try modelContext.fetch(descriptor).map(\.asDomain)
   }
   ```

3. Сломай. Посчитай начало периода прямо внутри предиката: `#Predicate { $0.day >= Calendar.current.startOfDay(for: .now) }`. Прочитай ошибку: в предикате работает только то, что можно перевести в запрос к базе. Вынеси вычисление в локальную константу перед предикатом.
4. В `WellbeingViewModel` добавь `private(set) var weekAverageMood: Double?` и заполни его в `load()` через `checkins(from:to:)` за последние 7 дней. Покажи значение в заголовке списка (формат `.number.precision(.fractionLength(1))`).
5. Раскрой макросы: Expand Macro на `@Model` у `CheckinModel` (найди `_$backingData` и `@_PersistedProperty`), на `#Predicate` (найди `PredicateExpressions`) и на `@Observable` у `WellbeingViewModel` (найди `_$observationRegistrar`, `access` и `withMutation`).

**Готово, когда.** В заголовке списка видно среднее настроение за неделю, ошибка из шага 3 прочитана и исправлена, ты можешь показать, во что раскрылся каждый из трёх макросов.

**Если застрял.** Если Expand Macro неактивен, сначала собери проект (⌘B): Xcode раскрывает макрос только после сборки.

### Блок 34. @AppStorage

*≈30 мин · Справочник: [C6](handbook.md#c6-appstorage-и-keychain)*

**Цель.** У вкладки есть экран настроек: показывать ли кофеин (`wellbeing.showCaffeine`) и время напоминания (`wellbeing.reminderOn`, `wellbeing.reminderTime`), всё хранится в `@AppStorage`.

**Изучи (≈10 мин).**
- Карточка [C6](handbook.md#c6-appstorage-и-keychain) — первая половина, про `@AppStorage`.
- Документация: [AppStorage](https://developer.apple.com/documentation/swiftui/appstorage).
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/AccentChoice.swift:39`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L39) — `@AppStorage` с enum, и [`:30`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/AccentChoice.swift#L30) — как тот же ключ читает UIKit-код без `@AppStorage`.
- Код Buzz: [`iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/UserDefaultsSettingsRepository.swift#L9) — ключ вынесен в константу, чтобы его не опечатать.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Sources/WellbeingSettingsView.swift`:

   ```swift
   import SwiftUI

   /// Keys for small settings of the Wellbeing tab. One place, so nobody mistypes them.
   enum WellbeingKeys {
       static let showCaffeine = "wellbeing.showCaffeine"
       static let reminderOn = "wellbeing.reminderOn"
       /// Seconds from midnight, so 20:00 is 72_000.
       static let reminderTime = "wellbeing.reminderTime"
   }

   struct WellbeingSettingsView: View {
       @AppStorage(WellbeingKeys.showCaffeine) private var showCaffeine = true
       @AppStorage(WellbeingKeys.reminderOn) private var reminderOn = false
       @AppStorage(WellbeingKeys.reminderTime) private var reminderTime: Double = 20 * 3600

       /// DatePicker works with Date, storage keeps seconds. This binding converts both ways.
       private var reminderDate: Binding<Date> {
           Binding(
               get: { Calendar.current.startOfDay(for: .now).addingTimeInterval(reminderTime) },
               set: { newValue in
                   // TODO: reminderTime = seconds between the start of that day and newValue
               }
           )
       }

       var body: some View {
           Form {
               // TODO: Toggle for showCaffeine
               // TODO: Toggle for reminderOn
               // TODO: DatePicker(selection: reminderDate, displayedComponents: .hourAndMinute), only when reminderOn
           }
           .navigationTitle(Text("wellbeing.settings.title", bundle: .module))
       }
   }
   ```

2. Открой экран из `WellbeingView` кнопкой с шестерёнкой в тулбаре, через `.sheet` (как форму в блоке 19) или через `navigationDestination`.
3. В строке или на графике, где показывается кофеин, прочитай тот же ключ: `@AppStorage(WellbeingKeys.showCaffeine) private var showCaffeine = true`, и спрячь кофеин, если он выключен. Проверь, что второй экран обновился сразу, без перезапуска.
4. Перезапусти приложение: значения на месте.
5. Сломай. Во втором месте объяви `@AppStorage(WellbeingKeys.showCaffeine) private var showCaffeine = false`, то есть с другим значением по умолчанию. Удали приложение и посмотри, как два экрана при первом запуске показывают разное. Отсюда правило: значение по умолчанию держи рядом с ключом в одном месте. Верни `true`.

**Готово, когда.** Переключатель кофеина сразу меняет другой экран, время напоминания сохраняется после перезапуска, все ключи начинаются с `wellbeing.`.

**Если застрял.** Если `DatePicker` прыгает на другое время, проверь знак в `set`: нужно `newValue.timeIntervalSince(Calendar.current.startOfDay(for: newValue))`.

### Блок 35. Keychain: как Buzz хранит токен

*≈30 мин · Справочник: [C6](handbook.md#c6-appstorage-и-keychain)*

**Цель.** Ты понимаешь, как устроен `KeychainTokenStore`, и написал в песочнице свою маленькую обёртку над Keychain.

**Изучи (≈10 мин).**
- Карточка [C6](handbook.md#c6-appstorage-и-keychain) — вторая половина, про Keychain.
- Документация: [Keychain services](https://developer.apple.com/documentation/security/keychain-services).
- Код Buzz: [`iOS/Modules/Networking/Sources/TokenStore.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L17) — актор вокруг C-API. Пройди по нему сверху вниз: базовый запрос ([`:37`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L37)), чтение ([`:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L45)), запись с удалением перед ней ([`:56`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L56)), доступность после первой разблокировки ([`:60`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/TokenStore.swift#L60)).
- Код Buzz: [`iOS/Modules/Networking/Sources/RemoteAuthService.swift:21`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/RemoteAuthService.swift#L21) — когда токен сохраняется.

**Сделай руками (≈20 мин).**
1. Ответь себе письменно, в журнал: почему токен не в `UserDefaults`? Подсказка: где лежит plist с `UserDefaults` и кто может его прочитать с бэкапа.
2. Песочница прямо в тестах Buzz. Создай `iOS/Modules/WellbeingFeature/Tests/Sandbox/KeychainSandboxTests.swift` (папку `Sandbox` не коммить или удали в конце):

   ```swift
   import Foundation
   import Security
   import Testing

   /// Minimal Keychain wrapper for one string. Same idea as KeychainTokenStore in Buzz.
   struct KeychainBox {
       let service = "sandbox.keychain"

       func save(_ value: String, account: String) -> OSStatus {
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrService as String: service,
               kSecAttrAccount as String: account,
               kSecValueData as String: Data(value.utf8),
           ]
           return SecItemAdd(query as CFDictionary, nil)
       }

       func read(account: String) -> String? {
           // TODO: base query + kSecReturnData: true + kSecMatchLimit: kSecMatchLimitOne,
           // then SecItemCopyMatching and String(bytes:encoding:)
           nil
       }

       func delete(account: String) {
           // TODO: SecItemDelete with the base query
       }
   }

   @Test func keychainRoundTrip() {
       let box = KeychainBox()
       box.delete(account: "token")
       #expect(box.save("abc", account: "token") == errSecSuccess)
       #expect(box.read(account: "token") == "abc")
   }
   ```

   Тестовый таргет модуля запускается внутри симулятора, поэтому Keychain там доступен.
3. Сломай. Вызови `save` два раза подряд без `delete` и распечатай код второго вызова. Это `errSecDuplicateItem` (-25299). Теперь понятно, зачем Buzz удаляет запись перед записью (строка 57 в `TokenStore.swift`). Почини по образцу Buzz.
4. Дополнительно, если остаётся время: войди в аккаунт в Buzz, перезапусти приложение и убедись, что вход сохранился. Выйди и проверь, что `clear()` всё убрал.

**Готово, когда.** Тест `keychainRoundTrip` зелёный, ты видел `-25299` и знаешь, откуда он берётся.

**Если застрял.** Коды ошибок Keychain удобно расшифровывать функцией `SecCopyErrorMessageString(status, nil)`.

## Часть 5. Конкурентность и реактивность

Swift Concurrency по шагам: задачи и отмена, параллельная загрузка, акторы, потоки значений, мост к старым колбэкам и типизированные ошибки. Потом тот же поиск по заметкам дважды, на Combine и на `.task(id:)`, чтобы сравнить два подхода на одном экране.

### Блок 36. async/await и Task в песочнице

*≈30 мин · Справочник: [A1](handbook.md#a1-asyncawait-и-task)*

**Цель.** Ты своими руками запускаешь, отменяешь и останавливаешь задачи и знаешь, где отмена теряется.

**Изучи (≈10 мин).**
- Карточка [A1](handbook.md#a1-asyncawait-и-task).
- Документация: [Swift Book: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), [Task](https://developer.apple.com/documentation/swift/task).
- Код Buzz: [`iOS/Modules/Networking/Sources/APIClient.swift:37`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L37) — сетевой запрос сверху вниз, без колбэков и без `DispatchQueue.main.async`.

**Сделай руками (≈20 мин).**
1. Песочницы для конкурентности удобнее писать прямо в тестах модуля: там включён Swift 6 со всеми проверками, и `async` работает без обёрток. Создай `iOS/Modules/WellbeingFeature/Tests/Sandbox/AsyncSandboxTests.swift` (папку `Sandbox` не коммить):

   ```swift
   import Foundation
   import Testing

   func slowNumber() async throws -> Int {
       try await Task.sleep(for: .seconds(1))
       return 42
   }

   @Test func cancelDuringSleep() async {
       let task = Task {
           do {
               return try await slowNumber()
           } catch {
               print("caught: \(error)")  // expect CancellationError
               return -1
           }
       }
       // TODO: wait 0.3 s, cancel the task, print `await task.value`
   }
   ```

   Запусти один тест ромбиком слева от `@Test` и посмотри в консоль.
2. Отмена кооперативная: задача сама решает, где остановиться. Допиши второй тест:

   ```swift
   /// Counts to 10 with a pause between steps.
   func countSlowly() async -> Int {
       var count = 0
       for _ in 0..<10 {
           // TODO: stop early if the task was cancelled (Task.isCancelled)
           try? await Task.sleep(for: .milliseconds(100))
           count += 1
       }
       return count
   }
   ```

   Запусти `countSlowly()` в `Task`, отмени через 250 мс и распечатай результат.
3. Сломай. Убери проверку `Task.isCancelled` и запусти ещё раз. Цикл досчитал до 10 почти мгновенно: `try?` проглотил `CancellationError`, и каждый `sleep` после отмены возвращается сразу. Запомни: `try?` вокруг `Task.sleep` прячет отмену. Почини через `try Task.checkCancellation()` или верни проверку.
4. Найди в `WellbeingView` место, где синхронная кнопка вызывает `async`-метод модели через `Task { ... }`. Это и есть мост из синхронного мира в асинхронный.

**Готово, когда.** Первый тест печатает `CancellationError` и `-1`, второй после отмены возвращает число меньше 10, и ты можешь объяснить, почему без проверки получалось 10.

**Если застрял.** Если вывода нет, открой консоль: View → Debug Area → Activate Console, вкладка с выводом тестов.

### Блок 37. .task и отмена на экране

*≈30 мин · Справочник: [A1](handbook.md#a1-asyncawait-и-task), [B5](handbook.md#b5-жизненный-цикл-task-taskid-debounce-без-combine)*

**Цель.** Загрузка списка запускается из `.task`, отменяется при уходе с экрана, и отмена не показывается пользователю как ошибка.

**Изучи (≈10 мин).**
- Карточка [B5](handbook.md#b5-жизненный-цикл-task-taskid-debounce-без-combine) — первый абзац, про `.task`.
- Документация: [task(priority:_:)](https://developer.apple.com/documentation/swiftui/view/task(priority:_:)).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:69`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L69) — `.task` вместо `viewDidLoad`, и комментарий, когда он отменяется.

**Сделай руками (≈20 мин).**
1. Дай фейку задержку, чтобы отмену было видно. В `InMemoryCheckinRepository` добавь параметр `delay: Duration = .zero` в `init` и в начале `all()` вызови `try await Task.sleep(for: delay)`. Все старые вызовы фейка продолжат работать без изменений.
2. В `WellbeingViewModel.load()` отдели отмену от настоящей ошибки:

   ```swift
   func load() async {
       do {
           checkins = try await repository.all()
       } catch is CancellationError {
           // The screen went away during loading. This is normal, not an error for the user.
           print("load cancelled")
       } catch {
           // TODO: keep your error handling from block 12
       }
   }
   ```

3. Проверь, что во `WellbeingView` загрузка запускается через `.task { await model.load() }`, а не через `.onAppear`.
4. Превью для проверки ухода с экрана:

   ```swift
   #Preview("Leave during load") {
       @Previewable @State var isShown = true
       VStack {
           Button("Toggle screen") { isShown.toggle() }
           if isShown {
               NavigationStack {
                   WellbeingView(model: WellbeingViewModel(
                       repository: InMemoryCheckinRepository(checkins: Checkin.previewWeek, delay: .seconds(3))
                   ))
               }
           }
       }
   }
   ```

   Нажми кнопку в первые три секунды. В консоли превью появится `load cancelled`.
5. Сломай. Замени `.task { ... }` на `.onAppear { Task { await model.load() } }` и повтори. Сообщения об отмене нет: такая задача живёт дольше экрана. Верни `.task`.

**Готово, когда.** При уходе с экрана во время загрузки в консоли `load cancelled`, ошибка пользователю не показывается, а с `.onAppear` + `Task` ты видел, что отмены нет.

**Если застрял.** Логи превью видны в консоли Xcode, если превью запущено в режиме Debug (правый клик по кнопке запуска превью). Можно проверить и в симуляторе: временно передай фейк с задержкой в `WellbeingCoordinator` и переключи вкладку во время загрузки.

### Блок 38. async let

*≈30 мин · Справочник: [A2](handbook.md#a2-structured-concurrency-async-let-и-группы-задач)*

**Цель.** Наверху списка есть карточка дня: сегодняшняя отметка и кофеин за сегодня, загруженные параллельно через `async let`.

**Изучи (≈10 мин).**
- Карточка [A2](handbook.md#a2-structured-concurrency-async-let-и-группы-задач).
- Документация: [Swift Book: Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/), раздел «Calling Asynchronous Functions in Parallel».
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsViewModel.swift:30`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsViewModel.swift#L30) — здесь две загрузки идут последовательно. Подумай, какие из них можно запустить параллельно.

**Сделай руками (≈20 мин).**
1. Песочница. В `Tests/Sandbox/AsyncSandboxTests.swift` добавь две функции с задержками 1 и 2 секунды. Замерь последовательный вызов и вызов через `async let`:

   ```swift
   @Test func parallelIsFaster() async throws {
       let clock = ContinuousClock()
       let sequential = try await clock.measure {
           _ = try await slowA()
           _ = try await slowB()
       }
       let parallel = try await clock.measure {
           // TODO: async let a = slowA(); async let b = slowB(); _ = try await (a, b)
       }
       print(sequential, parallel)
   }
   ```

2. Фиче нужен кофеин, а он в `EntryRepository` из Domain. Добавь в `WellbeingViewModel` зависимость `entries: any EntryRepository` в `init`. В `WellbeingCoordinator` передай `deps.entries`, в превью — `InMemoryEntryRepository(entries: PreviewData.todayEntries)`.
3. Загрузка карточки дня:

   ```swift
   struct DaySummary: Equatable {
       let checkin: Checkin?
       let caffeineMg: Double
   }

   private(set) var today: DaySummary?

   func loadToday(now: Date = .now) async {
       let calendar = Calendar.current
       let start = calendar.startOfDay(for: now)
       let end = calendar.date(byAdding: .day, value: 1, to: start) ?? now
       // Copy dependencies into local constants: child tasks of `async let`
       // run off the main actor and should not touch `self`.
       let checkins = repository
       let entries = self.entries
       do {
           // TODO: async let todayCheckins = checkins.checkins(from: start, to: end)
           // TODO: async let todayEntries = entries.entries(from: start, to: end)
           // TODO: await both, build DaySummary (caffeine = sum of caffeineMg)
       } catch {
           today = nil
       }
   }
   ```

4. Покажи карточку первой секцией списка: настроение сегодня или «ещё не отмечено», кофеин через `BuzzFormat.caffeine(_:)` из DesignSystem. Вызови `loadToday()` в том же `.task`, что и `load()`.
5. Сломай. Объяви `async let`, но не жди его (`_ = ...` не пиши, `await` убери). Посмотри на предупреждение и подумай, что станет с дочерней задачей, когда функция закончится: она будет отменена и дождана, но результат потеряется.

**Готово, когда.** Песочница печатает примерно 3 и 2 секунды, наверху вкладки видна карточка дня с кофеином из «Сегодня».

**Если застрял.** Если компилятор ругается на захват `self` в `async let`, проверь, что внутри `async let` используются только локальные `checkins`, `entries`, `start` и `end`.

### Блок 39. Группа задач

*≈30 мин · Справочник: [A2](handbook.md#a2-structured-concurrency-async-let-и-группы-задач)*

**Цель.** В заголовке каждой недели видно среднее настроение и кофеин за неделю, посчитанные через `withTaskGroup`.

**Изучи (≈10 мин).**
- Карточка [A2](handbook.md#a2-structured-concurrency-async-let-и-группы-задач) — пример с `withThrowingTaskGroup`.
- Документация: [TaskGroup](https://developer.apple.com/documentation/swift/taskgroup).

**Сделай руками (≈20 мин).**
1. `async let` подходит, когда задач заранее известное число. Недель столько, сколько данных, поэтому нужна группа. Добавь в `WellbeingViewModel`:

   ```swift
   struct WeekStat: Identifiable, Equatable, Sendable {
       let weekStart: Date
       let averageMood: Double
       let caffeineMg: Double
       var id: Date { weekStart }
   }

   private(set) var weekStats: [Date: WeekStat] = [:]

   func loadWeekStats() async {
       let calendar = Calendar.current
       // Group check-ins by the first day of their week.
       let weeks = Dictionary(grouping: checkins) { checkin in
           calendar.dateInterval(of: .weekOfYear, for: checkin.day)?.start ?? checkin.day
       }
       let entries = self.entries
       let stats = await withTaskGroup(of: WeekStat?.self) { group in
           for (start, items) in weeks {
               group.addTask {
                   // TODO: end = start + 7 days; load entries(from: start, to: end) with try?
                   // TODO: average mood of `items`, sum of caffeineMg; return WeekStat
                   nil
               }
           }
           var result: [WeekStat] = []
           // TODO: for await stat in group { ... }
           return result
       }
       weekStats = Dictionary(uniqueKeysWithValues: stats.map { ($0.weekStart, $0) })
   }
   ```

2. Распечатай `weekStart` в том порядке, в каком результаты приходят из группы. Порядок не совпадает с порядком запуска: группа отдаёт результаты по мере готовности. Поэтому результат сложен в словарь по ключу недели.
3. Покажи статистику в заголовке секции недели из блока 14: «настроение 3,8 · кофеин 1 840 мг». Вызывай `loadWeekStats()` после `load()`.
4. Подумай честно о пользе. `EntryRepository` — актор, его методы всё равно выполняются по очереди. Здесь группа почти не ускоряет работу, зато показывает форму кода. Настоящий выигрыш будет там, где задачи ждут сеть. Запиши это в журнал.
5. Сломай. Перепиши на `withThrowingTaskGroup` и брось ошибку из одной недели. Посмотри, что остальные задачи отменились, а наружу вылетела первая ошибка.

**Готово, когда.** В заголовках недель видна статистика, ты видел разный порядок результатов и поведение группы при ошибке.

**Если застрял.** Если `addTask` ругается на захват, проверь, что в замыкании нет `self`: только `start`, `items`, `entries` и `calendar`.

### Блок 40. actor и @MainActor

*≈30 мин · Справочник: [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6)*

**Цель.** Ты знаешь, на каком акторе выполняется каждый кусок кода вкладки, и видел, что ломается, если убрать `@MainActor` у модели.

**Изучи (≈10 мин).**
- Карточка [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6) целиком, включая абзац про Swift 6.2.
- Документация: [Swift Book: Actors](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors), [Swift 6 migration guide](https://www.swift.org/migration/documentation/migrationguide/).
- Код Buzz: [`iOS/Modules/Sync/Sources/SyncEngine.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L12) — почему движок синхронизации актор, и [`:33`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L33) — про реентрантность: пока актор ждёт сеть, в него может войти другой вызов.

**Сделай руками (≈20 мин).**
1. Песочница в `Tests/Sandbox/ActorSandboxTests.swift`:

   ```swift
   import Testing

   final class Counter {
       var value = 0
       func increment() { value += 1 }
   }

   @Test func thousandIncrements() async {
       let counter = Counter()
       await withTaskGroup(of: Void.self) { group in
           for _ in 0..<1000 {
               group.addTask { counter.increment() }
           }
       }
       print(counter.value)
   }
   ```

   Прочитай ошибку компилятора: класс с изменяемым состоянием нельзя отдать в параллельные задачи.
2. Замени `final class` на `actor`, а вызов на `await counter.increment()`. Чтение тоже через `await counter.value`. Запусти: ровно 1000.
3. Посмотри на свою модель. Поставь точку останова в `WellbeingViewModel.load()` до и после `await repository.all()`. В Debug navigator оба раза будет главный поток (Thread 1), хотя репозиторий работает в фоне: модель на `@MainActor`, и после `await` код возвращается на него сам.
4. Сломай. Убери `@MainActor` у `WellbeingViewModel` и собери. Прочитай ошибки: где SwiftUI требует главный актор и где модель передаёт себя между изоляциями. Верни `@MainActor`.
5. Найди в модели чистую функцию без состояния (например, вычисление начала недели) и сделай её `nonisolated static`. Её можно вызывать откуда угодно без `await`.

**Готово, когда.** Песочница с актором печатает 1000, ты видел главный поток до и после `await` и ошибки без `@MainActor`.

**Если застрял.** Если ошибка в шаге 1 не появилась, проверь, что файл лежит в тестовом таргете Buzz: в отдельном playground проверки Swift 6 могут быть выключены.

### Блок 41. AsyncStream в песочнице

*≈30 мин · Справочник: [A4](handbook.md#a4-asyncstream-и-asyncsequence)*

**Цель.** Ты умеешь создать поток значений, читать его через `for await`, завершать и отменять, и знаешь, почему у `AsyncStream` только один читатель.

**Изучи (≈10 мин).**
- Карточка [A4](handbook.md#a4-asyncstream-и-asyncsequence).
- Документация: [AsyncStream](https://developer.apple.com/documentation/swift/asyncstream).
- Код Buzz: [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:28`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L28) — поток, который сам запускает задачу и отменяет её в `onTermination` ([строка 39](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L39)).

**Сделай руками (≈20 мин).**
1. В `Tests/Sandbox/StreamSandboxTests.swift`:

   ```swift
   import Testing

   @Test func streamBasics() async {
       let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
       continuation.onTermination = { reason in print("terminated: \(reason)") }

       let reader = Task {
           for await value in stream { print("got \(value)") }
           print("loop finished")
       }
       continuation.yield(1)
       continuation.yield(2)
       // TODO: finish the stream, then await reader.value
   }
   ```

   Убедись, что цикл закончился после `finish()`, а `onTermination` сообщил `finished`.
2. Скопируй тест и вместо `finish()` отмени читающую задачу `reader.cancel()`. Цикл тоже выходит, а `onTermination` сообщает `cancelled`.
3. Поток из «старого» источника, по образцу `NetworkMonitor`:

   ```swift
   /// Emits 1...count with a pause. Stops its producer when the reader goes away.
   func ticks(count: Int) -> AsyncStream<Int> {
       AsyncStream { continuation in
           let producer = Task {
               for i in 1...count {
                   try? await Task.sleep(for: .milliseconds(100))
                   continuation.yield(i)
               }
               continuation.finish()
           }
           // TODO: continuation.onTermination = { _ in ... cancel the producer ... }
       }
   }
   ```

4. Сломай. Запусти два цикла `for await` по одному и тому же `ticks(count: 10)`. Каждое значение получит только один из них. Вот почему в Buzz есть `Broadcaster`: следующий блок.

**Готово, когда.** Все три теста печатают ожидаемое, а на шаге 4 ты видел, что значения делятся между двумя читателями.

### Блок 42. Живые обновления через Broadcaster

*≈30 мин · Справочник: [A4](handbook.md#a4-asyncstream-и-asyncsequence)*

**Цель.** После сохранения или удаления отметки репозиторий шлёт сигналы `changes` и `localEdits`, а модель слушает `changes` и перезагружает экран сама.

**Изучи (≈10 мин).**
- Код Buzz: [`iOS/Modules/Domain/Sources/Broadcaster.swift:12`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L12) — комментарий над классом объясняет, зачем он нужен.
- Код Buzz: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L19) — почему сигналов два и почему их нельзя слить в один; [`:51`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L51) — где они отправляются.
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:26`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L26) — оба вещателя создаются один раз на приложение.
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsViewModel.swift:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsViewModel.swift#L45) — модель слушает изменения, и [`StatsView.swift:42`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L42) — где это запускается.

**Сделай руками (≈20 мин).**
1. Добавь в `CheckinRepository` требование `func changes() -> AsyncStream<Void>` и реализацию по умолчанию в расширении, которая сразу завершает поток (`AsyncStream { $0.finish() }`): так простые тестовые шпионы не обязаны её писать. В `InMemoryCheckinRepository` сделай настоящую, как в `InMemoryEntryRepository` (там `nonisolated let broadcaster = Broadcaster<Void>()` и `yield()` в `add`/`delete`).
2. Репозиторию теперь нужны параметры в `init`, а макрос `@ModelActor` генерирует только `init(modelContainer:)` и свои свойства не даёт инициализировать. Поэтому перепиши `SwiftDataCheckinRepository` без макроса, ровно как `SwiftDataEntryRepository` (строки 13–35):

   ```swift
   public actor SwiftDataCheckinRepository: CheckinRepository, ModelActor {
       public nonisolated let modelContainer: ModelContainer
       public nonisolated let modelExecutor: any ModelExecutor
       private nonisolated let broadcaster: Broadcaster<Void>
       private nonisolated let localEdits: Broadcaster<Void>

       public init(
           modelContainer: ModelContainer,
           broadcaster: Broadcaster<Void> = .init(),
           localEdits: Broadcaster<Void> = .init()
       ) {
           // TODO: same four assignments as in SwiftDataEntryRepository
       }

       // ... all(), checkins(from:to:), save(_:), delete(id:) stay the same.
       // TODO: after a successful save and delete: broadcaster.yield() and localEdits.yield()

       public nonisolated func changes() -> AsyncStream<Void> {
           broadcaster.stream()
       }
   }
   ```

3. В `AppDependencies` передай те же `changes` и `localEdits`, что получает `SwiftDataEntryRepository`.
4. В модели:

   ```swift
   /// Reload every time check-ins change anywhere in the app.
   func observeChanges() async {
       // TODO: for await _ in repository.changes() { await load() }
   }
   ```

   Во вью добавь второй `.task { await model.observeChanges() }`. Цикл живёт, пока экран на экране, и отменяется вместе с ним.
5. Если после сохранения в форме ты вручную вызывал `load()`, убери этот вызов. Сохрани отметку: список обновился сам.
6. Проверь сигнал между экранами: добавь банку на вкладке «Сегодня» и вернись в «Самочувствие». Кофеин в карточке дня обновится, только если модель слушает и `deps.entries.changes()`. Реши, нужно ли это, и если да, добавь третий `.task`.

**Готово, когда.** Список обновляется после сохранения и удаления без ручного `load()`, тесты репозитория зелёные.

**Если застрял.** Если обновлений нет, проверь, что `yield()` вызывается после `modelContext.save()`, а не до него, и что модель слушает тот же репозиторий, который сохраняет.

### Блок 43. Mutex и Synchronization

*≈30 мин · Справочник: [A9](handbook.md#a9-mutex-и-synchronization-защита-данных-без-актора)*

**Цель.** Ты понимаешь, почему `Broadcaster` сделан на `Mutex`, а не на акторе, и написал потокобезопасный счётчик.

**Изучи (≈10 мин).**
- Карточка [A9](handbook.md#a9-mutex-и-synchronization-защита-данных-без-актора) — особенно список «Когда что брать».
- Документация: [Mutex](https://developer.apple.com/documentation/synchronization/mutex).
- Код Buzz: [`iOS/Modules/Domain/Sources/Broadcaster.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L13) — словарь подписчиков под замком; [`:21`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L21) — `onTermination` вызывается из любого потока синхронно, там нельзя `await`; [`:29`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Domain/Sources/Broadcaster.swift#L29) — копия под замком, рассылка уже без него.
- Код Buzz: [`iOS/Modules/Networking/Sources/MockAPIClient.swift:21`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L21) — всё состояние фейкового сервера в одном `Mutex<State>`.

**Сделай руками (≈20 мин).**
1. Ответь себе: почему `yield` в `Broadcaster` не может быть методом актора? Подсказка: `SwiftDataEntryRepository` вызывает его синхронно, и `onTermination` тоже синхронный.
2. В `Tests/Sandbox/MutexSandboxTests.swift`:

   ```swift
   import Synchronization
   import Testing

   /// Thread-safe without an actor and without `await`.
   final class SafeCounter: Sendable {
       private let value = Mutex(0)

       func increment() {
           // TODO: value.withLock { $0 += 1 }
       }

       var current: Int {
           // TODO: read inside withLock
           0
       }
   }

   @Test func safeCounter() async {
       let counter = SafeCounter()
       await withTaskGroup(of: Void.self) { group in
           for _ in 0..<1000 { group.addTask { counter.increment() } }
       }
       #expect(counter.current == 1000)
   }
   ```

3. Сломай. Напиши рядом `final class UnsafeCounter: @unchecked Sendable { var value = 0 }` и тот же тест. Запусти несколько раз: иногда меньше 1000. Включи Thread Sanitizer (Edit Scheme → Test → Diagnostics → Thread Sanitizer) и прочитай отчёт о гонке. Выключи TSan после блока: с ним тесты медленнее.
4. Попробуй вызвать `increment()` у `SafeCounter` и у актора из блока 40 в синхронной функции. У `Mutex` получится, у актора нужен `await`. Это и есть главная разница.

**Готово, когда.** `SafeCounter` всегда даёт 1000, у `UnsafeCounter` ты видел потерянные инкременты или отчёт TSan, и можешь сказать, когда брать `Mutex`, а когда `actor`.

**Если застрял.** Если `import Synchronization` не находится, проверь, что деплоймент-таргет тестового таргета iOS 18: `Mutex` есть только начиная с него.

### Блок 44. continuation в песочнице

*≈30 мин · Справочник: [A5](handbook.md#a5-мост-со-старым-кодом-continuation)*

**Цель.** Ты оборачиваешь API на колбэках в `async`-функцию и видел, как checked-continuation ловит двойной вызов и забытый `resume`.

**Изучи (≈10 мин).**
- Карточка [A5](handbook.md#a5-мост-со-старым-кодом-continuation).
- Документация: [withCheckedThrowingContinuation](https://developer.apple.com/documentation/swift/withcheckedthrowingcontinuation(isolation:function:_:)).
- Код Buzz: в Buzz `withCheckedContinuation` нет. Похожий мост «колбэк → async», но для потока значений, сделан в [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:7`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L7). Правило выбора: одно значение — continuation, много значений — `AsyncStream`.

**Сделай руками (≈20 мин).**
1. В `Tests/Sandbox/ContinuationSandboxTests.swift`:

   ```swift
   import Foundation
   import Testing

   /// "Old" API: answers once, later, through a callback.
   func oldFetch(fail: Bool, completion: @escaping @Sendable (Result<Int, Error>) -> Void) {
       DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
           completion(fail ? .failure(URLError(.notConnectedToInternet)) : .success(42))
       }
   }

   /// The same API as async/await. The callback stays inside.
   func newFetch(fail: Bool = false) async throws -> Int {
       try await withCheckedThrowingContinuation { continuation in
           // TODO: call oldFetch and resume the continuation with its result
           // (there is resume(with: Result) for exactly this case)
       }
   }

   @Test func bridge() async throws {
       #expect(try await newFetch() == 42)
       await #expect(throws: URLError.self) { try await newFetch(fail: true) }
   }
   ```

2. Сломай первый раз: вызови `resume` два раза. Тест упадёт с сообщением `SWIFT TASK CONTINUATION MISUSE ... tried to resume its continuation more than once`. Checked-версия поймала ошибку, которая с колбэками была бы тихим двойным вызовом.
3. Сломай второй раз: не вызывай `resume` вообще. Тест повиснет, а в консоли появится предупреждение `... leaked its continuation`. Останови тест.
4. Посмотри на API, которое обернёшь в следующем блоке: `UNUserNotificationCenter.requestAuthorization(options:completionHandler:)` и `add(_:withCompletionHandler:)`. У них есть и `async`-версии; в следующем блоке ты сознательно обернёшь версии с колбэком, чтобы потренироваться, и сравнишь.

**Готово, когда.** Тест `bridge` зелёный, ты видел оба сообщения `CONTINUATION MISUSE`.

### Блок 45. Напоминание через UNUserNotificationCenter

*≈30 мин · Справочник: [A5](handbook.md#a5-мост-со-старым-кодом-continuation)*

**Цель.** Включённое в настройках вкладки напоминание каждый вечер в выбранное время приходит уведомлением «Как прошёл день?».

**Изучи (≈10 мин).**
- Документация: [UNUserNotificationCenter](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter), [UNCalendarNotificationTrigger](https://developer.apple.com/documentation/usernotifications/uncalendarnotificationtrigger).
- Вспомни блок 34: ключи `wellbeing.reminderOn` и `wellbeing.reminderTime` (секунды от полуночи) уже есть в `WellbeingSettingsView`.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Sources/ReminderScheduler.swift`:

   ```swift
   import Foundation
   import UserNotifications

   /// Schedules the evening "How was your day?" reminder.
   /// The completion-handler API is wrapped in continuations on purpose (practice from block 44).
   /// UNUserNotificationCenter also has async versions of these methods.
   public struct ReminderScheduler: Sendable {
       static let requestId = "wellbeing.reminder"

       public init() {}

       /// Shows the system dialog once. Later calls return the saved answer without a dialog.
       public func requestPermission() async throws -> Bool {
           try await withCheckedThrowingContinuation { continuation in
               UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                   // TODO: resume(throwing:) if there is an error, otherwise resume(returning: granted)
               }
           }
       }

       /// Repeats every day at the given time. Same id = the old reminder is replaced.
       public func schedule(secondsFromMidnight: Double) async throws {
           let content = UNMutableNotificationContent()
           content.title = String(localized: "wellbeing.reminder.title", bundle: .module)
           content.body = String(localized: "wellbeing.reminder.body", bundle: .module)

           var time = DateComponents()
           time.hour = Int(secondsFromMidnight) / 3600
           time.minute = Int(secondsFromMidnight) % 3600 / 60
           let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
           let request = UNNotificationRequest(identifier: Self.requestId, content: content, trigger: trigger)

           // TODO: try await withCheckedThrowingContinuation { ... add(request) { error in ... } }
       }

       public func cancel() {
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.requestId])
       }
   }
   ```

2. Подключи его в `WellbeingSettingsView`:

   ```swift
   private let scheduler = ReminderScheduler()

   /// Brings the system state in line with the two stored settings.
   private func syncReminder() async {
       guard reminderOn else { scheduler.cancel(); return }
       // TODO: ask for permission; if not granted, set reminderOn = false and return
       // TODO: schedule at reminderTime (ignore or print the error)
   }
   ```

   Вызывай его из `.onChange(of: reminderOn)` и `.onChange(of: reminderTime)` через `Task { await syncReminder() }`.
3. Заполни ключи `wellbeing.reminder.title` и `wellbeing.reminder.body` в `Localizable.xcstrings` модуля (ru и en).
4. Проверь в симуляторе: включи напоминание, разреши уведомления, поставь время на следующую минуту и уйди на домашний экран (⇧⌘H). Пока приложение открыто, система уведомление не показывает: для этого нужен делегат центра, здесь он не нужен.
5. Проверь отказ: в настройках симулятора запрети уведомления для Buzz, включи напоминание ещё раз. Переключатель должен вернуться в «выключено».

**Готово, когда.** Уведомление пришло в выбранную минуту, а при запрещённых уведомлениях переключатель сам выключается.

**Если застрял.** Чтобы увидеть, что реально запланировано, распечатай `await UNUserNotificationCenter.current().pendingNotificationRequests()` после `schedule`.

### Блок 46. Typed throws

*≈30 мин · Справочник: [A6](handbook.md#a6-typed-throws)*

**Цель.** Сохранение отметки проверяет правила и бросает `CheckinError`, а модель получает в `catch` сразу `CheckinError`, без приведения типов.

**Изучи (≈10 мин).**
- Карточка [A6](handbook.md#a6-typed-throws).
- Документация: [SE-0413 Typed throws](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0413-typed-throws.md).
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:33`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L33) — use case с `throws(AddEntryError)`; [строка 62](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L62) — любая ошибка хранилища превращается в один случай `.storage`.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryViewModel.swift:113`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryViewModel.swift#L113) — `error` в `catch` уже нужного типа; [`AddEntryView.swift:199`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L199) — перевод ошибки в текст живёт в слое представления.

**Сделай руками (≈20 мин).**
1. Песочница на 5 минут в `Tests/Sandbox/AsyncSandboxTests.swift`: `enum ParseError: Error { case empty, notNumber }`, `func parse(_ s: String) throws(ParseError) -> Int`, и в `catch` напиши `switch error` с двумя случаями без `default`. Компилятор доволен: он знает тип ошибки.
2. Создай `iOS/Modules/WellbeingFeature/Sources/Domain/CheckinError.swift`. В блоке 51 эти правила переедут в `SaveCheckinUseCase`, а пока живут рядом:

   ```swift
   import Domain
   import Foundation

   /// Why a check-in cannot be saved. No text here: the view translates each case.
   public enum CheckinError: Error, Equatable {
       case alreadyExistsForDay
       case invalidSleepHours
       case storage
   }

   enum CheckinRules {
       /// Throws only CheckinError, so callers can switch over it without `default`.
       static func validate(_ checkin: Checkin, existing: [Checkin]) throws(CheckinError) {
           // TODO: sleepHours must be in 0...24, otherwise .invalidSleepHours
           // TODO: another check-in (different id) with the same day -> .alreadyExistsForDay
       }
   }
   ```

3. В `WellbeingViewModel` оберни сохранение:

   ```swift
   var error: CheckinError?

   /// Returns `true` when saved, so the form knows it can close.
   func save(_ checkin: Checkin) async -> Bool {
       do throws(CheckinError) {
           try CheckinRules.validate(checkin, existing: checkins)
           try await store(checkin)
           return true
       } catch {
           self.error = error  // already CheckinError, no `as?`
           return false
       }
   }

   private func store(_ checkin: Checkin) async throws(CheckinError) {
       // TODO: call the repository; map any error to .storage
   }
   ```

   `do throws(CheckinError)` — явная запись. В Buzz (`AddEntryViewModel`) тип выведен сам, потому что в `do` один вызов. Попробуй убрать `throws(CheckinError)` после `do` и посмотри, что скажет компилятор.
4. Покажи ошибку через `.alert(isPresented:error:)` по образцу `AddEntryView`: обёртка `LocalizedCheckinError: LocalizedError` с ключами `wellbeing.error.*`.
5. Сломай. Брось внутри `validate` другую ошибку, например `throw URLError(.badURL)`. Прочитай ошибку компилятора и верни как было.

**Готово, когда.** Вторая отметка за тот же день и сон 30 часов показывают понятный алерт, в `catch` нет ни одного `as?`.

**Если застрял.** Если `switch error` требует `default`, значит выведенный тип ошибки — `any Error`. Ищи в `do` вызов, который бросает нетипизированную ошибку.

### Блок 47. Combine в песочнице

*≈30 мин · Справочник: [A8](handbook.md#a8-combine-subject-операторы-anycancellable)*

**Цель.** Ты собрал цепочку `PassthroughSubject` → `debounce` → `removeDuplicates` → `sink` и видел, что подписка живёт, только пока хранится `AnyCancellable`.

**Изучи (≈10 мин).**
- Карточка [A8](handbook.md#a8-combine-subject-операторы-anycancellable) — «Ключевые идеи».
- Документация: [Combine](https://developer.apple.com/documentation/combine), [debounce](https://developer.apple.com/documentation/combine/publisher/debounce(for:scheduler:options:)).
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:62`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L62) — цепочка читается сверху вниз, у каждого шага свой комментарий.

**Сделай руками (≈20 мин).**
1. Здесь Swift 6 не нужен, поэтому подойдёт обычный playground: File → New → Playground → iOS → Blank, `CombineSandbox`.

   ```swift
   import Combine
   import Foundation
   import PlaygroundSupport

   PlaygroundPage.current.needsIndefiniteExecution = true

   let subject = PassthroughSubject<String, Never>()
   var subscription: AnyCancellable? = subject.sink { print("got", $0) }

   subject.send("a")
   // TODO: set subscription = nil, send "b" and check that nothing is printed
   ```

2. Добавь задержку ввода. Пересоздай подписку с `.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)` и отправь «c», «co», «col» подряд, без пауз. Напечаталось только «col».
3. Имитируй паузы:

   ```swift
   for (delay, text) in [(0.0, "mon"), (0.1, "mo"), (0.2, "mon"), (0.8, "mon")] {
       DispatchQueue.main.asyncAfter(deadline: .now() + delay) { subject.send(text) }
   }
   ```

   Посчитай, сколько раз сработал `sink`. Вставь `.removeDuplicates()` после `debounce` и посчитай снова.
4. Добавь `.map { $0.trimmingCharacters(in: .whitespaces) }` в начало и отправь «mon » с пробелом.
5. Сломай: не сохраняй результат `sink` в переменную (`_ = subject.sink { ... }`). Ничего не приходит: подписка сразу освобождена.

**Готово, когда.** Ты можешь предсказать, что напечатает цепочка при любой последовательности отправок с паузами.

### Блок 48. Поиск по заметкам на Combine

*≈30 мин · Справочник: [A8](handbook.md#a8-combine-subject-операторы-anycancellable)*

**Цель.** Поиск по заметкам во вкладке работает через Combine с задержкой ввода, и это проверяет тест «быстрый ввод — одно применение».

**Изучи (≈10 мин).**
- Код Buzz: [`iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift:27`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L27) — `didSet` вместо `@Published`; [`:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L45) — где живёт подписка; [`:79`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogViewModel.swift#L79) — зачем `MainActor.assumeIsolated`.
- Код Buzz: [`iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift:58`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Tests/CatalogViewModelTests.swift#L58) — тест задержки ввода с коротким `debounce`.

**Сделай руками (≈20 мин).**
1. Отметки уже в памяти модели, поэтому поиск — это фильтр, а не запрос в базу. В `WellbeingViewModel`:

   ```swift
   import Combine

   /// The search text. `.searchable` writes here on every key press.
   var query = "" {
       didSet { queries.send(query) }
   }
   /// The text the list is filtered by: `query` after the debounce.
   private(set) var appliedQuery = ""

   @ObservationIgnored private let queries = PassthroughSubject<String, Never>()
   @ObservationIgnored private var subscription: AnyCancellable?

   /// What the list shows.
   var visible: [Checkin] {
       guard !appliedQuery.isEmpty else { return checkins }
       return checkins.filter { $0.note.localizedStandardContains(appliedQuery) }
   }
   ```

2. В `init` добавь параметр `debounce: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300)` и в самом конце, когда все свойства уже заданы, собери цепочку:

   ```swift
   subscription = queries
       .map { $0.trimmingCharacters(in: .whitespaces) }
       // TODO: .debounce(for: debounce, scheduler: DispatchQueue.main)
       // TODO: .removeDuplicates()
       .sink { [weak self] query in
           // The debounce runs on the main queue, assumeIsolated tells Swift 6 about it.
           MainActor.assumeIsolated {
               self?.appliedQuery = query
           }
       }
   ```

3. Во вью: секции строятся из `model.visible`, а не из `model.checkins`, и к списку добавлен `.searchable(text: $model.query)`. Подробно `.searchable` разберёшь в блоке 50.
4. Тест в `iOS/Modules/WellbeingFeature/Tests/WellbeingSearchTests.swift` по образцу `CatalogViewModelTests`: модель с `debounce: .milliseconds(50)`, три быстрых присваивания `query`, пауза 500 мс, затем `#expect(model.appliedQuery == ...)` и проверка, что `visible` содержит только отметки с этим словом в заметке.
5. Закоммить этот вариант отдельным коммитом. В следующем блоке ты его заменишь, и коммит останется для сравнения.

**Готово, когда.** Поиск фильтрует список после паузы в наборе, тест зелёный, вариант на Combine лежит в отдельном коммите.

**Если застрял.** Если поиск не срабатывает совсем, проверь, что `subscription` сохраняется в свойство и что цепочка собирается в `init` после присвоения всех остальных свойств.

### Блок 49. Тот же поиск на .task(id:)

*≈30 мин · Справочник: [B5](handbook.md#b5-жизненный-цикл-task-taskid-debounce-без-combine)*

**Цель.** Поиск работает без Combine, через `.task(id:)`, и ты выбрал, какой из двух вариантов оставить.

**Изучи (≈10 мин).**
- Карточка [B5](handbook.md#b5-жизненный-цикл-task-taskid-debounce-без-combine).
- Документация: [task(id:priority:_:)](https://developer.apple.com/documentation/swiftui/view/task(id:priority:_:)).
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:35`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L35) — задержка ввода без Combine; [`iOS/Modules/DesignSystem/Sources/Components/SnackView.swift:70`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Components/SnackView.swift#L70) — тот же приём для автоскрытия.

**Сделай руками (≈20 мин).**
1. Убери из модели `queries`, `subscription`, `didSet` и параметр `debounce`. Добавь метод:

   ```swift
   /// Called by the view after the user stops typing.
   func applySearch() {
       // TODO: appliedQuery = query trimmed
   }
   ```

2. Во вью рядом с `.searchable`:

   ```swift
   // Restarts on every change of `query` and cancels the previous run.
   .task(id: model.query) {
       try? await Task.sleep(for: .milliseconds(300))
       // `try?` hides the cancellation (block 36), so check it by hand.
       guard !Task.isCancelled else { return }
       model.applySearch()
   }
   ```

3. Перепиши тест: теперь задержка живёт во вью, и в модели проверяется только `applySearch()`. Подумай, что из поведения осталось без теста.
4. Сравни два варианта по четырём вопросам и запиши ответы в журнал: сколько строк кода, где живёт задержка (модель или вью), как устроена отмена, что можно проверить юнит-тестом.
5. Выбери вариант. Если оставляешь Combine, верни коммит из блока 48 (`git revert` последнего коммита). Если `.task(id:)` — закоммить.

**Готово, когда.** Поиск работает в выбранном варианте, а в журнале есть сравнение и причина выбора.

**Если застрял.** Если поиск срабатывает на каждую букву, проверь `guard !Task.isCancelled`: без него отменённый `sleep` сразу возвращается и `applySearch()` вызывается.

### Блок 50. searchable, refreshable, ContentUnavailableView

*≈30 мин · Справочник: [B6](handbook.md#b6-готовые-модификаторы-searchable-refreshable-contentunavailableview)*

**Цель.** У вкладки нормальная строка поиска, pull-to-refresh и два разных пустых состояния: «ещё нет отметок» и «ничего не найдено».

**Изучи (≈10 мин).**
- Карточка [B6](handbook.md#b6-готовые-модификаторы-searchable-refreshable-contentunavailableview).
- Документация: [searchable](https://developer.apple.com/documentation/swiftui/view/searchable(text:placement:prompt:)), [ContentUnavailableView](https://developer.apple.com/documentation/swiftui/contentunavailableview).
- Код Buzz: [`iOS/Modules/TodayFeature/Sources/TodayView.swift:43`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L43) — своё пустое состояние; [`:71`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L71) — `.refreshable`; [`iOS/Modules/CatalogFeature/Sources/CatalogView.swift:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/CatalogFeature/Sources/CatalogView.swift#L45) — готовое состояние «ничего не найдено».

**Сделай руками (≈20 мин).**
1. Подпиши поиск: `.searchable(text: $model.query, prompt: Text("wellbeing.search", bundle: .module))`.
2. Добавь `.refreshable { await model.load() }`. Временно передай фейк с задержкой из блока 37 и посмотри, как индикатор крутится ровно столько, сколько идёт `load()`. В части 8 сюда добавится синхронизация с сервером.
3. Пустые состояния поверх списка:

   ```swift
   .overlay {
       if model.checkins.isEmpty {
           ContentUnavailableView {
               Label {
                   Text("wellbeing.empty.title", bundle: .module)
               } icon: {
                   Image(systemName: "moon.zzz")
               }
           } description: {
               Text("wellbeing.empty.subtitle", bundle: .module)
           } actions: {
               // TODO: a Button that calls model.addTapped()
           }
       } else if model.visible.isEmpty {
           // TODO: ContentUnavailableView.search(text: model.query)
       }
   }
   ```

4. Заполни новые ключи `wellbeing.search`, `wellbeing.empty.*` на двух языках.
5. Проверь три состояния: удали все отметки (пустой экран с кнопкой), добавь одну и найди несуществующее слово (поиск без результатов), очисти поиск (список).
6. Сломай. Повесь `.refreshable` на `VStack` без прокрутки вместо `List`. Потянуть нечего, обновления нет. Верни на список.

**Готово, когда.** Все три состояния выглядят по-разному, кнопка в пустом состоянии открывает форму, pull-to-refresh перезагружает список.

**Если застрял.** Если пустое состояние наезжает на навбар или поиск, сравни с `TodayView`: там используется `.overlay` на списке и отступ сверху.

---

## Часть 6. Архитектура, строки, тесты, графики

В этой части фича «Самочувствие» получает настоящую архитектуру: правила уходят в use case, напоминания — в маленький Redux-стор. Потом приводим в порядок строки и форматирование, покрываем всё тестами на Swift Testing и рисуем график «настроение против кофеина».

### Блок 51. Clean: SaveCheckinUseCase

*≈30 мин · Справочник: [E3](handbook.md#e3-clean-architecture-в-одной-фиче), [A6](handbook.md#a6-typed-throws)*

**Цель.** Правила «одна отметка в день» и «сон от 0 до 24 часов» живут в `SaveCheckinUseCase`, а `WellbeingViewModel` сохраняет отметку только через него.

**Изучи (≈10 мин).**
- Карточка [E3](handbook.md#e3-clean-architecture-в-одной-фиче) целиком, она короткая.
- Документация: статья Robert C. Martin [«The Clean Architecture»](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), достаточно схемы с кругами и раздела про правило зависимостей.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L9) — протокол плюс реализация по умолчанию. Строка [`:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L19): время тоже зависимость. Строки [`:36`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L36)–63: сначала правила, потом сохранение, ошибки хранилища сводятся к одному `.storage`.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift:90`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Domain/UseCases.swift#L90) — честная заметка про use case, который ничего не делает, кроме проброса.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift:36`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/AddEntryModule.swift#L36) — где use case-ы создаются и передаются в модель.

**Сделай руками (≈20 мин).**
1. Найди `CheckinError` из блока 46. Если он лежит не в `iOS/Modules/WellbeingFeature/Sources/Domain/`, перенеси его туда (например, в `CheckinError.swift`). Добавь ему `Equatable` и `Sendable`, как у `AddEntryError`: это понадобится в тестах. Правила из временного `CheckinRules.validate(...)` (тоже блок 46) перенеси в `SaveCheckinUseCase` ниже, а сам `CheckinRules` удали.
2. Создай `iOS/Modules/WellbeingFeature/Sources/Domain/SaveCheckinUseCase.swift`. В этой папке разрешены только `Foundation` и `Domain`, никакого SwiftUI и SwiftData.

   ```swift
   import Domain
   import Foundation

   /// One thing the user can do: save the evening check-in.
   /// The view model knows only this protocol, so tests can replace it.
   public protocol SaveCheckinUseCase: Sendable {
       /// Returns the check-in as it was saved (day normalized, updatedAt set).
       func execute(_ checkin: Checkin) async throws(CheckinError) -> Checkin
   }

   public struct DefaultSaveCheckinUseCase: SaveCheckinUseCase {
       let checkins: any CheckinRepository
       let calendar: Calendar
       /// Time is a dependency: tests pass a fixed date.
       let now: @Sendable () -> Date

       public init(
           checkins: any CheckinRepository,
           calendar: Calendar = .current,
           now: @escaping @Sendable () -> Date = { .now }
       ) {
           self.checkins = checkins
           self.calendar = calendar
           self.now = now
       }

       public func execute(_ checkin: Checkin) async throws(CheckinError) -> Checkin {
           // 1. Rules that need no storage.
           // TODO: if sleepHours is outside 0...24, throw .invalidSleepHours

           var result = checkin
           result.day = calendar.startOfDay(for: checkin.day)
           // MoodPicker allows only 1...5, but the rule lives here, not in the UI.
           result.mood = min(max(checkin.mood, 1), 5)
           result.updatedAt = now()

           // 2. Rules that need storage. Storage errors become one simple case.
           let existing: [Checkin]
           do {
               existing = try await checkins.all()
           } catch {
               throw .storage
           }
           // TODO: if another check-in (a different id) has the same day, throw .alreadyExistsForDay.
           // Editing the same check-in (same id) must still work.

           // 3. Save.
           do {
               try await checkins.save(result)
           } catch {
               throw .storage
           }
           return result
       }
   }
   ```
   Если в блоке 7 поля `Checkin` объявлены через `let`, сделай `day`, `mood` и `updatedAt` изменяемыми (`var`) или собери новый `Checkin` через его `init`.
3. **Сломай и почини.** Перенеси проверку дубля внутрь первого `do { ... }` и подумай, какую ошибку получит пользователь. `catch` поймает твой же `.alreadyExistsForDay` и превратит его в `.storage`. Верни проверку между блоками `do`. Это частая ловушка при сведении ошибок к одному случаю.
4. В `WellbeingViewModel` замени прямой вызов `repository.save(...)` на use case. Репозиторий для чтения (`all()`, `delete`) пока остаётся.

   ```swift
   @ObservationIgnored private let saveCheckin: any SaveCheckinUseCase

   /// Returns true when the form can close.
   func save(_ draft: Checkin) async -> Bool {
       do {
           _ = try await saveCheckin.execute(draft)
           await load()
           return true
       } catch {
           // Typed throws: `error` is already CheckinError, no casting.
           // TODO: put it into the property the view shows as an alert (from block 46)
           return false
       }
   }
   ```
5. Там, где создаётся `WellbeingViewModel` (координатор или фабрика модуля из блока 25), собери `DefaultSaveCheckinUseCase(checkins: repository)` и передай в `init`. В `#Preview` то же самое с `InMemoryCheckinRepository`.
6. Как в карточке E3, честно посчитай: какие действия экрана остались прямыми вызовами репозитория и стоило ли заводить для них use case.

**Готово, когда.** Приложение собирается. Вторая отметка за тот же день не сохраняется и показывает ошибку, правка существующей отметки сохраняется. Ввод сна 30 часов (если форма позволяет) даёт ошибку `invalidSleepHours`.

**Если застрял.** Сравни свою структуру с `DefaultAddEntryUseCase`: там те же три шага — правила, создание, сохранение.

### Блок 52. Redux в Buzz: разбор

*≈30 мин · Справочник: [E4](handbook.md#e4-самописный-redux-и-потом-tca)*

**Цель.** Ты понимаешь путь action → reducer → state → effect в «Настройках» и сам написал такой же мини-стор в `WellbeingFeature`.

**Изучи (≈10 мин).**
- Карточка [E4](handbook.md#e4-самописный-redux-и-потом-tca), абзацы «Что и зачем» и «Было → стало».
- Документация: [TCA на GitHub](https://github.com/pointfreeco/swift-composable-architecture), только README до раздела «Basic usage», чтобы увидеть, во что вырастает та же идея.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/Redux/Store.swift:18`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L18) — `Effect`; [`:32`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L32) — reducer это просто функция; [`:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L48) — `send`; [`:66`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L66) — `binding` для `Stepper` и `Toggle`.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsState.swift:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsState.swift#L48) — действия в двух группах (от пользователя и от эффектов), [`:67`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsState.swift#L67) — зависимости как структура замыканий.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift:25`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsReducer.swift#L25) — ограничение лимита и эффект сохранения в одной ветке.

**Сделай руками (≈20 мин).**
1. Поставь брейкпоинт в `SettingsReducer.swift` на `case .limitChanged`. Запусти приложение, открой «Настройки» и нажми `+` у лимита. Пройди по стеку вызовов: `Stepper` → `binding` → `send` → reducer. Затем поставь брейкпоинт внутри `.run { _ in await env.saveLimit(limit) }` и посмотри, что эффект выполняется уже после возврата из reducer-а.
2. `Store` объявлен в `SettingsFeature`, а фичи не видят друг друга. Напиши свой в `iOS/Modules/WellbeingFeature/Sources/Redux/Store.swift`, набирая руками, а не копируя: так запоминается. Сделай типы `internal` (без `public`), иначе в App-таргете появятся два разных `Store` и имя станет неоднозначным.

   ```swift
   import Observation
   import SwiftUI

   /// Async work that a reducer asks the store to run.
   struct Effect<Action: Sendable>: Sendable {
       typealias Send = @Sendable (Action) async -> Void
       let run: @Sendable (_ send: @escaping Send) async -> Void

       static var none: Self { Self { _ in } }
       static func run(_ work: @escaping @Sendable (_ send: @escaping Send) async -> Void) -> Self {
           Self(run: work)
       }
   }

   /// Pure function: no async, no side effects, only state changes.
   typealias Reducer<State, Action: Sendable> = (inout State, Action) -> Effect<Action>

   @MainActor
   @Observable
   final class Store<State, Action: Sendable> {
       private(set) var state: State
       @ObservationIgnored private let reducer: Reducer<State, Action>
       @ObservationIgnored private var tasks: [Task<Void, Never>] = []

       init(initial: State, reducer: @escaping Reducer<State, Action>) {
           self.state = initial
           self.reducer = reducer
       }

       func send(_ action: Action) {
           // TODO: 1) run the reducer on `state`, 2) start a Task that runs the effect,
           // 3) the effect's `send` calls back into `self` (weak), 4) keep the task in `tasks`
       }

       func cancelEffects() {
           // TODO: cancel and forget all tasks
       }

       func binding<Value>(_ keyPath: KeyPath<State, Value>, send action: @escaping (Value) -> Action) -> Binding<Value> {
           // TODO: get reads from state, set sends an action
       }
   }
   ```
3. Проверь стор на песочнице. Создай временный файл `WellbeingFeature/Sources/Redux/CounterPlayground.swift` со счётчиком: `increment`, `decrement` и `loadRandom`, где эффект ждёт `Task.sleep(for: .seconds(1))` и шлёт `.randomLoaded(Int.random(in: 1...100))`. Сделай для него `#Preview` с кнопками и `Stepper(value: store.binding(\.count, send: CounterAction.set))`.
4. Когда превью работает, удали `CounterPlayground.swift`. Сам `Store.swift` оставь: он нужен в следующем блоке.

**Готово, когда.** В превью счётчик меняется кнопками и `Stepper`, через секунду после `loadRandom` подставляется случайное число. Ты можешь словами объяснить, почему reducer не может сам вызвать `await`.

**Если застрял.** Сверь `send` со строками [`Store.swift:48`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/Redux/Store.swift#L48)–57. В настоящем проекте общий стор вынесли бы в отдельный модуль; копия здесь ради практики.

### Блок 53. Мини-стор напоминаний

*≈30 мин · Справочник: [E4](handbook.md#e4-самописный-redux-и-потом-tca), [F1](handbook.md#f1-swift-testing)*

**Цель.** Включение напоминания и выбор времени идут через `reminderReducer`, а его поведение закреплено тестами без UI.

**Изучи (≈10 мин).**
- Карточка [E4](handbook.md#e4-самописный-redux-и-потом-tca), строка про зависимости-замыкания.
- Код Buzz: [`iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift:10`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift#L10) — тест reducer-а без async; [`:39`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Tests/SettingsReducerTests.swift#L39) — тест эффекта через настоящий `Store`.
- Код Buzz: [`iOS/App/Sources/Coordinators/SettingsCoordinator.swift:44`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/Coordinators/SettingsCoordinator.swift#L44) — эффект пишет в `UserDefaults` под тем же ключом, что читает `@AppStorage`, поэтому все экраны видят новое значение.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsState.swift:42`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsState.swift#L42) — в состоянии хранится значение алерта, а не текст.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Sources/Redux/Reminder.swift` с состоянием, действиями и зависимостями:

   ```swift
   import Foundation

   struct ReminderState: Equatable {
       var isOn = false
       /// Seconds from midnight, same as the "wellbeing.reminderTime" key.
       var time: Double = 21 * 3600
       var alert: ReminderAlert?
   }

   enum ReminderAlert: Equatable, Sendable {
       case permissionDenied
   }

   enum ReminderAction: Sendable {
       // From the user
       case onAppear
       case toggled(Bool)
       case timeChanged(Double)
       case alertDismissed
       // Results of effects
       case loaded(isOn: Bool, time: Double)
       case permissionDenied
   }

   /// Dependencies as closures: a test replaces only the one it needs.
   struct ReminderEnvironment: Sendable {
       var load: @Sendable () async -> (isOn: Bool, time: Double)
       var save: @Sendable (_ isOn: Bool, _ time: Double) async -> Void
       /// Asks for permission when needed and schedules. Returns false if the user said no.
       var schedule: @Sendable (_ time: Double) async -> Bool
       var cancel: @Sendable () async -> Void

       static let noop = ReminderEnvironment(
           load: { (false, 21 * 3600) },
           save: { _, _ in },
           schedule: { _ in true },
           cancel: {}
       )
   }
   ```
2. В том же файле напиши reducer:

   ```swift
   func reminderReducer(env: ReminderEnvironment) -> Reducer<ReminderState, ReminderAction> {
       { state, action in
           switch action {
           case .onAppear:
               return .run { send in
                   let loaded = await env.load()
                   await send(.loaded(isOn: loaded.isOn, time: loaded.time))
               }

           case .loaded(let isOn, let time):
               state.isOn = isOn
               state.time = time
               return .none

           case .toggled(let isOn):
               state.isOn = isOn
               let time = state.time
               // TODO: return .run { send in ... }:
               // save; if on, schedule and send .permissionDenied when it returns false; if off, cancel

           case .timeChanged(let seconds):
               // TODO: clamp to 0...(24 * 3600 - 60), save, reschedule only when isOn

           case .permissionDenied:
               state.isOn = false
               state.alert = .permissionDenied
               let time = state.time
               return .run { _ in await env.save(false, time) }

           case .alertDismissed:
               state.alert = nil
               return .none
           }
       }
   }
   ```
3. Тесты в `iOS/Modules/WellbeingFeature/Tests/ReminderReducerTests.swift`:

   ```swift
   import Testing

   @testable import WellbeingFeature

   @Test("Permission denied turns the toggle off and shows an alert")
   func permissionDenied() {
       var state = ReminderState(isOn: true)
       _ = reminderReducer(env: .noop)(&state, .permissionDenied)
       #expect(state == ReminderState(isOn: false, alert: .permissionDenied))
   }

   @Test("Time is clamped to one day", arguments: [(-5.0, 0.0), (90_000.0, 86_340.0), (75_600.0, 75_600.0)])
   func timeIsClamped(input: Double, expected: Double) {
       // TODO: apply .timeChanged(input) and check state.time
   }

   @MainActor
   @Test("A refused permission comes back as an action")
   func refusedPermission() async throws {
       var env = ReminderEnvironment.noop
       env.schedule = { _ in false }
       let store = Store(initial: ReminderState(), reducer: reminderReducer(env: env))
       store.send(.toggled(true))
       try await Task.sleep(for: .milliseconds(100))
       // TODO: expect isOn == false and alert == .permissionDenied
   }
   ```
4. Подключи стор к экрану. Там, где в блоке 34 стоял переключатель напоминания на `@AppStorage`, используй стор: `Toggle(isOn: store.binding(\.isOn, send: ReminderAction.toggled))` и `DatePicker` с `Binding`, который переводит секунды от полуночи в `Date` и обратно (`.task { store.send(.onAppear) }`, `.onDisappear { store.cancelEffects() }`). Окружение собери из настоящего `ReminderScheduler` из блока 45 и `UserDefaults.standard` с ключами `wellbeing.reminderOn` и `wellbeing.reminderTime`. Имена методов планировщика подставь свои.

**Готово, когда.** Три теста зелёные. В приложении переключатель включает напоминание; если в системном запросе нажать «Не разрешать», переключатель сам выключается и появляется алерт.

**Если застрял.** Чтобы снова увидеть системный запрос разрешения, удали приложение с симулятора. Захват `let time = state.time` перед `.run` нужен потому, что `inout`-параметр нельзя захватить в escaping-замыкание.

### Блок 54. String Catalog и плюрализация

*≈30 мин · Справочник: [D1](handbook.md#d1-string-catalog-и-плюрализация)*

**Цель.** Все строки вкладки лежат в каталоге под ключами `wellbeing.*`, а строка «N дней подряд» правильно склоняется на русском и английском.

**Изучи (≈10 мин).**
- Карточка [D1](handbook.md#d1-string-catalog-и-плюрализация).
- Документация: [Localizing and varying text with a string catalog](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog), раздел про варианты по множественному числу.
- Описание в Buzz: [`docs/client/localization.md`](https://github.com/disavle/buzz/blob/main/docs/client/localization.md), разделы 1 и 3. Обрати внимание на ловушку Xcode 26: каждый вариант, включая `one`, должен содержать само число.
- Код Buzz: каталог [`iOS/Modules/TodayFeature/Resources/Localizable.xcstrings`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Resources/Localizable.xcstrings) — как выглядят семантические ключи `today.empty.title`.

**Сделай руками (≈20 мин).**
1. Открой `iOS/Modules/WellbeingFeature/Resources/Localizable.xcstrings` (если файла нет: File → New → String Catalog, положи в `Resources`, затем `mise run generate`). Проверь, что в каталоге есть языки English и Russian.
2. Пройди по вьюхам фичи и замени текст в коде на ключи: `Text("wellbeing.title", bundle: .module)`, `wellbeing.empty.title`, `wellbeing.form.mood`, `wellbeing.form.sleep`, `wellbeing.form.note` и так далее. Про `bundle: .module` подробно в следующем блоке; пока пиши его везде.
3. Добавь подсчёт серии в `iOS/Modules/WellbeingFeature/Sources/Domain/CheckinStreak.swift`:

   ```swift
   import Domain
   import Foundation

   /// How many days in a row have a check-in, counting back from today.
   /// If today has no check-in yet, the streak is still alive: count from yesterday.
   func checkinStreak(_ checkins: [Checkin], today: Date, calendar: Calendar = .current) -> Int {
       let days = Set(checkins.map { calendar.startOfDay(for: $0.day) })
       var day = calendar.startOfDay(for: today)
       if !days.contains(day), let yesterday = calendar.date(byAdding: .day, value: -1, to: day) {
           day = yesterday
       }
       var count = 0
       // TODO: while `days` contains `day`: count += 1, step `day` one day back
       return count
   }
   ```
   В `WellbeingViewModel` добавь вычисляемое `var streak: Int { checkinStreak(checkins, today: .now) }`.
4. Покажи серию над списком: `Text("wellbeing.streak \(model.streak)", bundle: .module)`. Собери проект. В каталоге появится ключ `wellbeing.streak %lld`. Если Xcode не добавил его сам, добавь кнопкой `+` вручную.
5. Правый клик по ключу → **Vary by Plural**. Русский: `one` — «%lld день подряд», `few` — «%lld дня подряд», `many` — «%lld дней подряд», `other` — «%lld дня подряд». Английский: `one` — «%lld day in a row», `other` — «%lld days in a row».
6. **Сломай и почини.** В русском варианте `one` напиши «Один день подряд» без `%lld` и собери проект. Прочитай ошибку сборки, верни число.
7. Edit Scheme → Run → Options → App Language: Russian. Проверь 1, 3 и 5 дней (можно временно подставить число прямо в `Text`). Потом попробуй псевдоязык Double-Length: не ломается ли вёрстка строки серии.

**Готово, когда.** На русском видно «1 день подряд», «3 дня подряд», «5 дней подряд», на английском «1 day in a row» и «3 days in a row». В коде фичи не осталось русских или английских фраз, только ключи.

### Блок 55. Строки в модуле: bundle .module

*≈30 мин · Справочник: [D2](handbook.md#d2-строки-в-модулях-bundle-module-и-генерация-символов)*

**Цель.** Ты видел своими глазами, что без `bundle: .module` перевод пропадает, и ошибки `CheckinError` показываются пользователю переведённым текстом.

**Изучи (≈10 мин).**
- Карточка [D2](handbook.md#d2-строки-в-модулях-bundle-module-и-генерация-символов).
- Документация: [Bundling resources with a Swift package](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package), раздел про `Bundle.module`.
- Код Buzz: [`iOS/Tuist/ProjectDescriptionHelpers/Module.swift:41`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/ProjectDescriptionHelpers/Module.swift#L41) — откуда у модуля ресурсы; поэтому Tuist генерирует `Bundle.module`.
- Код Buzz: [`iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift:199`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L199) — ошибка домена переводится в слое Presentation; [`:53`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Sources/Presentation/AddEntryView.swift#L53) — как она попадает в `.alert`.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsView.swift:179`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsView.swift#L179) — тот же приём для алерта Redux-стора.

**Сделай руками (≈20 мин).**
1. **Сломай и почини.** В `WellbeingView` у заголовка убери `bundle: .module`: `Text("wellbeing.title")`. Запусти на русском. Вместо «Самочувствие» на экране сам ключ `wellbeing.title`: SwiftUI искал строку в каталоге приложения, а не модуля. Верни `bundle: .module`.
2. Повтори то же для строки вне `Text`: `String(localized: "wellbeing.title")` без бандла и с ним. Запомни, что правило одинаковое для `Text`, `String(localized:)`, `navigationTitle` и подписей в Charts.
3. Создай `iOS/Modules/WellbeingFeature/Sources/LocalizedCheckinError.swift`. Domain не знает про тексты, перевод живёт здесь:

   ```swift
   import Foundation

   /// Wraps the domain error so `.alert(isPresented:error:)` can show a translated message.
   struct LocalizedCheckinError: LocalizedError {
       let error: CheckinError

       var errorDescription: String? {
           switch error {
           case .alreadyExistsForDay: String(localized: "wellbeing.error.duplicateDay", bundle: .module)
           // TODO: .invalidSleepHours -> "wellbeing.error.sleep"
           // TODO: .storage -> "wellbeing.error.storage"
           }
       }
   }
   ```
4. В `CheckinForm` (или там, где сейчас показывается ошибка) замени алерт на шаблон из `AddEntryView`: `.alert(isPresented: ..., error: model.error.map(LocalizedCheckinError.init)) {}`.
5. Заполни три новых ключа на двух языках. Проверь: сохрани вторую отметку за день, увидишь переведённый текст.
6. Если у тебя Xcode 26 и осталось время: в Build Settings таргета `WellbeingFeature` включи «Generate String Catalog Symbols» и перепиши один `Text` на сгенерированный символ. Опечатка в ключе теперь ловится компилятором. Это эксперимент: настройку в `Project.swift` пока не добавляй, после `mise run generate` она сбросится.

**Готово, когда.** Без `bundle: .module` ты видел ключ вместо перевода, с ним видишь перевод. Ошибка дубля дня показывается переведённой на обоих языках.

**Если застрял.** Если перевод не появляется и с `bundle: .module`, проверь, что каталог лежит в `Resources/`, а модуль объявлен с `resources: true`, и выполни `mise run generate`.

### Блок 56. FormatStyle и Measurement

*≈30 мин · Справочник: [D3](handbook.md#d3-formatstyle-и-measurement)*

**Цель.** Часы сна, даты отметок и заголовки недель форматируются по локали через `FormatStyle`, и формат сна закреплён тестом.

**Изучи (≈10 мин).**
- Карточка [D3](handbook.md#d3-formatstyle-и-measurement).
- Документация: [FormatStyle](https://developer.apple.com/documentation/foundation/formatstyle), [UnitDuration](https://developer.apple.com/documentation/foundation/unitduration).
- Код Buzz: [`iOS/Modules/DesignSystem/Sources/Formatting.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Formatting.swift#L9) — `BuzzFormat.caffeine`, локаль параметром для тестов; [`:34`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Sources/Formatting.swift#L34) — зачем `usage: .asProvided`.
- Код Buzz: [`iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift:15`](https://github.com/disavle/buzz/blob/main/iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift#L15) — почему тест проверяет `hasPrefix`, а не всю строку.
- Код Buzz: [`iOS/Modules/SettingsFeature/Sources/SettingsView.swift:170`](https://github.com/disavle/buzz/blob/main/iOS/Modules/SettingsFeature/Sources/SettingsView.swift#L170) — относительная дата; [`iOS/Modules/StatsFeature/Sources/StatsView.swift:123`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L123) — интервал.

**Сделай руками (≈20 мин).**
1. Песочница на 5 минут: в Playground выполни `Measurement(value: 7.5, unit: UnitDuration.hours).formatted(.measurement(width: .abbreviated, usage: .asProvided).locale(Locale(identifier: "ru_RU")))`, затем то же для `en_US` и с `width: .wide`. Посмотри, какой вариант лучше читается в строке списка.
2. Добавь в `iOS/Modules/DesignSystem/Sources/Formatting.swift` форматтер сна рядом с остальными:

   ```swift
   /// "7.5 hr" / "7,5 ч". One decimal at most: 7 h, 7.5 h.
   public static func sleep(_ hours: Double, locale: Locale = .current) -> String {
       // TODO: Measurement(value: hours, unit: UnitDuration.hours)
       //       .formatted(.measurement(width: .abbreviated, usage: .asProvided,
       //                               numberFormatStyle: .number.precision(.fractionLength(0...1)))
       //       .locale(locale))
   }
   ```
3. Тест в `iOS/Modules/DesignSystem/Tests/DesignSystemTests.swift` по образцу `caffeineFormat`:

   ```swift
   @Test("Sleep uses the decimal separator of the language", arguments: [("en_US", "7.5"), ("ru_RU", "7,5")])
   func sleepFormat(localeId: String, number: String) {
       // TODO: BuzzFormat.sleep(7.5, locale: Locale(identifier: localeId)) starts with `number`
   }
   ```
4. Используй форматтеры во вьюхах фичи:
   - `CheckinRow`: сон через `BuzzFormat.sleep(checkin.sleepHours)`, день через `checkin.day.formatted(.dateTime.weekday(.wide).day().month())`.
   - `CheckinDetailView`: «изменено» через `checkin.updatedAt.formatted(.relative(presentation: .named))`.
   - Заголовок секции недели: `(weekStart..<weekEnd).formatted(.interval.day().month())`, получится «13–19 окт.».
5. **Сломай и почини.** Где-нибудь напиши `Text("\(checkin.sleepHours) ч")`, посмотри на «7.5 ч» на русском и на «7.5 ч» на английском. Верни `BuzzFormat.sleep`.

**Готово, когда.** Тест проходит. На русском в строке видно «7,5 ч» и «пятница, 17 окт.», на английском «7.5 hr» и «Friday, Oct 17». В коде фичи нет склейки чисел с единицами.

**Если застрял.** Форматтер ставит неразрывный пробел между числом и единицей, поэтому `==` с обычной строкой не сработает. Проверяй начало строки.

### Блок 57. Swift Testing: первые тесты

*≈30 мин · Справочник: [F1](handbook.md#f1-swift-testing)*

**Цель.** У `SaveCheckinUseCase` есть первые тесты на успешное сохранение, и ты видел, как Swift Testing показывает упавшую проверку.

**Изучи (≈10 мин).**
- Карточка [F1](handbook.md#f1-swift-testing).
- Документация: [Swift Testing](https://developer.apple.com/documentation/testing), [Expectations and confirmations](https://developer.apple.com/documentation/testing/expectations).
- Код Buzz: [`iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift#L9) — фиксированное «сейчас» для тестов; [`:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift#L11) — тест как свободная функция.
- Код Buzz: [`Backend/Tests/AppTests/AppTests.swift:7`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L7) — `@Suite` со структурой; [`:34`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L34) — `#require` вместо `XCTUnwrap`.

**Сделай руками (≈20 мин).**
1. Создай `iOS/Modules/WellbeingFeature/Tests/SaveCheckinUseCaseTests.swift`. Общую настройку сделай в `init` сьюта: Swift Testing создаёт новый экземпляр на каждый тест, как `setUp` в XCTest.

   ```swift
   import Domain
   import Foundation
   import Testing

   @testable import WellbeingFeature

   @Suite("Save check-in")
   struct SaveCheckinUseCaseTests {
       let calendar = Calendar(identifier: .gregorian)
       let evening: Date
       let repo = InMemoryCheckinRepository()
       let sut: DefaultSaveCheckinUseCase

       init() {
           // 21:30 on a fixed day: the test does not depend on the clock.
           evening = Date(timeIntervalSince1970: 1_760_736_600)
           sut = DefaultSaveCheckinUseCase(checkins: repo, calendar: calendar, now: { [evening] in evening })
       }

       /// A check-in with sane defaults. Change only what the test is about.
       func makeCheckin(id: UUID = UUID(), mood: Int = 4, sleepHours: Double = 7.5) -> Checkin {
           // TODO: call your Checkin init from block 7 with day: evening, note: "", updatedAt: .distantPast
       }

       @Test("The day is stored as the start of the day")
       func dayIsNormalized() async throws {
           let saved = try await sut.execute(makeCheckin())
           #expect(saved.day == calendar.startOfDay(for: evening))
       }

       @Test("updatedAt comes from the clock, not from the form")
       func updatedAtIsNow() async throws {
           // TODO: save and expect saved.updatedAt == evening
       }

       @Test("The saved check-in is in the repository")
       func isStored() async throws {
           let checkin = makeCheckin()
           _ = try await sut.execute(checkin)
           let stored = try #require(try await repo.all().first)
           // TODO: expect stored.id == checkin.id
       }
   }
   ```
2. Запусти тесты ромбиком у `@Suite` в редакторе или из Test Navigator (⌘6). Все тесты модуля сразу: `mise run test` (дольше, идёт через fastlane).
3. **Сломай и почини.** В `dayIsNormalized` сравни с `evening` вместо начала дня. Посмотри на вывод: Swift Testing печатает обе стороны выражения и их значения. Сравни с тем, что показал бы `XCTAssertEqual`. Верни правильное значение.
4. **Сломай и почини.** В `isStored` перед `#require` очисти репозиторий (или не вызывай `execute`). Тест остановится на `#require`, следующая строка не выполнится. В этом разница между `#require` и `#expect`.
5. Если `InMemoryCheckinRepository` принимает начальные данные иначе, чем пустым `init()`, поправь создание `repo`.

**Готово, когда.** Три теста зелёные, ты видел красный тест с подробной разницей значений и остановку на `#require`.

**Если застрял.** Если тест не видит `DefaultSaveCheckinUseCase`, проверь `@testable import WellbeingFeature` и что модуль объявлен с `tests: true` в `iOS/Project.swift`.

### Блок 58. Параметры и ошибки в тестах

*≈30 мин · Справочник: [F1](handbook.md#f1-swift-testing), [E1](handbook.md#e1-mvvm-на-observable)*

**Цель.** Правила use case-а проверены параметризованными тестами и `#expect(throws:)`, а `WellbeingViewModel` протестирован с фейками.

**Изучи (≈10 мин).**
- Документация: [Implementing parameterized tests](https://developer.apple.com/documentation/testing/parameterizedtesting).
- Код Buzz: [`iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift:17`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift#L17) — аргументы-кортежи с именами; [`:52`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift#L52) — `await #expect(throws:)` с конкретным случаем ошибки; [`:62`](https://github.com/disavle/buzz/blob/main/iOS/Modules/AddEntryFeature/Tests/AddEntryUseCaseTests.swift#L62) — массив простых аргументов.
- Код Buzz: [`iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Tests/TodayViewModelTests.swift#L9) — тест модели экрана на `@MainActor` с фейками из Domain.

**Сделай руками (≈20 мин).**
1. В `SaveCheckinUseCaseTests` добавь параметризованный тест на сон:

   ```swift
   @Test("Impossible sleep is rejected", arguments: [-1.0, 24.5, 100])
   func badSleep(hours: Double) async {
       await #expect(throws: CheckinError.invalidSleepHours) {
           try await sut.execute(makeCheckin(sleepHours: hours))
       }
   }

   @Test("Edge values are allowed", arguments: [0.0, 24.0])
   func edgeSleep(hours: Double) async throws {
       // TODO: execute does not throw
   }
   ```
   `#expect(throws: CheckinError.invalidSleepHours)` требует, чтобы ошибка была `Equatable` (блок 51).
2. Тест на дубль и тест на правку той же отметки:

   ```swift
   @Test("A second check-in for the same day is rejected")
   func duplicateDay() async throws {
       _ = try await sut.execute(makeCheckin())
       // TODO: a new check-in (new id) for the same evening throws .alreadyExistsForDay
   }

   @Test("Editing today's check-in is allowed")
   func editSameDay() async throws {
       let first = try await sut.execute(makeCheckin(mood: 2))
       // TODO: save `first` again with mood 5, then expect repo.all() has one check-in with mood 5
   }
   ```
3. Создай `iOS/Modules/WellbeingFeature/Tests/WellbeingViewModelTests.swift`. Фейковый use case покажет, зачем модели протокол:

   ```swift
   import Domain
   import Foundation
   import Testing

   @testable import WellbeingFeature

   /// Always fails: lets us test the error path without a broken database.
   struct FailingSaveCheckin: SaveCheckinUseCase {
       func execute(_ checkin: Checkin) async throws(CheckinError) -> Checkin { throw .storage }
   }

   @MainActor
   @Test("A storage error is shown and the form stays open")
   func saveFails() async {
       // TODO: build WellbeingViewModel with InMemoryCheckinRepository() and FailingSaveCheckin()
       // TODO: let closed = await model.save(...); expect closed == false and the error == .storage
   }

   @MainActor
   @Test("After load the list has the preview week")
   func loads() async {
       // TODO: repository with Checkin.previewWeek, await model.load(), expect the count matches
   }
   ```
   Подставь настоящие имена параметров `init` и свойства ошибки своей модели.
4. **Сломай и почини.** В use case-е поменяй `0...24` на `0..<24`. Какой тест упал и с каким аргументом? Swift Testing показывает упавший аргумент отдельной строкой. Верни границу.

**Готово, когда.** Все тесты модуля зелёные. В Test Navigator у параметризованных тестов видны отдельные строки на каждый аргумент.

### Блок 59. Swift Charts: столбцы кофеина

*≈30 мин · Справочник: [B10](handbook.md#b10-swift-charts)*

**Цель.** На вкладке «Самочувствие» есть `WellbeingChartView` со столбцами кофеина за последние 14 дней.

**Изучи (≈10 мин).**
- Карточка [B10](handbook.md#b10-swift-charts).
- Документация: [Creating a chart using Swift Charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts).
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsView.swift:55`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L55) — `Chart` с `BarMark`, `unit: .day` и переводом подписи значения; [`:76`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L76) — своя ось X.
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsCalculator.swift:6`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsCalculator.swift#L6) — маленькие `Identifiable`-структуры для графика.

**Сделай руками (≈20 мин).**
1. Песочница на 7 минут: пустой SwiftUI-файл с `#Preview`, массив `struct Sale: Identifiable { let day: Date; let value: Double; var id: Date { day } }` на 7 дней и `Chart(data) { BarMark(x: .value("Day", $0.day, unit: .day), y: .value("Sum", $0.value)) }`. Добавь `RuleMark(y: .value("Goal", 100))` с пунктиром. Файл потом удали.
2. Данные графика. Создай `iOS/Modules/WellbeingFeature/Sources/Domain/MoodCaffeine.swift`:

   ```swift
   import Domain
   import Foundation

   /// One day on the chart. `mood` is nil when there is no check-in that day.
   struct MoodCaffeineDay: Identifiable, Equatable, Sendable {
       let day: Date
       let caffeineMg: Double
       let mood: Int?
       var id: Date { day }
   }

   enum MoodCaffeine {
       /// The last `days` days ending today, days without data included with zeros.
       static func make(
           checkins: [Checkin],
           entries: [Entry],
           days: Int,
           today: Date,
           calendar: Calendar = .current
       ) -> [MoodCaffeineDay] {
           let todayStart = calendar.startOfDay(for: today)
           guard let first = calendar.date(byAdding: .day, value: -(days - 1), to: todayStart) else { return [] }
           return (0..<days).compactMap { offset in
               guard let day = calendar.date(byAdding: .day, value: offset, to: first) else { return nil }
               // TODO: caffeine = sum of caffeineMg of entries with calendar.isDate(consumedAt, inSameDayAs: day)
               // TODO: mood = mood of the check-in whose day is the same day, or nil
               return MoodCaffeineDay(day: day, caffeineMg: 0, mood: nil)
           }
       }
   }
   ```
3. В `WellbeingViewModel` добавь `private(set) var chart: [MoodCaffeineDay] = []` и загрузку: отметки уже есть, кофеин бери из `EntryRepository` через `entries(from:to:)` за 14 дней. Если модель ещё не получает `EntryRepository` (его добавляли в блоке 38 для карточки дня), передай его через `init`.
4. Создай `iOS/Modules/WellbeingFeature/Sources/WellbeingChartView.swift`:

   ```swift
   import Charts
   import DesignSystem
   import SwiftUI

   struct WellbeingChartView: View {
       let days: [MoodCaffeineDay]

       var body: some View {
           Chart {
               ForEach(days) { day in
                   BarMark(
                       x: .value(String(localized: "wellbeing.chart.day", bundle: .module), day.day, unit: .day),
                       y: .value(String(localized: "wellbeing.chart.caffeine", bundle: .module), day.caffeineMg)
                   )
                   .foregroundStyle(.tint.opacity(0.5))
                   .cornerRadius(3)
               }
           }
           // TODO: .chartXAxis with AxisMarks(values: .stride(by: .day, count: 2)) and weekday labels
           .frame(height: 200)
       }
   }
   ```
5. Покажи график первой секцией в `WellbeingView` и сделай `#Preview` с `Checkin.previewWeek` и `PreviewData.history()`.

**Готово, когда.** В превью и в приложении видны 14 столбцов кофеина, дни без банок нулевые, подписи осей переведены.

**Если застрял.** Если столбцы склеиваются в один, проверь `unit: .day` в `.value(...)`: без него Charts ставит точку в момент времени, а не на весь день.

### Блок 60. Настроение поверх кофеина

*≈30 мин · Справочник: [B10](handbook.md#b10-swift-charts), [C6](handbook.md#c6-appstorage-и-keychain)*

**Цель.** Поверх столбцов кофеина нарисована линия настроения со своей правой осью, пунктир среднего настроения и легенда, а столбцы скрываются настройкой `wellbeing.showCaffeine`.

**Изучи (≈10 мин).**
- Документация: [LineMark](https://developer.apple.com/documentation/charts/linemark), [RuleMark](https://developer.apple.com/documentation/charts/rulemark).
- Код Buzz: [`iOS/Modules/StatsFeature/Sources/StatsView.swift:176`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L176) — `LineMark` и `PointMark` для одних данных, сглаживание на [`:181`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L181); [`:67`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L67) — `RuleMark` с подписью; [`:188`](https://github.com/disavle/buzz/blob/main/iOS/Modules/StatsFeature/Sources/StatsView.swift#L188) — своя ось Y.
- Подумай над задачей до кода: кофеин в сотнях миллиграммов, настроение от 1 до 5. Двух независимых осей Y в Swift Charts нет. Решение: пересчитать настроение в масштаб миллиграммов для рисования, а правую ось подписать обратно числами 1–5.

**Сделай руками (≈20 мин).**
1. В `WellbeingChartView` добавь масштаб и линию:

   ```swift
   /// Mood 5 sits at the top of the caffeine axis. At least 100 mg, so a week without coffee still has room.
   private var scale: Double { max(days.map(\.caffeineMg).max() ?? 0, 100) / 5 }

   private var moodName: String { String(localized: "wellbeing.chart.mood", bundle: .module) }
   private var caffeineName: String { String(localized: "wellbeing.chart.caffeine", bundle: .module) }

   // Inside Chart, after the bars:
   ForEach(days.filter { $0.mood != nil }) { day in
       LineMark(
           x: .value(String(localized: "wellbeing.chart.day", bundle: .module), day.day, unit: .day),
           y: .value(moodName, Double(day.mood ?? 0) * scale)
       )
       .interpolationMethod(.catmullRom)
       // TODO: a PointMark with the same x and y
   }
   ```
2. Легенда появится сама, если раскрасить ряды через `.foregroundStyle(by: .value("Series", caffeineName))` у столбцов и `.foregroundStyle(by: .value("Series", moodName))` у линии и точек. Цвета задай один раз: `.chartForegroundStyleScale([caffeineName: Color.secondary, moodName: Color.accentColor])`. Убери `.foregroundStyle(.tint.opacity(0.5))` из прошлого блока.
3. Пунктир среднего настроения:

   ```swift
   // TODO: average of moods that are not nil; skip the rule when there are none
   RuleMark(y: .value(moodName, averageMood * scale))
       .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
       .annotation(position: .top, alignment: .leading) {
           Text("wellbeing.chart.averageMood \(averageMood.formatted(.number.precision(.fractionLength(1))))", bundle: .module)
               .font(.caption)
               .foregroundStyle(.secondary)
       }
   ```
4. Правая ось с настроением, левая с кофеином:

   ```swift
   .chartYAxis {
       AxisMarks(position: .leading)
       AxisMarks(position: .trailing, values: (1...5).map { Double($0) * scale }) { value in
           AxisValueLabel {
               // TODO: turn value.as(Double.self) back into a mood number and show it
           }
       }
   }
   ```
5. Переключатель: в `WellbeingChartView` добавь `@AppStorage("wellbeing.showCaffeine") private var showCaffeine = true` и рисуй столбцы только при `showCaffeine`. Переключатель уже есть с блока 34; проверь, что график реагирует сразу.
6. Добавь новые ключи в каталог на двух языках, проверь график в тёмной теме.

**Готово, когда.** На графике видны столбцы кофеина, линия настроения с точками, пунктир среднего с подписью «среднее 3,6», слева миллиграммы, справа 1–5, внизу легенда. Выключенный `wellbeing.showCaffeine` оставляет только линию.

**Если застрял.** Если легенда не появляется, у всех рядов должен быть `.foregroundStyle(by:)`; обычный `.foregroundStyle(...)` на отдельной отметке перебивает легенду.

## Часть 7. Сервер на Vapor

Теперь у отметок появляется сервер: маршруты, таблица в базе, общий с клиентом DTO, валидация, авторизация и коды ошибок. К концу части `/checkins` полностью покрыт тестами и готов к синхронизации из приложения.

### Блок 61. Как устроен сервер

*≈30 мин · Справочник: [G1](handbook.md#g1-vapor-сервер-как-долгоживущий-процесс)*

**Цель.** Ты запустил учебный Vapor-проект, поймал запрос брейкпоинтом и можешь пересказать путь запроса в Buzz от порта до обработчика.

**Изучи (≈10 мин).**
- Карточка [G1](handbook.md#g1-vapor-сервер-как-долгоживущий-процесс), особенно «Аналогии».
- Документация: [Vapor: Hello, world](https://docs.vapor.codes/getting-started/hello-world/), [Middleware](https://docs.vapor.codes/advanced/middleware/) (раздел про порядок).
- Код Buzz: [`Backend/Sources/App/entrypoint.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/entrypoint.swift#L6) — старт процесса, аналог `@main`.
- Код Buzz: [`Backend/Sources/App/configure.swift:13`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L13) — выбор базы; [`:32`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L32) — middleware (стандартный набор заменён своим); [`:37`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L37) — общий формат JSON; [`:40`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L40) — миграции.
- Код Buzz: [`Backend/Sources/App/routes.swift:12`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift#L12) — открытые и защищённые маршруты.

**Сделай руками (≈20 мин).**
1. Песочница вне репозитория: `brew install vapor`, затем `cd ~/sandbox && vapor new Hello -n && cd Hello && swift run`. Первая сборка долгая.
2. `curl http://127.0.0.1:8080/hello`. Открой `Package.swift` проекта Hello в Xcode, запусти схему, поставь брейкпоинт в обработчике `hello` и дёрни его ещё раз через `curl`. Посмотри на стек: внизу SwiftNIO, выше responder Vapor, ещё выше твой обработчик.
3. В Buzz: `mise run backend:run`, затем `curl -i localhost:8080/health`. В логе сервера найди строку от `RouteLoggingMiddleware`.
4. **Сломай и почини.** `curl -i localhost:8080/me` без токена. Ответ `401` и тело `{"error":"unauthorized"}`. Найди по коду, кто именно отказал: `User.guardMiddleware()` в `routes.swift` бросает ошибку, а `APIErrorMiddleware` превращает её в JSON.
5. Нарисуй на бумаге путь запроса `GET /me`: порт → `RouteLoggingMiddleware` → `APIErrorMiddleware` → `UserToken.authenticator()` → `User.guardMiddleware()` → `MeController.show` → кодирование ответа через `JSONEncoder.buzz`. Этот рисунок пригодится в блоке 84.
6. Остановить сервер: `Ctrl+C`. Сервер — долгоживущий процесс, в отличие от приложения, которое iOS может выгрузить в любой момент.

**Готово, когда.** Брейкпоинт в проекте Hello срабатывает от `curl`. Ты показываешь пальцем в коде Buzz каждый шаг пути запроса.

**Если застрял.** Если порт 8080 занят, остался прошлый сервер: `lsof -i :8080` покажет процесс. Подробный путеводитель по коду сервера: [`docs/backend/STEPS.md`](https://github.com/disavle/buzz/blob/main/docs/backend/STEPS.md).

### Блок 62. Первый маршрут: CheckinController

*≈30 мин · Справочник: [G2](handbook.md#g2-роуты-контроллеры-content)*

**Цель.** `GET /checkins` отвечает пустым JSON-массивом, а маршрут описан в своём контроллере.

**Изучи (≈10 мин).**
- Карточка [G2](handbook.md#g2-роуты-контроллеры-content).
- Документация: [Routing](https://docs.vapor.codes/basics/routing/), [Controllers](https://docs.vapor.codes/basics/controllers/).
- Код Buzz: [`Backend/Sources/App/Controllers/EntryController.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L6) — `boot` собирает маршруты контроллера; [`:19`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L19) — зачем `@Sendable` у обработчика.
- Код Buzz: [`Backend/Sources/App/Controllers/MeController.swift:12`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/MeController.swift#L12) — самый короткий обработчик в проекте.

**Сделай руками (≈20 мин).**
1. Разминка в проекте Hello из блока 61: добавь `app.get("hello", ":name") { req async throws -> String in ... }` и достань имя через `req.parameters.get("name")`. Проверь `curl localhost:8080/hello/Dima`.
2. В Buzz создай временный DTO `Backend/Sources/App/DTOs/CheckinDTO.swift`. В блоке 65 он переедет в `Shared`, а пока живёт только на сервере:

   ```swift
   import Vapor

   /// Temporary: server only. Moves to the Shared package in block 65.
   struct CheckinDTO: Content {
       var id: UUID
       var day: Date
       var mood: Int
       var sleepHours: Double
       var note: String
       var updatedAt: Date
   }
   ```
3. Создай `Backend/Sources/App/Controllers/CheckinController.swift`:

   ```swift
   import Fluent
   import Vapor

   struct CheckinController: RouteCollection {
       func boot(routes: any RoutesBuilder) throws {
           let checkins = routes.grouped("checkins")
           checkins.get(use: index)
       }

       /// GET /checkins
       @Sendable
       func index(req: Request) async throws -> [CheckinDTO] {
           // TODO: for now return an empty array. Block 64 reads the database here.
       }
   }
   ```
4. Зарегистрируй контроллер в `Backend/Sources/App/routes.swift` среди открытых маршрутов, рядом с `AuthController`: `try app.register(collection: CheckinController())`. В блоке 64 он переедет в защищённую группу.
5. `mise run backend:run`, затем `curl -i localhost:8080/checkins`. Ответ `200`, тело `[]`, заголовок `content-type: application/json`.
6. **Сломай и почини.** `curl -i -X POST localhost:8080/checkins`. Маршрута нет, ответ `404` с `{"error":"not_found"}`. Сравни с ответом Vapor по умолчанию в проекте Hello: `curl -i -X POST localhost:8080/hello`. Разница в теле — работа `APIErrorMiddleware`.

**Готово, когда.** `curl localhost:8080/checkins` возвращает `[]`, `swift build` в `Backend` проходит без предупреждений.

### Блок 63. Fluent: модель и миграция

*≈30 мин · Справочник: [G3](handbook.md#g3-fluent-модели-миграции-запросы)*

**Цель.** В базе есть таблица `checkins` с уникальностью `(user_id, day)`, а модель `Checkin` умеет превращаться в `CheckinDTO`.

**Изучи (≈10 мин).**
- Карточка [G3](handbook.md#g3-fluent-модели-миграции-запросы).
- Документация: [Fluent: Model](https://docs.vapor.codes/fluent/model/), [Fluent: Migrations](https://docs.vapor.codes/fluent/migration/).
- Код Buzz: [`Backend/Sources/App/Models/Entry.swift:5`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift#L5) — модель-класс и почему `@unchecked Sendable`; [`:12`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift#L12) — `@Parent`; [`:59`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift#L59) — модель базы и DTO это разные типы.
- Код Buzz: [`Backend/Sources/App/Migrations/CreateEntry.swift:7`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Migrations/CreateEntry.swift#L7) — внешний ключ на пользователя; [`Backend/Sources/App/Migrations/CreateUserToken.swift:10`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Migrations/CreateUserToken.swift#L10) — ограничение уникальности.
- Сравни с SwiftData из блока 32: там схему выводит фреймворк, а здесь каждое изменение схемы — отдельная миграция.

**Сделай руками (≈20 мин).**
1. Создай `Backend/Sources/App/Models/Checkin.swift`:

   ```swift
   import Fluent
   import Foundation

   final class Checkin: Model, @unchecked Sendable {
       static let schema = "checkins"

       /// Set by the client, so a check-in can be created offline.
       @ID(key: .id)
       var id: UUID?

       @Parent(key: "user_id")
       var user: User

       /// Start of the day on the user's device.
       @Field(key: "day")
       var day: Date

       // TODO: mood (Int, key "mood"), sleepHours (Double, key "sleep_hours"), note (String, key "note")

       /// The time of the last edit on the device. A plain field, not @Timestamp:
       /// the client sets it, and sync compares it later.
       @Field(key: "updated_at")
       var updatedAt: Date

       init() {}

       init(id: UUID, userID: User.IDValue, day: Date, mood: Int, sleepHours: Double, note: String, updatedAt: Date) {
           self.id = id
           self.$user.id = userID
           // TODO: the other fields
       }

       func toDTO() throws -> CheckinDTO {
           // TODO: CheckinDTO(id: try requireID(), ...)
       }
   }
   ```
2. Создай `Backend/Sources/App/Migrations/CreateCheckin.swift`:

   ```swift
   import Fluent

   struct CreateCheckin: AsyncMigration {
       func prepare(on database: any Database) async throws {
           try await database.schema(Checkin.schema)
               .id()
               .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
               .field("day", .datetime, .required)
               // TODO: mood .int, sleep_hours .double, note .string, all .required
               .field("updated_at", .datetime, .required)
               // One check-in per user per day. The database guards it even if the code forgets.
               .unique(on: "user_id", "day")
               .create()
       }

       func revert(on database: any Database) async throws {
           try await database.schema(Checkin.schema).delete()
       }
   }
   ```
3. В `configure.swift` добавь `app.migrations.add(CreateCheckin())` последней строкой после `CreateEntry()`: таблица ссылается на `users`, а откат идёт в обратном порядке.
4. Перезапусти `mise run backend:run`: в режиме разработки миграции применяются при старте. Проверь базу: `sqlite3 Backend/db.sqlite ".schema checkins"` и `sqlite3 Backend/db.sqlite "select name from _fluent_migrations;"`.
5. **Сломай и почини.** Переименуй в `CreateCheckin` поле `note` в `comment` и перезапусти сервер. Схема в базе не изменилась: миграция уже записана в `_fluent_migrations` и второй раз не выполняется. Верни `note`. Правило: опубликованную миграцию не правят, для изменения пишут новую (`AddXToCheckin`). Пока таблица только твоя, можно откатить: `cd Backend && swift run App migrate --revert`, потом снова запустить сервер.

**Готово, когда.** `.schema checkins` показывает все семь колонок и `UNIQUE` на `user_id, day`. `swift build` проходит.

**Если застрял.** Если база запуталась окончательно, удали `Backend/db.sqlite` и запусти сервер: миграции и каталог напитков создадутся заново.

### Блок 64. POST и запросы Fluent

*≈30 мин · Справочник: [G3](handbook.md#g3-fluent-модели-миграции-запросы), [G2](handbook.md#g2-роуты-контроллеры-content)*

**Цель.** `POST /checkins` создаёт или обновляет отметку по `id`, `GET /checkins` отдаёт отметки пользователя от новых к старым, `DELETE /checkins/:id` удаляет.

**Изучи (≈10 мин).**
- Документация: [Fluent: Query](https://docs.vapor.codes/fluent/query/), [Content](https://docs.vapor.codes/basics/content/).
- Код Buzz: [`Backend/Sources/App/Controllers/EntryController.swift:24`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L24) — фильтр по пользователю, необязательный период и сортировка до [`:35`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L35); [`:47`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L47) — повторная отправка не создаёт дубль; [`:70`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L70) — удаление только своей записи.
- Код Buzz: [`Backend/Sources/App/DTOs/DateQuery.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/DateQuery.swift#L6) — дата из query-параметра.

**Сделай руками (≈20 мин).**
1. Перенеси регистрацию `CheckinController` в `routes.swift` в защищённую группу `protected`. Как она работает, разберём в блоке 68; пока достаточно, что `req.auth.require(User.self)` даёт текущего пользователя.
2. Дополни `boot`: `checkins.post(use: save)` и `checkins.delete(":id", use: delete)`.
3. Чтение:

   ```swift
   struct IndexQuery: Content {
       var from: String?
   }

   /// GET /checkins?from=  (from is inclusive)
   @Sendable
   func index(req: Request) async throws -> [CheckinDTO] {
       let userID = try req.auth.require(User.self).requireID()
       let params = try req.query.decode(IndexQuery.self)

       let query = Checkin.query(on: req.db).filter(\.$user.$id == userID)
       // TODO: if `from` parses with isoDate(params.from, name: "from"), keep days >= from
       return try await query.sort(\.$day, .descending).all().map { try $0.toDTO() }
   }
   ```
4. Создание или правка по `id` (upsert):

   ```swift
   /// POST /checkins
   /// Create or update by id. Sending the same check-in again is safe.
   @Sendable
   func save(req: Request) async throws -> CheckinDTO {
       let userID = try req.auth.require(User.self).requireID()
       let input = try req.content.decode(CheckinDTO.self)

       if let existing = try await Checkin.find(input.id, on: req.db) {
           // TODO (block 68): who owns `existing`? For now we trust the client.
           // TODO: copy day, mood, sleepHours, note, updatedAt from input, then `try await existing.save(on: req.db)`
           return try existing.toDTO()
       }

       let checkin = Checkin(
           id: input.id,
           userID: userID,
           day: input.day,
           mood: input.mood,
           sleepHours: input.sleepHours,
           note: input.note,
           updatedAt: input.updatedAt
       )
       try await checkin.create(on: req.db)
       return try checkin.toDTO()
   }
   ```
5. `delete` напиши сам по образцу `EntryController.delete`: найти по `id` и пользователю, иначе `Abort(.notFound)`, удалить, вернуть `.noContent`. Мягкое удаление здесь не нужно.
6. Проверь через `curl`. Токен возьми из регистрации (`docs/backend/README.md`, раздел 8):

   ```bash
   ID=$(uuidgen)
   curl -s -X POST localhost:8080/checkins -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
     -d "{\"id\":\"$ID\",\"day\":\"2026-10-17T21:00:00Z\",\"mood\":4,\"sleepHours\":7.5,\"note\":\"ok\",\"updatedAt\":\"2026-10-18T19:00:00Z\"}"
   curl -s localhost:8080/checkins -H "Authorization: Bearer $TOKEN"
   ```
   Отправь тот же `POST` с `"note":"edited"`: в списке по-прежнему одна запись, заметка новая.

**Готово, когда.** Создание, повторная отправка, правка, чтение с `?from=` и удаление работают через `curl`, в таблице нет дублей.

**Если застрял.** `"day":"2026-10-17T21:00:00Z"` — это полночь 18 октября по Москве в UTC. Сервер хранит момент времени, а не «календарный день».

### Блок 65. Общий DTO в Shared

*≈30 мин · Справочник: [G6](handbook.md#g6-общий-пакет-shared-с-dto)*

**Цель.** `CheckinDTO` живёт в пакете `Shared`, сервер делает его `Content`, и ты видел, как компилятор ловит расхождение контракта.

**Изучи (≈10 мин).**
- Карточка [G6](handbook.md#g6-общий-пакет-shared-с-dto), раздел «Правила».
- Документация: [Creating a standalone Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode).
- Код Buzz: [`Shared/Package.swift:5`](https://github.com/disavle/buzz/blob/main/Shared/Package.swift#L5) — пакет без зависимостей; [`Shared/Sources/Shared/EntryDTO.swift:42`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/EntryDTO.swift#L42) — DTO с `id` от клиента и явным `public init`.
- Код Buzz: [`Backend/Sources/App/DTOs/Shared+Content.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/Shared+Content.swift#L6) — `@retroactive Content`; [`iOS/Tuist/Package.swift:20`](https://github.com/disavle/buzz/blob/main/iOS/Tuist/Package.swift#L20) — как пакет видит iOS.

**Сделай руками (≈20 мин).**
1. Создай `Shared/Sources/Shared/CheckinDTO.swift`:

   ```swift
   import Foundation

   /// One evening check-in. Body of POST /checkins and items of GET /checkins.
   /// The client generates `id`, so a check-in can be created offline and sent again safely.
   public struct CheckinDTO: Codable, Sendable, Equatable {
       public var id: UUID
       /// Start of the day on the user's device.
       public var day: Date
       /// 1...5
       public var mood: Int
       public var sleepHours: Double
       public var note: String
       /// The last edit on the device.
       public var updatedAt: Date

       // TODO: a public memberwise init. Swift makes the automatic one internal,
       // so without it neither the server nor the app can create the DTO.
   }
   ```
2. Удали временный `Backend/Sources/App/DTOs/CheckinDTO.swift`. В `Shared+Content.swift` добавь `extension CheckinDTO: @retroactive Content {}`. Подумай, почему нужен `@retroactive`: и тип, и протокол объявлены не в модуле `App`.
3. В `Checkin.swift` и `CheckinController.swift` добавь `import Shared`. `swift build` в `Backend` должен пройти.
4. **Сломай и почини.** Переименуй в `Shared` поле `sleepHours` в `sleep` и собери `Backend`. Компилятор покажет `Checkin.toDTO()` и создание модели в контроллере. Так же сломалось бы приложение, если бы оно уже использовало DTO (оно начнёт в блоке 71). Верни имя.
5. Запомни, чего компилятор не поймал: в теле `curl` из прошлого блока ключ `"sleepHours"` — строка. Клиент с новым именем поля и старый сервер не договорятся, и это всплывёт только во время работы. Поэтому DTO общий, а клиент и сервер собираются из одного коммита.
6. Проверь, что iOS-проект по-прежнему собирается: `mise run generate`, затем сборка в Xcode.

**Готово, когда.** На сервере нет своего `CheckinDTO`, `curl` из блока 64 работает как раньше, iOS-проект собирается.

### Блок 66. Codable и даты

*≈30 мин · Справочник: [C8](handbook.md#c8-codable-json-и-деньги-в-decimal)*

**Цель.** Ты видел три типичные поломки JSON (формат даты, потеря долей секунды, нет ключа) и понимаешь, почему деньги в Buzz хранятся в `Decimal` и копейках.

**Изучи (≈10 мин).**
- Карточка [C8](handbook.md#c8-codable-json-и-деньги-в-decimal).
- Документация: [Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/encoding-and-decoding-custom-types), [JSONDecoder.DateDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/datedecodingstrategy).
- Код Buzz: [`Shared/Sources/Shared/Coding.swift:4`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/Coding.swift#L4) — единый формат дат; [`Backend/Sources/App/configure.swift:37`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L37) — сервер использует те же кодировщики.
- Код Buzz: [`Backend/Sources/App/Models/Entry.swift:74`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/Entry.swift#L74) — `Decimal` в копейки и обратно; [`Backend/Sources/App/Errors/APIErrorMiddleware.swift:44`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L44) — что сервер отвечает на `DecodingError`.

**Сделай руками (≈20 мин).**
1. Создай Playground (macOS, Blank). Скопируй туда `CheckinDTO` без `public` и расширения `JSONEncoder.buzz` и `JSONDecoder.buzz` из `Coding.swift`.
2. Закодируй отметку: `let encoder = JSONEncoder.buzz; encoder.outputFormatting = [.prettyPrinted, .sortedKeys]`, выведи строку. Посмотри, как выглядят `day` и `UUID`.
3. **Сломай и почини.** Раскодируй тот же JSON обычным `JSONDecoder()` без стратегии. Выведи ошибку целиком: `catch { print(error) }`. Найди в ней `typeMismatch`, ключ `day` и ожидаемый `Double`. Без общей стратегии клиент и сервер ждут разный формат.
4. **Сломай и почини.** Создай DTO с `updatedAt: .now`, закодируй и раскодируй через `.buzz`. Сравни `==`: результат `false`. Выведи `timeIntervalSince1970` обеих дат: ISO 8601 в этой стратегии отбрасывает доли секунды. Отсюда два правила: в тестах даты с целыми секундами, а при сравнении `updatedAt` в синхронизации нельзя ждать точного равенства с исходником.
5. Убери из JSON ключ `note` и раскодируй: `keyNotFound`. Обсуди с собой: должна ли заметка быть необязательной (`String?`)? Для Buzz оставляем пустую строку.
6. Деньги: выведи `0.1 + 0.2 == 0.3` для `Double` и для `Decimal`. Затем прочитай `Money.toMinor` и ответь, почему в базе цена лежит целым числом копеек.
7. На сервере: отправь `curl` из блока 64 с `"day":"2026-10-17"` (без времени). Ответ `400` с `invalid_body`, в `reason` то же описание `DecodingError`.

**Готово, когда.** Ты воспроизвёл три ошибки декодирования и можешь объяснить, почему тестовые даты в блоке 70 будут с целыми секундами.

### Блок 67. Валидация запроса

*≈30 мин · Справочник: [G2](handbook.md#g2-роуты-контроллеры-content), [G5](handbook.md#g5-ошибки-кодами-и-свой-middleware)*

**Цель.** Сервер отклоняет настроение вне 1–5, сон вне 0–24 и слишком длинную заметку ответом `400` с кодом ошибки.

**Изучи (≈10 мин).**
- Документация: [Validation](https://docs.vapor.codes/basics/validation/).
- Код Buzz: [`Backend/Sources/App/DTOs/Shared+Content.swift:34`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/DTOs/Shared+Content.swift#L34) — диапазоны для `Int` и `Double`, строка с ограничением длины.
- Код Buzz: [`Backend/Sources/App/Controllers/EntryController.swift:44`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/EntryController.swift#L44) — проверка до декодирования.
- Код Buzz: [`Backend/Sources/App/Errors/APIErrorMiddleware.swift:8`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L8) — как имя поля превращается в код ошибки, [`:39`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L39) — запасной `validation_failed`.

**Сделай руками (≈20 мин).**
1. В `Backend/Sources/App/DTOs/Shared+Content.swift` добавь правила. `Shared` ничего не знает про Vapor, поэтому валидация живёт на сервере:

   ```swift
   extension CheckinDTO: @retroactive Validatable {
       public static func validations(_ validations: inout Validations) {
           validations.add("mood", as: Int.self, is: .range(1...5))
           // TODO: "sleepHours" as Double in 0...24
           // TODO: "note" as String, at most 500 characters
       }
   }
   ```
2. В `CheckinController.save` первой строкой после пользователя вызови `try CheckinDTO.validate(content: req)`.
3. Проверь через `curl` с `"mood":7`, `"sleepHours":30` и заметкой из 600 символов (`python3 -c 'print("a"*600)'`). Ответ `400`, код `validation_failed`, в `reason` понятно, какое поле не прошло.
4. **Сломай и почини.** В правилах опечатайся: `"moood"`. Теперь любой корректный запрос получает `400`: ключ обязательный, а в теле его нет. Компилятор опечатку не видит, ключи здесь строки. Верни правильное имя и запомни: после переименования поля в DTO (блок 65) надо проверить и эту строку.
5. Сравни правила сервера с `SaveCheckinUseCase` из блока 51: граница сна одна и та же в двух местах. Сервер — источник правды, клиент проверяет раньше ради быстрой ошибки без сети. Подумай, где описать границы один раз (например, константы в `Shared`), и реши, стоит ли.

**Готово, когда.** Три неправильных запроса получают `400 validation_failed`, правильный проходит.

### Блок 68. Авторизация по токену

*≈30 мин · Справочник: [G4](handbook.md#g4-авторизация-по-bearer-токену)*

**Цель.** Ты понимаешь, как запрос с `Bearer`-токеном превращается в пользователя, и `/checkins` никогда не отдаёт и не меняет чужие отметки.

**Изучи (≈10 мин).**
- Карточка [G4](handbook.md#g4-авторизация-по-bearer-токену).
- Документация: [Authentication](https://docs.vapor.codes/security/authentication/), разделы про bearer и `ModelTokenAuthenticatable`.
- Код Buzz: [`Backend/Sources/App/Models/UserToken.swift:30`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/UserToken.swift#L30) — как Fluent находит пользователя по токену; [`:35`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/UserToken.swift#L35) — место для срока жизни.
- Код Buzz: [`Backend/Sources/App/Controllers/AuthController.swift:34`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Controllers/AuthController.swift#L34) — вход и выдача токена; [`Backend/Sources/App/Models/User.swift:47`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Models/User.swift#L47) — сам токен это 32 случайных байта.
- Код Buzz: [`Backend/Sources/App/routes.swift:12`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/routes.swift#L12) — `authenticator()` только пытается найти пользователя, `guardMiddleware()` отказывает, если не нашёл.

**Сделай руками (≈20 мин).**
1. Зарегистрируй двух пользователей и сохрани токены в `ALICE` и `BOB`:

   ```bash
   ALICE=$(curl -s -X POST localhost:8080/auth/register -H "Content-Type: application/json" \
     -d '{"email":"alice@buzz.app","password":"password123"}' | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
   # TODO: the same for BOB with bob@buzz.app
   ```
2. Алиса создаёт отметку (команда из блока 64 с `$ALICE`). Боб читает `GET /checkins` со своим токеном: должен прийти `[]`.
3. **Сломай и почини.** Боб отправляет `POST /checkins` с `id` отметки Алисы и своей заметкой. Прочитай отметки Алисы: заметка Боба там. Это дыра, оставленная в блоке 64 комментарием `TODO (block 68)`. Закрой её в `save`:

   ```swift
   if let existing = try await Checkin.find(input.id, on: req.db) {
       // Someone else's check-in: answer as if it does not exist, do not reveal it.
       guard existing.$user.id == userID else { throw Abort(.notFound) }
       // ... update as before
   }
   ```
4. Проверь, что `DELETE` с токеном Боба для отметки Алисы даёт `404`, а без токена вообще — `401` с `unauthorized`.
5. Посмотри в базу: `sqlite3 Backend/db.sqlite "select value, user_id from user_tokens;"`. Токен хранится открытым текстом, поэтому утечка базы равна утечке сессий. Подумай, что изменилось бы, если хранить хеш токена.
6. Если осталось время: сделай срок жизни токена. В `UserToken.isValid` верни `createdAt` моложе 30 дней и проверь, что старый токен даёт `401` (дату можно состарить через `sqlite3 ... update`).

**Готово, когда.** Боб не видит, не меняет и не удаляет отметки Алисы, запрос без токена получает `401`.

### Блок 69. Коды ошибок и middleware

*≈30 мин · Справочник: [G5](handbook.md#g5-ошибки-кодами-и-свой-middleware)*

**Цель.** Вторая отметка за тот же день получает `409` с кодом `checkin_duplicate_day`, и ты понимаешь, как любая ошибка становится JSON-ответом.

**Изучи (≈10 мин).**
- Карточка [G5](handbook.md#g5-ошибки-кодами-и-свой-middleware).
- Документация: [Errors](https://docs.vapor.codes/basics/errors/), [Middleware](https://docs.vapor.codes/advanced/middleware/).
- Код Buzz: [`Shared/Sources/Shared/APIError.swift:16`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/APIError.swift#L16) — список кодов; [`:42`](https://github.com/disavle/buzz/blob/main/Shared/Sources/Shared/APIError.swift#L42) — неизвестный код раскодируется в `.unknown`, старое приложение не падает.
- Код Buzz: [`Backend/Sources/App/Errors/APIError.swift:6`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIError.swift#L6) — ошибка со статусом и кодом; [`Backend/Sources/App/Errors/APIErrorMiddleware.swift:20`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L20) — middleware ловит всё, что бросили дальше по цепочке; [`:34`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/Errors/APIErrorMiddleware.swift#L34) — сопоставление ошибки и ответа.
- Код Buzz: [`iOS/Modules/Networking/Sources/APIClient.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L9) — где этот код окажется на клиенте.

**Сделай руками (≈20 мин).**
1. В `Shared/Sources/Shared/APIError.swift` добавь группу кодов:

   ```swift
   // Check-ins
   case checkinDuplicateDay = "checkin_duplicate_day"
   ```
2. В `CheckinController.save` перед созданием и перед правкой проверь день:

   ```swift
   /// Another check-in of this user on the same day (not this one).
   let sameDay = try await Checkin.query(on: req.db)
       .filter(\.$user.$id == userID)
       .filter(\.$day == input.day)
       .filter(\.$id != input.id)
       .first()
   // TODO: if sameDay is not nil, throw APIError(.conflict, .checkinDuplicateDay)
   ```
3. Проверка в коде не спасает от двух одновременных запросов: оба увидят пустую базу. Подстраховывает уникальный индекс из блока 63. Оберни запись в базу, чтобы и нарушение индекса давало тот же код:

   ```swift
   do {
       try await checkin.create(on: req.db)
   } catch let error as any DatabaseError where error.isConstraintFailure {
       throw APIError(.conflict, .checkinDuplicateDay)
   }
   ```
4. Проверь `curl`: две отметки с разными `id` и одинаковым `day`. Вторая получает `409` и `{"error":"checkin_duplicate_day","reason":"checkin_duplicate_day"}`.
5. **Сломай и почини.** Вместо `APIError(.conflict, .checkinDuplicateDay)` брось `Abort(.conflict)`. Ответ: `409` с кодом `internal`. Найди в `APIErrorMiddleware.map` ветку, которая так решила. Клиент не сможет показать понятный текст. Верни `APIError`.
6. Собери iOS-проект: новый случай в `APIErrorCode` ничего не ломает, потому что клиент нигде не делает по нему исчерпывающий `switch`. Перевод кода на клиенте появится в блоке 71.

**Готово, когда.** Дубль дня получает `409 checkin_duplicate_day` и через проверку, и через индекс (проверь, временно закомментировав проверку из шага 2).

**Если застрял.** `DatabaseError` объявлен в Fluent; если компилятор его не видит, проверь `import Fluent` в файле контроллера.

### Блок 70. Тесты сервера

*≈30 мин · Справочник: [G7](handbook.md#g7-тесты-vapor-vaportesting), [F1](handbook.md#f1-swift-testing)*

**Цель.** `Backend/Tests/AppTests/CheckinTests.swift` проверяет создание и чтение, `401`, дубль дня, правку по `id` и валидацию, и `mise run backend:test` зелёный.

**Изучи (≈10 мин).**
- Карточка [G7](handbook.md#g7-тесты-vapor-vaportesting).
- Документация: [Vapor: Testing](https://docs.vapor.codes/advanced/testing/).
- Код Buzz: [`Backend/Tests/AppTests/AppTests.swift:10`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L10) — приложение в памяти на каждый тест; [`:26`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L26) — регистрация и токен; [`:43`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L43) — проверка кода ошибки; [`:161`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L161) — повторная отправка без дубля; [`:204`](https://github.com/disavle/buzz/blob/main/Backend/Tests/AppTests/AppTests.swift#L204) — чужая запись.
- Код Buzz: [`Backend/Sources/App/configure.swift:13`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L13) — в тестах SQLite в памяти и пароли без Bcrypt.

**Сделай руками (≈20 мин).**
1. Создай `Backend/Tests/AppTests/CheckinTests.swift`. Хелперы в `AppTests` объявлены `private`, поэтому скопируй `withApp`, `register` и `expectError` в новый сьют (вынести их в общий файл можно потом, если захочется).

   ```swift
   @testable import App
   import Fluent
   import Foundation
   import Shared
   import Testing
   import VaporTesting

   @Suite("Check-ins API", .serialized)
   struct CheckinTests {
       /// 2025-10-17 00:00 UTC. Whole seconds on purpose: ISO 8601 drops fractions (block 66).
       let day = Date(timeIntervalSince1970: 1_760_659_200)

       // TODO: copy withApp, register and expectError from AppTests.swift

       func checkin(id: UUID = UUID(), mood: Int = 4, note: String = "") -> CheckinDTO {
           CheckinDTO(id: id, day: day, mood: mood, sleepHours: 7.5, note: note, updatedAt: day.addingTimeInterval(75_600))
       }

       @Test("Create and read back")
       func createAndRead() async throws {
           try await withApp { app in
               let token = try await register(app)
               let input = checkin()

               try await app.testing().test(.POST, "checkins", beforeRequest: { req in
                   req.headers.bearerAuthorization = .init(token: token)
                   try req.content.encode(input)
               }, afterResponse: { res async throws in
                   #expect(res.status == .ok)
               })

               try await app.testing().test(.GET, "checkins", beforeRequest: { req in
                   req.headers.bearerAuthorization = .init(token: token)
               }, afterResponse: { res async throws in
                   #expect(try res.content.decode([CheckinDTO].self) == [input])
               })
           }
       }

       @Test("No token, no check-ins")
       func unauthorized() async throws {
           // TODO: GET checkins without a header -> 401, code .unauthorized
       }

       @Test("A second check-in for the same day is a conflict")
       func duplicateDay() async throws {
           // TODO: POST checkin(), then POST checkin() with a new id -> 409, .checkinDuplicateDay
       }

       @Test("Sending the same id again updates, not duplicates")
       func upsert() async throws {
           // TODO: POST checkin(id: x, note: "a"), POST checkin(id: x, note: "b"),
           // expect Checkin.query(on: app.db).count() == 1 and the note is "b"
       }

       @Test("Bad values are rejected", arguments: [0, 6])
       func badMood(mood: Int) async throws {
           // TODO: POST checkin(mood: mood) -> 400, .validationFailed
       }
   }
   ```
2. Запусти `mise run backend:test` или только новый сьют: `cd Backend && swift test --filter CheckinTests`.
3. **Сломай и почини.** В `checkin(...)` замени `day` на `Date.now` и запусти `createAndRead`. Тест упадёт на сравнении массивов: доли секунды потерялись по дороге (блок 66). Верни фиксированную дату.
4. Добавь тест на изоляцию пользователей по образцу `foreignEntry`: Боб не видит отметку Алисы и получает `404` при попытке её удалить.

**Готово, когда.** Все тесты сервера зелёные, старые 8 и твои новые, включая параметризованный тест валидации.

**Если застрял.** Если тесты из двух сьютов мешают друг другу, запусти `swift test --no-parallel` и посмотри, пропала ли проблема. Тогда причина в общем состоянии, например в `ContentConfiguration.global`, которое меняет `configure`.

---

## Часть 8. Сеть и синхронизация

Отметки учатся ходить на сервер: эндпоинты и методы клиента, фейковый сервер для тестов, очередь неотправленного в SwiftData и проход синхронизации в `SyncEngine`. В конце проверишь всё в офлайне: отметки копятся на телефоне и уходят на сервер, когда возвращается сеть.

### Блок 71. APIClient для отметок

*≈30 мин · Справочник: [C1](handbook.md#c1-сетевой-слой-на-urlsession-asyncawait), [C8](handbook.md#c8-codable-json-и-деньги-в-decimal)*

**Цель.** В модуле `Networking` есть эндпоинты `GET/POST/DELETE /checkins`, методы `fetchCheckins()`, `saveCheckin(_:)`, `deleteCheckin(id:)` и маппинг `Checkin` ↔ `CheckinDTO`, всё покрыто тестами.

**Изучи (≈10 мин).**
- Карточка [C1](handbook.md#c1-сетевой-слой-на-urlsession-asyncawait) целиком, особенно «Было → стало»: тип ответа зашит в описание эндпоинта.
- Документация: [URLSession](https://developer.apple.com/documentation/foundation/urlsession).
- Код Buzz: [`iOS/Modules/Networking/Sources/Endpoint.swift:9`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L9) — один тип `Endpoint<Response>` на все запросы. Посмотри, как эндпоинты разложены по расширениям `where Response == ...` ([`:56`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L56) `createEntry`, [`:62`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/Endpoint.swift#L62) `deleteEntry` с `EmptyResponse`).
- Код Buzz: [`iOS/Modules/Networking/Sources/APIClient.swift:18`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L18) — у протокола один метод `send`. Затем [`:56`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/APIClient.swift#L56): как статус ответа превращается в `APIError` (401 → `.unauthorized`, остальное → `.server(code, status:)`, где код берётся из тела `{"error": "..."}`).
- Код Buzz: [`iOS/Modules/Networking/Sources/DTOMapping.swift:34`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/DTOMapping.swift#L34) — DTO и доменная модель встречаются только здесь.
- Важная мысль на будущее: экраны «Самочувствия» по-прежнему **не вызывают сеть**. Они читают SwiftData, а сетевые методы будет вызывать только `SyncEngine` (блок 74).

**Сделай руками (≈20 мин).**
1. В `iOS/Modules/Networking/Sources/Endpoint.swift` добавь два расширения рядом с `createEntry`, а `deleteCheckin` положи в уже существующее расширение `where Response == EmptyResponse`:

   ```swift
   public extension Endpoint where Response == [CheckinDTO] {
       /// GET /checkins: all checkins of the logged-in user.
       static var checkins: Self { Self(method: .get, path: "/checkins") }
   }

   public extension Endpoint where Response == CheckinDTO {
       /// POST /checkins: create or update by id (upsert), so sending again does not duplicate.
       static func saveCheckin(_ dto: CheckinDTO) -> Self {
           // TODO: method .post, path "/checkins", body encoded with JSONEncoder.buzz (see createEntry)
       }
   }

   // Inside the existing `extension Endpoint where Response == EmptyResponse`:
   static func deleteCheckin(_ id: UUID) -> Self {
       // TODO: method .delete, path "/checkins/<uuid>" (see deleteEntry)
   }
   ```
2. Создай `iOS/Modules/Networking/Sources/APIClient+Checkins.swift`. Это расширение протокола: методы сразу появятся и у настоящего клиента, и у `MockAPIClient`.

   ```swift
   import Foundation
   import Shared

   /// Named calls for checkins: `api.fetchCheckins()` reads better than `api.send(.checkins)`.
   /// An extension on the protocol, so every APIClient gets them for free.
   public extension APIClient {
       func fetchCheckins() async throws(APIError) -> [CheckinDTO] {
           try await send(.checkins)
       }

       func saveCheckin(_ dto: CheckinDTO) async throws(APIError) -> CheckinDTO {
           // TODO: send the .saveCheckin endpoint
       }

       func deleteCheckin(id: UUID) async throws(APIError) {
           // TODO: send .deleteCheckin(id); we do not need the EmptyResponse, so `_ = try await ...`
       }
   }
   ```
   `throws(APIError)` — типизированная ошибка из блока 46: в `catch` у вызывающего сразу `APIError`, без `as?`.
3. В `iOS/Modules/Networking/Sources/DTOMapping.swift` добавь маппинг в обе стороны:

   ```swift
   public extension Checkin {
       init(_ dto: CheckinDTO) {
           // TODO: copy id, day, mood, sleepHours, note, updatedAt
       }

       var dto: CheckinDTO {
           // TODO: the same fields in the other direction
       }
   }
   ```
4. Создай `iOS/Modules/Networking/Tests/CheckinEndpointTests.swift`:

   ```swift
   import Foundation
   import Shared
   import Testing

   @testable import Networking

   @Test("DELETE /checkins/:id puts the id into the path")
   func deleteCheckinPath() {
       let id = UUID()
       let endpoint = Endpoint<EmptyResponse>.deleteCheckin(id)
       #expect(endpoint.method == .delete)
       #expect(endpoint.path == "/checkins/\(id.uuidString)")
   }

   @Test("POST /checkins body decodes back to the same DTO")
   func saveCheckinBody() throws {
       // Whole seconds on purpose: ISO 8601 in JSON drops fractions of a second.
       let date = Date(timeIntervalSince1970: 1_760_000_000)
       let dto = CheckinDTO(id: UUID(), day: date, mood: 4, sleepHours: 7.5, note: "ok", updatedAt: date)
       let body = try #require(Endpoint<CheckinDTO>.saveCheckin(dto).body)
       // TODO: decode body with JSONDecoder.buzz and #expect it equals dto
   }

   @Test("checkin_duplicate_day from the server decodes into its case")
   func duplicateDayCode() throws {
       // TODO: like unknownErrorCode() in NetworkingTests.swift, but expect .checkinDuplicateDay
   }
   ```
5. **Сломай и почини.** В `saveCheckinBody` замени `date` на `.now` и запусти тест. Прочитай, почему даты не равны (дробные секунды теряются при кодировании, это тема блока 66). Верни как было.
6. Запусти тесты: Test navigator (Cmd+6) → `NetworkingTests` → запуск. Перед коммитом прогони всё через `mise run test`.

**Готово, когда.** Три новых теста зелёные, старые тесты `NetworkingTests` тоже. Проект собирается без предупреждений Swift 6.

**Если застрял.** Готовый образец всех трёх шагов лежит в Buzz для записей: `createEntry` и `deleteEntry` в `Endpoint.swift`, `Entry.init(_:drink:)` и `createDTO` в `DTOMapping.swift`. Если тест на код ошибки не компилируется, проверь, как ты назвал случай в `APIErrorCode` в блоке 69 (`Shared/Sources/Shared/APIError.swift`).

### Блок 72. Фейковый сервер для отметок

*≈30 мин · Справочник: [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api), [A9](handbook.md#a9-mutex-и-synchronization-защита-данных-без-актора)*

**Цель.** `MockAPIClient` умеет `GET/POST/DELETE /checkins` и ведёт себя как твой сервер: upsert по id, одна отметка в день, удаление; это проверено тестами без бэкенда.

**Изучи (≈10 мин).**
- Карточка [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api): «Что и зачем» и «Было → стало». Абзац про адрес сервера пока можно пропустить, он понадобится в блоке 80.
- Документация: [Mutex](https://developer.apple.com/documentation/synchronization/mutex).
- Код Buzz: [`iOS/Modules/Networking/Sources/MockAPIClient.swift:14`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L14) — всё «серверное» состояние в одной структуре под `Mutex` ([`:21`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L21)). Роутер — один `switch` по методу и пути ([`:55`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L55)). Идемпотентный POST — [`:74`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L74). `seedRemote` ([`:45`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Networking/Sources/MockAPIClient.swift#L45)) кладёт запись «как будто с другого устройства».
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:54`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L54) — где выбирается фейк по `BUZZ_MOCK_API=1`.
- Ограничение линтера: [`.swiftlint.yml:34`](https://github.com/disavle/buzz/blob/main/.swiftlint.yml#L34) — тело функции не длиннее 80 строк (с `--strict` предупреждение тоже валит линт). `send(_:)` уже около 70 строк, поэтому новые ветки выносим в отдельные функции.

**Сделай руками (≈20 мин).**
1. В `State` внутри `MockAPIClient.swift` добавь `var checkins: [UUID: CheckinDTO] = [:]`.
2. Рядом с `seedRemote` добавь `public func seedRemoteCheckin(_ checkin: CheckinDTO)` — тот же приём для отметок. Он понадобится в тестах синхронизации.
3. В `switch` метода `send(_:)` перед `default:` добавь три ветки. Сама логика живёт в помощниках, ветки остаются короткими:

   ```swift
   case (.get, "/checkins"):
       result = state.withLock { $0.checkins.values.sorted { $0.day > $1.day } }

   case (.post, "/checkins"):
       result = try saveCheckin(decode(CheckinDTO.self, endpoint.body))

   case (.delete, let path) where path.hasPrefix("/checkins/"):
       try deleteCheckin(path: path)
       result = EmptyResponse()
   ```
4. В конце файла добавь помощники. Обрати внимание: внутри `withLock` мы не бросаем ошибку, а возвращаем `nil`, и бросаем уже снаружи. Так тип ошибки остаётся `APIError`, и компилятору не нужно выводить тип ошибки замыкания.

   ```swift
   // MARK: - Checkins
   // Split out of send(_:) to keep it under SwiftLint's function_body_length.

   private extension MockAPIClient {
       /// Upsert by id, like the real server. Only one checkin per day.
       func saveCheckin(_ dto: CheckinDTO) throws(APIError) -> CheckinDTO {
           let saved: CheckinDTO? = state.withLock { state in
               // TODO: if another checkin (different id) has the same `day`, return nil
               // TODO: otherwise store dto by its id and return it
           }
           // Use the same status your CheckinController returns for this code (block 69).
           guard let saved else { throw .server(.checkinDuplicateDay, status: 409) }
           return saved
       }

       func deleteCheckin(path: String) throws(APIError) {
           let id = UUID(uuidString: String(path.dropFirst("/checkins/".count)))
           let removed: CheckinDTO? = state.withLock { state in
               // TODO: remove by id and return what was removed (nil if nothing)
           }
           // TODO: if nothing was removed, throw .server(.notFound, status: 404), like Vapor's Abort(.notFound)
       }
   }
   ```
5. Создай `iOS/Modules/Networking/Tests/MockCheckinTests.swift` с тремя тестами: два сохранения одного id дают одну запись с последними данными; вторая отметка с другим id за тот же день бросает ошибку; после `deleteCheckin(id:)` список пуст. Каркас второго:

   ```swift
   @Test("A second checkin for the same day is rejected")
   func duplicateDay() async throws {
       let api = MockAPIClient()
       let day = Calendar.current.startOfDay(for: .now)
       _ = try await api.saveCheckin(
           CheckinDTO(id: UUID(), day: day, mood: 4, sleepHours: 7, note: "", updatedAt: .now)
       )
       let other = CheckinDTO(id: UUID(), day: day, mood: 2, sleepHours: 5, note: "", updatedAt: .now)

       await #expect(throws: APIError.server(.checkinDuplicateDay, status: 409)) {
           try await api.saveCheckin(other)
       }
   }
   ```
6. По правилам из [`Mocks/README.md`](https://github.com/disavle/buzz/blob/main/Mocks/README.md) добавь примеры для документации: `Mocks/api/checkin-save.request.json` и `Mocks/api/checkins.response.json` (даты ISO 8601 в UTC, как в `entry-create.request.json`).
7. Прогони `mise run lint`: проверь, что `send(_:)` не стал длиннее лимита.

**Готово, когда.** Тесты `MockCheckinTests` зелёные, `mise run lint` чистый, в `api.calls` видны строки вроде `"POST /checkins"`.

**Если застрял.** Если `withLock` не компилируется, проверь, что замыкание возвращает одно и то же опциональное значение во всех ветках и ничего не бросает. Сравнивать дни можно через `==`: в DTO `day` уже начало дня.

### Блок 73. Outbox: состояние синхронизации

*≈30 мин · Справочник: [C4](handbook.md#c4-offline-first-синхронизация-outbox), [C2](handbook.md#c2-swiftdata)*

**Цель.** Каждая правка отметки помечается `pending`, удаление уже отправленной — `pendingDelete`, и об этом узнаёт только движок синхронизации через `localEdits`.

**Изучи (≈10 мин).**
- Карточка [C4](handbook.md#c4-offline-first-синхронизация-outbox): «Ключевые идеи» и «Подвох: бесконечный цикл». Второе прямо про сигнал `localEdits`.
- Документ проекта: [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 2 «Данные: что добавить в модели».
- Код Buzz: [`iOS/Modules/Persistence/Sources/Models/SyncState.swift:11`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/SyncState.swift#L11) и почему он хранится строкой: [`iOS/Modules/Persistence/Sources/Models/EntryModel.swift:42`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L42), [`:58`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/Models/EntryModel.swift#L58).
- Код Buzz: [`iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift:47`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L47) (`add` ставит `pending` и шлёт оба сигнала) и [`:55`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L55) (`delete`: неотправленное удаляется сразу, отправленное становится `pendingDelete`).

**Сделай руками (≈20 мин).**
1. В `iOS/Modules/Persistence/Sources/Models/CheckinModel.swift` добавь поле и вычисляемое свойство, как в `EntryModel`:

   ```swift
   public var syncStateRaw: String = SyncState.pending.rawValue

   public var syncState: SyncState {
       get { SyncState(rawValue: syncStateRaw) ?? .pending }
       set { syncStateRaw = newValue.rawValue }
   }
   ```
   Добавь в `init` параметр `syncState: SyncState = .pending`.
2. Новое поле — это новая схема. Вспомни блоки 31–32 и сделай третью версию в `iOS/Modules/Persistence/Sources/Migrations.swift`:
   - текущую `CheckinModel` (с `note`, без `syncStateRaw`) заморозь вложенной копией в `BuzzSchemaV2`, как ты делал для V1;
   - заведи `BuzzSchemaV3` с живыми классами и добавь лёгкую стадию.

   ```swift
   enum BuzzSchemaV3: VersionedSchema {
       static var versionIdentifier: Schema.Version { Schema.Version(3, 0, 0) }
       static var models: [any PersistentModel.Type] {
           [DrinkModel.self, EntryModel.self, CheckinModel.self]
       }
   }

   // In BuzzMigrationPlan:
   // TODO: add BuzzSchemaV3.self to `schemas`
   // TODO: add .lightweight(fromVersion: BuzzSchemaV2.self, toVersion: BuzzSchemaV3.self) to `stages`
   ```
   Не забудь, что `PersistenceContainer.schema` должен указывать на последнюю версию. Подумай, что получат старые отметки: у поля значение по умолчанию `pending`, значит, при первой синхронизации всё накопленное до этого уйдёт на сервер. Нам это и нужно.
3. В `SwiftDataCheckinRepository` проверь `init`: он должен принимать `broadcaster` и `localEdits`, как [`SwiftDataEntryRepository.swift:25`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Sources/SwiftDataEntryRepository.swift#L25). Если репозиторий всё ещё на макросе `@ModelActor`, перепиши его руками, как в том файле: макрос генерирует только `init(modelContainer:)`, и сигналы в него не передать. В [`iOS/App/Sources/AppDependencies.swift:41`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L41) передай те же `changes` и `localEdits`, что и репозиторию записей.
4. Поменяй `save` и `delete`:

   ```swift
   public func save(_ checkin: Checkin) async throws {
       if let model = try fetch(id: checkin.id) {
           model.update(from: checkin)
           // TODO: the user changed it, so it must be sent again: syncState = .pending
       } else {
           modelContext.insert(CheckinModel(checkin, syncState: .pending))
       }
       // TODO: set updatedAt = .now on the model: on conflict the newer updatedAt wins
       try modelContext.save()
       broadcaster.yield()   // screens reload
       localEdits.yield()    // the sync engine sends it
   }

   public func delete(id: UUID) async throws {
       guard let model = try fetch(id: id) else { return }
       // TODO: pending (the server never saw it) -> delete the row for real
       // TODO: otherwise -> syncState = .pendingDelete, updatedAt = .now (the row stays until the server confirms)
       try modelContext.save()
       broadcaster.yield()
       localEdits.yield()
   }
   ```
5. Скрой `pendingDelete` от экранов. Во всех выборках репозитория (`all()`, выборка за 7 дней из блока 33) добавь условие:

   ```swift
   let hidden = SyncState.pendingDelete.rawValue   // a plain local value: #Predicate captures it
   // ... #Predicate { $0.syncStateRaw != hidden && <your old condition> }
   ```
6. Напиши `iOS/Modules/Persistence/Tests/CheckinSyncStateTests.swift` по образцу [`PersistenceTests.swift:20`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Persistence/Tests/PersistenceTests.swift#L20): сохранённая отметка в базе `pending`; отметка, вставленная как `synced`, после `delete` пропала из `all()`, но строка в базе осталась с `pendingDelete`.

**Готово, когда.** Тест зелёный. Приложение на симуляторе с данными прошлых блоков открывается без падения миграции, отметки на месте.

**Если застрял.** Падение при старте с ошибкой про несовместимую модель значит, что хэш V2 изменился: проверь, что в `BuzzSchemaV2.models` стоит замороженная копия, а не живой `CheckinModel`. Совсем крайний случай: удали приложение с симулятора и поставь заново.

### Блок 74. Синхронизация отметок

*≈30 мин · Справочник: [C4](handbook.md#c4-offline-first-синхронизация-outbox), [A3](handbook.md#a3-actor-mainactor-sendable-и-swift-6)*

**Цель.** Каждый проход `SyncEngine` отправляет неотправленные отметки и удаления, забирает список с сервера и применяет его, не трогая то, что ещё ждёт отправки.

**Изучи (≈10 мин).**
- Документ проекта: [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 3, особенно «Две детали, на которых легко ошибиться».
- Код Buzz: [`iOS/Modules/Sync/Sources/SyncEngine.swift:90`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L90) — один проход: сначала отправить, потом забрать. [`:110`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L110) — отправка очереди, [`:124`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L124) — 404 на удаление считается успехом.
- Код Buzz: [`iOS/Modules/Sync/Sources/SyncStore.swift:73`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L73) (`markSynced(_:ifUpdatedAt:)`) и [`:125`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncStore.swift#L125) (`applyEntries`: «pending побеждает», «свежий `updatedAt` побеждает»).
- Отличие отметок от записей: `/sync` отдаёт только изменения и «надгробия» удалённого, а `GET /checkins` отдаёт **полный список**. Поэтому удаление на другом устройстве видно так: отметки нет в ответе, а у нас она `synced`.
- Второе отличие: на сервере уникальность `(user_id, day)`. Если удалить отметку за понедельник и сразу создать новую за тот же день, удаление должно уйти **раньше**, иначе сервер ответит `checkin_duplicate_day`.

**Сделай руками (≈20 мин).**
1. В `iOS/Modules/Sync/Sources/SyncStore.swift` добавь раздел `// MARK: - Checkins`:

   ```swift
   public func pendingCheckins() throws -> [Checkin] {
       let pending = SyncState.pending.rawValue
       let descriptor = FetchDescriptor<CheckinModel>(predicate: #Predicate { $0.syncStateRaw == pending })
       return try modelContext.fetch(descriptor).map(\.asDomain)
   }

   public func pendingCheckinDeletes() throws -> [UUID] {
       // TODO: like pendingDeletes(), for CheckinModel
   }

   public func markCheckinSynced(_ id: UUID, ifUpdatedAt updatedAt: Date) throws {
       // TODO: like markSynced(_:ifUpdatedAt:): only if updatedAt did not change while sending
   }

   /// Removes the row for real: after the server confirmed a delete,
   /// or when the server already has another checkin for that day.
   public func removeCheckinRow(_ id: UUID) throws {
       // TODO: fetch by id, modelContext.delete, save
   }

   /// GET /checkins returns the full list. Never touch rows that still wait to be sent.
   public func applyCheckins(_ remote: [CheckinDTO]) throws {
       let locals = try modelContext.fetch(FetchDescriptor<CheckinModel>())
       let localById = Dictionary(uniqueKeysWithValues: locals.map { ($0.id, $0) })
       let remoteIds = Set(remote.map(\.id))

       for dto in remote {
           if let local = localById[dto.id] {
               // TODO: skip if local is not .synced (pending wins)
               // TODO: skip if dto.updatedAt <= local.updatedAt; otherwise local.update(from: Checkin(dto))
           } else {
               // TODO: insert CheckinModel(Checkin(dto), syncState: .synced)
           }
       }
       for local in locals where local.syncState == .synced && !remoteIds.contains(local.id) {
           // TODO: deleted on another device -> delete locally
       }
       guard modelContext.hasChanges else { return }  // quiet when nothing changed
       try modelContext.save()
       changes.yield()
   }
   ```
2. В `iOS/Modules/Sync/Sources/SyncEngine.swift` добавь два шага и вызови их из `pass()`: `pushCheckins()` после `pushPending()`, `pullCheckins()` после `pullChanges()`.

   ```swift
   /// Deletes go first: the server allows one checkin per day.
   private func pushCheckins() async throws {
       for id in try await store.pendingCheckinDeletes() {
           do {
               try await api.deleteCheckin(id: id)
           } catch APIError.server(.notFound, _) {
               // Already gone on the server: a success for us.
           }
           try await store.removeCheckinRow(id)
       }
       for checkin in try await store.pendingCheckins() {
           do {
               _ = try await api.saveCheckin(checkin.dto)
               // TODO: markCheckinSynced(checkin.id, ifUpdatedAt: checkin.updatedAt)
           } catch APIError.server(.checkinDuplicateDay, _) {
               // Another device already sent a checkin for this day. The server's one wins:
               // TODO: remove our row; the server's checkin arrives in pullCheckins()
           }
       }
   }

   private func pullCheckins() async throws {
       // TODO: fetchCheckins() and applyCheckins(_:)
   }
   ```
   Без обработки `checkinDuplicateDay` одна такая отметка валила бы каждый проход, и записи о банках тоже перестали бы синхронизироваться.
3. В [`iOS/Modules/Sync/Tests/SyncEngineTests.swift:13`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift#L13) добавь в `Fixture` поле `let checkins: SwiftDataCheckinRepository` с теми же `changes` и `localEdits`. Напиши два теста по образцу [`:32`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift#L32) и [`:44`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Tests/SyncEngineTests.swift#L44): «сохранённая отметка уходит `POST /checkins` и больше не pending» (`try await f.store.pendingCheckins().isEmpty`) и «отметка с другого устройства скачивается» (`f.api.seedRemoteCheckin(...)`).
4. **Сломай и почини.** Напиши третий тест: отметка за сегодня синхронизирована; удаляешь её, создаёшь новую за тот же день с новым id, `syncNow()`; на «сервере» (`f.api.fetchCheckins()`) ровно одна отметка с новым id. Потом поменяй в `pushCheckins` циклы местами, запусти тест и посмотри, что сломалось. Верни порядок.

**Готово, когда.** Все тесты `SyncEngineTests` зелёные, включая старые: в частности, `syncDoesNotRetriggerItself` показывает, что проход синхронизации не считается правкой пользователя.

**Если застрял.** Если `#Predicate` ругается на `SyncState`, проверь, что сравниваешь со строкой `syncStateRaw`, а значение достал в локальную константу до предиката. `CheckinModel` не `Sendable`, поэтому наружу из `SyncStore` отдаём только `Checkin` и `UUID`; это тема блока 30.

### Блок 75. Офлайн-сценарий и NWPathMonitor

*≈30 мин · Справочник: [C5](handbook.md#c5-nwpathmonitor-и-триггеры-синхронизации), [A4](handbook.md#a4-asyncstream-и-asyncsequence)*

**Цель.** В строке отметки видно «не отправлено», и ты своими глазами видишь, как три правки без сети уходят на сервер, когда сеть возвращается.

**Изучи (≈10 мин).**
- Карточка [C5](handbook.md#c5-nwpathmonitor-и-триггеры-синхронизации).
- Документация: [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor).
- Документ проекта: [`docs/client/sync.md`](https://github.com/disavle/buzz/blob/main/docs/client/sync.md), раздел 4 «Когда запускается» и раздел 5 «Что видит пользователь».
- Код Buzz: [`iOS/Modules/Sync/Sources/NetworkMonitor.swift:19`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L19) — колбэк превращается в `AsyncStream`, повторы отбрасываются ([`:33`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/NetworkMonitor.swift#L33)). Подписка движка — [`iOS/Modules/Sync/Sources/SyncEngine.swift:81`](https://github.com/disavle/buzz/blob/main/iOS/Modules/Sync/Sources/SyncEngine.swift#L81), возврат из фона — [`iOS/App/Sources/SceneDelegate.swift:53`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/SceneDelegate.swift#L53).
- Код Buzz: значок в строке записи [`iOS/Modules/TodayFeature/Sources/TodayView.swift:121`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayView.swift#L121) и pull to refresh через синхронизацию [`iOS/Modules/TodayFeature/Sources/TodayViewModel.swift:59`](https://github.com/disavle/buzz/blob/main/iOS/Modules/TodayFeature/Sources/TodayViewModel.swift#L59).

**Сделай руками (≈20 мин).**
1. Песочница (5 мин). Новый macOS Playground в Xcode:

   ```swift
   import Network
   import PlaygroundSupport

   PlaygroundPage.current.needsIndefiniteExecution = true

   let monitor = NWPathMonitor()
   monitor.pathUpdateHandler = { path in
       // TODO: print path.status and path.availableInterfaces.map(\.type)
   }
   monitor.start(queue: DispatchQueue(label: "sandbox.monitor"))
   ```
   Выключи и включи Wi-Fi на Mac, посмотри на вывод.
2. Добавь в `Checkin` поле `isSynced: Bool` (параметр `init` со значением по умолчанию `false`), как у `Entry`. В `CheckinModel.asDomain` заполни его из `syncState == .synced`, в `Checkin.init(_ dto:)` из блока 71 поставь `true`.
3. В `CheckinRow` покажи значок:

   ```swift
   if !checkin.isSynced {
       // Not an error, just "not sent yet": gray, like in TodayView.
       Image(systemName: "icloud.slash")
           .imageScale(.small)
           .foregroundStyle(.secondary)
           .accessibilityLabel(Text("wellbeing.checkin.notSynced", bundle: .module))
   }
   ```
   Ключ `wellbeing.checkin.notSynced` добавь в `Localizable.xcstrings` (en «Not synced», ru «Не отправлено»). Добавь превью строки с `isSynced: false`.
4. Передай в `WellbeingViewModel` зависимость `any SyncService` и в `refresh()` вызывай `await sync.syncNow()`, как в `TodayViewModel`. В превью передавай `NoopSyncService()`.
5. Сценарий «нет сети». Запусти `buzz-dev` (или `mise run backend:run` и приложение из Xcode), войди в аккаунт. Выключи Wi-Fi на Mac. Сделай три правки: новая отметка, изменение старой, удаление ещё одной (если форма умеет выбирать день, лучше три новые отметки за три разных дня). Значки на месте, в логе сервера тишина. Включи Wi-Fi и смотри в `Backend/server.log`: должны прийти `DELETE` и `POST /checkins`, значки пропадут.
6. Сценарий «сеть есть, сервера нет». Останови сервер (`buzz-stop` или Ctrl+C), измени отметку. Через 2 секунды проход упадёт, в «Настройках» статус «не удалось». Запусти сервер снова: ничего не происходит. Почему? `NWPathMonitor` знает про сеть, а не про сервер. Сделай pull to refresh или сверни и разверни приложение (триггер из `SceneDelegate`), и правка уйдёт.
7. Проверь базу сервера: `sqlite3 Backend/db.sqlite "select day, mood, note from checkins;"`.

**Готово, когда.** Значок появляется без сети и исчезает после синхронизации; в базе сервера ровно те отметки, что на экране.

**Если застрял.** Симулятор иногда поздно замечает смену сети Mac. Тогда повтори шаг на iPhone (блок 80) или подожди несколько секунд. Если значок не пропадает, проверь, что `markCheckinSynced` шлёт `changes.yield()`, иначе экран не узнает о смене состояния. Если успел: посчитай неотправленные отметки в `SyncStore.pendingCount()`, чтобы «Настройки» показывали и их.

---

## Часть 9. Инфраструктура и выпуск

Фича уходит в настоящую жизнь: сервер на Postgres и в Docker-образе, линтеры, PR с CI, деплой на Render, обновления зависимостей и релиз с CHANGELOG. В конце соберёшь весь путь отметки от кнопки до базы и обратно на второе устройство.

### Блок 76. Postgres в Docker

*≈30 мин · Справочник: [G8](handbook.md#g8-postgres-в-docker-и-деплой), [G3](handbook.md#g3-fluent-модели-миграции-запросы)*

**Цель.** Сервер Buzz работает с Postgres в Docker на твоём Mac, и ты видишь таблицу `checkins` с её ограничением уникальности через `psql`.

**Изучи (≈10 мин).**
- Карточка [G8](handbook.md#g8-postgres-в-docker-и-деплой).
- Документация: [Fluent: overview](https://docs.vapor.codes/fluent/overview/), [Vapor: Environment](https://docs.vapor.codes/basics/environment/).
- Код Buzz: [`Backend/Sources/App/configure.swift:13`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L13) — три ветки выбора базы. С [`:17`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L17) включается Postgres, если задан `DATABASE_URL`. [`:50`](https://github.com/disavle/buzz/blob/main/Backend/Sources/App/configure.swift#L50) — в режиме разработки миграции идут при старте.
- Мысль: модели и миграции не меняются, меняется только драйвер. Это и проверим.

**Сделай руками (≈20 мин).**
1. Поставь Docker Desktop или OrbStack, если ещё нет. Подними базу (именованный том, чтобы данные пережили перезапуск контейнера):

   ```bash
   docker run --name buzz-pg -d \
     -e POSTGRES_PASSWORD=buzz -e POSTGRES_DB=buzz \
     -p 5432:5432 -v buzz-pg-data:/var/lib/postgresql/data \
     postgres:17
   docker ps
   ```
2. Запусти сервер с Postgres. Переменная окружения доходит до задачи mise. `sslmode=disable`, потому что у локальной базы нет TLS (у Neon будет `require`):

   ```bash
   DATABASE_URL="postgres://postgres:buzz@localhost:5432/buzz?sslmode=disable" mise run backend:run
   ```
   В логе должны пройти все миграции, включая твою `CreateCheckin`.
3. Посмотри на таблицы:

   ```bash
   docker exec -it buzz-pg psql -U postgres -d buzz
   ```
   ```sql
   \dt
   \d checkins
   SELECT * FROM _fluent_migrations;
   ```
   Найди в `\d checkins` уникальный индекс по `(user_id, day)` и внешний ключ на `users`.
4. Создай пользователя и отметку через `curl` (в macOS 15 есть `jq`; если нет, скопируй токен руками):

   ```bash
   TOKEN=$(curl -s -X POST localhost:8080/auth/register \
     -H 'Content-Type: application/json' \
     -d '{"email":"pg@buzz.app","password":"12345678"}' | jq -r .token)
   curl -s -X POST localhost:8080/checkins -H "Authorization: Bearer $TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"id":"'$(uuidgen)'","day":"2026-10-17T21:00:00Z","mood":4,"sleepHours":7.5,"note":"pg","updatedAt":"2026-10-18T19:00:00Z"}'
   ```
   В `psql`: `SELECT day, mood, sleep_hours, note FROM checkins;`.
5. **Сломай и почини.** Повтори `curl` с новым `uuidgen` и тем же `day`: сервер ответит `checkin_duplicate_day`. Теперь вставь дубль прямо в базу через `INSERT` в `psql` и прочитай ошибку Postgres про `unique constraint`. Правило живёт в базе, а сервер только переводит его в понятный клиенту код.
6. Запусти приложение в симуляторе, войди как `pg@buzz.app` и проверь, что отметка доехала. Когда закончишь: `docker stop buzz-pg` (данные останутся в томе, `docker start buzz-pg` вернёт базу).

**Готово, когда.** `\d checkins` показывает уникальный индекс, отметка из приложения видна в `SELECT`, а `mise run backend:test` по-прежнему зелёный (тесты всё так же на SQLite в памяти).

**Если застрял.** `connection refused` — контейнер не запущен или порт 5432 занят другим Postgres (`lsof -i :5432`). Если сервер падает на миграции, которая прошла на SQLite, ищи разницу типов: Postgres строже относится к типам колонок.

### Блок 77. Docker-образ сервера

*≈30 мин · Справочник: [G9](handbook.md#g9-деплой-docker-multi-stage-ghcr-deploy-hook-12-factor)*

**Цель.** Ты собрал образ сервера из `Backend/Dockerfile`, запустил контейнер с SQLite и с Postgres из блока 76 и понимаешь каждую стадию сборки.

**Изучи (≈10 мин).** Сначала запусти сборку (шаг 1), она идёт долго, и читай, пока она работает.
- Карточка [G9](handbook.md#g9-деплой-docker-multi-stage-ghcr-deploy-hook-12-factor), «Новые понятия».
- Документация: [Docker: multi-stage builds](https://docs.docker.com/build/building/multi-stage/), [Vapor: Docker](https://docs.vapor.codes/deploy/docker/).
- Код Buzz: [`Backend/Dockerfile:14`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L14) — стадия сборки. [`:27`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L27)–[`:29`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L29) — сначала только манифесты и `resolve`, чтобы Docker закэшировал зависимости. [`:51`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L51) — лёгкая стадия запуска, [`:61`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L61) — не root, [`:67`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L67) — `AUTO_MIGRATE`.
- Код Buzz: [`.dockerignore:3`](https://github.com/disavle/buzz/blob/main/.dockerignore#L3) — сначала исключить всё, потом вернуть `Backend/` и `Shared/`.

**Сделай руками (≈20 мин).**
1. Из корня репозитория (контекст сборки — корень, потому что серверу нужен `Shared/`):

   ```bash
   docker build -f Backend/Dockerfile -t buzz-backend .
   docker image ls buzz-backend
   ```
   Сравни размер образа с образом `swift:6.2-noble` (`docker image ls swift`).
2. Останови локальный сервер, если он запущен (порт 8080), и запусти контейнер с SQLite внутри:

   ```bash
   docker run --rm -p 8080:8080 buzz-backend
   curl localhost:8080/health
   ```
3. Запусти тот же образ с базой из блока 76. Изнутри контейнера Mac виден как `host.docker.internal`:

   ```bash
   docker start buzz-pg
   docker run --rm -p 8080:8080 \
     -e DATABASE_URL="postgres://postgres:buzz@host.docker.internal:5432/buzz?sslmode=disable" \
     buzz-backend
   ```
   Отметка `pg@buzz.app` должна отдаваться через `GET /checkins`. Один образ, разные настройки из окружения: это и есть 12-factor.
4. Проверь `PORT`: `docker run --rm -e PORT=9090 -p 9090:9090 buzz-backend` и `curl localhost:9090/health`. Найди строку, которая это читает, в `configure.swift`.
5. **Сломай и почини.** В `.dockerignore` закомментируй строку `!Shared/` и пересобери. Прочитай, на какой строке Dockerfile упала сборка и почему. Верни файл: `git checkout .dockerignore`.
6. Кэш слоёв: поменяй комментарий в любом файле `Backend/Sources` и пересобери. Посмотри, какие шаги помечены `CACHED`. Верни изменение.

**Готово, когда.** `/health` отвечает из контейнера, контейнер с `DATABASE_URL` читает данные из Postgres, и ты можешь своими словами объяснить, зачем две стадии.

**Если застрял.** Первая сборка на Mac может идти 10–15 минут: компилируется Vapor со всеми зависимостями. Если не хватает памяти, увеличь её в настройках Docker Desktop.

### Блок 78. Линт и форматирование

*≈30 мин · Справочник: [H5](handbook.md#h5-swift-format-swiftlint-pre-commit), [H2](handbook.md#h2-mise-версии-инструментов-и-задачи)*

**Цель.** Весь код фичи проходит `mise run lint` и `mise run lint:imports`, и ты знаешь, как хуки останавливают коммит и пуш.

**Изучи (≈10 мин).**
- Карточка [H5](handbook.md#h5-swift-format-swiftlint-pre-commit).
- Документация: [swift-format](https://github.com/swiftlang/swift-format), [mise: tasks](https://mise.jdx.dev/tasks/).
- Код Buzz: задачи [`mise.toml:59`](https://github.com/disavle/buzz/blob/main/mise.toml#L59) (`format`), [`:63`](https://github.com/disavle/buzz/blob/main/mise.toml#L63) (`lint`: swift-format в строгом режиме, потом SwiftLint), [`:70`](https://github.com/disavle/buzz/blob/main/mise.toml#L70) (`lint:imports`).
- Код Buzz: [`.githooks/pre-commit:10`](https://github.com/disavle/buzz/blob/main/.githooks/pre-commit#L10) — линтер запускается, только если в коммите есть Swift-код или настройки линтеров; [`.githooks/run-lint:24`](https://github.com/disavle/buzz/blob/main/.githooks/run-lint#L24) — общий запуск и подсказка при ошибке. Правила: [`.swift-format`](https://github.com/disavle/buzz/blob/main/.swift-format) и [`.swiftlint.yml`](https://github.com/disavle/buzz/blob/main/.swiftlint.yml) (прочитай комментарии, почему часть правил выключена).
- Раздел «Git-хуки» в [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md#git-хуки).

**Сделай руками (≈20 мин).**
1. Проверь, что хуки включены: `git config core.hooksPath` должен вывести `.githooks`. Если пусто, `mise run setup:hooks`.
2. Прогони всё и запиши число замечаний:

   ```bash
   mise run lint
   mise run lint:imports
   ```
   `lint:imports` найдёт модули, которые фича импортирует, но не объявила зависимостью в `iOS/Project.swift`.
3. Почини: `mise run format` правит форматирование сам. Посмотри `git diff`, чтобы понять, что именно он поменял. Замечания SwiftLint правь руками.
4. **Сломай и почини.** В `WellbeingViewModel.swift` добавь строку с принудительным приведением, например `let n = (1 as Any) as! Int`, и сломай отступ у соседней строки. `git add` и `git commit -m "test: lint"`: хук остановит коммит. Прочитай, какие сообщения от swift-format, а какие от SwiftLint (`force_cast`). Почини и закоммить.
5. Попробуй `git commit --no-verify` с той же ошибкой, а затем `git push`: коммит прошёл, но `pre-push` не пустит его на GitHub. Откати учебный коммит (`git reset --soft HEAD~1`), почини и закоммить заново.

**Готово, когда.** `mise run lint` и `mise run lint:imports` выходят без ошибок, рабочий коммит прошёл через хук без `--no-verify`.

**Если застрял.** Хук из Xcode или GUI-клиента может не найти `mise`: смотри строку с `PATH` в `.githooks/run-lint`. Линтер проверяет файлы на диске, а не только застейдженное, поэтому незаконченную работу убери в `git stash`.

### Блок 79. PR и CI

*≈30 мин · Справочник: [H4](handbook.md#h4-github-actions), [H7](handbook.md#h7-github-flow-и-защита-main-rulesets)*

**Цель.** Открыт PR из `learn/wellbeing`, проверки `iOS` и `Backend` зелёные, и ты понимаешь, почему на PR с одной документацией они пропускаются.

**Изучи (≈10 мин).**
- Карточки [H4](handbook.md#h4-github-actions) и [H7](handbook.md#h7-github-flow-и-защита-main-rulesets).
- Документация: [GitHub Actions](https://docs.github.com/en/actions), [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets).
- Код Buzz: [`.github/workflows/ci.yml:19`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L19) — job `changes` с `dorny/paths-filter` отдаёт флаги `ios`, `backend`, `deploy`. [`:57`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L57) — условие job `iOS`: на PR только если тронут iOS-код. [`:82`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L82) — тесты сервера идут на Linux в контейнере `swift:6.4`. Комментарий в начале файла объясняет, почему пропущенный job считается пройденным.
- [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md): «Цикл», «Коммиты» (автор коммитов должен быть владельцем репозитория) и «Перед пушем».

**Сделай руками (≈20 мин).**
1. Перед пушем по `CONTRIBUTING.md`:

   ```bash
   git config user.email          # must be the repo owner
   mise run test
   mise run backend:test
   ```
2. Запушь ветку и открой PR:

   ```bash
   git push -u origin learn/wellbeing
   gh pr create --title "feat(wellbeing): evening check-in with offline sync" --fill
   gh pr checks --watch
   ```
3. Пока идёт CI, открой на GitHub вкладку Actions → свой запуск → job `Changes` → шаг фильтра. Найди, какие флаги стали `true`. Ответь себе: запустится ли сейчас `Deploy backend`? (Нет: условие на [`:95`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L95) требует `main`.)
4. Эксперимент с фильтром. От свежего `main` сделай ветку `docs/ci-experiment`, поменяй одну строку в `docs/`, открой черновик `gh pr create --draft --fill`. Убедись, что `iOS` и `Backend` пропущены, но PR всё равно можно влить. Закрой: `gh pr close --delete-branch`.
5. Если `Backend` упал только в CI, а локально зелёный, повтори Linux-окружение у себя (отдельная папка сборки, чтобы не смешать с macOS):

   ```bash
   docker run --rm -v "$PWD":/src -w /src swift:6.4 \
     swift test --package-path Backend --scratch-path /tmp/linux-build
   ```
6. Влей PR кнопкой **Squash and merge**, когда обе проверки зелёные. Заголовок PR станет сообщением коммита в `main`.

**Готово, когда.** PR влит в `main` одним коммитом, в истории `main` нет промежуточных коммитов ветки.

**Если застрял.** Если кнопка слияния неактивна, открой Settings → Rules → Rulesets и проверь, какие проверки требуются (шаг 4 в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md)). Если упали тесты iOS, артефакт `test-results` с результатами лежит на странице запуска.

### Блок 80. Деплой на Render

*≈30 мин · Справочник: [G9](handbook.md#g9-деплой-docker-multi-stage-ghcr-deploy-hook-12-factor), [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api)*

**Цель.** После слияния job `Deploy backend` выкатил новый образ, на Render работает `/checkins`, а отметка с iPhone видна на сервере.

**Изучи (≈10 мин).**
- Карточка [G9](handbook.md#g9-деплой-docker-multi-stage-ghcr-deploy-hook-12-factor), абзац «Деплой не на каждый пуш». Карточка [C7](handbook.md#c7-моки-и-фейковый-сервер-buzz_mock_api), абзац «Адрес сервера».
- Документация: [Render: Deploy hooks](https://render.com/docs/deploy-hooks), [Render: Free](https://render.com/docs/free).
- Код Buzz: [`.github/workflows/ci.yml:46`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L46) — фильтр `deploy`; [`:90`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L90) — job: сборка образа, пуш в `ghcr.io` с тегами `latest` и SHA коммита, [`:129`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L129) — вызов deploy hook с точным образом.
- Документ проекта: [`docs/backend/DEPLOY.md`](https://github.com/disavle/buzz/blob/main/docs/backend/DEPLOY.md), разделы «Настройка» и «Проверка». Если Render и Neon ещё не настроены, сначала пройди там шаги 1–5: это отдельный блок примерно на 30 минут.

**Сделай руками (≈20 мин).**
1. Слияние из блока 79 трогает `Backend/Sources` и `Shared/`, значит, деплой пошёл сам. Следи за ним:

   ```bash
   gh run list --branch main --limit 3
   gh run watch
   ```
   В job `Deploy backend` найди тег образа с SHA коммита и шаг «Deploy on Render».
2. В панели Render открой сервис → Logs. Найди строки миграций: при старте с `AUTO_MIGRATE=true` должна пройти `CreateCheckin`. В консоли Neon (Tables) появилась таблица `checkins`.
3. Проверь сервер. Первый запрос после сна идёт около минуты, это нормально:

   ```bash
   curl https://buzz-backend-latest.onrender.com/health
   TOKEN=$(curl -s -X POST https://buzz-backend-latest.onrender.com/auth/login \
     -H 'Content-Type: application/json' \
     -d '{"email":"<твой email>","password":"<пароль>"}' | jq -r .token)
   curl -s https://buzz-backend-latest.onrender.com/checkins -H "Authorization: Bearer $TOKEN"
   ```
   Если аккаунта на Render ещё нет, вместо `login` вызови `register`.
4. iPhone. Сборка на телефон по умолчанию ходит на Render ([`iOS/Project.swift:81`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L81)). Если ещё не ставил на телефон, пройди шаг 6 в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md) (`TUIST_TEAM_ID` в `mise.local.toml`, затем `mise run generate`). Войди тем же аккаунтом, добавь отметку, повтори последний `curl`: она там.
5. Второе устройство. Запусти симулятор с переменной схемы `BUZZ_API_URL = https://buzz-backend-latest.onrender.com` (Edit Scheme → Run → Environment Variables) и войди тем же аккаунтом. Отметка с телефона приходит при старте; потом измени её на телефоне и сделай pull to refresh в симуляторе.

**Готово, когда.** `GET /checkins` на Render возвращает отметку с iPhone, а симулятор показывает её же после синхронизации.

**Если застрял.** Шаг «Deploy on Render» пропущен — нет секрета `RENDER_DEPLOY_HOOK` (DEPLOY.md, шаг 5). Сервер на Render падает при старте — смотри Logs: чаще всего неверный `DATABASE_URL` или лишний `&channel_binding=require` (DEPLOY.md, шаг 1). Первый запрос с телефона упал по таймауту — подожди минуту: отметка осталась `pending` и уйдёт со следующим проходом.

### Блок 81. Renovate и обновления

*≈30 мин · Справочник: [H6](handbook.md#h6-renovate), [H7](handbook.md#h7-github-flow-и-защита-main-rulesets)*

**Цель.** Ты можешь по `renovate.json` предсказать, какой PR Renovate откроет на любое обновление и вольётся ли он сам.

**Изучи (≈10 мин).**
- Карточка [H6](handbook.md#h6-renovate).
- Документация: [Renovate: configuration options](https://docs.renovatebot.com/configuration-options/).
- Код Buzz: [`renovate.json:5`](https://github.com/disavle/buzz/blob/main/renovate.json#L5) — расписание по понедельникам; [`:8`](https://github.com/disavle/buzz/blob/main/renovate.json#L8)–[`:12`](https://github.com/disavle/buzz/blob/main/renovate.json#L12) — патчи и минорные версии инструментов (`mise`, GitHub Actions, гемы) идут одной группой `tools` и вливаются сами; [`:15`](https://github.com/disavle/buzz/blob/main/renovate.json#L15)–[`:17`](https://github.com/disavle/buzz/blob/main/renovate.json#L17) — SPM-пакеты отдельным PR без автослияния.
- Шаги 2–3 в [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md): без **Allow auto-merge** в настройках автослияние не работает.

**Сделай руками (≈20 мин).**
1. Найди, что Renovate уже сделал:

   ```bash
   gh issue list --search "Dependency Dashboard"
   gh pr list --author "app/renovate" --state all --limit 20
   ```
   Открой Dependency Dashboard: какие обновления ждут, какие заблокированы.
2. Открой один влитый PR группы `tools`. Кто его влил? Какие проверки он прошёл перед этим? Почему ruleset на `main` не помешал?
3. Предскажи и запиши в журнал, что будет с каждым обновлением (свой PR или группа, вольётся ли сам):
   - `tuist` 4.212.0 → 4.213.0 в `mise.toml`;
   - `ruby` 3.4.11 → 3.5.0;
   - `vapor` 4.115 → 4.116 в `Backend/Package.swift`;
   - `actions/checkout` v5 → v6 в `ci.yml`;
   - `FROM swift:6.2-noble` в `Backend/Dockerfile` (менеджер `dockerfile` в правилах не упомянут, значит, работают настройки `config:recommended`).
   Подсказка: мажорные обновления (`v5 → v6`) не попадают под `matchUpdateTypes` из правила.
4. Заметь: CI тестирует сервер на `swift:6.4` ([`ci.yml:82`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L82)), а образ собирается на `swift:6.2` ([`Dockerfile:14`](https://github.com/disavle/buzz/blob/main/Backend/Dockerfile#L14)). Подумай, чем это опасно и как это можно выровнять. Запиши вывод в журнал; если хочешь поправить, это отдельная ветка `chore/` и отдельный PR.
5. Если стоит Node.js, проверь конфиг валидатором Renovate: `npx --yes --package renovate -- renovate-config-validator`.

**Готово, когда.** В журнале пять предсказаний с объяснением, и ты нашёл в истории хотя бы один PR, который Renovate влил сам.

**Если застрял.** Если Renovate ещё не установлен, пройди шаг 2 в `SETUP.md` и вернись к блоку после ближайшего понедельника.

### Блок 82. CHANGELOG и релиз

*≈30 мин · Справочник: [H9](handbook.md#h9-релизы-changelog-и-github-release-по-тегу)*

**Цель.** В `CHANGELOG.md` есть раздел `0.2.0` про «Самочувствие», версия приложения 0.2.0, тег `v0.2.0` создал черновик релиза, и ты его опубликовал.

**Изучи (≈10 мин).**
- Карточка [H9](handbook.md#h9-релизы-changelog-и-github-release-по-тегу).
- Документация: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), [GitHub: About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).
- Код Buzz: [`CHANGELOG.md:10`](https://github.com/disavle/buzz/blob/main/CHANGELOG.md#L10) — `[Unreleased]` сверху, ниже версии; в каждой версии английская и русская части ([`:12`](https://github.com/disavle/buzz/blob/main/CHANGELOG.md#L12)).
- Код Buzz: [`.github/workflows/release.yml:31`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml#L31) — `awk` вырезает раздел версии; [`:36`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml#L36) — без раздела workflow падает; [`:45`](https://github.com/disavle/buzz/blob/main/.github/workflows/release.yml#L45) — черновик через `gh release create`.
- Раздел «Релизы» в [`CONTRIBUTING.md`](https://github.com/disavle/buzz/blob/main/CONTRIBUTING.md): версию меняют отдельным PR перед тегом.

**Сделай руками (≈20 мин).**
1. Ветка от свежего `main`: `git switch main && git pull && git switch -c chore/release-0.2.0`.
2. В `CHANGELOG.md` под `## [Unreleased]` добавь раздел `## [0.2.0] - <сегодняшняя дата>` с частями `### English` и `### Русский`: вкладка «Самочувствие», отметки с настроением, сном и заметкой, график против кофеина, напоминание, синхронизация `/checkins`. Почему 0.2.0, а не 0.1.2: новая функциональность без поломки старой — это минорная версия по SemVer.
3. В [`iOS/Project.swift:74`](https://github.com/disavle/buzz/blob/main/iOS/Project.swift#L74) поменяй `MARKETING_VERSION` на `"0.2.0"`.
4. Проверь вырезку локально той же командой, что в workflow:

   ```bash
   version=0.2.0
   awk -v header="## [$version]" '
     index($0, header) == 1 { found = 1; next }
     found && /^## \[/      { exit }
     found                  { print }
   ' CHANGELOG.md
   ```
   **Сломай:** поставь `version=9.9.9` и убедись, что вывод пуст. Именно это поймала бы проверка на `:36`, если бы тег опередил CHANGELOG.
5. Коммит `chore: release 0.2.0`, PR, слияние после зелёного CI.
6. Тег на `main` после слияния:

   ```bash
   git switch main && git pull
   git tag v0.2.0 && git push origin v0.2.0
   gh run watch
   gh release view v0.2.0
   ```
   Открой Releases на GitHub, проверь текст и нажми **Publish release**.

**Готово, когда.** На странице Releases опубликован `v0.2.0` с текстом из `CHANGELOG.md`.

**Если застрял.** Тег `v*` и тег `ios-v*` — разные вещи: первый создаёт релиз на GitHub, второй отправляет сборку в TestFlight (блок 83). Если тег поставил не на тот коммит, удали его до публикации: `git push origin :refs/tags/v0.2.0 && git tag -d v0.2.0`.

### Блок 83. fastlane и TestFlight (когда будет аккаунт разработчика)

*≈30 мин · Справочник: [H3](handbook.md#h3-fastlane-match-app-store-connect-api-key), [H4](handbook.md#h4-github-actions)*

**Цель.** Ты запускаешь lane `test` и понимаешь каждую строку lane `beta`; когда появится Apple Developer Program, знаешь точный порядок шагов до сборки в TestFlight.

**Изучи (≈10 мин).**
- Карточка [H3](handbook.md#h3-fastlane-match-app-store-connect-api-key).
- Документация: [fastlane: match](https://docs.fastlane.tools/actions/match/), [fastlane: App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/).
- Код Buzz: [`iOS/fastlane/Fastfile:28`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile#L28) — `test`; [`:39`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile#L39) — `certs` (один раз, локально); [`:46`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile#L46) — `beta`: ключ API, генерация проекта, match только для чтения, ручная подпись, номер сборки из TestFlight плюс один ([`:61`](https://github.com/disavle/buzz/blob/main/iOS/fastlane/Fastfile#L61)), загрузка.
- Код Buzz: [`.github/workflows/ci.yml:131`](https://github.com/disavle/buzz/blob/main/.github/workflows/ci.yml#L131) — job `TestFlight` на тег `ios-v*` после зелёного `iOS`, секреты в `env`.
- Документ проекта: [`docs/infra/SETUP.md`](https://github.com/disavle/buzz/blob/main/docs/infra/SETUP.md), раздел «Позже, после Apple Developer Program», шаги 8–13.

**Сделай руками (≈20 мин).**
1. Запусти тесты через fastlane и найди результат:

   ```bash
   mise run test                     # = cd iOS && bundle exec fastlane test
   open iOS/fastlane/test_output
   ```
   Открой `.xcresult` в Xcode и найди свои тесты отметок.
2. Посмотри, что ещё умеет проект:

   ```bash
   cd iOS
   bundle exec fastlane lanes
   bundle exec fastlane action match
   ```
3. **Сломай (безопасно).** Без секретов `bundle exec fastlane beta` упадёт на первом шаге, на ключе App Store Connect: в окружении нет `ASC_KEY_ID`. Прочитай ошибку. Так lane и задумана: без ключа она ничего не трогает.
4. Составь в журнале свой чек-лист «когда куплю аккаунт» по шагам 8–13 из `SETUP.md`: что сделать в App Store Connect, какой приватный репозиторий завести, какие переменные положить в `mise.local.toml`, какие семь секретов добавить в GitHub.
5. Когда аккаунт будет: `cd iOS && bundle exec fastlane certs` один раз, затем тег на `main`:

   ```bash
   git tag ios-v0.2.0 && git push origin ios-v0.2.0
   ```
   Версия 0.2.0 уже стоит в `Project.swift` после блока 82, номер сборки CI возьмёт сам.

**Готово, когда.** `mise run test` зелёный через fastlane, в журнале готов чек-лист для TestFlight. С аккаунтом: сборка 0.2.0 видна в TestFlight.

**Если застрял.** Если `bundle exec` ругается на отсутствующие гемы, выполни `mise run setup:gems`. Про `setup_ci` в начале Fastfile: он создаёт временную связку ключей только в CI, на Mac он не срабатывает.

### Блок 84. Итоги курса

*≈30 мин · Справочник: [C4](handbook.md#c4-offline-first-синхронизация-outbox), [E5](handbook.md#e5-модули-фичи-видят-только-domain), [G9](handbook.md#g9-деплой-docker-multi-stage-ghcr-deploy-hook-12-factor), [H8](handbook.md#h8-заведение-репозитория-чек-лист)*

**Цель.** В журнале есть схема пути одной отметки от кнопки «Сохранить» до Postgres и на второе устройство и пять строк для резюме.

**Изучи (≈10 мин).**
- Пролистай свой `docs/learning/journal.md` от блока 1: отметь три места, где было труднее всего.
- Карточка [H8](handbook.md#h8-заведение-репозитория-чек-лист) — чек-лист для следующего своего проекта: всё, что ты прошёл в Buzz, собранное в один список.
- Код Buzz: [`iOS/App/Sources/AppDependencies.swift:30`](https://github.com/disavle/buzz/blob/main/iOS/App/Sources/AppDependencies.swift#L30) — место, где все слои встречаются. Пройди глазами от него к каждому модулю.

**Сделай руками (≈20 мин).**
1. Нарисуй в журнале схему на Mermaid (GitHub её рисует). Заполни пропуски своими именами типов и файлов:

   ````markdown
   ```mermaid
   flowchart TD
       Form[CheckinForm: Save] --> VM[WellbeingViewModel]
       VM --> UC[SaveCheckinUseCase]
       UC --> Repo[SwiftDataCheckinRepository: pending]
       Repo -- changes --> VM
       Repo -- localEdits --> Engine[SyncEngine: 2 s debounce]
       Engine --> Store[SyncStore.pendingCheckins]
       Engine --> API[APIClient.saveCheckin]
       API -->|POST /checkins| Server[TODO: middleware, auth, controller]
       Server --> DB[(TODO: which database and where)]
       Device2[Second device] -->|TODO: which trigger| Pull[TODO]
       Pull --> Apply[SyncStore.applyCheckins]
       Apply -- changes --> Screen2[TODO]
   ```
   ````
2. Под схемой ответь в двух-трёх предложениях на каждый вопрос:
   - Почему экран никогда не ждёт сеть?
   - Что случится, если две правки придут, пока запрос в полёте?
   - Где в этой цепочке проверяется, что `mood` от 1 до 5, и почему в двух местах?
   - Что изменится в схеме, если сервер переедет с Render на другой хостинг?
3. Пять строк для резюме: факты и технологии, без оценок. Например: «Спроектировал офлайн-синхронизацию с очередью неотправленного (SwiftData, actor, AsyncStream), идемпотентный upsert на Vapor + Postgres». Сделай по строке на клиент, сервер, синхронизацию, инфраструктуру и тесты.
4. Выбери следующий шаг и запиши его в журнал: фоновая синхронизация через `BGAppRefreshTask` (вне MVP, см. [C5](handbook.md#c5-nwpathmonitor-и-триггеры-синхронизации)), экран на TCA вместо самописного Redux ([E4](handbook.md#e4-самописный-redux-и-потом-tca)) или новый проект с нуля по [H8](handbook.md#h8-заведение-репозитория-чек-лист).
5. Закоммить журнал в ветку `docs/learning-summary` и влей через PR. Пройди весь цикл без подсказок.

**Готово, когда.** Схема рисуется на GitHub без пропусков `TODO`, ответы и пять строк записаны, PR влит.

**Если застрял.** Если не можешь заполнить узел схемы, найди соответствующий блок в оглавлении курса и открой файл, который ты там писал. Это и есть повторение.
