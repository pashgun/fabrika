import SwiftUI

struct ContentView: View {
    @EnvironmentObject var subscriptionService: SubscriptionService
    @State private var showPaywall = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

    var body: some View {
        Group {
            if subscriptionService.isLoading {
                // Loading screen
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(hex: "#14B8A6").opacity(0.3),
                            Color(hex: "#10B981").opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    ProgressView()
                        .controlSize(.large)
                }
            } else if !hasCompletedOnboarding {
                // Onboarding flow
                OnboardingView(showPaywall: $showPaywall)
                    .onChange(of: showPaywall) { _, newValue in
                        if !newValue && subscriptionService.isPremium {
                            // User completed paywall
                            hasCompletedOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        }
                    }
            } else if !subscriptionService.isPremium {
                // Show paywall if not premium
                PaywallView()
            } else {
                // Main app (premium users)
                MainTabView()
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
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
