import Foundation

struct RecoveryTimelinePreview {
    private let metricData: [TrendMetric: [Double]] = [
        .sleep: [6.8, 7.0, 7.2, 6.9, 7.4, 7.1, 7.3],
        .resting: [51, 52, 54, 53, 51, 50, 49],
        .weight: [181, 181.4, 180.9, 181.1, 181.0, 180.8, 181.2],
    ]

    func values(for metric: TrendMetric) -> [Double] {
        metricData[metric, default: []]
    }

    func summary(for metric: TrendMetric) -> String {
        switch metric {
        case .sleep:
            "Sleep has been steady this week."
        case .resting:
            "Resting rate is easing back down."
        case .weight:
            "Weight is stable."
        }
    }
}
