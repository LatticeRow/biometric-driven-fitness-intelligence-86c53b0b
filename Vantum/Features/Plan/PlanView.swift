import SwiftUI

struct PlanView: View {
    @Binding var planFocus: TrainingGoal
    @Binding var isDeloadEnabled: Bool

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
                        Text(sessionTitle)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)

                        Text(sessionSummary)
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

    private var sessionTitle: String {
        if isDeloadEnabled {
            return "Reduced load"
        }

        switch planFocus {
        case .strength:
            return "Heavy compound focus"
        case .conditioning:
            return "Aerobic quality focus"
        case .recovery:
            return "Recovery-first focus"
        }
    }

    private var sessionSummary: String {
        if isDeloadEnabled {
            return "Keep the same movements and cut total sets by 20 percent."
        }

        switch planFocus {
        case .strength:
            return "Keep the main lift and trim accessories if recovery slips."
        case .conditioning:
            return "Hold a steady interval session unless resting rate climbs."
        case .recovery:
            return "Prioritize zone 2 work and mobility."
        }
    }
}
