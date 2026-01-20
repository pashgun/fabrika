# Phase 2 → Phase 3 Handoff: UI Engineer → Swift Developer

**Date**: 2026-01-20
**From**: UI Engineer
**To**: Swift Developer
**Project**: ZenCards MVP
**Status**: Phase 2 Complete ✅ → Phase 3 Ready to Start

---

## Executive Summary

Phase 2 (UI Engineer) has completed all MVP screen designs and the design system. This handoff provides the Swift Developer with:

- **Design System Reference**: Complete visual specifications in `design_system.md`
- **Screen Designs**: All 9 MVP screens in `screen_designs_mvp.md`
- **Implementation Priorities**: 3-phase development approach
- **Technical Specifications**: SwiftData models, FSRS integration, Widget implementation
- **Code Examples**: Reusable SwiftUI components
- **Accessibility Requirements**: VoiceOver, Dynamic Type, WCAG AA compliance

**MVP Scope**: 9 screens, Dark Mode only, iOS 17+ target, Paywall-first monetization

---

## Implementation Priorities

### Phase 3A: Foundation (Critical Path)
**Goal**: Core data layer + FSRS + basic review flow

1. **SwiftData Models** (Card, Deck, ReviewRecord)
2. **FSRS Integration** (swift-fsrs package wrapper)
3. **Review Session Screen** (front/back/actions)
4. **Basic Navigation** (TabView structure)

**Why First**: Review session is the core UX. Without FSRS algorithm, nothing else matters.

**Success Criteria**:
- User can create a card
- User can review a card with flip gesture
- FSRS algorithm schedules next review
- Review data persists in SwiftData

---

### Phase 3B: Paywall + Content Management
**Goal**: Monetization + full CRUD for decks/cards

5. **Adapty Paywall** (Subscription flow)
6. **Onboarding** (3 screens → Paywall)
7. **Deck List** (empty + populated)
8. **Card List** (empty + populated)
9. **Card Create/Edit** (with TTS preview)

**Why Second**: Paywall-first strategy requires early monetization gate. Content management enables users to build decks.

**Success Criteria**:
- New users see Onboarding → Paywall
- Subscription unlocks all features
- Users can create/edit/delete decks and cards
- TTS pronunciation works for back text

---

### Phase 3C: Interactive Widget (Killer Feature)
**Goal**: Home Screen widget with inline card review

10. **Widget Extension** (Small, Medium, Large sizes)
11. **App Intents** (FlipCardIntent, RateCardIntent)
12. **App Group Shared Container** (data sync between app/widget)
13. **Settings Screen** (Subscription management, Daily Reminder)

**Why Last**: Widget requires stable data layer and FSRS working. It's a differentiator but not blocking.

**Success Criteria**:
- Widget shows due cards from shared container
- User can rate cards directly from widget
- Widget updates timeline after rating
- Settings allow subscription management

---

## Technical Specifications

### 1. SwiftData Models

#### Card Model
```swift
import SwiftData
import Foundation

@Model
final class Card {
    @Attribute(.unique) var id: UUID
    var front: String
    var back: String
    var createdAt: Date
    var updatedAt: Date

    // FSRS State (from swift-fsrs Card struct)
    var stability: Double
    var difficulty: Double
    var elapsedDays: Int
    var scheduledDays: Int
    var reps: Int
    var lapses: Int
    var state: Int // 0=New, 1=Learning, 2=Review, 3=Relearning
    var lastReview: Date?
    var due: Date

    // Relationships
    var deck: Deck?

    @Relationship(deleteRule: .cascade, inverse: \ReviewRecord.card)
    var reviews: [ReviewRecord]?

    init(front: String, back: String, deck: Deck? = nil) {
        self.id = UUID()
        self.front = front
        self.back = back
        self.createdAt = Date()
        self.updatedAt = Date()

        // FSRS initial state (all new cards start as New)
        self.stability = 0.0
        self.difficulty = 0.0
        self.elapsedDays = 0
        self.scheduledDays = 0
        self.reps = 0
        self.lapses = 0
        self.state = 0 // New
        self.lastReview = nil
        self.due = Date() // Due immediately

        self.deck = deck
    }

    var isDue: Bool {
        due <= Date()
    }

    var isNew: Bool {
        state == 0
    }
}
```

