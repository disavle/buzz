# Buzz: структура проекта, Tuist, mise, CI/CD

Как собрать репозиторий Buzz: Tuist генерирует Xcode-проект из Swift-манифестов, mise фиксирует версии инструментов, fastlane гоняет тесты и выкладывает в TestFlight, GitHub Actions запускает всё это на каждый PR. Готовые файлы лежат в [skeleton/](../../), их можно копировать в репозиторий как есть.

> **Не проверялось.** В облаке, где это писалось, нет macOS, Xcode и Swift, поэтому ни `tuist generate`, ни fastlane, ни workflow ни разу не запускались. API Tuist 4 и fastlane написаны по документации; первые запуски почти наверняка потребуют мелких правок.

---

## 1. Tuist: хорошая ли идея

**Да, для Buzz хорошая.** Коротко почему и чем платишь.

Что даёт именно здесь:
- **Модули одной строкой.** В Buzz уже 10 модулей, потом добавится виджет. В Tuist модуль описывается вызовом `Module("CatalogFeature", dependencies: ...)`, а таргет, тесты, bundle id и настройки получаются из одного хелпера. Руками в Xcode это десятки кликов на каждый модуль.
- **Проект как код.** `.xcodeproj` не хранится в git: нет конфликтов в `project.pbxproj`, все настройки видны в диффе, и Xcode-проект можно в любой момент пересоздать с нуля.
- **Граф и проверки.** `tuist graph` рисует зависимости модулей, `tuist inspect implicit-imports` ловит импорт модуля, который не объявлен в зависимостях. Это прямо помогает держать правило «фича видит только Domain».
- **Это навык с рынка.** Tuist используют многие большие iOS-команды, на собеседованиях про него спрашивают. Для учебного проекта это плюс сам по себе.

Чем платишь:
- **Ещё один слой.** После `git pull` или добавления нового файла нужно запустить `tuist generate` (либо перейти на buildable folders, см. ниже). Ошибки иногда приходится искать в сгенерированном проекте.
- **Зависимость от релизов Tuist.** После выхода новой версии Xcode иногда надо подождать обновления Tuist. Поэтому версия закрепляется в mise.
- **Платные плюшки.** Бинарный кэш модулей, выборочные тесты и превью сборок работают через сервер Tuist с аккаунтом. Для проекта такого размера они не нужны, всё ниже работает без аккаунта.

Альтернатива без Tuist: локальный SPM-пакет `BuzzKit` плюс обычный `.xcodeproj`, как сейчас описано в разделе 4 [архитектуры клиента](../client/architecture.md). Это тоже рабочий вариант, проще на старте, но таргеты приложения, виджета и их настройки останутся кликами в Xcode.

**Что меняется для архитектуры клиента.** Границы модулей те же, меняется только способ их объявить: вместо `BuzzKit/Package.swift` модули становятся таргетами Tuist в `iOS/Project.swift`. Раздел 4 в [architecture.md](../client/architecture.md) стоит поправить в ветке «SwiftUI-клиент». Я добавил модуль `SettingsFeature`: вкладка «Настройки» есть в экранах, а модуля в списке не было. Модуль `Sync` (офлайн-синхронизация, [sync.md](../client/sync.md)) тоже есть в манифестах.

Почему модули сделаны таргетами Tuist, а не SPM-пакетом, подключённым в Tuist: так у модулей работают ресурсы (цвета и шрифты в `DesignSystem`) с синтезом аксессоров, тесты получают нормальные схемы, и всё описано в одном месте. Внешние пакеты (у нас только `Shared`) Tuist подключает через `Tuist/Package.swift`.

---

## 2. Структура репозитория

Один монорепозиторий: клиент, бэкенд и общий пакет DTO рядом, чтобы `Shared` менялся в одном коммите для обеих сторон.

```
buzz/
├── mise.toml                    версии инструментов и задачи (mise run generate)
├── .swift-format, .swiftlint.yml
├── renovate.json                автообновление версий
├── .gitignore                   без *.xcodeproj / *.xcworkspace
├── .github/workflows/
│   └── ci.yml                   линт и тесты iOS и бэкенда на PR, TestFlight по тегу
├── Shared/                      SPM-пакет DTO (переезжает из backend/skeleton/Shared)
├── Backend/                     Vapor (Vapor-сервер), путь к Shared: "../Shared"
└── iOS/
    ├── Tuist.swift              глобальный конфиг: версия Swift, совместимые Xcode
    ├── Project.swift            приложение, модули, схема
    ├── Tuist/
    │   ├── Package.swift        внешние зависимости (Shared)
    │   └── ProjectDescriptionHelpers/Module.swift
    ├── App/
    │   ├── Sources/             AppDelegate, SceneDelegate, координаторы, сборка зависимостей
    │   ├── Resources/           Assets, launch screen
    │   └── Tests/
    ├── Modules/
    │   ├── Domain/{Sources,Tests}
    │   ├── Persistence/{Sources,Tests}
    │   ├── Networking/{Sources,Tests}
    │   ├── DesignSystem/{Sources,Resources}
    │   ├── Sync/{Sources,Tests}
    │   ├── TodayFeature/{Sources,Tests}
    │   ├── AddEntryFeature/Sources
    │   ├── CatalogFeature/Sources
    │   ├── StatsFeature/{Sources,Tests}
    │   └── SettingsFeature/Sources
    ├── Gemfile                  fastlane
    └── fastlane/{Fastfile,Appfile,Matchfile}
```

