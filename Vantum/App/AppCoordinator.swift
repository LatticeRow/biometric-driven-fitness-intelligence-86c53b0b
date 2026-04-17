import Observation
import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case trends = "Trends"
    case plan = "Plan"
    case settings = "Settings"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .dashboard: "bolt.heart"
        case .trends: "chart.line.uptrend.xyaxis"
        case .plan: "calendar"
        case .settings: "gearshape"
        }
    }
}

enum TrainingGoal: String, CaseIterable, Identifiable {
    case strength = "Strength"
    case conditioning = "Conditioning"
    case recovery = "Recovery"

    var id: String { rawValue }
}

enum TrendMetric: String, CaseIterable, Identifiable {
    case sleep = "Sleep"
    case resting = "Resting"
    case weight = "Weight"

    var id: String { rawValue }
}

@MainActor
@Observable
final class AppCoordinator {
    var selectedTab: AppTab = .dashboard
    var showingOnboarding = false

    var athleteName = "Athlete"
    var onboardingName = ""
    var trainingGoal: TrainingGoal = .strength
    var reminderEnabled = true

    var trendMetric: TrendMetric = .sleep
    var planFocus: TrainingGoal = .strength
    var isDeloadEnabled = false

    var recoveryScore = 82
    var lastRefresh = Date()

    var recoveryStatus: String {
        switch recoveryScore {
        case 75...: "Green"
        case 55..<75: "Yellow"
        case 35..<55: "Orange"
        default: "Red"
        }
    }

    var recoverySummary: String {
        switch recoveryStatus {
        case "Green":
            "Keep your main lift. Add nothing extra."
        case "Yellow":
            "Keep the session. Trim the top end."
        case "Orange":
            "Lower volume and cap effort."
        default:
            "Swap today for zone 2 and mobility."
        }
    }

    var drivers: [String] {
        switch trendMetric {
        case .sleep:
            ["Sleep is near baseline", "Resting rate is steady"]
        case .resting:
            ["Resting rate is elevated", "Sleep is slightly down"]
        case .weight:
            ["Weight trend is stable", "Recovery looks consistent"]
        }
    }

    func refreshDashboard(using dateProvider: DateProviding) {
        lastRefresh = dateProvider.now()

        switch recoveryScore {
        case 75...:
            recoveryScore = 71
            trendMetric = .resting
        case 55..<75:
            recoveryScore = 61
            trendMetric = .weight
        default:
            recoveryScore = 82
            trendMetric = .sleep
        }
    }

    func presentOnboarding() {
        onboardingName = athleteName == "Athlete" ? "" : athleteName
        showingOnboarding = true
    }

    func dismissOnboarding() {
        showingOnboarding = false
    }

    func completeOnboarding() {
        let trimmedName = onboardingName.trimmingCharacters(in: .whitespacesAndNewlines)
        athleteName = trimmedName.isEmpty ? "Athlete" : trimmedName
        planFocus = trainingGoal
        showingOnboarding = false
    }

    func resetPreviewState() {
        onboardingName = ""
        athleteName = "Athlete"
        trainingGoal = .strength
        trendMetric = .sleep
        planFocus = .strength
        reminderEnabled = true
        isDeloadEnabled = false
        recoveryScore = 82
        lastRefresh = Date()
    }
}

struct AppCoordinatorView: View {
    let environment: AppEnvironment
    @Bindable var coordinator: AppCoordinator

    init(environment: AppEnvironment, coordinator: AppCoordinator) {
        self.environment = environment
        self.coordinator = coordinator
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack {
                DashboardView(
                    athleteName: coordinator.athleteName,
                    recoveryScore: coordinator.recoveryScore,
                    recoveryStatus: coordinator.recoveryStatus,
                    recoverySummary: coordinator.recoverySummary,
                    drivers: coordinator.drivers,
                    lastRefresh: coordinator.lastRefresh,
                    onRefresh: {
                        coordinator.refreshDashboard(using: environment.dateProvider)
                        environment.logger.log("Dashboard refreshed.")
                    },
                    onOpenSetup: coordinator.presentOnboarding
                )
            }
            .tag(AppTab.dashboard)
            .tabItem {
                Label(AppTab.dashboard.rawValue, systemImage: AppTab.dashboard.symbolName)
            }

            NavigationStack {
                TrendsView(selectedMetric: $coordinator.trendMetric)
            }
            .tag(AppTab.trends)
            .tabItem {
                Label(AppTab.trends.rawValue, systemImage: AppTab.trends.symbolName)
            }

            NavigationStack {
                PlanView(
                    planFocus: $coordinator.planFocus,
                    isDeloadEnabled: $coordinator.isDeloadEnabled
                )
            }
            .tag(AppTab.plan)
            .tabItem {
                Label(AppTab.plan.rawValue, systemImage: AppTab.plan.symbolName)
            }

            NavigationStack {
                SettingsView(
                    reminderEnabled: $coordinator.reminderEnabled,
                    onReviewSetup: coordinator.presentOnboarding,
                    onResetPreviewData: coordinator.resetPreviewState
                )
            }
            .tag(AppTab.settings)
            .tabItem {
                Label(AppTab.settings.rawValue, systemImage: AppTab.settings.symbolName)
            }
        }
        .sheet(isPresented: $coordinator.showingOnboarding) {
            OnboardingView(
                athleteName: $coordinator.onboardingName,
                trainingGoal: $coordinator.trainingGoal,
                reminderEnabled: $coordinator.reminderEnabled,
                onClose: coordinator.dismissOnboarding,
                onSave: coordinator.completeOnboarding
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .tint(AppTheme.accentGold)
        .background(AppTheme.sceneBackground.ignoresSafeArea())
    }
}
