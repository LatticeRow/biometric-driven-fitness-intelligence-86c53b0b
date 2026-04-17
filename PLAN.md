# Biometric-Driven Fitness Intelligence

## Product Summary
Build a native iPhone app in SwiftUI that reads biometric data, analyzes recovery trends locally, and produces specific daily workout adjustments rather than generic fitness advice. The MVP should ingest Apple Health data directly and support Google Fit data on iPhone through user-imported export files in the Files app. The core product promise is concrete coaching output such as reduce squat top sets by one, cap intensity at RPE 7, or replace intervals with zone 2 cardio, with each recommendation tied to real recovery signals.

This plan is intentionally iPhone-native even though the source metadata also mentions web. The prompt explicitly requires a native iPhone app plan and local-first implementation, so web work is out of scope for this handoff.

## Primary User And Core Use Case
Target user: serious fitness enthusiasts who already train consistently and are frustrated by static templates and generic AI coaching.

Daily job to be done:
- open the app in the morning
- sync biometric data
- see a recovery summary
- view the planned workout for today
- receive a specific, justified adjustment to that session

The app should feel like a decision-support tool, not a chat toy.

## MVP Scope
In scope:
- HealthKit integration for sleep, resting heart rate, and body weight
- normalized daily aggregate storage in SwiftData
- rolling baseline and trend analysis
- daily recovery assessment
- configurable weekly workout template
- workout-specific daily adjustment engine
- dashboard and trends UI
- local notifications and best-effort background refresh
- Google Fit export import through Files app
- privacy controls and local data reset

Out of scope for MVP:
- social features
- subscriptions or billing
- cloud accounts and sync
- server-side AI orchestration
- direct Android companion app
- generic chatbot interface
- long-form coaching memory across months

## Product Behavior
Expected morning flow:
1. App launches and checks whether yesterday or today needs a biometric refresh.
2. HealthKit aggregates sleep, resting heart rate, and weight into normalized daily values.
3. Imported Google Fit metrics, if any, are merged into the same daily aggregate format.
4. Recovery scoring computes status and top metric drivers.
5. The workout engine looks up the planned session for the day and applies a rules-based adjustment.
6. The dashboard shows one clear recommendation with supporting evidence.

Example outputs the app should be able to produce:
- Sleep was 18 percent below your 7-day baseline and resting heart rate is up 6 bpm. Keep bench day, but remove one top set and cap all work at RPE 7.
- Weight trend is stable and sleep recovered to baseline. Run the planned interval session as written.
- Recovery is poor for the second day in a row. Replace tempo work with 30 minutes of zone 2 cardio and mobility.

## Key Technical Decisions
- Use SwiftUI for UI and app structure.
- Use SwiftData for local persistence.
- Use HealthKit as the source of truth for Apple biometric data.
- Persist normalized daily aggregates locally instead of every raw HealthKit sample.
- Keep analytics deterministic and testable.
- Keep narrative generation subordinate to the deterministic adjustment engine.
- Do not build a backend for MVP.

Recommended platform targets:
- minimum deployment target: iOS 17
- optional availability-gated enhancements for iOS 18 and newer if the agent wants on-device narrative polish

## iOS Sandbox And Platform Constraints
The downstream agent must respect the following constraints:
- HealthKit data is only available after explicit user consent. The app must handle denied and partial authorization cleanly.
- Background refresh is not guaranteed on iOS. Always recompute on foreground entry if data is stale.
- The app cannot browse arbitrary files. Google Fit support must use `FileImporter` and security-scoped access to user-selected files.
- A local-first iPhone app should not rely on a hidden cloud sync path for Google Fit. Treat import as the MVP-compatible implementation.
- Physical device testing is required for real HealthKit behavior. The simulator is not enough.

## Suggested Xcode Structure
Use a straightforward, feature-first layout. The exact names can vary, but keep the separation of concerns.

```text
BiometricCoach/
  App/
    BiometricCoachApp.swift
    AppCoordinator.swift
  Core/
    AppEnvironment.swift
    DateProvider.swift
    Logger.swift
  Persistence/
    PersistenceController.swift
    Models/
      UserProfile.swift
      WorkoutTemplate.swift
      PlannedSession.swift
      DailyMetricAggregate.swift
      RecoveryAssessment.swift
      CoachAdjustment.swift
      ImportRecord.swift
      AppSettings.swift
    Repositories/
      UserProfileRepository.swift
      MetricsRepository.swift
      WorkoutRepository.swift
      RecommendationRepository.swift
  Services/
    Health/
      HealthKitService.swift
      HealthAuthorizationManager.swift
      HealthMetricQueryBuilder.swift
      HealthSyncCoordinator.swift
    Import/
      ExternalMetricImporter.swift
      GoogleFitExportParser.swift
      ImportCoordinator.swift
    Analytics/
      BaselineCalculator.swift
      TrendAnalyzer.swift
      RecoveryScorer.swift
      MetricDriverExplainer.swift
    Coaching/
      WorkoutAdjustmentEngine.swift
      CoachingPolicy.swift
      CoachNarrativeService.swift
    Notifications/
      RecommendationNotificationScheduler.swift
  Background/
    BackgroundRefreshManager.swift
    AppRefreshTaskHandler.swift
  Features/
    Onboarding/
      OnboardingView.swift
      PermissionsStepView.swift
      InitialTemplateSetupView.swift
    Dashboard/
      DashboardView.swift
      RecoveryCardView.swift
      DailyAdjustmentCardView.swift
    Trends/
      TrendsView.swift
      MetricTrendChartView.swift
    Plan/
      PlanEditorView.swift
      AdjustmentDetailView.swift
    Import/
      ImportView.swift
      ImportHistoryView.swift
    Settings/
      SettingsView.swift
      PrivacyView.swift
      DataResetView.swift
  Shared/
    Components/
    Theme/
  Tests/
    Fixtures/
    RecoveryScorerTests.swift
    WorkoutAdjustmentEngineTests.swift
    GoogleFitExportParserTests.swift
```

