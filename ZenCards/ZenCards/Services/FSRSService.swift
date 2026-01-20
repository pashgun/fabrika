import Foundation
import FSRS
import SwiftData
import WidgetKit

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

        // Update widget timeline
        syncDueCardsToWidget(modelContext: modelContext)
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

    /// Sync due cards to shared UserDefaults for widget
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
}

// Codable snapshot for widget
struct CardSnapshot: Codable, Identifiable {
    let id: UUID
    let front: String
    let back: String
    let due: Date
}
