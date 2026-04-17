import Foundation

struct AppEnvironment {
    let dateProvider: DateProviding
    let logger: AppLogger
    let persistenceController: PersistenceController

    @MainActor
    static func live() -> AppEnvironment {
        AppEnvironment(
            dateProvider: SystemDateProvider(),
            logger: AppLogger(subsystem: Bundle.main.bundleIdentifier ?? "com.atkinsonfam.vantum"),
            persistenceController: PersistenceController.shared
        )
    }
}