#### Deck Model
```swift
import SwiftData
import Foundation

@Model
final class Deck {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String // For color badge (e.g., "#14B8A6")
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Card.deck)
    var cards: [Card]?

    init(name: String, colorHex: String = "#14B8A6") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var cardCount: Int {
        cards?.count ?? 0
    }

    var dueCount: Int {
        cards?.filter { $0.isDue }.count ?? 0
    }

    var newCount: Int {
        cards?.filter { $0.isNew }.count ?? 0
    }
}
```

#### ReviewRecord Model
```swift
import SwiftData
import Foundation

@Model
final class ReviewRecord {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var rating: Int // 1=Again, 2=Hard, 3=Good, 4=Easy
    var elapsedDays: Int // Days since last review
    var scheduledDays: Int // Days until next review (after this review)
    var state: Int // Card state at time of review

    var card: Card?

    init(card: Card, rating: Int, elapsedDays: Int, scheduledDays: Int, state: Int) {
        self.id = UUID()
        self.timestamp = Date()
        self.rating = rating
        self.elapsedDays = elapsedDays
        self.scheduledDays = scheduledDays
        self.state = state
        self.card = card
    }
}
```

#### ModelContainer Setup
```swift
import SwiftData
import SwiftUI

@main
struct ZenCardsApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                Card.self,
                Deck.self,
                ReviewRecord.self
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                groupContainer: .identifier("group.com.zencards.shared") // For widget access
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
```

---

### 2. FSRS Integration

#### Package Dependency
Add to `Package.swift` or Xcode project:

```swift
dependencies: [
    .package(url: "https://github.com/open-spaced-repetition/swift-fsrs", from: "5.0.0")
]
```

#### FSRSService Wrapper
```swift
import Foundation
import FSRS // from swift-fsrs package
import SwiftData

@MainActor
final class FSRSService {
    private let scheduler: FSRS

    init() {
        // Default parameters (can be customized later)
        let parameters = FSRSParameters(
            requestRetention: 0.9, // 90% retention target
            maximumInterval: 36500, // ~100 years
            w: [
                0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01, 1.49, 0.14,
                0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61
            ] // Default FSRS v5 weights
        )
        self.scheduler = FSRS(parameters: parameters)
    }

    /// Review a card and update its FSRS state
    func reviewCard(
        _ card: Card,
        rating: Rating, // Rating enum from swift-fsrs (Again=1, Hard=2, Good=3, Easy=4)
        modelContext: ModelContext
    ) {
        // Convert SwiftData Card → FSRS Card
        let fsrsCard = FSRS.Card(
            due: card.due,
            stability: card.stability,
            difficulty: card.difficulty,
            elapsedDays: card.elapsedDays,
            scheduledDays: card.scheduledDays,
            reps: card.reps,
            lapses: card.lapses,
            state: FSRS.State(rawValue: card.state) ?? .new,
            lastReview: card.lastReview
        )

        let now = Date()
        let reviewLog = scheduler.review(card: fsrsCard, rating: rating, reviewTime: now)

        // Update SwiftData Card with new FSRS state
        card.due = reviewLog.card.due
        card.stability = reviewLog.card.stability
        card.difficulty = reviewLog.card.difficulty
        card.elapsedDays = reviewLog.card.elapsedDays
        card.scheduledDays = reviewLog.card.scheduledDays
        card.reps = reviewLog.card.reps
        card.lapses = reviewLog.card.lapses
        card.state = reviewLog.card.state.rawValue
        card.lastReview = now
        card.updatedAt = now

        // Create ReviewRecord
        let record = ReviewRecord(
            card: card,
            rating: rating.rawValue,
            elapsedDays: reviewLog.elapsedDays,
            scheduledDays: reviewLog.scheduledDays,
            state: card.state
        )
        modelContext.insert(record)

        // Save changes
        try? modelContext.save()

        // Update widget timeline (if widget extension exists)
        WidgetCenter.shared.reloadAllTimelines()
    }

    /// Get all due cards across all decks
    func getDueCards(modelContext: ModelContext) -> [Card] {
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { card in
                card.due <= Date()
            },
            sortBy: [SortDescriptor(\.due)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Get due cards for a specific deck
    func getDueCards(for deck: Deck, modelContext: ModelContext) -> [Card] {
        let deckID = deck.id
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { card in
                card.due <= Date() && card.deck?.id == deckID
            },
            sortBy: [SortDescriptor(\.due)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}
```