Граф зависимостей:

```
Buzz (app) ──► все модули
TodayFeature, AddEntryFeature, CatalogFeature, StatsFeature, SettingsFeature ──► Domain, DesignSystem
Persistence ──► Domain
Networking  ──► Domain, Shared (внешний SPM)
Sync        ──► Domain, Persistence, Networking
DesignSystem, Domain ──► ничего
```

Координаторы живут в `App`, потому что только приложение знает обо всех фичах. Позже виджет станет вторым таргетом `.appExtension` с зависимостями `Domain`, `Persistence`, `DesignSystem` и общей App Group.

---

## 3. Tuist-манифесты

Файлы: [Tuist.swift](../../iOS/Tuist.swift), [Project.swift](../../iOS/Project.swift), [Tuist/Package.swift](../../iOS/Tuist/Package.swift), [Module.swift](../../iOS/Tuist/ProjectDescriptionHelpers/Module.swift).

Ключевые решения:
- **Хелпер `Module`** в `ProjectDescriptionHelpers` собирает таргет фреймворка и, если нужно, таргет тестов. Добавить модуль: строка в `Project.swift` плюс папка `Modules/<Имя>/Sources`.
- **Static frameworks** для модулей: быстрее старт приложения, Tuist сам упаковывает ресурсы. Если SwiftUI-превью в каком-то модуле начнут капризничать, этот модуль можно временно переключить на `.framework`.
- **Одна схема `Buzz`** запускает тесты всех модулей; её же вызывает fastlane. Схемы на каждый модуль Tuist генерирует сам, их удобно гонять по одной.
- **Swift 6 и строгая конкурентность** включены на весь проект, в духе `Sendable`-моделей из архитектуры.
- **Team ID** не хранится в коде: Tuist читает переменную `TUIST_TEAM_ID` (`Environment.teamId`). Локально её задаёт `mise.local.toml`, в CI секрет.
- **Bundle id** `com.disavle.buzz` взят для примера, поменяй на свой.
- **Buildable folders.** В свежих версиях Tuist можно объявить папки как buildable folders Xcode 16+: тогда новые файлы подхватываются без `tuist generate`. В манифестах для надёжности стоят обычные глобы `Sources/**`; когда освоишься, можно попробовать.

Повседневные команды:

```bash
mise run generate         # всё после клона: инструменты, гемы, хук, проект
tuist edit                # открыть манифесты в Xcode с автодополнением
tuist graph               # картинка графа модулей
tuist inspect implicit-imports   # найти необъявленные импорты
```

---

## 4. mise и одна команда после клона

[mise.toml](../../mise.toml) в корне фиксирует версии и описывает задачи. После `git clone` нужна одна команда:

```bash
mise run generate
```

Она по цепочке:
1. ставит tuist, ruby и swiftlint нужных версий (настройка `task_run_auto_install`);
2. ставит гемы fastlane в `iOS/vendor/bundle` (задача `setup:gems`);
3. вешает git pre-commit хук, который запускает `mise run lint` (задача `setup:hooks`, встроенный `mise generate git-pre-commit`);
4. делает `tuist install` (SPM-зависимости, у нас `Shared`) и `tuist generate`.

Почему `mise run generate`, а не `mise generate`: у mise есть своя встроенная команда `generate`, и она перехватит вызов. Сокращённо можно писать `mise r generate`.

Остальные задачи (`mise tasks` покажет все):

| Задача | Что делает |
|---|---|
| `open` | открыть `Buzz.xcworkspace` в Xcode |
| `format` / `lint` | swift-format из тулчейна Xcode и SwiftLint |
| `lint:imports` | `tuist inspect implicit-imports`, ловит нарушение границ модулей |
| `test` | generate и все тесты iOS через fastlane |
| `graph`, `clean` | граф модулей, пересборка с нуля |
| `backend:run`, `backend:test` | Vapor локально и его тесты |

Ещё про mise:
- **Почему не brew:** brew ставит одну глобальную версию, а mise ставит версию из файла в репозитории, одинаковую у тебя и в CI. Tuist сам рекомендует ставить себя через mise.
- **Закрепи версии:** после первого `mise use tuist@latest ruby@3.3 swiftlint@latest` mise запишет точные номера.
- **Секреты** и `TUIST_TEAM_ID` лежат в `mise.local.toml`, этот файл в `.gitignore`.
- **Xcode** mise не ставит. Его версию проверяет Tuist (`compatibleXcodeVersions` в `Tuist.swift`), а в CI её выбирает `setup-xcode`.

---

## 4a. Что ещё современного стоит добавить

