# Как вести работу в Buzz

Процесс: **GitHub Flow**. Одна долгоживущая ветка `main`, всё остальное короткие ветки через PR. Git flow с `develop`, `release/*` и `hotfix/*` для одного разработчика избыточен: те же гарантии дают защищённый `main`, зелёный CI и теги релизов.

## Ветки

`main` всегда собирается и проходит тесты. Работа идёт в короткой ветке от свежего `main`:

| Префикс | Для чего | Пример |
|---|---|---|
| `feature/` | новая функциональность | `feature/stats-month` |
| `fix/` | исправление бага | `fix/sync-duplicates` |
| `chore/` | инструменты, зависимости, рефакторинг без изменения поведения | `chore/bump-tuist` |
| `ci/` | workflow и сборка | `ci/cache-derived-data` |
| `docs/` | только документация | `docs/localization` |

Ветки от Renovate называются `renovate/*`, их трогать не нужно.

## Цикл

```bash
git switch main && git pull
git switch -c feature/stats-month
# ...коммиты...
git push -u origin feature/stats-month
gh pr create --fill      # или кнопкой на GitHub
```

PR вливается, когда зелёные проверки `iOS` и `Backend`. Лучше делать **Squash and merge**: тогда в `main` один коммит на одну задачу, а заголовок PR становится сообщением коммита. После мержа ветка удаляется.

## Коммиты

Заголовок до 72 символов, в повелительном наклонении, по желанию с префиксом в стиле Conventional Commits:

```
feat(stats): show monthly caffeine chart
fix(sync): do not resend deleted entries
chore: bump tuist to 4.213
```

Автор коммитов в ветке должен быть владельцем репозитория (`git config user.name` и `user.email`). При squash-мерже GitHub дописывает строку `Co-authored-by` для каждого другого автора коммитов в ветке, поэтому чужой автор попадёт в историю `main`.

## Релизы

Релиз iOS делается тегом на `main`: `git tag ios-v0.2.0 && git push origin ios-v0.2.0`. CI прогонит тесты и отправит сборку в TestFlight (когда будет настроен аккаунт разработчика, см. [docs/infra/SETUP.md](docs/infra/SETUP.md)). Номер сборки CI берёт сам из TestFlight, а версию (`MARKETING_VERSION`) меняют в `iOS/Project.swift` отдельным PR перед тегом.

## Перед пушем

Pre-commit хук запускает `mise run lint`. Перед PR полезно прогнать `mise run test` и, если трогал сервер, `mise run backend:test`.