#### Usage Example in Review Session
```swift
struct ReviewSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var fsrsService = FSRSService()
    @State private var currentCard: Card?
    @State private var isFlipped = false

    var body: some View {
        VStack {
            if let card = currentCard {
                // Card view with flip animation
                FlashcardView(
                    card: card,
                    isFlipped: $isFlipped
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isFlipped.toggle()
                    }
                }

                if isFlipped {
                    // Action buttons (only show on back)
                    HStack(spacing: 8) {
                        ActionButton(
                            label: "Again",
                            systemImage: "xmark",
                            color: .red
                        ) {
                            rateCard(.again)
                        }

                        ActionButton(
                            label: "Hard",
                            systemImage: "minus",
                            color: .orange
                        ) {
                            rateCard(.hard)
                        }

                        ActionButton(
                            label: "Easy",
                            systemImage: "checkmark",
                            color: .green
                        ) {
                            rateCard(.easy)
                        }
                    }
                }
            } else {
                // No cards due
                EmptyStateView(
                    systemImage: "checkmark.circle.fill",
                    title: "All Done!",
                    description: "No cards due right now"
                )
            }
        }
        .onAppear {
            loadNextCard()
        }
    }

    private func rateCard(_ rating: Rating) {
        guard let card = currentCard else { return }

        fsrsService.reviewCard(card, rating: rating, modelContext: modelContext)

        // Load next card
        isFlipped = false
        loadNextCard()
    }

    private func loadNextCard() {
        let dueCards = fsrsService.getDueCards(modelContext: modelContext)
        currentCard = dueCards.first
    }
}
```

---

### 3. Interactive Widget Implementation

#### Widget Extension Target
Create new Widget Extension target in Xcode:
- Target name: `ZenCardsWidget`
- Bundle ID: `com.zencards.app.widget`
- App Group: `group.com.zencards.shared` (enable in both app and widget)

#### Widget Entry + Timeline
```swift
import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct CardEntry: TimelineEntry {
    let date: Date
    let card: CardSnapshot? // Codable snapshot of Card
    let dueCount: Int
    let configuration: ConfigurationAppIntent
}

struct CardSnapshot: Codable, Identifiable {
    let id: UUID
    let front: String
    let back: String
    let due: Date
}

struct ZenCardsWidgetProvider: AppIntentTimelineProvider {
    typealias Entry = CardEntry
    typealias Intent = ConfigurationAppIntent

    func placeholder(in context: Context) -> CardEntry {
        CardEntry(
            date: Date(),
            card: CardSnapshot(
                id: UUID(),
                front: "What is spaced repetition?",
                back: "A learning technique that spaces reviews over time",
                due: Date()
            ),
            dueCount: 5,
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> CardEntry {
        await getEntry(for: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<CardEntry> {
        let entry = await getEntry(for: configuration)

        // Refresh timeline in 15 minutes or when next card is due
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()

        return Timeline(entries: [entry], policy: .after(refreshDate))
    }

    private func getEntry(for configuration: ConfigurationAppIntent) async -> CardEntry {
        // Read due cards from shared UserDefaults
        let sharedDefaults = UserDefaults(suiteName: "group.com.zencards.shared")

        guard let data = sharedDefaults?.data(forKey: "dueCards"),
              let cards = try? JSONDecoder().decode([CardSnapshot].self, from: data),
              let firstCard = cards.first else {
            return CardEntry(
                date: Date(),
                card: nil,
                dueCount: 0,
                configuration: configuration
            )
        }

        return CardEntry(
            date: Date(),
            card: firstCard,
            dueCount: cards.count,
            configuration: configuration
        )
    }
}
```

