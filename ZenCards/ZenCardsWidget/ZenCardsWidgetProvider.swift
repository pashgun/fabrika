import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct CardEntry: TimelineEntry {
    let date: Date
    let card: CardSnapshot?
    let dueCount: Int
    let configuration: ConfigurationAppIntent
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
