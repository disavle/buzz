# Бесплатный деплой бэкенда: Render + Neon

Сервер Buzz можно бесплатно выложить в интернет, без банковской карты. Связка такая:

- **[Render](https://render.com/docs/free)** запускает Docker-контейнер с Vapor.
- **[Neon](https://neon.com/pricing)** хранит базу Postgres.
- **GitHub Actions** после зелёных тестов на `main` собирает образ, кладёт его в GitHub Container Registry (`ghcr.io`) и просит Render его запустить.

Тарифы проверены 15 октября 2026, они часто меняются.

## Почему именно так

| Вариант | Что не так |
|---|---|
| GitHub Pages | только статические файлы, сервер не запустить |
| Codespaces | среда для разработки, засыпает, публичного адреса для приложения нет |
| Actions | джоба живёт до 6 часов, это CI, а не хостинг |
| Postgres на Render | бесплатная база удаляется через 30 дней |
| Supabase | 500 МБ, проект ставится на паузу после недели без активности |
| Fly.io | бесплатного тарифа больше нет, только пробный период и карта |
| Railway | $5 на 30 дней, потом $1 в месяц |

**Ограничения бесплатной связки:**
- Render усыпляет сервис после 15 минут без запросов. Первый запрос после сна ждёт около минуты. Клиент должен это пережить: большой таймаут и повтор запроса.
- Render даёт 750 часов в месяц. Пока сервис спит, часы не тратятся.
- Диск у Render не сохраняется, поэтому SQLite там не годится, нужна внешняя база.
- Neon даёт 1 ГБ на проект и 100 часов вычислений в месяц. База засыпает через 5 минут без запросов и просыпается за секунды. Данные не удаляются.

## Как это устроено в коде

- [`Backend/Dockerfile`](../../Backend/Dockerfile): двухэтапная сборка. В первом этапе есть Swift, он компилирует сервер. Во второй этап попадает только готовый бинарник, поэтому образ маленький.
- [`.dockerignore`](../../.dockerignore): в образ попадают только `Backend/` и `Shared/`.
- [`configure.swift`](../../Backend/Sources/App/configure.swift): если задана переменная `DATABASE_URL`, сервер подключается к Postgres, иначе работает с SQLite как раньше. Порт берётся из `PORT`, если хостинг его передаёт. Когда `AUTO_MIGRATE=true` (его ставит Dockerfile), таблицы создаются при старте.
- [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml), job `deploy`: сборка образа, `ghcr.io/disavle/buzz-backend`, вызов Render Deploy Hook.

## Настройка (один раз, руками)

1. **Neon.** Зарегистрируйся на neon.com через GitHub, создай проект `buzz`. На странице Connect скопируй строку подключения, она выглядит как `postgresql://user:password@host/neondb?sslmode=require`. Если в конце есть `&channel_binding=require`, убери эту часть.
2. **Первый образ.** GitHub → Actions → CI → Run workflow, ветка `main`. Job `Deploy backend` соберёт и выложит образ. Шаг «Deploy on Render» пока пропустится, это нормально. Потом образ пересобирается сам при каждом пуше в `main`, который меняет бэкенд.
3. **Сделай образ публичным.** GitHub → твой профиль → Packages → `buzz-backend` → Package settings → Change visibility → Public. Тогда Render скачает его без пароля.
4. **Render.** Зарегистрируйся на render.com через GitHub. New → Web Service → Existing Image, адрес `ghcr.io/disavle/buzz-backend:latest`, тариф Free. В Environment добавь `DATABASE_URL` со строкой из Neon.
5. **Deploy Hook.** В Render: сервис → Settings → Deploy Hook, скопируй URL. В GitHub: репозиторий → Settings → Secrets and variables → Actions → New repository secret, имя `RENDER_DEPLOY_HOOK`.

После этого каждый пуш в `main`, который меняет бэкенд, сам доезжает до Render.

**Проверка:** открой `https://<имя-сервиса>.onrender.com/health`, должно вернуться `ok`. Первый раз ответ придёт примерно через минуту.

## Собрать и запустить образ у себя

```bash
# из корня репозитория
docker build -f Backend/Dockerfile -t buzz-backend .
docker run --rm -p 8080:8080 buzz-backend               # SQLite внутри контейнера
docker run --rm -p 8080:8080 -e DATABASE_URL="..." buzz-backend   # с базой в Neon
```

## Что почитать

- Vapor и Docker: https://docs.vapor.codes/deploy/docker/
- Render, бесплатный тариф: https://render.com/docs/free
- Render Deploy Hooks: https://render.com/docs/deploy-hooks
- Neon, лимиты Free: https://neon.com/faqs/free-plan-limits-and-quotas
- GitHub Container Registry: https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry
