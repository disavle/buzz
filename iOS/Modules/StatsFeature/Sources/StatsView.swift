import Charts
import DesignSystem
import Domain
import SwiftUI

/// Four chart cards with Swift Charts. Each card starts with its main number, then the chart.
///
/// Swift Charts is declarative: you describe *marks* (BarMark, LineMark, SectorMark, RuleMark)
/// and the framework draws axes, scales and legends. In UIKit days this was DGCharts or custom drawing.
public struct StatsView: View {
    @State private var model: StatsViewModel

    public init(model: StatsViewModel) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker(selection: $model.period) {
                    Text("stats.week", bundle: .module).tag(StatsPeriod.week)
                    Text("stats.month", bundle: .module).tag(StatsPeriod.month)
                } label: {
                    Text("stats.period", bundle: .module)
                }
                .pickerStyle(.segmented)

                caffeineByDay
                byHour
                byBrand
                spending
            }
            .padding(.horizontal, BuzzMetrics.screenPadding)
            .padding(.bottom, 24)
        }
        .background(Color.buzzBackground)
        .navigationTitle(Text("stats.title", bundle: .module))
        // Reload with animation when the period changes: bars grow to the new values.
        .task(id: model.period) {
            await model.load()
        }
        .task { await model.observeChanges() }
        .animation(.easeInOut, value: model.snapshot)
        .refreshable { await model.refresh() }
    }

    // MARK: - 1. Caffeine by day + limit line (BarMark + RuleMark)

    private var caffeineByDay: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("stats.byDay.title", bundle: .module).font(.subheadline).foregroundStyle(.secondary)
            Text("stats.byDay.average \(BuzzFormat.caffeine(model.snapshot.averageMg))", bundle: .module)
                .font(.buzzMetric)

            Chart {
                ForEach(model.snapshot.byDay) { day in
                    BarMark(
                        x: .value(String(localized: "stats.axis.day", bundle: .module), day.day, unit: .day),
                        y: .value(String(localized: "stats.axis.caffeine", bundle: .module), day.caffeineMg)
                    )
                    // Orange when over the limit, accent color otherwise.
                    .foregroundStyle(
                        day.caffeineMg > Double(model.limitMg) ? AnyShapeStyle(Color.buzzOver) : AnyShapeStyle(.tint)
                    )
                    .cornerRadius(4)
                }
                RuleMark(y: .value(String(localized: "stats.axis.limit", bundle: .module), model.limitMg))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.secondary)
                    .annotation(position: .top, alignment: .trailing) {
                        Text("stats.limit \(BuzzFormat.caffeine(Double(model.limitMg)))", bundle: .module)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
            }
            .chartXAxis {
                // A week shows weekday letters; a month shows every 5th day number.
                if model.period == .week {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    }
                } else {
                    AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                        AxisValueLabel(format: .dateTime.day())
                    }
                }
            }
            .frame(height: 220)
        }
        .card()
    }

    // MARK: - 2. When you usually drink (BarMark by hour)

    private var byHour: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("stats.byHour.title", bundle: .module).font(.subheadline).foregroundStyle(.secondary)
            if let peak = model.snapshot.peakHour {
                Text(hourRange(peak)).font(.buzzMetric)
            }
            Chart(model.snapshot.byHour) { bucket in
                BarMark(
                    x: .value(String(localized: "stats.axis.hour", bundle: .module), bucket.hour),
                    y: .value(String(localized: "stats.axis.cans", bundle: .module), bucket.count)
                )
                .foregroundStyle(
                    bucket.hour == model.snapshot.peakHour ? AnyShapeStyle(.tint) : AnyShapeStyle(.tint.opacity(0.45))
                )
            }
            .chartXScale(domain: 0...23)
            .chartXAxis { AxisMarks(values: [0, 6, 12, 18, 23]) }
            .chartYAxis(.hidden)
            .frame(height: 140)
        }
        .card()
    }

    /// "14:00–15:00" in the user's time format.
    private func hourRange(_ hour: Int) -> String {
        let calendar = Calendar.current
        let start = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: .now) ?? .now
        let end = start.addingTimeInterval(3600)
        return (start..<end).formatted(.interval.hour().minute())
    }

    // MARK: - 3. Favorite brands (SectorMark donut)

    private var byBrand: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("stats.byBrand.title", bundle: .module).font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 20) {
                Chart(model.snapshot.byBrand) { share in
                    SectorMark(
                        angle: .value(String(localized: "stats.axis.cans", bundle: .module), share.count),
                        innerRadius: .ratio(0.62),
                        angularInset: 2
                    )
                    .cornerRadius(4)
                    // The same color as the brand tile everywhere in the app.
                    .foregroundStyle(share.brand.map(BrandPalette.color(for:)) ?? .gray)
                }
                .chartBackground { _ in
                    VStack(spacing: 0) {
                        Text(model.snapshot.totalCans.formatted()).font(.buzzMetric)
                        Text("stats.cans \(model.snapshot.totalCans)", bundle: .module)
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                .frame(width: 150, height: 150)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(model.snapshot.byBrand) { share in
                        HStack {
                            Circle().fill(share.brand.map(BrandPalette.color(for:)) ?? .gray).frame(
                                width: 10,
                                height: 10
                            )
                            if let brand = share.brand { Text(brand) } else { Text("stats.other", bundle: .module) }
                            Spacer()
                            Text(share.count.formatted()).monospacedDigit()
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
        .card()
    }

    // MARK: - 4. Spending by week (LineMark + PointMark)

    private var spending: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("stats.spend.title", bundle: .module).font(.subheadline).foregroundStyle(.secondary)
            Text(BuzzFormat.money(model.snapshot.lastWeekSpend)).font(.buzzMetric)
            Chart(model.snapshot.spendByWeek) { week in
                LineMark(
                    x: .value(String(localized: "stats.axis.week", bundle: .module), week.weekStart, unit: .weekOfYear),
                    y: .value(String(localized: "stats.axis.money", bundle: .module), week.amount)
                )
                .interpolationMethod(.catmullRom)  // smooth curve instead of straight segments
                PointMark(
                    x: .value(String(localized: "stats.axis.week", bundle: .module), week.weekStart, unit: .weekOfYear),
                    y: .value(String(localized: "stats.axis.money", bundle: .module), week.amount)
                )
            }
            .foregroundStyle(.tint)
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .currency(code: BuzzFormat.currencyCode).precision(.fractionLength(0)))
                }
            }
            .frame(height: 180)
        }
        .card()
    }
}

#Preview {
    NavigationStack {
        StatsView(
            model: StatsViewModel(
                entries: InMemoryEntryRepository(entries: PreviewData.history()),
                settings: InMemorySettingsRepository(),
                sync: NoopSyncService()
            )
        )
    }
    .buzzTheme()
}
