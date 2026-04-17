import SwiftUI

struct TrendsView: View {
    @Binding var selectedMetric: TrendMetric

    private let metricData: [TrendMetric: [Double]] = [
        .sleep: [6.8, 7.0, 7.2, 6.9, 7.4, 7.1, 7.3],
        .resting: [51, 52, 54, 53, 51, 50, 49],
        .weight: [181, 181.4, 180.9, 181.1, 181.0, 180.8, 181.2],
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Trends")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.white)

                Picker("Metric", selection: $selectedMetric) {
                    ForEach(TrendMetric.allCases) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityIdentifier("trendMetricPicker")

                SectionCard(title: selectedMetric.rawValue, eyebrow: "7 DAYS") {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .bottom, spacing: 10) {
                            ForEach(Array((metricData[selectedMetric] ?? []).enumerated()), id: \.offset) { index, value in
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(index == 6 ? AppTheme.accentGold.gradient : AppTheme.accentTeal.opacity(0.75).gradient)
                                        .frame(width: 28, height: barHeight(for: value))

                                    Text(dayLabel(for: index))
                                        .font(.caption2)
                                        .foregroundStyle(AppTheme.tertiaryText)
                                }
                            }
                        }

                        Text(summaryText)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .padding(24)
        }
        .background(AppTheme.sceneBackground.ignoresSafeArea())
        .navigationTitle("Trends")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func barHeight(for value: Double) -> CGFloat {
        switch selectedMetric {
        case .sleep:
            CGFloat((value - 6.4) * 50)
        case .resting:
            CGFloat((value - 46) * 12)
        case .weight:
            CGFloat((value - 179.5) * 36)
        }
    }

    private func dayLabel(for index: Int) -> String {
        ["S", "M", "T", "W", "T", "F", "S"][index]
    }

    private var summaryText: String {
        switch selectedMetric {
        case .sleep:
            "Sleep has been steady this week."
        case .resting:
            "Resting rate is easing back down."
        case .weight:
            "Weight is stable."
        }
    }
}
