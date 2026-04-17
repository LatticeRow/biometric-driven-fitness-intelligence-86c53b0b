import SwiftUI

struct DashboardView: View {
    let athleteName: String
    let recoveryScore: Int
    let recoveryStatus: String
    let recoverySummary: String
    let drivers: [String]
    let lastRefresh: Date
    let onRefresh: () -> Void
    let onOpenSetup: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        Image("LaunchMark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Vantum")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundStyle(.white)

                            Text("Daily recovery")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }

                    Text(athleteName)
                        .font(.system(size: 40, weight: .semibold, design: .serif))
                        .foregroundStyle(.white)
                        .privacySensitive()

                    Text("Today")
                        .font(.headline)
                        .foregroundStyle(AppTheme.secondaryText)
                }

                SectionCard(title: "Recovery", eyebrow: recoveryStatus.uppercased()) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text("\(recoveryScore)")
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .privacySensitive()

                            Text("/100")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(AppTheme.secondaryText)
                        }

                        Text(recoverySummary)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)

                        ForEach(drivers, id: \.self) { driver in
                            Label(driver, systemImage: "circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.secondaryText)
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }

                SectionCard(title: "Plan", eyebrow: "TODAY") {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Strength day")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)

                        Text("Keep your main lift, cap the top set at RPE 7, and leave one set in reserve.")
                            .foregroundStyle(AppTheme.secondaryText)

                        Text("Updated \(lastRefresh.formatted(date: .omitted, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.tertiaryText)
                    }
                }

                HStack(spacing: 12) {
                    Button("Refresh", action: onRefresh)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(AppTheme.accentGold)
                        .foregroundStyle(.black)
                        .accessibilityIdentifier("refreshButton")

                    Button("Setup", action: onOpenSetup)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(AppTheme.cardStroke)
                        .accessibilityIdentifier("startSetupButton")
                }
            }
            .padding(24)
        }
        .background(AppTheme.sceneBackground.ignoresSafeArea())
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}
