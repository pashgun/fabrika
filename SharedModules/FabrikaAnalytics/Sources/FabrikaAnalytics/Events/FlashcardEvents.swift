import Foundation

/// Flashcard-specific analytics events for learning apps
public enum FlashcardEvent: AnalyticsEvent {
    case deckCreated(name: String, cardCount: Int)
    case deckDeleted(cardCount: Int)
    case studySessionStarted(deckName: String, dueCardsCount: Int)
    case studySessionCompleted(cardsReviewed: Int, duration: TimeInterval)
    case cardRated(rating: String, cardAge: TimeInterval)
    case cardCreated(hasFront: Bool, hasBack: Bool)
    case cardDeleted
    case milestoneReached(type: String, value: Int)

    public var name: String {
        switch self {
        case .deckCreated: return "deck_created"
        case .deckDeleted: return "deck_deleted"
        case .studySessionStarted: return "study_session_started"
        case .studySessionCompleted: return "study_session_completed"
        case .cardRated: return "card_rated"
        case .cardCreated: return "card_created"
        case .cardDeleted: return "card_deleted"
        case .milestoneReached: return "milestone_reached"
        }
    }

    public var properties: [String: Any] {
        var props: [String: Any] = [:]

        switch self {
        case .deckCreated(let name, let count):
            props["deck_name"] = name
            props["initial_card_count"] = count

        case .deckDeleted(let count):
            props["card_count"] = count

        case .studySessionStarted(let deck, let dueCount):
            props["deck_name"] = deck
            props["due_cards_count"] = dueCount

        case .studySessionCompleted(let reviewed, let duration):
            props["cards_reviewed"] = reviewed
            props["duration_seconds"] = duration
            let cardsPerMinute = duration > 0 ? Double(reviewed) / (duration / 60.0) : 0
            props["cards_per_minute"] = cardsPerMinute

        case .cardRated(let rating, let age):
            props["rating"] = rating
            props["card_age_days"] = age / 86400

        case .cardCreated(let hasFront, let hasBack):
            props["has_front"] = hasFront
            props["has_back"] = hasBack

        case .cardDeleted:
            break // No additional properties

        case .milestoneReached(let type, let value):
            props["milestone_type"] = type
            props["value"] = value
        }

        return props
    }
}
