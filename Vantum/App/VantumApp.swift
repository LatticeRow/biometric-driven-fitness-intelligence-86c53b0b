import SwiftData
import SwiftUI

@main
struct VantumApp: App {
    @State private var coordinator = AppCoordinator()
    private let environment = AppEnvironment.live()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(environment: environment, coordinator: coordinator)
                .modelContainer(environment.persistenceController.container)
                .preferredColorScheme(.dark)
        }
    }
}
