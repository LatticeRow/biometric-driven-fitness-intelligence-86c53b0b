import SwiftUI

struct OnboardingView: View {
    @Binding var athleteName: String
    @Binding var trainingGoal: TrainingGoal
    @Binding var reminderEnabled: Bool

    let onClose: () -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Image("LaunchMark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 76, height: 76)
                            .padding(14)
                            .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .stroke(AppTheme.cardStroke, lineWidth: 1)
                            )

                        Text("Make today simple.")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundStyle(.white)

                        Text("Data stays on this iPhone.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }

                    SectionCard(title: "Profile", eyebrow: "START") {
                        VStack(alignment: .leading, spacing: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                TextField("Your name", text: $athleteName)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                    .padding(14)
                                    .background(AppTheme.inputBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(AppTheme.cardStroke, lineWidth: 1)
                                    )
                                    .foregroundStyle(.white)
                                    .accessibilityIdentifier("athleteNameField")
                            }

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Goal")
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Picker("Goal", selection: $trainingGoal) {
                                    ForEach(TrainingGoal.allCases) { goal in
                                        Text(goal.rawValue).tag(goal)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .accessibilityIdentifier("goalPicker")
                            }

                            Toggle(isOn: $reminderEnabled) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Daily reminder")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("One quiet check-in.")
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                            }
                            .tint(AppTheme.accentTeal)
                            .accessibilityIdentifier("notificationsToggle")
                        }
                    }

                    HStack(spacing: 12) {
                        Button("Close", action: onClose)
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .tint(AppTheme.secondaryText)
                            .accessibilityIdentifier("closeOnboardingButton")

                        Button("Save", action: onSave)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(AppTheme.accentGold)
                            .foregroundStyle(.black)
                            .accessibilityIdentifier("saveOnboardingButton")
                    }
                }
                .padding(24)
            }
            .background(AppTheme.sceneBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: onSave)
                        .foregroundStyle(AppTheme.accentGold)
                }
            }
        }
    }
}
