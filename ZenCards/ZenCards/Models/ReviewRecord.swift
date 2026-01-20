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
