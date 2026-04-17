import SwiftUI

struct SettingsView: View {
    @Binding var reminderEnabled: Bool

    let onReviewSetup: () -> Void
    let onOpenImport: () -> Void
    let onResetPreviewData: () -> Void

    @State private var showingResetConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Settings")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundStyle(.white)

                SectionCard(title: "Privacy", eyebrow: "LOCAL") {
                    Text("Your data stays on this iPhone unless you choose to export it.")
                        .foregroundStyle(AppTheme.secondaryText)
                }

                SectionCard(title: "Reminders", eyebrow: "NOTICE") {
                    Toggle("Daily reminder", isOn: $reminderEnabled)
                        .tint(AppTheme.accentTeal)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("reminderToggle")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Button("Review setup", action: onReviewSetup)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(AppTheme.cardStroke)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("reviewSetupButton")

                    Button("Import", action: onOpenImport)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(AppTheme.cardStroke)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("openImportButton")

                    Button("Reset preview", role: .destructive) {
                        showingResetConfirmation = true
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("resetPreviewButton")
                }
            }
            .padding(24)
        }
        .background(AppTheme.sceneBackground.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset preview?", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) {
            }
            Button("Reset", role: .destructive, action: onResetPreviewData)
        } message: {
            Text("This clears placeholder data only.")
        }
    }
}
