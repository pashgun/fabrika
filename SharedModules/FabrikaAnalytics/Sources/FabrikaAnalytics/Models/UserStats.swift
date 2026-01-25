import Foundation

/// User-facing analytics statistics calculated from local SwiftData
public struct UserStats: Codable {
    public let totalEvents: Int
    public let totalSessions: Int
    public let averageSessionDuration: TimeInterval
    public let streakDays: Int
    public let lastActiveDate: Date

    // Flashcard-specific stats
    public let totalCardsReviewed: Int
    public let totalStudySessions: Int
    public let averageCardsPerSession: Double

    /// Calculate stats from local analytics events
    public static func calculate(from events: [AnalyticsEventRecord]) -> UserStats {
        let flashcardEvents = events.filter { event in
            event.name.contains("study_session") || event.name.contains("card_rated")
        }

        let studySessions = events.filter { $0.name == "study_session_completed" }
        let cardsReviewed = events.filter { $0.name == "card_rated" }.count

        let avgCards = studySessions.isEmpty ? 0.0 : Double(cardsReviewed) / Double(studySessions.count)

        // Calculate streak
        let streak = calculateStreak(from: events)

        // Calculate average session duration
        let avgDuration = calculateAvgDuration(from: studySessions)

        return UserStats(
            totalEvents: events.count,
            totalSessions: studySessions.count,
            averageSessionDuration: avgDuration,
            streakDays: streak,
            lastActiveDate: events.last?.timestamp ?? Date(),
            totalCardsReviewed: cardsReviewed,
            totalStudySessions: studySessions.count,
            averageCardsPerSession: avgCards
        )
    }

    // MARK: - Private Helpers

    private static func calculateAvgDuration(from events: [AnalyticsEventRecord]) -> TimeInterval {
        let durations = events.compactMap { event -> TimeInterval? in
            guard let duration = event.properties["duration_seconds"] as? TimeInterval else { return nil }
            return duration
        }
        guard !durations.isEmpty else { return 0 }
        return durations.reduce(0, +) / Double(durations.count)
    }

    private static func calculateStreak(from events: [AnalyticsEventRecord]) -> Int {
        guard !events.isEmpty else { return 0 }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Get unique days with activity
        let activeDays = Set(events.map { calendar.startOfDay(for: $0.timestamp) })

        var streak = 0
        var currentDate = today

        // Count consecutive days backwards from today
        while activeDays.contains(currentDate) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return streak
    }
}
