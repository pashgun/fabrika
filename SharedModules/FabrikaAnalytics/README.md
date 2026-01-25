# FabrikaAnalytics

Privacy-first analytics module for all Fabrika iOS apps. Integrates Amplitude (product analytics) and AppsFlyer (attribution) with local SwiftData storage.

## Features

- ✅ **Privacy-First**: All events stored locally in SwiftData
- ✅ **Optional Cloud Sync**: Amplitude & AppsFlyer with user consent
- ✅ **User Stats**: Show users their progress
- ✅ **GDPR/ATT Compliant**: Full privacy controls
- ✅ **Simple API**: Following FSRSService pattern
- ✅ **Shared Module**: One implementation for all apps

## Installation

### Add to project.yml (XcodeGen)

```yaml
packages:
  FabrikaAnalytics:
    path: ../SharedModules/FabrikaAnalytics

targets:
  YourApp:
    dependencies:
      - package: FabrikaAnalytics
```

### Add to SwiftData Schema

```swift
import FabrikaAnalytics

let schema = Schema([
    // Your models
    User.self, Deck.self, Flashcard.self,
    // Analytics models
    AnalyticsEventRecord.self,
    SessionRecord.self,
    PrivacyConsent.self
])
```

## Quick Start

### 1. Initialize Service

```swift
import FabrikaAnalytics

@main
struct YourApp: App {
    let analyticsService: AnalyticsService

    init() {
        let config = AnalyticsConfiguration(
            enableAmplitude: true,
            enableAppsFlyer: true,
            enableCloudSync: UserDefaults.standard.bool(forKey: "analytics_consent"),
            hasUserConsent: UserDefaults.standard.bool(forKey: "analytics_consent"),
            amplitudeApiKey: "YOUR_AMPLITUDE_KEY",
            appsFlyerAppId: "YOUR_APPSFLYER_APP_ID",
            appsFlyerDevKey: "YOUR_APPSFLYER_DEV_KEY"
        )

        analyticsService = AnalyticsService(configuration: config)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.analyticsService, analyticsService)
        }
    }
}

// Add environment key
private struct AnalyticsServiceKey: EnvironmentKey {
    static let defaultValue = AnalyticsService()
}

extension EnvironmentValues {
    var analyticsService: AnalyticsService {
        get { self[AnalyticsServiceKey.self] }
        set { self[AnalyticsServiceKey.self] = newValue }
    }
}
```

### 2. Track Events

```swift
import FabrikaAnalytics

struct StudyView: View {
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Text("Study")
            .onAppear {
                analytics.track(
                    StandardEvent.screenViewed(screen: "Study"),
                    context: modelContext
                )
            }
    }

    func completeSession() {
        analytics.track(
            FlashcardEvent.studySessionCompleted(
                cardsReviewed: 10,
                duration: 120
            ),
            context: modelContext
        )
    }
}
```

### 3. Show User Stats

```swift
struct StatsView: View {
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    @State private var stats: UserStats?

    var body: some View {
        VStack {
            if let stats = stats {
                Text("Streak: \(stats.streakDays) days")
                Text("Cards Reviewed: \(stats.totalCardsReviewed)")
            }
        }
        .onAppear {
            stats = analytics.getUserStats(from: modelContext)
        }
    }
}
```

## Event Taxonomy

### Standard Events (All Apps)

- `app_launched` - App finishes launching
- `session_started` / `session_ended` - Session boundaries
- `screen_viewed` - Screen appears
- `feature_used` - User uses feature
- `setting_changed` - User changes setting
- `error_occurred` - Error happens

### Flashcard Events

- `deck_created` / `deck_deleted` - Deck management
- `study_session_started` / `study_session_completed` - Study flow
- `card_rated` - User rates card
- `card_created` / `card_deleted` - Card management
- `milestone_reached` - User hits milestone

### Naming Convention

- Use `snake_case`
- Use past tense
- Max 40 characters
- Start with lowercase letter

## Privacy

### MVP Mode (Local Only)

```swift
let config = AnalyticsConfiguration(
    enableAmplitude: false,
    enableAppsFlyer: false,
    enableCloudSync: false,
    hasUserConsent: true  // Always track locally
)
```

### Production Mode (With Consent)

```swift
let config = AnalyticsConfiguration(
    enableAmplitude: true,
    enableAppsFlyer: true,
    enableCloudSync: UserDefaults.standard.bool(forKey: "analytics_consent"),
    hasUserConsent: UserDefaults.standard.bool(forKey: "analytics_consent"),
    amplitudeApiKey: "YOUR_KEY",
    appsFlyerAppId: "YOUR_APP_ID",
    appsFlyerDevKey: "YOUR_DEV_KEY"
)
```

## Architecture

```
FabrikaAnalytics/
├── Core/
│   ├── AnalyticsService.swift      # Main service API
│   ├── AnalyticsConfiguration.swift
│   └── AnalyticsEvent.swift
├── Models/
│   ├── AnalyticsEventRecord.swift  # SwiftData models
│   ├── SessionRecord.swift
│   ├── UserStats.swift
│   └── PrivacyConsent.swift
├── Adapters/
│   ├── AmplitudeAdapter.swift      # Product analytics
│   └── AppsFlyerAdapter.swift      # Attribution
├── Events/
│   ├── StandardEvents.swift        # Common events
│   ├── FlashcardEvents.swift       # App-specific
│   └── EventTaxonomy.swift
└── Extensions/
    └── View+Analytics.swift
```

## License

MIT
