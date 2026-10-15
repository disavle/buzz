# Buzz: экраны SwiftUI-клиента

Раскладка идеи из [idea.md](../idea.md) на экраны, модели и графики. Общие подходы (архитектура, навигация, сеть) описаны в [README.md](README.md), здесь только то, что специфично для Buzz.

> Навигация и слои данных пересмотрены в [architecture.md](architecture.md): вкладки и переходы держат координаторы на UIKit, данные приходят через ViewModel и сторы. Вёрстка экранов и графики ниже остаются в силе.

Допущения: iOS 18+, Swift 6, без сторонних библиотек. Этап 1 из idea.md: всё работает офлайн на SwiftData, сеть подключается позже.

> Локализация (ru + en): [localization.md](localization.md). Русские строки в примерах ниже — для наглядности, в коде это ключи String Catalog.

---

## 1. Карта приложения

```
TabView
├── Сегодня      NavigationStack → (деталь записи)          + sheet «Добавить»
├── Каталог      NavigationStack → деталь напитка            + sheet «Свой напиток»
├── Статистика   NavigationStack (переключатель Неделя/Месяц)
└── Настройки    Form
```

```swift
enum AppTab: Hashable { case today, catalog, stats, settings }

struct RootView: View {
    @State private var tab: AppTab = .today

    var body: some View {
        TabView(selection: $tab) {
            Tab("Сегодня", systemImage: "bolt.fill", value: .today) { TodayScreen() }
            Tab("Каталог", systemImage: "square.grid.2x2", value: .catalog) { CatalogScreen() }
            Tab("Статистика", systemImage: "chart.bar.xaxis", value: .stats) { StatsScreen() }
            Tab("Настройки", systemImage: "gearshape", value: .settings) { SettingsScreen() }
        }
    }
}
```

У каждой вкладки свой `NavigationStack` внутри экрана: так стеки независимы, как у `UITabBarController` с отдельными `UINavigationController`.

---

## 2. Структура папок

```
Buzz/
├── App/            BuzzApp.swift, RootView.swift
├── Data/
│   ├── DrinkModel.swift        @Model
│   ├── EntryModel.swift        @Model
│   ├── SeedCatalog.swift       захардкоженные напитки для этапа 1
│   └── Nutrition.swift         расчёт кофеина/сахара
├── Features/
│   ├── Today/       TodayScreen, CaffeineRing, EntryRow
│   ├── AddEntry/    AddEntrySheet, AddEntryModel
│   ├── Catalog/     CatalogScreen, DrinkCard, CustomDrinkForm
│   ├── Stats/       StatsScreen, StatsModel, графики по файлу на каждый
│   └── Settings/    SettingsScreen
├── Core/           APIClient, SyncService (этапы 3–4)
└── Preview Content/ PreviewData.swift (in-memory контейнер для #Preview)
```

Общий пакет с DTO у бэкенда называется `Shared` (`Shared/`), клиент подключит его же на этапе 3.

---

## 3. Локальные данные (SwiftData)

```swift
@Model
final class DrinkModel {
    @Attribute(.unique) var id: UUID
    var brand: String
    var name: String
    var volumeMl: Int
    var caffeinePer100ml: Double
    var sugarPer100ml: Double
    var imageURL: URL?
    var isCustom: Bool

    init(id: UUID = UUID(), brand: String, name: String, volumeMl: Int,
         caffeinePer100ml: Double, sugarPer100ml: Double, imageURL: URL? = nil, isCustom: Bool = false) { ... }
}

@Model
final class EntryModel {
    @Attribute(.unique) var id: UUID
    var drink: DrinkModel?          // связь; для API хранится drinkId
    var consumedAt: Date
    var volumeMl: Int
    var price: Decimal?
    var caffeineMg: Double          // считаем один раз при создании
    var sugarG: Double
    var updatedAt: Date
    var deletedAt: Date?            // мягкое удаление для синхронизации

    init(drink: DrinkModel, volumeMl: Int, consumedAt: Date = .now, price: Decimal? = nil) {
        self.id = UUID()
        self.drink = drink
        self.volumeMl = volumeMl
        self.consumedAt = consumedAt
        self.price = price
        self.caffeineMg = drink.caffeinePer100ml * Double(volumeMl) / 100
        self.sugarG = drink.sugarPer100ml * Double(volumeMl) / 100
        self.updatedAt = .now
    }
}
```