#### Widget Views (Small, Medium, Large)
```swift
struct ZenCardsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: CardEntry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .systemLarge:
                LargeWidgetView(entry: entry)
            default:
                MediumWidgetView(entry: entry)
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct MediumWidgetView: View {
    let entry: CardEntry

    var body: some View {
        if let card = entry.card {
            VStack(spacing: 12) {
                // Header with progress
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Color(hex: "#14B8A6"))
                    Text("\(entry.dueCount) left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                // Card question
                Text(card.front)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Action buttons
                HStack(spacing: 8) {
                    Button(intent: RateCardIntent(cardID: card.id, rating: 2)) {
                        Label("Hard", systemImage: "minus")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.thickMaterial)
                            .foregroundStyle(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.orange, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 4)) {
                        Label("Easy", systemImage: "checkmark")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.thickMaterial)
                            .foregroundStyle(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.green, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        } else {
            // No cards due
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.headline)
                Text("No cards due right now")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
    }
}

struct SmallWidgetView: View {
    let entry: CardEntry

    var body: some View {
        VStack(spacing: 8) {
            if let card = entry.card {
                Image(systemName: "brain.head.profile")
                    .font(.title)
                    .foregroundStyle(Color(hex: "#14B8A6"))

                Text("\(entry.dueCount)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "#14B8A6"))

                Text("due")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .padding(12)
    }
}

struct LargeWidgetView: View {
    let entry: CardEntry

    var body: some View {
        if let card = entry.card {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(Color(hex: "#14B8A6"))
                    Text("\(entry.dueCount) cards left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                // Card front (question)
                VStack(spacing: 12) {
                    Text(card.front)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity)

                    Divider()

                    // Card back (answer)
                    Text(card.back)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity)
                }
                .padding(16)
                .frame(maxHeight: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Action buttons (all 4 ratings)
                HStack(spacing: 8) {
                    Button(intent: RateCardIntent(cardID: card.id, rating: 1)) {
                        VStack(spacing: 4) {
                            Image(systemName: "xmark")
                            Text("Again")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.red, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 2)) {
                        VStack(spacing: 4) {
                            Image(systemName: "minus")
                            Text("Hard")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.orange, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 3)) {
                        VStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup")
                            Text("Good")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.blue, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(intent: RateCardIntent(cardID: card.id, rating: 4)) {
                        VStack(spacing: 4) {
                            Image(systemName: "checkmark")
                            Text("Easy")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.thickMaterial)
                        .foregroundStyle(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.green, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color(hex: "#14B8A6"))
                Text("All Done!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("No cards due right now. Great work!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
        }
    }
}
```

#### App Intents for Widget Actions
```swift
import AppIntents
import SwiftData
import WidgetKit

struct RateCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Rate Card"
    static var description: IntentDescription = IntentDescription("Rate a flashcard from the widget")

    @Parameter(title: "Card ID")
    var cardID: UUID

    @Parameter(title: "Rating")
    var rating: Int // 1=Again, 2=Hard, 3=Good, 4=Easy

    init() {}

    init(cardID: UUID, rating: Int) {
        self.cardID = cardID
        self.rating = rating
    }

    func perform() async throws -> some IntentResult {
        // Get shared ModelContainer
        let schema = Schema([Card.self, Deck.self, ReviewRecord.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.com.zencards.shared")
        )
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        let modelContext = ModelContext(modelContainer)

        // Fetch card
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { card in
                card.id == cardID
            }
        )
        guard let card = try? modelContext.fetch(descriptor).first else {
            throw IntentError.message("Card not found")
        }

        // Convert rating Int → FSRS Rating enum
        let fsrsRating: Rating
        switch rating {
        case 1: fsrsRating = .again
        case 2: fsrsRating = .hard
        case 3: fsrsRating = .good
        case 4: fsrsRating = .easy
        default: fsrsRating = .good
        }

        // Review card
        let fsrsService = FSRSService()
        await fsrsService.reviewCard(card, rating: fsrsRating, modelContext: modelContext)

        // Update shared UserDefaults for widget
        updateSharedDueCards(modelContext: modelContext)

        // Reload widget timeline
        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }

    private func updateSharedDueCards(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { card in
                card.due <= Date()
            },
            sortBy: [SortDescriptor(\.due)]
        )

        guard let dueCards = try? modelContext.fetch(descriptor) else { return }

        let snapshots = dueCards.prefix(10).map { card in
            CardSnapshot(id: card.id, front: card.front, back: card.back, due: card.due)
        }

        let sharedDefaults = UserDefaults(suiteName: "group.com.zencards.shared")
        if let data = try? JSONEncoder().encode(snapshots) {
            sharedDefaults?.set(data, forKey: "dueCards")
        }
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description: IntentDescription = IntentDescription("Configure your ZenCards widget")

    // Future: Add deck filtering parameter
    // @Parameter(title: "Deck")
    // var deck: DeckEntity?
}
```

#### Widget Registration
```swift
import WidgetKit
import SwiftUI

@main
struct ZenCardsWidgetBundle: WidgetBundle {
    var body: some Widget {
        ZenCardsWidget()
    }
}

struct ZenCardsWidget: Widget {
    let kind: String = "ZenCardsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: ZenCardsWidgetProvider()
        ) { entry in
            ZenCardsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ZenCards")
        .description("Review flashcards right from your Home Screen")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled() // For edge-to-edge design
    }
}
```

