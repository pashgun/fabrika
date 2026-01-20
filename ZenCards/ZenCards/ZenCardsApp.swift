import SwiftUI
import SwiftData

@main
struct ZenCardsApp: App {
    let modelContainer: ModelContainer

    init() {
        // Initialize SwiftData ModelContainer
        do {
            let schema = Schema([
                Card.self,
                Deck.self,
                ReviewRecord.self
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                groupContainer: .identifier("group.com.zencards.shared") // For widget access
            )

            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }

        // Create sample data for development/testing
        #if DEBUG
        SampleDataHelper.createSampleData(modelContainer: modelContainer)
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
