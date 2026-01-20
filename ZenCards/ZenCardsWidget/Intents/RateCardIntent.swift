import AppIntents
import SwiftData
import WidgetKit
import FSRS

struct RateCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Rate Card"
    static var description: IntentDescription = IntentDescription("Rate a flashcard from the widget")

    @Parameter(title: "Card ID")
    var cardID: UUID

    @Parameter(title: "Rating")
    var rating: Int // 1=Again, 2=Hard, 3=Good, 4=Easy

    init() {
        self.cardID = UUID()
        self.rating = 3
    }

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