#### Update Shared Data from Main App
In main app, update shared UserDefaults whenever cards are reviewed or created:

```swift
// Add to FSRSService or CardViewModel
func syncDueCardsToWidget(modelContext: ModelContext) {
    let descriptor = FetchDescriptor<Card>(
        predicate: #Predicate { card in
            card.due <= Date()
        },
        sortBy: [SortDescriptor(\.due)]
    )

    guard let dueCards = try? modelContext.fetch(descriptor) else { return }

    let snapshots = dueCards.prefix(10).map { card in
        CardSnapshot(id: card.id, front: card.front, back: card.back, due: card.due)
    }

    let sharedDefaults = UserDefaults(suiteName: "group.com.zencards.shared")
    if let data = try? JSONEncoder().encode(snapshots) {
        sharedDefaults?.set(data, forKey: "dueCards")
    }

    WidgetCenter.shared.reloadAllTimelines()
}
```

---

### 4. Adapty SDK Integration

#### Add Adapty SDK
SPM: `https://github.com/adaptyteam/AdaptySDK-iOS`
Version: `3.0.0` or later

#### Adapty Setup in App
```swift
import Adapty
import SwiftUI

@main
struct ZenCardsApp: App {
    let modelContainer: ModelContainer

    init() {
        // SwiftData setup (see above)
        // ...

        // Adapty setup
        Adapty.activate("PUBLIC_SDK_KEY_FROM_ADAPTY_DASHBOARD")
        Adapty.logLevel = .verbose // For debugging, remove in production
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
```

#### Paywall View
```swift
import SwiftUI
import Adapty

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var paywall: AdaptyPaywall?
    @State private var products: [AdaptyPaywallProduct] = []
    @State private var isLoading = true
    @State private var selectedProduct: AdaptyPaywallProduct?
    @State private var isPurchasing = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(hex: "#14B8A6").opacity(0.3),
                    Color(hex: "#10B981").opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 64))
                            .foregroundStyle(Color(hex: "#14B8A6"))

                        Text("Unlock Your Potential")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)

                        Text("Master any subject with spaced repetition")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(
                            icon: "sparkles",
                            title: "Modern FSRS Algorithm",
                            description: "Scientifically proven spaced repetition"
                        )

                        FeatureRow(
                            icon: "apps.iphone",
                            title: "Interactive Home Screen Widget",
                            description: "Review cards without opening the app"
                        )

                        FeatureRow(
                            icon: "infinity",
                            title: "Unlimited Cards & Decks",
                            description: "Create as many flashcards as you need"
                        )

                        FeatureRow(
                            icon: "speaker.wave.2",
                            title: "Text-to-Speech",
                            description: "Hear pronunciations for better learning"
                        )
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 16)

                    // Products
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(products, id: \.vendorProductId) { product in
                                ProductCard(
                                    product: product,
                                    isSelected: selectedProduct?.vendorProductId == product.vendorProductId
                                )
                                .onTapGesture {
                                    selectedProduct = product
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // CTA Button
                    if let selected = selectedProduct {
                        Button {
                            purchase(selected)
                        } label: {
                            Group {
                                if isPurchasing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Start Learning")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#14B8A6"),
                                        Color(hex: "#10B981")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(isPurchasing)
                        .padding(.horizontal, 16)
                    }

                    // Footer
                    VStack(spacing: 8) {
                        Button("Restore Purchases") {
                            restorePurchases()
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        HStack(spacing: 16) {
                            Link("Privacy Policy", destination: URL(string: "https://zencards.app/privacy")!)
                            Text("•")
                            Link("Terms of Use", destination: URL(string: "https://zencards.app/terms")!)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 32)
                }
            }

            // Error toast
            if let error = errorMessage {
                VStack {
                    Spacer()
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .padding()
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
                .transition(.move(edge: .bottom))
            }
        }
        .task {
            await loadPaywall()
        }
    }

    private func loadPaywall() async {
        do {
            let paywall = try await Adapty.getPaywall(placementId: "main_paywall")
            let products = try await Adapty.getPaywallProducts(paywall: paywall)

            await MainActor.run {
                self.paywall = paywall
                self.products = products
                self.selectedProduct = products.first // Auto-select first
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load paywall: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    private func purchase(_ product: AdaptyPaywallProduct) {
        isPurchasing = true
        errorMessage = nil

        Task {
            do {
                let profile = try await Adapty.makePurchase(product: product)

                await MainActor.run {
                    if profile.accessLevels["premium"]?.isActive == true {
                        // Premium unlocked!
                        dismiss()
                    } else {
                        self.errorMessage = "Purchase failed. Please try again."
                    }
                    self.isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isPurchasing = false
                }
            }
        }
    }

    private func restorePurchases() {
        isPurchasing = true
        errorMessage = nil

        Task {
            do {
                let profile = try await Adapty.restorePurchases()

                await MainActor.run {
                    if profile.accessLevels["premium"]?.isActive == true {
                        dismiss()
                    } else {
                        self.errorMessage = "No purchases found to restore."
                    }
                    self.isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Restore failed: \(error.localizedDescription)"
                    self.isPurchasing = false
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color(hex: "#14B8A6"))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ProductCard: View {
    let product: AdaptyPaywallProduct
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.localizedTitle)
                    .font(.headline)
                Text(product.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(product.localizedPrice ?? "")
                    .font(.title3)
                    .fontWeight(.bold)

                if product.subscriptionPeriod?.unit == .month {
                    Text("/month")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if product.subscriptionPeriod?.unit == .year {
                    Text("/year")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            isSelected ? Color(hex: "#14B8A6").opacity(0.2) : Color.clear
        )
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isSelected ? Color(hex: "#14B8A6") : Color.clear,
                    lineWidth: 2
                )
        )
    }
}
```

