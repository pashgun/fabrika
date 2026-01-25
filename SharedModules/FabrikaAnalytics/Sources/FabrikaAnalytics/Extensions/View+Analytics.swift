import SwiftUI
import SwiftData

/// SwiftUI View extensions for convenient analytics tracking
public extension View {
    /// Track screen view when view appears
    func trackScreen(_ screenName: String, analytics: AnalyticsService) -> some View {
        self.onAppear {
            analytics.trackScreen(screenName)
        }
    }

    /// Track screen view with SwiftData context for local storage
    func trackScreenWithContext(
        _ screenName: String,
        analytics: AnalyticsService,
        modelContext: ModelContext
    ) -> some View {
        self.onAppear {
            analytics.trackScreen(screenName, context: modelContext)
        }
    }
}
