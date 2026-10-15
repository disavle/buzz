# Buzz: русский и английский в клиенте

Требования в разделе «Языки» в [idea.md](../idea.md). Здесь описано, как их выполнить в нашей архитектуре: модули Tuist, координаторы на UIKit, MVVM, Clean и Redux ([architecture.md](architecture.md)).

Основной язык разработки (development language) — английский: ключи и исходные строки на английском, русский — перевод. Так проще с инструментами Xcode и с будущими языками. Если хочется наоборот, это меняется одной настройкой проекта.

---

## 1. String Catalog в модульном проекте

- В каждом модуле, где есть UI-текст, свой `Localizable.xcstrings`: `TodayFeature`, `AddEntryFeature`, `CatalogFeature`, `StatsFeature`, `SettingsFeature`, `DesignSystem`, App-таргет (вкладки, заголовки из координаторов, `InfoPlist.xcstrings` для разрешений).
- В Tuist у модуля должны быть `resources: ["Resources/**"]`. Тогда Tuist сгенерирует аксессор бандла (`Bundle.module`).
- Языки проекта: `ru` и `en`, в `Project.swift` указать `developmentRegion: "en"` и `knownRegions`/`CFBundleLocalizations` для обоих. Без этого iOS не покажет выбор языка в настройках приложения.

**Главная ловушка модулей:** `Text("Today")` по умолчанию ищет строку в главном бандле приложения, а не в модуле. Внутри модуля бандл надо указывать явно:

```swift
Text("today.title", bundle: .module)                               // SwiftUI
String(localized: "today.title", bundle: .module)                  // обычная строка
LocalizedStringResource("today.title", bundle: .atURL(Bundle.module.bundleURL))   // отложенный перевод
```

Чтобы не писать `bundle: .module` руками сотни раз, в каждом модуле заводим маленький хелпер или включаем генерацию символов (Xcode 26: Build Settings → «Generate String Catalog Symbols»). Тогда строки вызываются как `Text(.todayTitle)`, а опечатку в ключе поймает компилятор. Рекомендую генерацию символов: это заодно новая фича, которую стоит пощупать.

Ключи: семантические, с префиксом модуля (`today.empty.title`, `settings.sync.button`), а не фраза целиком. Фразу можно менять, не теряя переводы.

---

## 2. Где живут строки в каждом слое

| Слой | Что делаем |
|---|---|
| SwiftUI View | `Text("key", bundle: .module)` или сгенерированные символы |
| ViewModel (MVVM) | Отдаёт `LocalizedStringResource`, а не `String`, если текст зависит от состояния: перевод выполнит View в нужной локали (и в превью тоже) |
| Domain / use case-ы (Clean) | Без текстов. Ошибки — enum (`AddEntryError.invalidVolume`), перевод в Presentation: `extension AddEntryError { var message: LocalizedStringResource }` |
| Redux-состояние | В `State` храним не текст алерта, а значение: `var alert: SettingsAlert?` (enum). Так reducer-тесты не зависят от языка |
| Координаторы (UIKit) | `UITabBarItem(title: String(localized: "tab.today"), ...)`, `vc.title` аналогично |
| Ошибки сервера | Бэкенд присылает код (`"error": "limit_invalid"`), клиент переводит: `APIErrorCode` enum + `LocalizedStringResource` для каждого кейса, неизвестный код → общий текст |
| Данные | Бренды и названия напитков не переводим. Свои напитки пользователя — как ввёл |

Пример для Redux из [architecture-experiments.md](architecture-experiments.md), вместо `alert: String?`:

```swift
enum SettingsAlert: Equatable { case syncFailed }

extension SettingsAlert {
    var title: LocalizedStringResource {
        switch self { case .syncFailed: "settings.alert.syncFailed" }
    }
}
```

---

## 3. Плюрализация

В String Catalog строка с числом получает варианты (Vary by Plural). Для русского Xcode сам предложит формы `one / few / many / other`, для английского `one / other`.

```swift
Text("today.cans.count \(entries.count)", bundle: .module)
// ru: 1 банка · 3 банки · 5 банок      en: 1 can · 3 cans
```

Ключ с интерполяцией `\(Int)` в каталоге превращается в `today.cans.count %lld`, варианты заполняются в редакторе каталога. Каждый вариант, включая `one`, должен содержать само число (`%lld банка`), иначе Xcode 26 падает при сборке с ошибкой «Plural variation requires referencing the number». Если число показано отдельно (как в бублике статистики), нужна обычная строка без вариантов. Где пригодится в Buzz: «N банок сегодня», «N дней подряд без превышения», «N напитков в каталоге», «синхронизировано N записей».

---

## 4. Числа, единицы, даты и деньги