## Data Model Notes
Use SwiftData models for the app-owned state. Keep HealthKit raw data out of the long-term local store unless there is a strong reason to cache it.

Suggested entities:
- `UserProfile`
  - training goal
  - preferred workout split
  - units
  - onboarding state
- `WorkoutTemplate`
  - name
  - goal type such as strength, hypertrophy, conditioning, recovery
  - weekly sessions
- `PlannedSession`
  - day of week
  - session type
  - baseline duration
  - baseline intensity guidance
  - baseline volume notes
- `DailyMetricAggregate`
  - date
  - source type such as HealthKit or imported file
  - sleep duration
  - resting heart rate
  - body weight
  - optional HRV or workout load if available later
  - sync timestamp
- `RecoveryAssessment`
  - date
  - recovery score
  - status band
  - top driver reasons
  - baseline deltas
- `CoachAdjustment`
  - date
  - planned session reference
  - adjusted prescription
  - explanation text
  - confidence or data completeness flag
- `ImportRecord`
  - file name
  - import timestamp
  - rows processed
  - status
- `AppSettings`
  - notification preference
  - reminder time
  - last successful refresh

Important modeling rule:
Normalize Apple Health and imported Google Fit data into the same aggregate representation before analytics run. Do not fork the analytics pipeline per source.

## Health Data Integration
### Apple Health
Implement a `HealthKitService` that wraps:
- authorization requests
- metric queries
- conversion from raw samples to daily aggregates
- availability checks

Required metrics for MVP:
- sleep duration
- resting heart rate
- body weight

Optional, only if easy and stable:
- workout history for recent training strain
- HRV as an enhancement when present

Aggregation guidance:
- sleep should aggregate into a single daily sleep duration figure using the sleep window most relevant to the next training day
- resting heart rate should use the daily resting value or nearest stable daily sample
- weight should use the most recent daily value and retain trend direction over 7 and 28 days

### Google Fit On iPhone
Do not design this as background OAuth sync for MVP. Instead:
- use `FileImporter`
- support one or two clearly defined export file shapes
- parse them into `DailyMetricAggregate`
- persist `ImportRecord` rows for auditability

If the agent cannot confidently support multiple file shapes in the first pass, ship one documented parser for a single export format and leave the parser protocol in place for future extension.

## Analytics Engine
The analytics layer is the core product differentiator. It must be deterministic, explainable, and well tested.

### Baselines
Compute rolling baselines for each metric:
- 7-day baseline for short-term recovery context
- 28-day baseline for broader trend context

Suggested outputs:
- current value
- delta versus 7-day baseline
- delta versus 28-day baseline
- confidence based on data completeness

### Recovery Scoring
Define a simple first-pass score from 0 to 100. The exact weights can be tuned later, but the first version should be explicit and stable.

Suggested signal weights:
- sleep versus 7-day baseline: 40 percent
- resting heart rate delta: 35 percent
- weight trend stability and abrupt drop flag: 15 percent
- recent training strain or workout density if available: 10 percent

Suggested status bands:
- `Green` at 75 and above
- `Yellow` at 55 to 74
- `Orange` at 35 to 54
- `Red` below 35

The recovery scorer should output:
- numeric score
- status band
- top two or three driver reasons
- data completeness flag

### Explainability Rule
Every recommendation shown to the user must cite why it changed. The UI should never show a vague statement such as low recovery without naming the metrics responsible.

## Workout Adjustment Engine
This engine converts a planned session plus the recovery assessment into a concrete daily change. Keep it rule-based.

Supported session types for MVP:
- strength
- hypertrophy
- conditioning
- recovery

Suggested adjustment mapping:
- `Green`
  - keep the workout as planned
  - optionally allow a minor progression note if trends are strong for several days
- `Yellow`
  - keep movement selection
  - reduce top-end intensity modestly or trim accessory volume by 10 to 15 percent
