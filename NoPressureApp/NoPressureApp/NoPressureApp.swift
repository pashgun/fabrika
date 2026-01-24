import SwiftUI
import SwiftData

@main
struct NoPressureApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                User.self,
                Deck.self,
                Flashcard.self,
                FSRSData.self
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            // Create sample data for development
            #if DEBUG
            createSampleData()
            #endif
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }

    private func createSampleData() {
        let context = ModelContext(modelContainer)

        // Check if data already exists
        let descriptor = FetchDescriptor<Deck>()
        let existingDecks = (try? context.fetch(descriptor)) ?? []

        guard existingDecks.isEmpty else { return }

        // Create Spanish deck
        let spanishDeck = Deck(
            name: "Spanish Basics",
            description: "Learn basic Spanish vocabulary",
            colorHex: "#0A84FF",
            icon: "globe"
        )
        context.insert(spanishDeck)

        let spanishCards = [
            Flashcard(front: "Hello", back: "Hola", deck: spanishDeck),
            Flashcard(front: "Goodbye", back: "Adiós", deck: spanishDeck),
            Flashcard(front: "Thank you", back: "Gracias", deck: spanishDeck),
            Flashcard(front: "Please", back: "Por favor", deck: spanishDeck),
            Flashcard(front: "Yes", back: "Sí", deck: spanishDeck),
            Flashcard(front: "No", back: "No", deck: spanishDeck),
        ]

        spanishCards.forEach { context.insert($0) }

        // Create Programming deck
        let programmingDeck = Deck(
            name: "Swift Basics",
            description: "Swift programming fundamentals",
            colorHex: "#FF9F0A",
            icon: "swift"
        )
        context.insert(programmingDeck)

        let programmingCards = [
            Flashcard(front: "What is a variable?", back: "A container for storing data values", deck: programmingDeck),
            Flashcard(front: "What is a constant?", back: "An immutable value that cannot be changed", deck: programmingDeck),
            Flashcard(front: "What is a function?", back: "A reusable block of code that performs a specific task", deck: programmingDeck),
            Flashcard(front: "What is an array?", back: "An ordered collection of values", deck: programmingDeck),
        ]

        programmingCards.forEach { context.insert($0) }

        // Save
        try? context.save()
    }
}
