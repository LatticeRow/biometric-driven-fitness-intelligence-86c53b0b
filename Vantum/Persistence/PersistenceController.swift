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
            if !inMemory,
               let fallbackContainer = try? ModelContainer(
                for: schema,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
               ) {
                container = fallbackContainer
                return
            }

            fatalError("Unable to create model container: \(error)")
        }
    }
}