```swift
@main
struct BuzzApp: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: [DrinkModel.self, EntryModel.self]) { result in
                // при первом запуске залить SeedCatalog, если каталог пуст
            }
    }
}
```

Дневной лимит до появления бэкенда хранится в `@AppStorage("dailyCaffeineLimitMg") var limit = 400`.

**Превью:** `ModelContainer(for:..., configurations: .init(isStoredInMemoryOnly: true))` с несколькими записями, чтобы каждый экран открывался в `#Preview` без запуска приложения.

---

## 4. Экраны

### 4.1 Сегодня

Что на экране: кольцо «кофеин / лимит» с анимацией, под ним сахар за день, список сегодняшних банок (свайп удаляет), кнопка «+» в тулбаре открывает «Добавить».

Данные берутся прямо из `@Query`, отдельная модель экрану не нужна:

```swift
struct TodayScreen: View {
    @Query private var entries: [EntryModel]
    @AppStorage("dailyCaffeineLimitMg") private var limit = 400
    @State private var isAdding = false

    init() {
        let start = Calendar.current.startOfDay(for: .now)
        _entries = Query(filter: #Predicate<EntryModel> { $0.consumedAt >= start && $0.deletedAt == nil },
                         sort: \.consumedAt, order: .reverse)
    }

    private var caffeine: Double { entries.reduce(0) { $0 + $1.caffeineMg } }
    private var sugar: Double { entries.reduce(0) { $0 + $1.sugarG } }

    var body: some View {
        NavigationStack {
            List {
                Section { CaffeineRing(value: caffeine, limit: Double(limit)) }
                Section("Выпито сегодня") {
                    ForEach(entries) { EntryRow(entry: $0) }
                        .onDelete { /* entry.deletedAt = .now */ }
                }
            }
            .navigationTitle("Сегодня")
            .toolbar { Button("Добавить", systemImage: "plus") { isAdding = true } }
            .sheet(isPresented: $isAdding) { AddEntrySheet() }
            .overlay { if entries.isEmpty { ContentUnavailableView("Пока ни одной банки", systemImage: "bolt.slash") } }
        }
    }
}
```

Нюанс: «сегодня» вычисляется в `init`, после полуночи экран не обновится сам. Для учебного MVP достаточно; правильнее пересоздавать Query по `.onChange(of: scenePhase)` или по таймеру.

Кольцо прогресса (тренировка анимаций и `Shape`):

```swift
struct CaffeineRing: View {
    let value: Double, limit: Double
    private var progress: Double { min(value / limit, 1.5) }   // за лимит рисуем второй виток
    private var isOver: Bool { value > limit }

    var body: some View {
        ZStack {
            Circle().stroke(.quaternary, lineWidth: 18)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(isOver ? Color.red : Color.green, style: .init(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(duration: 0.6), value: progress)
            VStack {
                Text(value, format: .number.precision(.fractionLength(0))).font(.largeTitle.bold())
                    .contentTransition(.numericText(value: value))
                Text("из \(Int(limit)) мг").foregroundStyle(.secondary)
            }
        }
        .frame(height: 200)
        .sensoryFeedback(.warning, trigger: isOver) { _, new in new }   // хаптик при превышении
    }
}
```

### 4.2 Добавить (sheet)

Что на экране: сверху горизонтальная лента «Недавние» (последние 5 разных напитков), ниже поиск по каталогу; после выбора напитка форма: объём (Stepper или выбор 250/330/500/свой), время (`DatePicker`, по умолчанию сейчас), цена (необязательно). Внизу превью «+ 80 мг кофеина» и кнопка «Добавить».

```swift
@MainActor @Observable
final class AddEntryModel {
    var drink: DrinkModel?
    var volumeMl = 500
    var consumedAt = Date.now
    var priceText = ""

    var caffeinePreview: Double {
        guard let drink else { return 0 }
        return drink.caffeinePer100ml * Double(volumeMl) / 100
    }
    var canSave: Bool { drink != nil && volumeMl > 0 }

    func select(_ d: DrinkModel) { drink = d; volumeMl = d.volumeMl }

    func save(in context: ModelContext) {
        guard let drink else { return }
        let price = Decimal(string: priceText.replacingOccurrences(of: ",", with: "."))
        context.insert(EntryModel(drink: drink, volumeMl: volumeMl, consumedAt: consumedAt, price: price))
    }
}
```

