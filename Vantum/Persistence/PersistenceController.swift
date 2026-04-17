import SwiftData

@MainActor
final class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        let schema = Schema([
            AppSettings.self,
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Unable to create model container: \(error)")
        }
    }
}
