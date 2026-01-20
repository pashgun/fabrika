import Foundation
import SwiftData

#if DEBUG
struct SampleDataHelper {
    static func createSampleData(modelContainer: ModelContainer) {
        let context = ModelContext(modelContainer)

        // Check if data already exists
        let descriptor = FetchDescriptor<Deck>()
        let existingDecks = (try? context.fetch(descriptor)) ?? []

        guard existingDecks.isEmpty else {
            print("Sample data already exists, skipping creation")
            return
        }

        // Create Spanish deck
        let spanishDeck = Deck(name: "Spanish", colorHex: "#14B8A6")
        context.insert(spanishDeck)

        let spanishCards = [
            Card(front: "Hello", back: "Hola", deck: spanishDeck),
            Card(front: "Goodbye", back: "Adiós", deck: spanishDeck),
            Card(front: "Thank you", back: "Gracias", deck: spanishDeck),
            Card(front: "Please", back: "Por favor", deck: spanishDeck),
            Card(front: "Yes", back: "Sí", deck: spanishDeck),
            Card(front: "No", back: "No", deck: spanishDeck),
            Card(front: "Good morning", back: "Buenos días", deck: spanishDeck),
            Card(front: "Good night", back: "Buenas noches", deck: spanishDeck),
        ]

        spanishCards.forEach { context.insert($0) }

        // Create Programming deck
        let programmingDeck = Deck(name: "Swift Basics", colorHex: "#F59E0B")
        context.insert(programmingDeck)

        let programmingCards = [
            Card(front: "What is SwiftUI?", back: "A declarative UI framework for building iOS apps", deck: programmingDeck),
            Card(front: "What is SwiftData?", back: "A data persistence framework for SwiftUI apps", deck: programmingDeck),
            Card(front: "What does @State do?", back: "Creates a source of truth for local view state", deck: programmingDeck),
            Card(front: "What is FSRS?", back: "Free Spaced Repetition Scheduler - a modern algorithm for optimal learning", deck: programmingDeck),
        ]

        programmingCards.forEach { context.insert($0) }

        // Create Geography deck
        let geoDeck = Deck(name: "World Capitals", colorHex: "#8B5CF6")
        context.insert(geoDeck)

        let geoCards = [
            Card(front: "Capital of France?", back: "Paris", deck: geoDeck),
            Card(front: "Capital of Japan?", back: "Tokyo", deck: geoDeck),
            Card(front: "Capital of Brazil?", back: "Brasília", deck: geoDeck),
            Card(front: "Capital of Australia?", back: "Canberra", deck: geoDeck),
        ]

        geoCards.forEach { context.insert($0) }

        // Save all
        do {
            try context.save()
            print("✅ Sample data created: 3 decks, 16 cards")
        } catch {
            print("❌ Failed to create sample data: \(error)")
        }
    }
}
#endif