Здесь отдельная `@Observable`-модель оправдана: состояние формы, вычисляемые превью, валидация. Закрытие через `@Environment(\.dismiss)`. Шит удобно сделать с `.presentationDetents([.medium, .large])`.

### 4.3 Каталог

Что на экране: `LazyVGrid` карточек (картинка банки или цветная заглушка с буквой бренда, название, «32 мг/100 мл»), `.searchable`, фильтр «Все / Мои» в тулбаре, «+» открывает форму своего напитка. Тап по карточке: деталь напитка, сколько раз пил, кнопка «Выпить сейчас».

```swift
LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
    ForEach(filtered) { drink in
        NavigationLink(value: drink) { DrinkCard(drink: drink) }
            .buttonStyle(.plain)
    }
}
.padding()
.navigationDestination(for: DrinkModel.self) { DrinkDetailScreen(drink: $0) }
```

`GridItem(.adaptive)` заменяет то, что в CompositionalLayout делалось через `NSCollectionLayoutGroup` с вычислением числа колонок от ширины.

Поиск с debounce (практика `Task` и отмены). На этапе 1, пока каталог локальный, хватит фильтра в памяти; debounce нужен, когда поиск пойдёт в сеть `/drinks?query=`:

```swift
.task(id: searchText) {
    try? await Task.sleep(for: .milliseconds(300))   // новый текст отменит эту задачу
    guard !Task.isCancelled else { return }
    await model.search(searchText)
}
```

`.task(id:)` перезапускается при каждом изменении `searchText` и отменяет предыдущий запуск: это и есть debounce без Combine.

Форма своего напитка: `Form` с `TextField` для бренда и названия, `TextField(value:format:)` для чисел, кнопка сохранения неактивна, пока поля не валидны.

### 4.4 Статистика (Swift Charts)

Сверху `Picker` с `.pickerStyle(.segmented)`: Неделя / Месяц. Под ним вертикальный `ScrollView` с четырьмя карточками-графиками. Данные считаются на клиенте из записей SwiftData в `StatsModel` (эндпоинт `/stats` подключится позже и вернёт те же структуры).

```swift
struct DayTotal: Identifiable { let day: Date; let caffeine: Double; var id: Date { day } }
struct HourBucket: Identifiable { let hour: Int; let count: Int; var id: Int { hour } }
struct BrandShare: Identifiable { let brand: String; let count: Int; var id: String { brand } }
struct WeekSpend: Identifiable { let weekStart: Date; let amount: Double; var id: Date { weekStart } }

@MainActor @Observable
final class StatsModel {
    enum Period: String, CaseIterable { case week = "Неделя", month = "Месяц" }
    var period: Period = .week

    private(set) var byDay: [DayTotal] = []
    private(set) var byHour: [HourBucket] = []
    private(set) var byBrand: [BrandShare] = []
    private(set) var spendByWeek: [WeekSpend] = []

    func recompute(from entries: [EntryModel]) {
        let cal = Calendar.current
        byDay = Dictionary(grouping: entries) { cal.startOfDay(for: $0.consumedAt) }
            .map { DayTotal(day: $0.key, caffeine: $0.value.reduce(0) { $0 + $1.caffeineMg }) }
            .sorted { $0.day < $1.day }
        byHour = Dictionary(grouping: entries) { cal.component(.hour, from: $0.consumedAt) }
            .map { HourBucket(hour: $0.key, count: $0.value.count) }
        byBrand = Dictionary(grouping: entries) { $0.drink?.brand ?? "Другое" }
            .map { BrandShare(brand: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
        // spendByWeek аналогично, группировка по cal.dateInterval(of: .weekOfYear, for:)
    }
}
```

Экран получает записи через `@Query` за период и вызывает `model.recompute(from:)` в `.onChange(of: entries, initial: true)`.

**1. Кофеин по дням + линия лимита** (BarMark + RuleMark)

```swift
Chart {
    ForEach(model.byDay) { d in
        BarMark(x: .value("День", d.day, unit: .day), y: .value("Кофеин, мг", d.caffeine))
            .foregroundStyle(d.caffeine > Double(limit) ? .red : .green)
            .cornerRadius(4)
    }
    RuleMark(y: .value("Лимит", limit))
        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
        .annotation(position: .top, alignment: .trailing) { Text("лимит \(limit) мг").font(.caption) }
}
.chartXAxis { AxisMarks(values: .stride(by: .day)) { AxisValueLabel(format: .dateTime.weekday(.narrow)) } }
.frame(height: 220)
```