#### Check Premium Access
```swift
import Adapty

@MainActor
class SubscriptionService: ObservableObject {
    @Published var isPremium: Bool = false

    init() {
        checkAccess()
    }

    func checkAccess() {
        Task {
            do {
                let profile = try await Adapty.getProfile()
                await MainActor.run {
                    self.isPremium = profile.accessLevels["premium"]?.isActive == true
                }
            } catch {
                print("Failed to check access: \(error)")
            }
        }
    }
}

// Usage in ContentView
struct ContentView: View {
    @StateObject private var subscriptionService = SubscriptionService()
    @State private var showPaywall = false

    var body: some View {
        Group {
            if subscriptionService.isPremium {
                MainTabView()
            } else {
                OnboardingFlow(showPaywall: $showPaywall)
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear {
            subscriptionService.checkAccess()
        }
    }
}
```

---

### 5. Reusable SwiftUI Components

#### GlassCard Component
```swift
import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let material: Material

    init(
        cornerRadius: CGFloat = 16,
        material: Material = .regularMaterial,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.material = material
        self.content = content()
    }

    var body: some View {
        content
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// Usage
GlassCard {
    VStack {
        Text("Hello World")
    }
    .padding()
}
```

#### PrimaryButton Component
```swift
import SwiftUI

struct PrimaryButton: View {
    let label: String
    let action: () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(label)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "#14B8A6"),
                        Color(hex: "#10B981")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isLoading)
    }
}
```

#### SecondaryButton Component
```swift
import SwiftUI

struct SecondaryButton: View {
    let label: String
    let systemImage: String?
    let action: () -> Void

    init(
        label: String,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image = systemImage {
                    Image(systemName: image)
                }
                Text(label)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(.thickMaterial)
            .foregroundStyle(Color(hex: "#14B8A6"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(hex: "#14B8A6"), lineWidth: 2)
            )
        }
    }
}
```

#### EmptyStateView Component
```swift
import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let description: String
    var actionLabel: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundStyle(Color(hex: "#14B8A6"))

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionLabel = actionLabel, let action = action {
                Button(action: action) {
                    Text(actionLabel)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#14B8A6"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .padding(32)
    }
}
```

#### Color Extension (Hex Support)
```swift
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

---

### 6. Accessibility Implementation

#### VoiceOver Labels
Always add `.accessibilityLabel()` and `.accessibilityHint()` to interactive elements:

```swift
Button {
    flipCard()
} label: {
    Image(systemName: "arrow.triangle.2.circlepath")
}
.accessibilityLabel("Flip card")
.accessibilityHint("Reveals the answer on the back of the card")

