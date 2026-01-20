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

    var dueText: String {
        if dueCount > 0 {
            return "\(cardCount) cards, \(dueCount) due"
        } else {
            return "\(cardCount) cards"
        }
    }
}
