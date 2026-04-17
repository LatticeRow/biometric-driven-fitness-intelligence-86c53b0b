import SwiftData

enum AppSettingsRepositoryError: Error {
    case fetchFailed
    case saveFailed
}

@MainActor
struct AppSettingsRepository {
    let modelContext: ModelContext

    func loadOrCreate() throws -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()

        let existingSettings: AppSettings?

        do {
            existingSettings = try modelContext.fetch(descriptor).first
        } catch {
            throw AppSettingsRepositoryError.fetchFailed
        }

        if let existing = existingSettings {
            return existing
        }

        let settings = AppSettings()
        modelContext.insert(settings)

        do {
            try modelContext.save()
        } catch {
            throw AppSettingsRepositoryError.saveFailed
        }

        return settings
    }

    func save(
        athleteName: String,
        trainingGoal: TrainingGoal,
        notificationsEnabled: Bool
    ) throws {
        let settings = try loadOrCreate()
        settings.athleteName = athleteName
        settings.trainingGoal = trainingGoal.rawValue
        settings.notificationsEnabled = notificationsEnabled
        settings.updatedAt = .now

        do {
            try modelContext.save()
        } catch {
            throw AppSettingsRepositoryError.saveFailed
        }
    }
}