Button {
    rateCard(.easy)
} label: {
    Label("Easy", systemImage: "checkmark")
}
.accessibilityLabel("Rate as Easy")
.accessibilityHint("Marks this card as easy to remember")
```

#### Dynamic Type Support
Use semantic font sizes (`.body`, `.headline`, etc.) instead of fixed sizes:

```swift
// Good
Text("Hello")
    .font(.body)

// Bad
Text("Hello")
    .font(.system(size: 17))
```

For custom sizes that scale:
```swift
Text("Custom")
    .font(.system(size: 20, weight: .bold, design: .rounded))
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // Cap at xxxLarge if needed
```

#### Reduce Motion Support
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var body: some View {
    card
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(
            reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7),
            value: isFlipped
        )
}
```

#### Contrast Requirements
All text must meet WCAG AA (4.5:1 for normal text, 3:1 for large text):

```swift
// Primary Teal (#14B8A6) on Dark Background (#1C1C1E) = 5.2:1 ✅
Text("Premium Feature")
    .foregroundStyle(Color(hex: "#14B8A6"))

// White on Primary Teal = 4.6:1 ✅
Text("Button Label")
    .foregroundStyle(.white)
    .background(Color(hex: "#14B8A6"))
```

Test all colors with a contrast checker tool.

---

### 7. Text-to-Speech for Card Pronunciation

```swift
import AVFoundation

@MainActor
class TTSService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, language: String = "en-US") {
        // Stop current speech if any
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5 // Slightly slower for learning
        utterance.pitchMultiplier = 1.0

        isSpeaking = true
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    // AVSpeechSynthesizerDelegate
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
        }
    }
}

// Usage in Card Edit View
struct CardEditView: View {
    @State private var back: String = ""
    @StateObject private var ttsService = TTSService()

    var body: some View {
        VStack {
            TextField("Back", text: $back, axis: .vertical)
                .lineLimit(5...10)

            Button {
                ttsService.speak(back)
            } label: {
                HStack {
                    Image(systemName: ttsService.isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.2")
                    Text("Preview Pronunciation")
                }
            }
            .disabled(back.isEmpty || ttsService.isSpeaking)
        }
    }
}
```

---

## Design Reference

All visual specifications are in:
- **Design System**: `/home/user/fabrika/design_system.md`
- **Screen Designs**: `/home/user/fabrika/screen_designs_mvp.md`

Key design tokens:
- **Primary Color**: Teal 500 `#14B8A6`
- **Secondary Color**: Green 500 `#10B981`
- **UI Font**: SF Pro Rounded (all weights)
- **Content Font**: SF Pro (regular/medium)
- **Base Spacing**: 4pt grid
- **Materials**: `.ultraThinMaterial`, `.regularMaterial`, `.thickMaterial`
- **Corner Radius**: 12pt (small), 16pt (medium), 20pt (large)
- **Button Height**: 56pt
- **Minimum Target Size**: 44x44pt (Apple HIG)

---

## Testing Checklist

### Phase 3A Testing
- [ ] Cards persist in SwiftData
- [ ] FSRS schedules next review correctly
- [ ] Review flow: flip gesture works
- [ ] Action buttons (Again/Hard/Easy) update FSRS state
- [ ] Due cards query returns correct results
- [ ] VoiceOver reads card content
- [ ] Dynamic Type scales text correctly

### Phase 3B Testing
- [ ] Adapty paywall loads products
- [ ] Purchase flow completes successfully
- [ ] Restore purchases works
- [ ] Premium access check works
- [ ] Onboarding flow navigates to paywall
- [ ] Deck CRUD operations work
- [ ] Card CRUD operations work
- [ ] TTS pronunciation plays correctly
- [ ] Empty states show when no data

### Phase 3C Testing
- [ ] Widget shows due cards
- [ ] Widget "Hard" button rates card correctly
- [ ] Widget "Easy" button rates card correctly
- [ ] Widget updates after rating
- [ ] App Group container shares data
- [ ] Widget reflects app changes
- [ ] All 3 widget sizes display correctly
- [ ] Settings manage subscription link works
- [ ] Daily reminder notification (if implemented)

### Accessibility Testing
- [ ] All interactive elements have labels
- [ ] VoiceOver navigation is logical
- [ ] Dynamic Type scales up to xxxLarge
- [ ] Contrast ratios meet WCAG AA
- [ ] Reduce Motion disables animations
- [ ] All buttons meet 44x44pt minimum size

---

## Known Constraints

