# SwiftUI-клиент: общая основа

Шпаргалка-каркас для учебного приложения. Конкретные экраны появятся, когда будет готова идея (`docs/idea.md`).

**Исходные допущения** (можно поменять):
- iOS 18+, Swift 6 с строгой проверкой конкурентности (strict concurrency).
- Только SwiftUI, без UIKit-обёрток, кроме случаев, где без них никак.
- Без сторонних зависимостей: Observation, NavigationStack, URLSession async/await, SwiftData.
- Общие с бэкендом модели (DTO) лежат в отдельном Swift-пакете, его же подключит Vapor.

---

## 1. Структура проекта

```
MyApp/
├── MyApp.xcodeproj
├── App/
│   ├── MyApp.swift              // @main, сборка зависимостей
│   └── AppRouter.swift          // навигация
├── Features/
│   ├── ItemList/
│   │   ├── ItemListView.swift
│   │   └── ItemListModel.swift  // @Observable
│   └── ItemDetail/
│       ├── ItemDetailView.swift
│       └── ItemDetailModel.swift
├── Core/
│   ├── Networking/
│   │   ├── APIClient.swift
│   │   └── Endpoint.swift
│   ├── Persistence/
│   │   └── CachedItem.swift     // @Model для SwiftData
│   └── DesignSystem/            // цвета, шрифты, общие View
└── Packages/
    └── Shared/                  // Swift Package: DTO, общие с Vapor
        └── Sources/Shared/ItemDTO.swift
```

Принцип: папка на фичу (feature-first), а не на тип файла. Внутри фичи View и её модель лежат рядом. Это ближе к тому, как мысленно режется приложение, и проще удалять/переносить фичи.

Пакет `Shared` — главный бонус «бэк тоже на Swift»: один и тот же `Codable`-тип используется на клиенте и в Vapor, контракт API проверяет компилятор.

```swift
// Packages/Shared/Sources/Shared/ItemDTO.swift
public struct ItemDTO: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var createdAt: Date
    public init(id: UUID, title: String, createdAt: Date) { ... }
}
```

---

## 2. Архитектура: View + @Observable-модель

Проще всего начать с **MV / MVVM-lite**: у экрана есть View и класс состояния, помеченный `@Observable`. Без Combine, без `@Published`, без `ObservableObject`.

```swift
import Observation

@MainActor
@Observable
final class ItemListModel {
    enum State { case idle, loading, loaded([ItemDTO]), failed(String) }

    private(set) var state: State = .idle
    var searchText = ""

    @ObservationIgnored private let api: APIClient

    init(api: APIClient) { self.api = api }

    var filtered: [ItemDTO] {
        guard case .loaded(let items) = state else { return [] }
        return searchText.isEmpty ? items : items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    func load() async {
        state = .loading
        do { state = .loaded(try await api.send(.items)) }
        catch { state = .failed(error.localizedDescription) }
    }
}
```

```swift
struct ItemListView: View {
    @State private var model: ItemListModel

    init(api: APIClient) { _model = State(initialValue: ItemListModel(api: api)) }

    var body: some View {
        content
            .searchable(text: $model.searchText)   // биндинг прямо в @Observable
            .task { await model.load() }           // отменится сам при уходе с экрана
            .refreshable { await model.load() }
            .navigationTitle("Items")
    }

    @ViewBuilder private var content: some View {
        switch model.state {
        case .idle, .loading: ProgressView()
        case .failed(let msg): ContentUnavailableView("Ошибка", systemImage: "wifi.slash", description: Text(msg))
        case .loaded:
            List(model.filtered) { item in
                NavigationLink(value: Route.itemDetail(item.id)) { Text(item.title) }
            }
        }
    }
}
```

Что важно понять про Observation:
- SwiftUI отслеживает **только те свойства, которые реально прочитаны в `body`**. Поменял `searchText` — перерисуются только зависимые от него View. С `ObservableObject` перерисовывалось всё при любом `@Published`.
- Владелец модели держит её в `@State` (как раньше `@StateObject`). Дочерней View модель передаётся обычным параметром `let model: ItemListModel`, а если нужен биндинг — `@Bindable var model`.
- Общие сервисы кладутся в окружение. `@Observable`-объект (например, сессия пользователя): `.environment(session)` → `@Environment(Session.self) var session`. Неизменяемый сервис вроде APIClient: ключ через `@Entry` → `@Environment(\.apiClient) var api`.
- `@MainActor` на модели — норма: всё состояние UI живёт на главном потоке, а `await api.send(...)` уходит в сеть и возвращается обратно сам.

