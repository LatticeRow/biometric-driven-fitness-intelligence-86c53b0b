import Foundation

struct DashboardSnapshot {
    let recoveryScore: Int
    let trendMetric: TrendMetric
    let lastRefresh: Date
}

struct HealthSyncCoordinator {
    func nextPreviewSnapshot(
        currentScore: Int,
        dateProvider: DateProviding
    ) -> DashboardSnapshot {
        let nextState: (score: Int, metric: TrendMetric)

        switch currentScore {
        case 75...:
            nextState = (71, .resting)
        case 55..<75:
            nextState = (61, .weight)
        default:
            nextState = (82, .sleep)
        }

        return DashboardSnapshot(
            recoveryScore: nextState.score,
            trendMetric: nextState.metric,
            lastRefresh: dateProvider.now()
        )
    }
}