1. **Dark Mode Only**: MVP does not include Light Mode to reduce complexity.
2. **iOS 17+ Only**: Required for App Intents (interactive widgets).
3. **No CloudKit Sync**: Deferred to v1.1 (see `backlog_mvp.md`).
4. **Single Language**: TTS defaults to `en-US`, language picker deferred.
5. **Basic FSRS**: Using default weights, custom optimization deferred.
6. **No Statistics**: Dashboard and analytics deferred to v1.1.

---

## Phase 3 Success Criteria

**Definition of Done**:
- All 9 screens implemented and functional
- FSRS algorithm schedules reviews correctly
- Adapty paywall unlocks premium access
- Interactive widget works on Home Screen
- App passes accessibility audit (VoiceOver + Dynamic Type + Reduce Motion)
- No console errors or warnings
- App builds and runs on physical iOS 17+ device
- Ready for TestFlight beta testing

---

## Next Steps After Phase 3

Once Phase 3 is complete:
1. **Internal Testing**: Test on multiple devices (iPhone SE, Pro, Pro Max)
2. **Beta Testing**: TestFlight with 10-20 users
3. **App Store Submission**: Prepare metadata, screenshots, privacy policy
4. **Phase 4 (Polish)**: Bug fixes, performance optimization, final QA
5. **Launch**: Submit to App Store with Adapty paywall live

---

## Questions for Swift Developer

If you encounter blockers, ask:
1. **Adapty Setup**: Need help with Adapty dashboard configuration? (Placements, products, access levels)
2. **FSRS Behavior**: Uncertain about rating logic? Check FSRS v5 documentation.
3. **Widget Data Sync**: App Group not sharing data? Verify entitlements and group identifier.
4. **Design Tokens**: Need a specific spacing/color value? Check `design_system.md`.
5. **Screen Layout**: Unclear about a screen design? Check `screen_designs_mvp.md` ASCII diagrams.

**Communication Protocol**:
- For design clarifications → Reference line numbers in `screen_designs_mvp.md`
- For data model questions → Reference SwiftData schemas in this handoff
- For FSRS questions → Reference swift-fsrs package docs
- For Adapty questions → Reference Adapty iOS SDK docs

---

## File Structure Recommendation

```
ZenCards/
├── ZenCardsApp.swift              # App entry + SwiftData + Adapty setup
├── Models/
│   ├── Card.swift                 # SwiftData Card model
│   ├── Deck.swift                 # SwiftData Deck model
│   └── ReviewRecord.swift         # SwiftData ReviewRecord model
├── Services/
│   ├── FSRSService.swift          # FSRS wrapper
│   ├── SubscriptionService.swift  # Adapty wrapper
│   └── TTSService.swift           # AVSpeechSynthesizer wrapper
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift
│   │   └── OnboardingPageView.swift
│   ├── Paywall/
│   │   └── PaywallView.swift
│   ├── Review/
│   │   ├── ReviewSessionView.swift
│   │   └── FlashcardView.swift
│   ├── Decks/
│   │   ├── DeckListView.swift
│   │   └── DeckRowView.swift
│   ├── Cards/
│   │   ├── CardListView.swift
│   │   ├── CardRowView.swift
│   │   └── CardEditView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       ├── GlassCard.swift
│       ├── PrimaryButton.swift
│       ├── SecondaryButton.swift
│       └── EmptyStateView.swift
├── Extensions/
│   └── Color+Hex.swift
└── ZenCardsWidget/               # Widget Extension
    ├── ZenCardsWidget.swift
    ├── ZenCardsWidgetProvider.swift
    ├── ZenCardsWidgetViews.swift
    └── Intents/
        └── RateCardIntent.swift
```

---

## Phase 2 → Phase 3 Handoff Complete ✅

**UI Engineer** has completed:
- Design System (`design_system.md`)
- Screen Designs (`screen_designs_mvp.md`)
- This handoff document

**Swift Developer** should now:
1. Create Xcode project (iOS App + Widget Extension)
2. Implement Phase 3A (Foundation)
3. Implement Phase 3B (Paywall + Content)
4. Implement Phase 3C (Widget)
5. Test accessibility
6. Prepare for Phase 4 (Polish)

**Estimated Complexity**: Medium-High
**Recommended Timeline**: No timeline estimates per policy, but work is broken into 3 clear phases
**Key Risks**: FSRS integration (mitigated by using open-source package), Widget App Intents (mitigated by code examples above), Adapty setup (mitigated by clear documentation)

Good luck! 🚀
