import Foundation

struct AppEnvironment {
    let dateProvider: DateProviding
    let logger: AppLogger
    let persistenceController: PersistenceController
    let appSettingsRepository: AppSettingsRepository
    let healthSyncCoordinator: HealthSyncCoordinator
    let importCoordinator: ImportCoordinator
    let recoveryTimelinePreview: RecoveryTimelinePreview
    let workoutAdjustmentEngine: WorkoutAdjustmentEngine
    let notificationScheduler: RecommendationNotificationScheduler
    let backgroundRefreshManager: BackgroundRefreshManager

    @MainActor
    static func live() -> AppEnvironment {
        let persistenceController = PersistenceController.shared
        let logger = AppLogger(subsystem: Bundle.main.bundleIdentifier ?? "com.atkinsonfam.vantum")

        return AppEnvironment(
            dateProvider: SystemDateProvider(),
            logger: logger,
            persistenceController: persistenceController,
            appSettingsRepository: AppSettingsRepository(modelContext: persistenceController.container.mainContext),
            healthSyncCoordinator: HealthSyncCoordinator(),
            importCoordinator: ImportCoordinator(),
            recoveryTimelinePreview: RecoveryTimelinePreview(),
            workoutAdjustmentEngine: WorkoutAdjustmentEngine(),
            notificationScheduler: RecommendationNotificationScheduler(),
            backgroundRefreshManager: BackgroundRefreshManager()
        )
    }
}