Только `FormatStyle`, никакой склейки `"\(value) мг"`:

```swift
// Кофеин и сахар
Measurement(value: caffeine, unit: UnitMass.milligrams)
    .formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle: .number.precision(.fractionLength(0))))
// ru: «160 мг»   en: «160 mg»

// Объём (usage: .asProvided, чтобы в США не превращалось в унции)
Measurement(value: 500, unit: UnitVolume.milliliters).formatted(.measurement(width: .abbreviated, usage: .asProvided))

// Цена: валюта из локали пользователя
price.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))

// Время записи и относительные даты
entry.consumedAt.formatted(date: .omitted, time: .shortened)       // 14:05 / 2:05 PM
lastSync.formatted(.relative(presentation: .named))                // «5 минут назад» / «5 minutes ago»

// Проценты в кольце
(caffeine / limit).formatted(.percent.precision(.fractionLength(0)))
```

Ввод чисел: `TextField(value: $price, format: .currency(code: ...))` вместо ручного парсинга с заменой запятой на точку, которая была в ранних примерах в [screens.md](screens.md). Формат сам понимает десятичный разделитель локали.

Цена хранится без валюты. Для учебного проекта считаем, что валюта всегда валюта устройства; если захочется честно, в `Entry` добавляется `currencyCode`.

---

## 5. Swift Charts

- Названия рядов и осей: `.value(String(localized: "stats.axis.day", bundle: .module), d.day, unit: .day)`. Внутри App-таргета хватит `LocalizedStringKey`, в модуле нужен бандл.
- Подписи дат на осях (`AxisValueLabel(format: .dateTime.weekday(.abbreviated))`) переводятся сами и учитывают первый день недели по локали: в ru неделя с понедельника, в en-US с воскресенья. Группировку по неделям в `StatsModel` считать через `Calendar.current`, чтобы она совпала с осью.
- Подпись линии лимита: `Text("stats.limit \(limit)", bundle: .module)` в `annotation`.
- Ось Y с единицами: `AxisMarks { AxisValueLabel { Text(Measurement(value: v, unit: UnitMass.milligrams).formatted(...)) } }`.
- Легенда брендов: бренды не переводятся, но «Другое» из группировки — переводимая строка, поэтому в модели хранить её как отдельный кейс, а не как строку бренда.
- Accessibility: `.accessibilityLabel` и `.accessibilityValue` у меток тоже из каталога; VoiceOver озвучивает графики на языке приложения.

---

## 6. Выбор языка в настройках

Отдельный переключатель языка внутри приложения не делаем: iOS сама показывает пункт «Язык» в системных настройках приложения, если в проекте больше одного языка. В «Настройках» Buzz — строка «Язык» с текущим языком и кнопкой, которая открывает системные настройки:

```swift
// Redux-эффект в SettingsFeature
case .languageTapped:
    return .run { _ in await env.openSystemSettings() }   // UIApplication.openSettingsURLString в координаторе
```

Текущий язык для подписи: `Locale.current.localizedString(forLanguageCode: Bundle.main.preferredLocalizations.first ?? "en")`.

При смене языка iOS перезапускает приложение, так что обновлять UI на лету не нужно. Поле `locale` у пользователя на сервере (на будущее для пушей) клиент отправляет в `PATCH /me` при старте, если язык поменялся.

---

## 7. Проверка

- Превью на обоих языках: `#Preview("ru") { TodayView(...).environment(\.locale, Locale(identifier: "ru")) }` и то же для `en`. Учти, что `\.locale` влияет на форматирование, а выбор строк из каталога в превью надёжнее проверять через схему.
- Схема запуска: Edit Scheme → Run → Options → App Language: Russian / English, плюс псевдоязыки «Double-Length» (ломается ли вёрстка от длинных строк) и «Right-to-Left».
- Тесты форматирования: `.formatted(... .locale(Locale(identifier: "ru_RU")))` и `#expect`, чтобы зафиксировать «160 мг» и «160 mg».
- Каталог подсвечивает непереведённые строки (статус «New» / «Needs Review»), смотреть в нём процент перевода по языкам перед каждым релизом.
- Snapshot-тесты, если дойдёт до них, гонять на двух языках.

---

## 8. Что поправить в остальных документах при реализации

- В примерах кода в [screens.md](screens.md) и [architecture.md](architecture.md) строки написаны по-русски прямо в коде (`Text("Сегодня")`) для наглядности. В реальном коде это ключи каталога с `bundle: .module`.
- Ручной парсинг цены в `AddEntryModel` / `AddEntryViewModel` заменить на `TextField(value:format:)`.
- `alert: String?` в Redux-примере заменить на enum (раздел 2).
