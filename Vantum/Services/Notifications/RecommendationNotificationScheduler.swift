import Foundation

struct RecommendationNotificationScheduler {
    func applyPreviewPreference(
        isEnabled: Bool,
        logger: AppLogger
    ) {
        logger.log(isEnabled ? "Reminders enabled." : "Reminders disabled.")
    }
}
