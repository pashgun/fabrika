import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var fsrsService = FSRSService()
    @State private var selectedTab = 0
    @State private var dueCount = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ReviewSessionView()
                .tabItem {
                    Label("Review", systemImage: "brain.head.profile")
                }
                .badge(dueCount > 0 ? dueCount : nil)
                .tag(0)

            DeckListView()
                .tabItem {
                    Label("Decks", systemImage: "rectangle.stack")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "#14B8A6"))
        .onAppear {
            updateDueCount()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            updateDueCount()
        }
    }

    private func updateDueCount() {
        let dueCards = fsrsService.getDueCards(modelContext: modelContext)
        dueCount = dueCards.count
    }
}
