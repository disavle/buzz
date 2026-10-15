# Путеводитель по инфраструктуре Buzz

Рабочий код и конфиги лежат в [skeleton/](../../), это основной вариант. Этот файл нужен, чтобы разобрать skeleton по частям и уметь собрать его заново руками. Шаги идут в том порядке, в котором имеет смысл изучать файлы. В каждом шаге сказано, что делает соответствующий кусок, как проверить, что он работает, и что при этом понять. Если хочешь закрепить, повтори шаг в пустой папке без подглядывания. Зачем всё это нужно, объясняет [README.md](README.md).

Документация: [Tuist](https://docs.tuist.dev), [mise](https://mise.jdx.dev), [fastlane](https://docs.fastlane.tools), [GitHub Actions](https://docs.github.com/actions).

---

## Шаг 1. mise: версии инструментов из репозитория

1. Поставь mise (`brew install mise`) и подключи его к shell по инструкции из документации (`mise activate`).
2. Создай пустую папку `buzz`, сделай в ней `git init` и выполни `mise use tuist@latest`.

**Проверка:** появился `mise.toml` с точной версией, а `which tuist` указывает внутрь каталога mise, а не в Homebrew.
**Что понять:** версия инструмента теперь записана в репозитории. Выйди из папки и снова зайди в неё: так mise переключает версии.

## Шаг 2. Tuist: приложение из манифеста

1. Создай `iOS/Project.swift` с одним таргетом приложения. Минимальный вариант:
   ```swift
   import ProjectDescription
   let project = Project(name: "Buzz", targets: [
       .target(name: "Buzz", destinations: [.iPhone], product: .app,
               bundleId: "com.you.buzz", sources: ["App/Sources/**"])
   ])
   ```
2. Положи в `App/Sources` файл `App.swift` с `@main`. Пока подойдёт и SwiftUI, координаторы будут позже.
3. В папке `iOS` выполни `tuist generate`.

**Проверка:** Xcode открылся, приложение запускается в симуляторе.
**Что понять:** открой `tuist edit` и пощёлкай автодополнение по `.target(`, так быстрее всего изучить API. Добавь `*.xcodeproj` и `*.xcworkspace` в `.gitignore`: проект теперь генерируется и в git не хранится.

## Шаг 3. Первый модуль и тесты

1. Добавь второй таргет `Domain` с `product: .staticFramework` и `sources: ["Modules/Domain/Sources/**"]`.
2. Подключи его к приложению через `dependencies: [.target(name: "Domain")]`.
3. Добавь таргет `DomainTests` с `product: .unitTests` и напиши один тест на Swift Testing (`@Test`, `#expect`).

**Проверка:** `import Domain` в приложении компилируется, а `tuist test DomainTests` проходит.
**Что понять:** модуль теперь отдельный таргет со своей видимостью: без `public` тип снаружи не виден.

## Шаг 4. Хелпер вместо копипасты

Когда модулей станет три, ты заметишь повтор. Вынеси его в `Tuist/ProjectDescriptionHelpers/Module.swift`. Это обычный Swift-файл, а всё публичное в нём видно в `Project.swift` через `import ProjectDescriptionHelpers`. Придумай функцию, которая по имени и зависимостям возвращает `[Target]` (фреймворк плюс тесты).

**Проверка:** новый модуль добавляется одной строкой.
**Подсмотреть:** [Module.swift](../../iOS/Tuist/ProjectDescriptionHelpers/Module.swift).

## Шаг 5. Внешняя зависимость

1. Создай `Tuist/Package.swift` и подключи в нём пакет `Shared` по пути (`.package(path: ...)`).
2. Выполни `tuist install`, а в таргете укажи `.external(name: "Shared")`.

**Проверка:** `import Shared` компилируется в модуле `Networking`.
**Что понять:** `tuist install` скачивает и разрешает пакеты, а `tuist generate` превращает их в таргеты Xcode. Это два разных шага.

## Шаг 6. Границы модулей

1. Выполни `tuist graph` и посмотри на картинку.
2. Нарочно импортируй одну фичу в другую, не объявляя зависимость, и запусти `tuist inspect implicit-imports`.

**Проверка:** команда находит нарушение. Убери его.
**Что понять:** так CI будет охранять правило «фича видит только Domain».

## Шаг 7. Одна команда: `mise run generate`

1. В `mise.toml` напиши задачу `[tasks.generate]` с `dir = "iOS"` и `run = [...]` из `tuist install` и `tuist generate --no-open`.
2. Выполни `mise tasks`, затем `mise run generate`.
3. Проверь на чистом клоне: `git clone . /tmp/buzz-test && cd /tmp/buzz-test && mise run generate`.

**Проверка:** на чистом клоне проект собирается одной командой.
**Что понять:** зачем `depends` и почему задачу нельзя вызвать как `mise generate` (это встроенная команда mise).
**Подсмотреть:** [mise.toml](../../mise.toml).

## Шаг 8. Форматирование, линтер, хук

1. Попробуй `xcrun swift-format lint -r iOS/` и посмотри, что он найдёт.
2. Добавь `swiftlint` через `mise use`.
3. Заведи задачу `lint` и выполни `mise generate git-pre-commit --write --task=lint`.

**Проверка:** коммит с плохо отформатированным файлом не проходит.

## Шаг 9. fastlane: тесты одной lane

1. Сделай `mise use ruby@3.3`, затем `bundle init` в `iOS/` и `bundle add fastlane`.
2. Создай `fastlane/Fastfile` с одной lane `test`: сначала `sh("cd .. && tuist generate --no-open")`, потом `run_tests(workspace:, scheme:)`.

**Проверка:** `bundle exec fastlane test` проходит.
**Что понять:** зачем Bundler (версия fastlane закреплена в `Gemfile.lock`) и почему `sh` запускается из папки `fastlane/`.

## Шаг 10. CI на GitHub Actions

1. Создай репозиторий на GitHub.
2. Напиши `.github/workflows/ios.yml`: на `pull_request` запускать `runs-on: macos-26`, `actions/checkout`, `jdx/mise-action` и `mise run test`.
3. Открой PR.

**Проверка:** в PR зелёная галочка. Потом сломай тест и посмотри, как CI краснеет.
**Что понять:** CI вызывает те же команды, что и ты локально. В этом весь смысл mise-задач.

## Шаг 11. Бэкенд в том же CI

Второй workflow `backend.yml`: на `ubuntu-latest` с `container: swift:6.2` и `swift test --package-path Backend`. Ограничь запуск через `paths:`, чтобы правка в `iOS/` не запускала тесты бэка.

**Проверка:** правка в `Shared/` запускает оба workflow.

## Шаг 12. Потом: TestFlight

Этот шаг только с платным Apple Developer Program. Тебе понадобятся `match` (сертификаты в приватном репозитории), API-ключ App Store Connect, lane `beta` и job по тегу. Готовая схема описана в разделе 5 [README](README.md).
