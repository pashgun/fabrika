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

    var statusText: String {
        if isNew {
            return "New"
        } else if isDue {
            return "Due now"
        } else {
            let days = Calendar.current.dateComponents([.day], from: Date(), to: due).day ?? 0
            if days == 0 {
                return "Due today"
            } else if days == 1 {
                return "Due tomorrow"
            } else {
                return "Due in \(days)d"
            }
        }
    }
}
