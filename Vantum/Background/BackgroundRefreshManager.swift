import Foundation

struct BackgroundRefreshManager {
    func shouldRefresh(
        lastRefresh: Date,
        now: Date
    ) -> Bool {
        now.timeIntervalSince(lastRefresh) > 60 * 60 * 6
    }
}
