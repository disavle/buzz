# Buzz: что настроить руками

Это то, что не делается коммитом: настройки GitHub, сторонние сервисы и аккаунт Apple. Всё остальное (CI, линтеры, mise, Tuist, fastlane) уже лежит в репозитории.

## Сейчас (бесплатно)

1. **Смёржить PR с починкой CI**, когда он станет зелёным. После этого в `main` появится единый workflow `ci.yml`.

2. **Установить Renovate.** Открой https://github.com/apps/renovate, нажми Install, выбери Only select repositories → `buzz`. Конфиг `renovate.json` уже в репозитории, поэтому Renovate не будет открывать вводный PR. Он сразу создаст issue «Dependency Dashboard», а по понедельникам будет открывать PR с обновлениями.

3. **Настройки PR в репозитории.** Settings → General → раздел Pull Requests:
   - включи **Allow auto-merge**: без этого Renovate не сможет сам вливать мелкие обновления;
   - включи **Automatically delete head branches**, чтобы ветки удалялись после мержа.
   - оставь включённым только **Allow squash merging**: в `main` будет один коммит на задачу (процесс описан в [CONTRIBUTING.md](../../CONTRIBUTING.md)).

4. **Защита `main`.** Settings → Rules → Rulesets → New branch ruleset:
   - Enforcement status: Active, Target branches: Include default branch;
   - **Require status checks to pass**: добавь `iOS` и `Backend` (они появятся в поиске после первого прогона `ci.yml`);
   - **Block force pushes**;
   - **Require a pull request before merging** с 0 обязательных апрувов: так работает GitHub Flow, изменения попадают в `main` только через PR;
   - в Bypass list добавь **Repository admin** с режимом «For pull requests only» или «Always». Первый вариант строже: напрямую в `main` не запушить даже тебе. Второй оставляет запасной выход для срочной правки.

5. **Mac для разработки** (один раз):
   ```bash
   brew install mise
   echo 'eval "$(mise activate zsh)"' >> ~/.zshrc && exec zsh
   git clone https://github.com/disavle/buzz && cd buzz
   mise trust
   mise run generate     # инструменты, гемы, pre-commit хук, Buzz.xcworkspace
   mise run open
   ```
   Нужен Xcode 26 из App Store. Pre-commit хук ставится той же командой `mise run generate`.

   **Алиасы для zsh.** Добавь в `~/.zshrc` одну строку (путь замени на свой) и открой новую вкладку терминала:
   ```bash
   source ~/Developer/buzz/scripts/buzz.zsh
   ```
   | Команда | Что делает |
   |---|---|
   | `buzz` | перейти в папку репозитория |
   | `buzz-gen` | `mise run generate`, после клона или `git pull` |
   | `buzz-open` | открыть проект в Xcode |
   | `buzz-ios` | собрать и запустить приложение в симуляторе |
   | `buzz-api` | запустить бэкенд в текущей вкладке (Ctrl+C остановит) |
   | `buzz-dev` | бэкенд в фоне (лог в `Backend/server.log`) и приложение в симуляторе |
   | `buzz-stop` | остановить фоновый бэкенд |
   | `buzz-test` | тесты iOS и бэкенда |
   | `buzz-lint` | линтеры |

   Команды работают из любой папки: скрипт сам находит репозиторий по своему расположению.

6. **Запуск на своём iPhone** (по желанию, платный аккаунт для этого не нужен). В Xcode → Settings → Accounts добавь Apple ID, скопируй Team ID и создай в корне репозитория файл `mise.local.toml` (он в `.gitignore`):
   ```toml
   [env]
   TUIST_TEAM_ID = "ABCDE12345"
   ```
   Затем снова выполни `mise run generate`.

7. **Бэкенд локально:** `mise run backend:run`. База SQLite лежит в `Backend/db.sqlite`, миграции в режиме разработки применяются при старте. Симулятор ходит на `http://localhost:8080`: http к localhost уже разрешён в `Info.plist`.

## Позже, после Apple Developer Program ($99 в год)

8. **Приложение в App Store Connect.** My Apps → + → New App, Bundle ID `com.disavle.buzz`. Если такого ID ещё нет в списке, сначала создай его в Certificates, Identifiers & Profiles → Identifiers.

9. **API-ключ App Store Connect.** Users and Access → Integrations → App Store Connect API → Team Keys → «+» с ролью App Manager. Сохрани Key ID, Issuer ID и файл `.p8` (его можно скачать только один раз). Для секрета понадобится base64 ключа: `base64 -i AuthKey_XXXX.p8 | pbcopy`.

10. **Приватный репозиторий для сертификатов**, например `disavle/buzz-certificates`: пустой и обязательно Private.

11. **Создать сертификаты.** Допиши в `mise.local.toml`:
    ```toml
    MATCH_GIT_URL = "https://github.com/disavle/buzz-certificates.git"
    MATCH_PASSWORD = "придумай-и-сохрани-в-менеджере-паролей"
    ASC_KEY_ID = "..."
    ASC_ISSUER_ID = "..."
    ASC_KEY_CONTENT = "base64 из шага 9"
    ```
    Затем выполни `cd iOS && bundle exec fastlane certs`.

12. **Секреты для CI.** Settings → Secrets and variables → Actions → New repository secret:
    `TEAM_ID`, `MATCH_GIT_URL`, `MATCH_PASSWORD`, `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT` и `MATCH_GIT_BASIC_AUTHORIZATION`. Последний нужен, чтобы CI мог читать репозиторий сертификатов:
    - создай fine-grained token с доступом Contents: Read только к `buzz-certificates`;
    - выполни `echo -n "disavle:ТОКЕН" | base64`;
    - вставь результат как значение секрета.

13. **Первая сборка в TestFlight:** `git tag ios-v0.1.0 && git push origin ios-v0.1.0`. Тег запускает job `TestFlight` после зелёных тестов.

## Пока не настроено совсем

- **Бэкенд в интернете.** Сервер живёт только локально. Когда понадобится: Postgres вместо SQLite, Dockerfile и деплой (Fly.io или VPS). Это отдельная задача.
- **Адрес сервера для TestFlight-сборки.** Сейчас приложение берёт его из переменной `BUZZ_API_URL` (по умолчанию `http://localhost:8080`, см. `AppDependencies.swift`). Для сборки в TestFlight адрес надо будет зашить в конфигурацию Release вместе с деплоем бэкенда.