Когда модель не нужна: если у экрана 1–2 локальных значения (`isExpanded`, текст поля), хватит `@State` прямо в View.

---

## 3. Навигация: NavigationStack + маршруты-значения

Вместо `pushViewController` навигация описывается **данными**: стек — это массив значений, экраны строятся по значению.

```swift
enum Route: Hashable {
    case itemDetail(UUID)
    case settings
}

@MainActor @Observable
final class AppRouter {
    var path: [Route] = []
    var sheet: Sheet?

    enum Sheet: Identifiable { case newItem; var id: Self { self } }

    func push(_ r: Route) { path.append(r) }
    func popToRoot() { path.removeAll() }
}
```

```swift
struct RootView: View {
    @State private var router = AppRouter()
    @Environment(\.apiClient) private var api

    var body: some View {
        NavigationStack(path: $router.path) {
            ItemListView(api: api)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .itemDetail(let id): ItemDetailView(id: id)
                    case .settings: SettingsView()
                    }
                }
        }
        .sheet(item: $router.sheet) { sheet in
            switch sheet { case .newItem: NewItemView() }
        }
        .environment(router)
    }
}
```

Плюсы по сравнению с координаторами в UIKit: диплинк = просто собрать массив `path`, состояние навигации можно сохранить/восстановить (`Route: Codable`), «назад до корня» = `path.removeAll()`.

Если появятся вкладки: `TabView` с отдельным `NavigationStack` (и своим `path`) в каждой вкладке.

---

## 4. Сетевой слой на async/await

Тонкий клиент поверх `URLSession`, без Alamofire.

```swift
struct Endpoint<Response: Decodable & Sendable>: Sendable {
    var method = "GET"
    var path: String
    var body: (any Encodable & Sendable)?
}

extension Endpoint where Response == [ItemDTO] {
    static var items: Self { .init(path: "/api/items") }
}
extension Endpoint where Response == ItemDTO {
    static func item(_ id: UUID) -> Self { .init(path: "/api/items/\(id)") }
    static func create(_ dto: ItemDTO) -> Self { .init(method: "POST", path: "/api/items", body: dto) }
}
```

```swift
final class APIClient: Sendable {   // без изменяемого состояния → безопасно делить между потоками
    let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) { self.baseURL = baseURL; self.session = session }

    func send<R>(_ endpoint: Endpoint<R>) async throws -> R {
        var request = URLRequest(url: baseURL.appending(path: endpoint.path))
        request.httpMethod = endpoint.method
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder.api.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder.api.decode(R.self, from: data)
    }
}

enum APIError: Error { case badStatus(Int) }

// Кладём клиент в окружение через @Entry (iOS 18): .environment(\.apiClient, client)
extension EnvironmentValues {
    @Entry var apiClient = APIClient(baseURL: URL(string: "http://localhost:8080")!)
}

extension JSONDecoder { static let api: JSONDecoder = { let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d }() }
extension JSONEncoder { static let api: JSONEncoder = { let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e }() }
```

На что обратить внимание:
- Тип ответа зашит в `Endpoint<Response>`, поэтому `try await api.send(.items)` сразу возвращает `[ItemDTO]`.
- Отмена бесплатна: `.task {}` отменяет задачу при уходе с экрана, `URLSession` прерывает запрос.
- Параллельно: `async let a = api.send(.items); async let b = api.send(.profile)` или `withThrowingTaskGroup`.
- Для тестов и превью: вынести `send` в протокол `APIClientProtocol` и подсунуть фейк. Локальный Vapor на симуляторе: `http://localhost:8080` (в Info.plist разрешить локальную сеть через `NSAllowsLocalNetworking`).
- Стратегия дат должна совпадать с Vapor (там по умолчанию тоже можно настроить `.iso8601`).

---

## 5. SwiftData: где и зачем

Сервер — источник правды. SwiftData на клиенте в такой схеме нужна для одного из двух сценариев:
1. **Офлайн-кэш**: показать прошлые данные мгновенно, обновить из сети.
2. **Чисто локальные данные**: черновики, избранное, настройки, которые не нужны на сервере.

Если в идее нет ни того, ни другого, SwiftData можно попробовать на маленьком кусочке (например, «избранное»), не тащить её везде.