- `Orange`
  - cut working volume by about 20 to 30 percent
  - cap intensity around RPE 7
  - swap hard conditioning for easier aerobic work if applicable
- `Red`
  - replace the session with recovery work or zone 2 cardio and mobility
  - explain that the change is protective, not punitive

Session-specific examples:
- strength day: reduce top sets, lower intensity cap
- hypertrophy day: keep exercises, reduce total sets
- conditioning day: convert intervals to easier steady work
- recovery day: keep recovery session as written

The adjustment object should include:
- summary label
- concrete prescription changes
- reason bullets derived from metric drivers
- fallback message when data is incomplete

## Narrative Layer
If the downstream agent wants polished prose, keep it behind a `CoachNarrativeService` protocol. However:
- the deterministic recommendation object remains the product truth
- narrative generation must not invent changes not present in the rule output
- if no on-device model is used, template-generated language is acceptable

This prevents the app from becoming a generic AI wrapper.

## UI Plan
### Onboarding
Required steps:
- value proposition and privacy framing
- HealthKit permission request
- optional Google Fit import explanation
- basic training goal and workout template setup
- notification opt-in

### Dashboard
Show:
- current recovery score and status band
- top metric drivers
- today planned session
- daily adjustment card
- last sync time
- one tap refresh

### Trends
Include charts for:
- sleep duration
- resting heart rate
- weight

Each chart should make the baseline visible so users understand why the recommendation changed.

### Plan
Allow the user to:
- choose a simple goal
- configure a weekly workout template
- inspect the adjustment detail for today

### Settings And Privacy
Include:
- permission status
- import history
- notification settings
- delete local data
- brief privacy explanation that biometric data remains local for MVP

## Background Refresh And Notifications
Implement two freshness paths:
- guaranteed path: recompute on foreground entry when the last refresh is stale
- opportunistic path: `BackgroundTasks` refresh and local notification scheduling

Requirements:
- do not assume background tasks always run
- store the last successful refresh time
- avoid duplicate notification spam by tracking the last surfaced recommendation date

## Test Strategy
Automated tests are mandatory for the logic-heavy parts.

Unit test targets:
- `BaselineCalculator`
- `RecoveryScorer`
- `WorkoutAdjustmentEngine`
- `GoogleFitExportParser`
- repository logic if it contains filtering or merge rules

Testing approach:
- inject a fake date provider
- inject fake repositories and fake HealthKit service adapters
- use deterministic fixtures for metric histories
- verify both score values and explanation drivers

UI and integration checks:
- simulator smoke test for app launch, navigation, and empty states
- physical iPhone validation for HealthKit permission states and real query behavior
- manual validation for import flow, delete-data flow, and notifications

## Implementation Phases
### Phase 1: Project Skeleton
- scaffold the iOS app target and folder layout
- create app environment and dependency injection surface
- build a placeholder tab shell

### Phase 2: Local Models And Persistence
- add SwiftData container
- define models and repositories
- seed default settings and sample workout template support

### Phase 3: Biometric Ingestion
- implement HealthKit authorization and sync
- persist normalized daily aggregates
- add Google Fit export import flow

### Phase 4: Analytics And Adjustment Logic
- compute rolling baselines
- score recovery
- map recovery to workout adjustments
- generate explanation drivers

### Phase 5: Product UI
- replace placeholders with onboarding, dashboard, trends, plan, and settings flows
- surface all states including denied permission, no data, partial data, stale data

### Phase 6: Freshness, Notifications, And Hardening
- add background refresh
- add local notifications
- finalize delete-data and privacy controls
- run tests and manual device validation

## Acceptance Criteria
The implementation is complete when all of the following are true:
- The native iPhone app builds and runs in Xcode.
- HealthKit authorization works and the app can ingest sleep, resting heart rate, and weight.
- The app computes local baselines and a daily recovery assessment.
- The app produces a concrete workout adjustment for the user planned session.
- The recommendation includes explicit reasons tied to real biometric drivers.
- Google Fit exports can be imported through the Files app and merged into the same analytics pipeline.
- The app remains useful offline after sync and does not require an account.
- Privacy controls include local data reset and clear permission messaging.
- Automated tests cover core scoring, adjustment, and parsing logic.

## Risk Mitigations
- If HealthKit data is sparse, degrade gracefully and show a data completeness badge instead of blocking the user.
- If import parsing is messy, support one documented Google Fit export format first and keep the parser extensible.
- If background refresh proves unreliable, foreground refresh still preserves the main user value.
- If narrative generation becomes unstable, fall back to template-generated explanation text immediately.

## Execution Notes For The Downstream Agent
- Start from an empty repo and scaffold the app cleanly.
- Use git branch handoff for each major phase.
- Keep commits small and aligned to the task nodes below.
- Validate build health after each phase before moving on.
- Do not let the UI lead the data model. Implement storage and analytics first so the views stay thin.
- Do not introduce a backend unless a later human decision changes the product constraints.
- If a framework choice becomes ambiguous, favor the simplest Apple-native path that preserves local-first behavior.