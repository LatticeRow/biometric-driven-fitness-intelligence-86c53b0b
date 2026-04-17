import Foundation

struct WorkoutAdjustment {
    let title: String
    let summary: String
}

struct WorkoutAdjustmentEngine {
    func makeAdjustment(
        focus: TrainingGoal,
        isDeloadEnabled: Bool
    ) -> WorkoutAdjustment {
        if isDeloadEnabled {
            return WorkoutAdjustment(
                title: "Reduced load",
                summary: "Keep the same movements and cut total sets by 20 percent."
            )
        }

        switch focus {
        case .strength:
            return WorkoutAdjustment(
                title: "Heavy compound focus",
                summary: "Keep the main lift and trim accessories if recovery slips."
            )
        case .conditioning:
            return WorkoutAdjustment(
                title: "Aerobic quality focus",
                summary: "Hold a steady interval session unless resting rate climbs."
            )
        case .recovery:
            return WorkoutAdjustment(
                title: "Recovery-first focus",
                summary: "Prioritize zone 2 work and mobility."
            )
        }
    }
}
