import SwiftUI
import SwiftData
import Adapty

@main
struct ZenCardsApp: App {
    let modelContainer: ModelContainer
    @StateObject private var subscriptionService = SubscriptionService()

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

        // Initialize Adapty
        Adapty.activate("PUBLIC_SDK_KEY_FROM_ADAPTY_DASHBOARD")
        #if DEBUG
        Adapty.logLevel = .verbose
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionService)
        }
        .modelContainer(modelContainer)
    }
}
