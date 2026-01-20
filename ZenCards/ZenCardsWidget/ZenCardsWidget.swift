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

// Preview
#Preview(as: .systemMedium) {
    ZenCardsWidget()
} timeline: {
    CardEntry(
        date: .now,
        card: CardSnapshot(
            id: UUID(),
            front: "What is FSRS?",
            back: "Free Spaced Repetition Scheduler - a modern SRS algorithm",
            due: Date()
        ),
        dueCount: 5,
        configuration: ConfigurationAppIntent()
    )
    CardEntry(
        date: .now,
        card: nil,
        dueCount: 0,
        configuration: ConfigurationAppIntent()
    )
}
