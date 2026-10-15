# Buzz: офлайн-синхронизация в клиенте

Что и зачем — в разделе «Зачем синхронизация» в [idea.md](../idea.md). Здесь описано, как это ложится на архитектуру клиента ([architecture.md](architecture.md)).

Коротко: **экраны читают только локальную SwiftData**, сеть их не касается. Отдельный `actor SyncEngine` в фоне отправляет очередь неотправленного и подтягивает изменения с сервера, никогда не затирая то, что ещё не ушло.

---

## 1. Где это живёт

Новый модуль `Sync` (зависит от `Domain`, `Persistence`, `Networking`). Фичи о нём не знают: они видят только протокол из `Domain`.

```
Feature (Today, Stats, Settings)
   │ видят протокол
Domain:  protocol SyncService { func syncNow() async; var status: AsyncStream<SyncStatus> }
   │ реализует
Sync:    actor SyncEngine ──▶ Persistence (SwiftData)  +  Networking (APIClient, DTO из Shared)
```

Создаётся в `AppDependencies`, запускается из `SceneDelegate`.

---

## 2. Данные: что добавить в модели

```swift
// Persistence
enum SyncState: String, Codable { case synced, pending, pendingDelete }

@Model
final class EntryModel {
    @Attribute(.unique) var id: UUID      // генерирует клиент → POST идемпотентен
    // ... поля записи ...
    var updatedAt: Date
    var deletedAt: Date?
    var syncStateRaw: String = SyncState.pending.rawValue
    var syncState: SyncState {
        get { SyncState(rawValue: syncStateRaw) ?? .pending }
        set { syncStateRaw = newValue.rawValue }
    }
}
```

`syncState` хранится строкой: предикаты `#Predicate` с enum в SwiftData работают ненадёжно, а со строкой — без сюрпризов. Свои напитки (`DrinkModel` с `isCustom`) получают те же три поля; общий каталог только скачивается.

В `Domain.Entry` добавляем `isSynced: Bool`, чтобы UI мог показать значок, не зная про `SyncState`.

**Правило для репозиториев:** любое изменение пользователя ставит `pending`:

```swift
func add(_ entry: Entry) async throws {
    let m = EntryModel(entry); m.updatedAt = .now; m.syncState = .pending
    modelContext.insert(m); try modelContext.save()
    changes.yield()                       // сообщить стору и SyncEngine
}

func delete(id: UUID) async throws {
    guard let m = try fetch(id) else { return }
    m.deletedAt = .now; m.updatedAt = .now
    m.syncState = .pendingDelete          // запись не удаляем физически, пока сервер не подтвердил
    try modelContext.save(); changes.yield()
}
```

Все чтения для UI фильтруют `deletedAt == nil`, поэтому удалённое пропадает с экрана сразу.

`changes` — `AsyncStream<Void>` у репозитория. На него подписан `EntryStore` (перечитать «Сегодня») и `SyncEngine` (отправить через секунду-две). Это закрывает и нюанс из [architecture-experiments.md](architecture-experiments.md): «Добавить» на Clean сохраняет через репозиторий, и «Сегодня» узнаёт об этом без участия координатора.

---

## 3. SyncEngine

```swift
public actor SyncEngine: SyncService {
    private let store: SyncStore            // доступ к SwiftData (@ModelActor)
    private let api: APIClient
    private let session: AuthSession        // есть ли токен
    private var isRunning = false
    private var needsAnotherPass = false
    private let statusContinuation: AsyncStream<SyncStatus>.Continuation
    public nonisolated let status: AsyncStream<SyncStatus>

    public func syncNow() async {
        // Склейка запусков: если синхронизация уже идёт, просто попросим ещё один проход.
        guard !isRunning else { needsAnotherPass = true; return }
        isRunning = true
        defer { isRunning = false }

        repeat {
            needsAnotherPass = false
            await pass()
        } while needsAnotherPass
    }

    private func pass() async {
        guard await session.isLoggedIn else { statusContinuation.yield(.offlineGuest); return }
        statusContinuation.yield(.syncing)
        do {
            try await pushPending()
            try await pullChanges()
            statusContinuation.yield(.idle(lastSync: await store.lastSyncedAt))
        } catch APIError.unauthorized {
            await session.logout()
            statusContinuation.yield(.needsLogin)
        } catch {
            statusContinuation.yield(.failed)       // pending остаются, повторим при следующем триггере
        }
    }

    // Шаг 1: отправить очередь
    private func pushPending() async throws {
        for entry in try await store.pendingEntries() {
            try await api.send(.createEntry(entry.dto))      // повтор того же id не создаст дубль
            try await store.markSynced(entry.id, ifUpdatedAt: entry.updatedAt)
        }
        for id in try await store.pendingDeletes() {
            try await api.send(.deleteEntry(id))             // 404 считаем успехом: уже удалено
            try await store.markSyncedDelete(id)
        }
    }

    // Шаг 2–3: забрать изменения и применить, не трогая pending
    private func pullChanges() async throws {
        let since = await store.lastSyncedAt
        let delta = try await api.send(.sync(since: since))  // entries + drinks + serverTime
        try await store.apply(delta)
        try await store.setLastSyncedAt(delta.serverTime)    // время сервера, не часы телефона
    }
}
```

