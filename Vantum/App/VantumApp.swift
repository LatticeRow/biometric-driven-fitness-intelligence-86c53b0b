import SwiftData
import SwiftUI

@main
struct VantumApp: App {
    private let environment: AppEnvironment
    @State private var coordinator: AppCoordinator

    @MainActor
    init() {
        let environment = AppEnvironment.live()
        self.environment = environment

        let coordinator: AppCoordinator
        do {
            coordinator = AppCoordinator(settings: try environment.appSettingsRepository.loadOrCreate())
        } catch {
            environment.logger.log("Settings unavailable. Starting with defaults.")
            coordinator = AppCoordinator()
        }

        _coordinator = State(initialValue: coordinator)
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(environment: environment, coordinator: coordinator)
                .modelContainer(environment.persistenceController.container)
                .preferredColorScheme(.dark)
        }
    }
}
