# Buzz: дизайн и токены для SwiftUI

Макеты: [холст Buzz — дизайн iOS](https://claude.ai/artifact/DBEh5DEASJSWRzgj8Bvp2W) (5 экранов в светлой и тёмной теме и доска с токенами; ссылка приватная). Экспорт всех экранов в PNG лежит в [screens/](screens/), исходники артбордов — в [canvas/](canvas/).

Принцип: всё, что есть в системе, берём из системы (фоны, текст, разделители, таб-бар, сегменты, поиск, шит), тогда тёмная тема, Dynamic Type и Liquid Glass на iOS 26 работают сами. Своих цветов всего три, и они лежат в `Assets.xcassets` как Color Set с вариантами Any / Dark.

## Цвета

| Роль | SwiftUI | Светлая | Тёмная |
|---|---|---|---|
| Фон экрана | `Color(.systemGroupedBackground)` | #F2F2F7 | #000000 |
| Карточка | `Color(.secondarySystemGroupedBackground)` | #FFFFFF | #1C1C1E |
| Текст | `.primary` | #000000 | #FFFFFF |
| Вторичный текст | `.secondary` | системный | системный |
| Заливка контролов | `Color(.tertiarySystemFill)` | ≈#E3E3E8 | ≈#2C2C2E |
| Акцент, кофеин, кольцо, главные кнопки | `Color("BuzzAccent")`, он же AccentColor | #5B3DF5 | #9A8CFF |
| Мягкий фон акцента | `.buzzAccent.opacity(0.12)` | ≈#ECE8FF | ≈#2A2550 |
| Выше лимита | `Color("BuzzOver")` | #C2410C | #FF8A4C |
| Сахар | `Color("BuzzSugar")` | #0B7A86 | #4FD1D9 |

Плитки брендов (белая буква на цветном фоне, одинаковые в обеих темах): #3D5AFE, #4D7C0F, #C2410C, #BE185D, #0F766E, #475569. Цвет плитки выбирается по бренду детерминированно: сумма `unicodeScalars` названия по модулю 6 (`hashValue` не подходит, он меняется между запусками). Эти же цвета идут в SectorMark «Любимые бренды», чтобы бренд везде был одного цвета.

Красный/зелёный для «норма/превышение» заменены на фиолетовый/оранжевый: так различают и люди с дальтонизмом. Все пары текст/фон проверены на контраст не ниже 4.5:1.

## Типографика

Шрифт системный (SF Pro), стили Dynamic Type. Цифры (кофеин, сахар, деньги) в `.rounded` и `.monospacedDigit()`, чтобы не прыгали в `.contentTransition(.numericText())`.

| Где | SwiftUI |
|---|---|
| Заголовок экрана | `.navigationTitle` (largeTitle, 34) |
| Число в кольце | `.system(size: 52, weight: .bold, design: .rounded)` |
| Метрика в карточке графика | `.system(.title, design: .rounded).bold()` |
| Заголовок секции | `.title3.bold()` |
| Название напитка | `.headline` |
| Строка формы | `.body` |
| Подпись под строкой | `.footnote` + `.foregroundStyle(.secondary)` |
| Подписи осей, лимит | `.caption` |

## Формы и отступы

- Карточка секции: `RoundedRectangle(cornerRadius: 26, style: .continuous)`; карточка в сетке каталога: 22; плитка бренда 44–52 pt: 12–16.
- Поля экрана 16 pt, шаги между блоками 8 / 12 / 16 / 20.
- Кольцо: 210 pt, `lineWidth: 20`, `lineCap: .round`, трек `.quaternary` или `tertiarySystemFill`.
- Главная кнопка: `.buttonStyle(.borderedProminent)`, `.buttonBorderShape(.capsule)`, `.controlSize(.large)`.
- Зона нажатия не меньше 44×44 pt.

## Код

```swift
// Core/DesignSystem/Theme.swift
import SwiftUI

extension Color {
    static let buzzAccent = Color("BuzzAccent")
    static let buzzOver   = Color("BuzzOver")
    static let buzzSugar  = Color("BuzzSugar")
}

extension Font {
    static let buzzHero   = Font.system(size: 52, weight: .bold, design: .rounded).monospacedDigit()
    static let buzzMetric = Font.system(.title, design: .rounded).bold().monospacedDigit()
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground),
                        in: .rect(cornerRadius: 26, style: .continuous))
    }
}
extension View { func card() -> some View { modifier(CardBackground()) } }

// Charts: столбик меняет цвет при превышении лимита
// BarMark(...).foregroundStyle(day.caffeine > limit ? Color.buzzOver : Color.buzzAccent)
```

## Что на каких экранах (отличия от screens.md)

- **Сегодня**: под кольцом три плитки «Осталось / Сахар / Банок»; кнопка «+» в тулбаре.
- **Добавить**: лента «Недавние» сверху, выбранный напиток карточкой с кнопкой «Сменить», объём сегментом 250/330/500/Свой, предупреждение оранжевым, если запись превысит лимит.
- **Каталог**: фильтр «Все / Мои» сегментом под поиском, свой напиток помечен «мой».
- **Статистика**: каждая карточка начинается с главного числа (среднее, пиковый час, итог трат), потом график.
- **Настройки**: сверху карточка профиля (аватар с буквой, имя, статус синхронизации, по тапу экран профиля с выходом), дальше «Основной цвет», лимит со Stepper ±50 мг, синхронизация, версия.

## Основной цвет (выбирает пользователь)

Шесть вариантов, у каждого пара для светлой и тёмной темы. Меняется только акцент: кольцо, кнопки, активная вкладка, столбики графиков. «Выше лимита» всегда оранжевый, сахар всегда бирюзовый.

| id | Название | Светлая | Тёмная |
|---|---|---|---|
| violet (по умолчанию) | Фиолетовый | #5B3DF5 | #9A8CFF |
| blue | Синий | #0A5FD6 | #64A8FF |
| pink | Розовый | #C2185B | #FF7AB0 |
| green | Зелёный | #2E7D32 | #7BD88F |
| teal | Бирюзовый | #00796B | #5ED6C6 |
| graphite | Графит | #3A3A3C | #D1D1D6 |

В тёмной теме акценты светлые, поэтому текст на залитых акцентом кнопках там тёмный.

```swift
enum AccentChoice: String, CaseIterable, Identifiable {
    case violet, blue, pink, green, teal, graphite
    var id: Self { self }
    var color: Color { Color("Accent/\(rawValue)") }   // Color Set с Any/Dark в Assets
}

// BuzzApp
@AppStorage("accent") private var accent: AccentChoice = .violet
WindowGroup { RootView().tint(accent.color) }

// Настройки: ряд кружков, выбранный с обводкой и галочкой
Section("Основной цвет") {
    HStack {
        ForEach(AccentChoice.allCases) { choice in
            Button { accent = choice } label: {
                Circle().fill(choice.color).frame(width: 32, height: 32)
                    .overlay { if accent == choice { Image(systemName: "checkmark").font(.caption.bold()) } }
                    .padding(4)
                    .overlay(Circle().strokeBorder(accent == choice ? choice.color : .clear, lineWidth: 3))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
        }
    }
}
```

Внутри экранов вместо `Color.buzzAccent` используй `.tint` / `Color.accentColor`, тогда выбор применяется везде сам.

## Языки в макетах

Приложение на русском и английском (см. раздел «Языки» в [idea.md](../idea.md)). На холсте есть отдельный ряд «Buzz · English» с экранами «Сегодня» и «Настройки», у этих двух экранов язык переключается свойством `lang`.

- Английские подписи короче русских, поэтому вёрстку проверяем по русскому: самые длинные строки там «Синхронизировать сейчас», «Статистика» во вкладке и подпись под выбором цвета. Всё помещается без переносов.
- Формат времени разный: `18:40` и `6:40 PM`. Не склеивай строки вручную, пиши `entry.consumedAt.formatted(date: .omitted, time: .shortened)`, и формат подставится сам.
- Единицы тоже через форматтеры: «мг / mg», «мл / ml», «г / g» берутся из `Measurement<UnitMass>` и `Measurement<UnitVolume>` с `.formatted(.measurement(width: .abbreviated))`.
- Подзаголовок с датой: `Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide))` даёт «среда, 15 октября» и «Wednesday, October 15».
- Названия брендов и напитков не переводятся.
- В настройках, в секции «Приложение», есть строка «Язык». По тапу она открывает системную страницу приложения (`UIApplication.openSettingsURLString`), где iOS сама показывает выбор языка для приложений с несколькими локализациями. Своего переключателя внутри приложения не делаем.

## Синхронизация в интерфейсе

Логика описана в разделе «Зачем синхронизация» в [idea.md](../idea.md), здесь только то, как она выглядит.

- **Значок «не синхронизировано»**: у записи со `syncState != .synced` перед временем стоит SF Symbol `icloud.slash` размером `.footnote` в цвете `.secondary`, для VoiceOver подпись «Ещё не синхронизировано». Цвет не акцентный: это нормальное состояние, а не ошибка.
- **Pull to refresh** на «Сегодня» и «Статистике»: `.refreshable { await syncEngine.syncNow() }`. Системный индикатор над заголовком; если очередь не пуста, под ним подпись «Отправляю N записей, потом загружаю новое…» (плюрализация через String Catalog).
- **Настройки → Синхронизация**: строки «Последняя», «Ждут отправки: N» и кнопка «Синхронизировать сейчас».
- Ошибку сети при обновлении не показываем алертом: записи остаются с тем же значком, отправка повторится сама.

## Снек «банка добавлена»

В iOS нет готового снекбара, делаем свой оверлей.

- Появляется на «Сегодня» после сохранения в шите «Добавить»: капсула внизу, над таб-баром (отступ ~16 pt), тёмный фон (#1C1C1E в светлой теме, #3A3A3C в тёмной), белый текст.
- Слева кружок с галочкой, дальше две строки: «Monster Ultra добавлен» (`.subheadline.semibold`) и «+160 мг · сегодня 320 из 400 мг» (`.footnote`). Справа кнопка «Отменить», она удаляет только что созданную запись.
- Держится 3 секунды и сам уезжает вниз: `.transition(.move(edge: .bottom).combined(with: .opacity))`, а таймер через `.task(id: snack) { try? await Task.sleep(for: .seconds(3)); snack = nil }`.
- Вместе со снеком срабатывает `.sensoryFeedback(.success, trigger:)`. Если запись превысила лимит, хаптик `.warning`, и вторая строка оранжевая: «Лимит превышен на 80 мг».
- Для VoiceOver: `AccessibilityNotification.Announcement("Monster Ultra добавлен").post()`.