Для месяца вместо подписи дня недели: `.dateTime.day()` и `stride(by: .day, count: 5)`. Дни без записей стоит дозаполнить нулями, иначе на графике будут дыры.

**2. Во сколько обычно пьёшь** (BarMark по часам 0–23)

```swift
Chart(model.byHour) {
    BarMark(x: .value("Час", $0.hour), y: .value("Банок", $0.count))
}
.chartXScale(domain: 0...23)
.chartXAxis { AxisMarks(values: [0, 6, 12, 18, 23]) }
```

**3. Любимые бренды** (SectorMark, бублик)

```swift
Chart(model.byBrand.prefix(5)) {
    SectorMark(angle: .value("Банок", $0.count), innerRadius: .ratio(0.6), angularInset: 2)
        .foregroundStyle(by: .value("Бренд", $0.brand))
        .cornerRadius(4)
}
.chartLegend(position: .trailing)
.frame(height: 200)
```

Можно добавить выбор сектора по тапу: `.chartAngleSelection(value: $selectedCount)` и показать бренд в центре через `.chartBackground`.

**4. Траты по неделям** (LineMark + PointMark)

```swift
Chart(model.spendByWeek) {
    LineMark(x: .value("Неделя", $0.weekStart, unit: .weekOfYear), y: .value("₽", $0.amount))
        .interpolationMethod(.catmullRom)
    PointMark(x: .value("Неделя", $0.weekStart, unit: .weekOfYear), y: .value("₽", $0.amount))
}
.chartYAxis { AxisMarks(format: .currency(code: "RUB")) }
```

Что ещё попробовать в Charts, когда базовое заработает: выбор столбца пальцем (`.chartXSelection(value:)` + `RuleMark` с аннотацией-подсказкой), прокрутка длинного периода (`.chartScrollableAxes(.horizontal)` + `.chartXVisibleDomain(length:)`), анимация появления (`withAnimation` при смене периода).

### 4.5 Настройки

`Form` из секций: «Лимит» (`Stepper` с шагом 50 мг, привязан к `@AppStorage`), «Аккаунт» (вход/выход, появится на этапе 4), «Синхронизация» (кнопка «Синхронизировать сейчас» и дата последней синхронизации), «О приложении».

---

## 5. Сравнение с UIKit на этих экранах

| Экран | В UIKit было бы | В SwiftUI |
|---|---|---|
| Сегодня | VC + `UICollectionView` с двумя секциями, снапшот, `NSFetchedResultsController`, кастомный `CAShapeLayer` для кольца | `List` из `@Query`, кольцо из двух `Circle().trim`, анимация одной строкой |
| Добавить | модальный VC, делегат обратно в «Сегодня» для обновления | `.sheet`, просто `context.insert`, «Сегодня» обновится сам через `@Query` |
| Каталог | CompositionalLayout с адаптивными колонками, `UISearchController`, ручной debounce | `LazyVGrid(.adaptive)`, `.searchable`, `.task(id:)` |
| Статистика | DGCharts/своя отрисовка | Swift Charts, декларативно |

---

## 6. Порядок реализации (этапы 1–2 из idea.md)

1. Проект, `TabView` с четырьмя пустыми вкладками, SwiftData-модели, `SeedCatalog` с 8–10 реальными банками.
2. «Сегодня»: список из `@Query` и удаление, затем `CaffeineRing` с анимацией.
3. «Добавить»: sheet с выбором из каталога, форма, сохранение.
4. «Каталог»: сетка, поиск, деталь напитка, форма своего напитка.
5. «Статистика»: сначала график 1 (кофеин по дням + лимит), затем остальные три.
6. «Настройки»: лимит.
7. Превью для каждого экрана на in-memory контейнере и тесты `StatsModel` на Swift Testing.

Дальше (этапы 3–4) подключаются `APIClient`, пакет `Shared` с DTO для Drink и Entry и `SyncService` как `actor`, который тянет `/sync?since=` и отправляет записи с `updatedAt` новее последней синхронизации.
