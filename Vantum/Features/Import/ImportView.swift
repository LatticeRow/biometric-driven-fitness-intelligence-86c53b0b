import SwiftUI

struct ImportView: View {
    let coordinator: ImportCoordinator
    let onClose: () -> Void

    @State private var showingPlaceholderAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Import")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(.white)

                    SectionCard(title: coordinator.supportedSource, eyebrow: "FILES") {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(coordinator.summary)
                                .foregroundStyle(AppTheme.secondaryText)

                            ForEach(coordinator.metricNames, id: \.self) { metricName in
                                Label(metricName, systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.white)
                            }
                        }
                    }

                    Button("Choose export file") {
                        showingPlaceholderAlert = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(AppTheme.accentGold)
                    .foregroundStyle(.black)
                    .accessibilityIdentifier("chooseImportFileButton")
                }
                .padding(24)
            }
            .background(AppTheme.sceneBackground.ignoresSafeArea())
            .navigationTitle("Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: onClose)
                        .foregroundStyle(AppTheme.accentGold)
                        .accessibilityIdentifier("closeImportButton")
                }
            }
            .alert("Files import is next", isPresented: $showingPlaceholderAlert) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text("This shell is ready for a Files-based Google Fit importer.")
            }
        }
    }
}