```swift
import SwiftData

@Model
final class CachedItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdAt: Date
    init(_ dto: ItemDTO) { id = dto.id; title = dto.title; createdAt = dto.createdAt }
}

// MyApp.swift
@main
struct MyApp: App {
    private let api = APIClient(baseURL: URL(string: "http://localhost:8080")!)
    var body: some Scene {
        WindowGroup { RootView().environment(\.apiClient, api) }
            .modelContainer(for: CachedItem.self)
    }
}

// Во View — живой запрос, сам обновляет список при изменениях:
@Query(sort: \CachedItem.createdAt, order: .reverse) private var cached: [CachedItem]
@Environment(\.modelContext) private var context
```

Правила, чтобы не обжечься:
- `@Model`-объекты не `Sendable` и привязаны к своему контексту. В сеть и между потоками передавать DTO, а не `@Model`.
- Не делать DTO и `@Model` одним типом: сетевой контракт и схема хранения меняются независимо.
- Фоновая синхронизация большого объёма: через `@ModelActor`.
- Аналогия из UIKit-мира: SwiftData = Core Data с макросами; `@Query` ≈ `NSFetchedResultsController`, уже связанный с UI.

---

## 6. Сравнение с привычным UIKit-стеком

| Задача | UIKit (как было) | SwiftUI (как будет) |
|---|---|---|
| Список | `UICollectionView` + `DiffableDataSource` + снапшоты | `List` / `LazyVStack` + `ForEach` по `Identifiable`; дифф считает SwiftUI сам |
| Раскладка | `CompositionalLayout`, секции, группы | `List` со `Section`, `LazyVGrid`, `ScrollView(.horizontal)` + `.scrollTargetBehavior(.viewAligned)` для каруселей, `Grid`, свой `Layout` |
| Ячейка | `UICollectionViewCell` / `CellRegistration` + `UIContentConfiguration` | Обычная `View` |
| Состояние экрана | свойства VC + ручной `apply(snapshot)` / `reloadData` | `@Observable` модель; UI = функция от состояния |
| Реактивность | KVO / делегаты / Combine `@Published` | Observation, автоматическое отслеживание чтений |
| Навигация | `UINavigationController.push`, координаторы | `NavigationStack(path:)` + `navigationDestination(for:)` |
| Модалки | `present(_:animated:)` | `.sheet(item:)`, `.fullScreenCover`, `.alert`, `.confirmationDialog` |
| Жизненный цикл | `viewDidLoad`, `viewWillAppear` | `.task {}`, `.onAppear`, `.onChange(of:)` |
| Асинхронность | completion-хендлеры, `DispatchQueue.main.async` | `async/await`, `@MainActor`, `Task` |
| Pull-to-refresh | `UIRefreshControl` | `.refreshable { await ... }` |
| Поиск | `UISearchController` | `.searchable(text:)` |
| Пустое состояние | своя вью/`backgroundView` | `ContentUnavailableView` |
| DI | инициализаторы, контейнеры | инициализаторы + `.environment(...)` |
| Хранение | Core Data, `NSFetchedResultsController` | SwiftData, `@Model`, `@Query` |
| Превью | запуск на симуляторе | `#Preview { ... }` с фейковыми данными |

Где SwiftUI пока хуже и не стыдно уйти в UIKit через `UIViewRepresentable`/`UIViewControllerRepresentable`: очень сложные кастомные коллекции с тонкой настройкой переиспользования, сложная работа с текстом (`UITextView` с атрибутами), отдельные системные контроллеры без SwiftUI-аналога.

Главный сдвиг в голове: **не «как обновить UI», а «какое состояние, и UI его просто отображает»**. Нет `apply(snapshot)`: поменял массив в модели — список обновился с анимацией (`withAnimation { ... }`).

---

## 7. Порядок изучения на этом проекте

1. Пустой проект, один экран со статическим `List` и `#Preview`.
2. `@Observable`-модель с фейковыми данными, состояния loading/error/loaded.
3. `NavigationStack` с `Route`, экран деталей, `.sheet` для создания.
4. Пакет `Shared` и `APIClient`, подключение к локальному Vapor.
5. SwiftData для кэша или избранного.
6. Swift 6 strict concurrency: разобрать все предупреждения, понять `Sendable` и `@MainActor`.
7. Тесты на Swift Testing (`@Test`, `#expect`) для моделей с фейковым APIClient.
