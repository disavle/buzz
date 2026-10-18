# Changelog

All notable changes to Buzz. Each version has an English and a Russian part.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versions follow [Semantic Versioning](https://semver.org/).

A `v*` tag (for example `v0.1.0`) makes the Release workflow create a draft
GitHub release with the notes of that version from this file.

## [Unreleased]

## [0.1.2] - 2026-10-18

### English

Documentation only: the app and the server are the same as in 0.1.0.

**Docs**
- New course `docs/learning/course.md`: build a new "Wellbeing" feature in
  Buzz by hand, in blocks of about 30 minutes, touching every part of the
  stack from Tuist and SwiftUI to Vapor, CI and releases.
- The handbook is theory only again; the course links to it.
- README (EN + RU) links the course and the handbook separately.

### Русский

Только документация: приложение и сервер такие же, как в 0.1.0.

**Документация**
- Новый курс `docs/learning/course.md`: своими руками пишешь в Buzz новую
  фичу «Самочувствие» блоками примерно по 30 минут и проходишь весь стек,
  от Tuist и SwiftUI до Vapor, CI и релизов.
- Справочник снова только про теорию, курс ссылается на него.
- README (EN и RU) ссылается на курс и справочник отдельно.

## [0.1.1] - 2026-10-18

### English

Documentation only: the app and the server are the same as in 0.1.0.

**Docs**
- The handbook has a new card about releases: how CHANGELOG.md, `v*` tags
  and the Release workflow in this repository work together.

### Русский

Только документация: приложение и сервер такие же, как в 0.1.0.

**Документация**
- В справочнике новая карточка про релизы: как в этом репозитории вместе
  работают CHANGELOG.md, теги `v*` и workflow Release.

## [0.1.0] - 2026-10-18

The first version of Buzz: an energy drink tracker for iPhone and its own
Swift backend. This is a learning project, see the README.

### English

**App (iOS 18+)**
- Today: caffeine and sugar for the day in a ring, the daily limit
  (400 mg by default) turns the ring orange when you go over it.
- Add a can in a couple of taps: drink, volume, time and price.
- Catalog of drinks with search (debounced with Combine).
- Stats with Swift Charts: caffeine by day, favorite brands, spending by week.
- Settings: daily limit, language, sign in and sign out.
- English and Russian, light and dark theme.
- Offline-first: everything is saved on the phone (SwiftData) and synced
  with the server when the network is back.

**Backend**
- Vapor 4 server: sign-up and login by token, drinks, entries, stats, sync.
- SQLite locally, Postgres (Neon) in production; deployed to Render as a
  Docker image.

**Tooling**
- Tuist project with feature modules, mise for tools and tasks, fastlane.
- One GitHub Actions workflow: tests and lint on PRs, backend deploy on
  `main`, TestFlight on an `ios-v*` tag.
- Git hooks run swift-format and SwiftLint before commit and push.
- Renovate keeps the tools up to date.

**Docs**
- Docs in Russian: design, architecture, API, deploy, infrastructure.
- A handbook of the new iOS stack with a 40-day course built on this app.

### Русский

**Приложение (iOS 18+)**
- «Сегодня»: кофеин и сахар за день в кольце; когда превышаешь дневной
  лимит (по умолчанию 400 мг), кольцо становится оранжевым.
- Добавить банку в пару тапов: напиток, объём, время и цена.
- Каталог напитков с поиском (debounce через Combine).
- Статистика на Swift Charts: кофеин по дням, любимые бренды, траты по неделям.
- Настройки: дневной лимит, язык, вход и выход из аккаунта.
- Английский и русский языки, светлая и тёмная тема.
- Offline-first: всё сохраняется на телефоне (SwiftData) и синхронизируется
  с сервером, когда появляется сеть.

**Бэкенд**
- Сервер на Vapor 4: регистрация и вход по токену, напитки, записи,
  статистика, синхронизация.
- SQLite локально, Postgres (Neon) на сервере; выкладка на Render
  Docker-образом.

**Инструменты**
- Tuist-проект с модулями фич, mise для инструментов и задач, fastlane.
- Один workflow в GitHub Actions: тесты и линтер на PR, деплой бэкенда из
  `main`, TestFlight по тегу `ios-v*`.
- Git-хуки запускают swift-format и SwiftLint перед коммитом и пушем.
- Renovate обновляет инструменты.

**Документация**
- Документы на русском: дизайн, архитектура, API, деплой, инфраструктура.
- Справочник по новому стеку iOS с курсом на 40 дней на примере этого приложения.

[Unreleased]: https://github.com/disavle/buzz/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/disavle/buzz/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/disavle/buzz/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/disavle/buzz/releases/tag/v0.1.0
