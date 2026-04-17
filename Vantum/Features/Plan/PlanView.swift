import SwiftUI

struct PlanView: View {
    @Binding var planFocus: TrainingGoal
    @Binding var isDeloadEnabled: Bool
    let workoutAdjustment: WorkoutAdjustment

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Plan")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.white)

                SectionCard(title: "Focus", eyebrow: "THIS WEEK") {
                    VStack(alignment: .leading, spacing: 18) {
                        Picker("Focus", selection: $planFocus) {
                            ForEach(TrainingGoal.allCases) { goal in
                                Text(goal.rawValue).tag(goal)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("planFocusPicker")

                        Toggle(isOn: $isDeloadEnabled) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Deload")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(isDeloadEnabled ? "Volume trimmed for the week." : "Run the week as planned.")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                            }
                        }
                        .tint(AppTheme.accentTeal)
                        .accessibilityIdentifier("deloadToggle")
                    }
                }

                SectionCard(title: "Today", eyebrow: "PRESCRIPTION") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(workoutAdjustment.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)

                        Text(workoutAdjustment.summary)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }
            .padding(24)
        }
        .background(AppTheme.sceneBackground.ignoresSafeArea())
        .navigationTitle("Plan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