Уже лежит в скелете:
- **swift-format** ([.swift-format](../../.swift-format)) вместо SwiftFormat. Это официальный форматтер Apple, с Xcode 16 он входит в тулчейн (`xcrun swift-format`) и не требует установки.
- **SwiftLint** ([.swiftlint.yml](../../.swiftlint.yml)) только для смысловых правил, форматирование отдано swift-format.
- **pre-commit хук** через mise, без husky, lefthook и прочих лишних инструментов.
- **Renovate** ([renovate.json](../../renovate.json)) раз в неделю открывает PR с обновлениями `mise.toml`, гемов, GitHub Actions и SPM-пакетов. Мелкие обновления инструментов вливаются сами при зелёном CI. Dependabot так не умеет, потому что не понимает `mise.toml`. Подключается как GitHub App.
- **Проверка границ модулей в CI** через `tuist inspect implicit-imports`.

Стоит попробовать позже:
- **Swift Testing** вместо XCTest для всех новых тестов (`@Test`, `#expect`, параметризация). Бэкенд уже на нём.
- **Snapshot-тесты** экранов на `swift-snapshot-testing`, когда появится DesignSystem.
- **Periphery** (через mise) ищет неиспользуемый код. Полезно, когда модулей станет много.
- **xcodes** (через mise) с файлом `.xcode-version` для переключения версий Xcode, если их будет несколько.
- **Tuist selective testing и кэш** гоняют только тесты изменённых модулей. Нужен аккаунт на сервере Tuist, для учёбы это скорее экскурсия.

---

## 5. fastlane

[Fastfile](../../iOS/fastlane/Fastfile), версия fastlane закреплена в [Gemfile](../../iOS/Gemfile), запуск всегда через `bundle exec`.

| Lane | Что делает | Где запускать |
|---|---|---|
| `test` | `tuist generate` и тесты схемы `Buzz` на симуляторе | локально и в CI на каждый PR |
| `certs` | создаёт сертификаты и профили в репозитории match | один раз локально |
| `beta` | generate, профили из match, номер сборки = последний в TestFlight + 1, сборка, загрузка в TestFlight | CI по тегу `ios-v*` |

Подпись через **match**: сертификаты лежат в отдельном приватном git-репозитории, зашифрованные паролем. В CI match работает в режиме `readonly`, а `update_code_signing_settings` переключает на ручную подпись только таргет приложения (фреймворкам профили не нужны). Авторизация в App Store Connect через **API-ключ**, без Apple ID и двухфакторки.

**Важно:** для `certs` и `beta` нужен платный Apple Developer Program. Без него работает только `test`, и для учёбы на первых порах этого достаточно: CI с тестами на каждый PR уже полноценный CI.

---

## 6. CI на GitHub Actions

[ci.yml](../../.github/workflows/ci.yml): один workflow на весь монорепо. Job `Changes` смотрит, какие папки затронуты, а job-ы `iOS` и `Backend` запускаются только при нужных изменениях. Пропущенный job считается пройденным, поэтому `iOS` и `Backend` можно сделать обязательными проверками на `main`, и PR с одной документацией не зависнет.

- **iOS, job `test`:** на PR, если менялись `iOS/`, `Shared/` или `mise.toml`. Раннер `macos-26`, Xcode `latest-stable`, `jdx/mise-action` ставит инструменты из `mise.toml` и кэширует их, дальше `mise run lint`, `mise run lint:imports` и `mise run test`, то есть те же команды, что и локально. При падении выгружается результат тестов.
- **iOS, job `beta`:** только на тег `ios-v*` после зелёных тестов.
- **Backend:** Linux-контейнер `swift:6.2`, `swift test`. Запускается и при изменении `Shared/`, так что сломанный DTO заметят обе стороны.

Секреты репозитория для `beta`: `TEAM_ID`, `MATCH_GIT_URL`, `MATCH_PASSWORD`, `MATCH_GIT_BASIC_AUTHORIZATION` (base64 от `user:token` для доступа к репозиторию match), `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT` (base64 от .p8).

Про деньги: в публичном репозитории минуты GitHub Actions бесплатные. В приватном macOS-минуты тратятся из лимита с множителем 10, так что iOS-job разумно гонять только на PR и тегах, как и настроено.

Версии экшенов (`checkout@v5`, `mise-action@v2`, `setup-xcode@v1`) и образа `swift:6.2` стоит сверить с актуальными при создании репозитория.

---

## 7. Порядок внедрения

1. Создать репозиторий с этой структурой, перенести `Shared` и `Backend`, поправить путь к `Shared` в `Backend/Package.swift`.
2. `mise use tuist@latest ruby@3.3 swiftlint@latest` для точных версий.
3. Положить манифесты, создать папки модулей с одним файлом в каждом, `mise run generate`. Первая цель: пустое приложение с `SceneDelegate` и четырьмя вкладками собирается.
4. Включить `ci.yml`, добиться зелёного CI на пустом проекте.
5. Дальше разработка по шагам из [architecture.md](../client/architecture.md).
6. Когда появится Apple Developer Program: `fastlane certs`, секреты, тег `ios-v0.1.0`, первая сборка в TestFlight.
