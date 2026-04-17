import Foundation
import SwiftData

@Model
final class AppSettings {
    var athleteName: String
    var trainingGoal: String
    var notificationsEnabled: Bool
    var updatedAt: Date

    init(
        athleteName: String = "",
        trainingGoal: String = TrainingGoal.strength.rawValue,
        notificationsEnabled: Bool = true,
        updatedAt: Date = .now
    ) {
        self.athleteName = athleteName
        self.trainingGoal = trainingGoal
        self.notificationsEnabled = notificationsEnabled
        self.updatedAt = updatedAt
    }
}