Две детали, на которых легко ошибиться:
- **`markSynced(id, ifUpdatedAt:)`**: пока запрос летел, пользователь мог снова изменить запись. Помечаем `synced` только если `updatedAt` не поменялся, иначе запись остаётся `pending` и уйдёт в следующем проходе.
- **`lastSyncedAt` = `serverTime` из ответа.** Часы телефона могут отставать, и тогда часть изменений с сервера никогда не придёт.

### Применение изменений с сервера

```swift
// SyncStore (@ModelActor)
func apply(_ delta: SyncResponseDTO) throws {
    for remote in delta.entries {
        if let local = try fetch(remote.id) {
            guard local.syncState == .synced else { continue }       // главное правило: неотправленное не трогаем
            guard remote.updatedAt > local.updatedAt else { continue } // конфликт: побеждает свежий updatedAt
            local.update(from: remote)
        } else if remote.deletedAt == nil {
            modelContext.insert(EntryModel(remote, syncState: .synced))
        }
    }
    try modelContext.save()
    changes.yield()
}
```

Удаление с другого устройства приходит как запись с `deletedAt` (сервер отдаёт «надгробия» в `/sync`), и у нас она тоже скрывается.

---

## 4. Когда запускается

| Триггер | Где в коде |
|---|---|
| Старт приложения | `SceneDelegate.scene(_:willConnectTo:)` → `Task { await deps.sync.syncNow() }` |
| Возврат из фона | `sceneDidBecomeActive(_:)` |
| Появилась сеть | `NWPathMonitor` в `Sync`: переход `.unsatisfied → .satisfied` |
| Пользователь что-то изменил | подписка на `changes` репозиториев, с задержкой ~2 с, чтобы склеить серию действий |
| Pull to refresh | `.refreshable` на «Сегодня» и «Статистике» |
| Кнопка в «Настройках» | Redux-эффект `syncTapped` → `env.sync()` |
| Вход в аккаунт | после логина: всё накопленное гостем `pending` уходит на сервер |

Фоновую синхронизацию при закрытом приложении (`BGAppRefreshTask`) пока не делаем: это хороший отдельный эксперимент после MVP.

---

## 5. Что видит пользователь

**Значок «не синхронизировано»** в строке записи на «Сегодня»:

```swift
HStack {
    EntryRowContent(entry: entry)
    if !entry.isSynced {
        Image(systemName: "icloud.slash")
            .foregroundStyle(.secondary).imageScale(.small)
            .accessibilityLabel(Text("today.entry.notSynced", bundle: .module))
    }
}
```

**Pull to refresh** в MVVM-экранах:

```swift
// TodayViewModel
func refresh() async {
    await sync.syncNow()                   // сначала отправит pending, потом заберёт свежее
}

// TodayView
List { ... }
    .refreshable { await model.refresh() }
```

Ошибку сети здесь не показываем алертом: данные и так на экране, а значки остаются. Статус в шапке не нужен.

**«Настройки» (Redux)** подписываются на `status` через эффект и показывают «Синхронизировано 5 минут назад», «Синхронизация…» или «Не удалось, повторим автоматически»:

```swift
case .onAppear:
    return .run { send in
        for await s in env.syncStatus() { await send(.syncStatusChanged(s)) }
    }
```

Количество неотправленных («3 записи ждут отправки») — плюрализация из [localization.md](localization.md).

---

## 6. Тесты

`SyncEngine` тестируется с фейковым `APIClient` и in-memory `ModelContainer`, без сети:
- Запись `pending` не перезаписывается версией с сервера, даже более свежей.
- Повторная отправка после обрыва не создаёт дубля (фейк сервера хранит записи по id).
- Изменение во время отправки оставляет запись `pending` (`ifUpdatedAt`).
- Удаление: `pendingDelete` → после успешного DELETE запись не возвращается из `/sync`.
- Два одновременных `syncNow()` дают два прохода подряд, а не параллельные запросы.
- `lastSyncedAt` берётся из `serverTime`.

---

## 7. Порядок

Этапы 1–2 из idea.md (офлайн) поля `syncState` уже могут иметь, просто всё остаётся `pending`. На этапе 4:
1. Модуль `Sync`, `SyncStore` на `@ModelActor`, `pushPending` и `pullChanges`.
2. Триггеры: старт, возврат из фона, pull to refresh.
3. `NWPathMonitor` и подписка на изменения репозиториев.
4. Значки и статус в «Настройках».
5. Тесты из раздела 6.
