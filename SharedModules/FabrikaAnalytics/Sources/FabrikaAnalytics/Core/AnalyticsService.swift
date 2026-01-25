import Foundation
import SwiftData

/// Main analytics service for Fabrika apps
/// Follow FSRSService pattern - simple, direct instantiation
public class AnalyticsService {
    private let configuration: AnalyticsConfiguration
    private let adapters: [AnalyticsAdapter]

    /// Initialize analytics service with configuration
    public init(configuration: AnalyticsConfiguration = .default) {
        self.configuration = configuration

        // Initialize adapters based on configuration
        var adapters: [AnalyticsAdapter] = []

        #if !os(Linux)
        if configuration.enableAmplitude {
            adapters.append(AmplitudeAdapter(apiKey: configuration.amplitudeApiKey))
        }

        if configuration.enableAppsFlyer {
            adapters.append(AppsFlyerAdapter(
                appId: configuration.appsFlyerAppId,
                devKey: configuration.appsFlyerDevKey
            ))
        }
        #endif

        self.adapters = adapters
    }

    // MARK: - Event Tracking

    /// Track an analytics event
    /// - Parameters:
    ///   - event: The event to track
    ///   - context: Optional SwiftData ModelContext for local storage
    public func track(_ event: AnalyticsEvent, context: ModelContext? = nil) {
        // Privacy check
        guard configuration.hasUserConsent else {
            print("[FabrikaAnalytics] User has not consented to analytics")
            return
        }

        // Store locally first (privacy-first)
        if let context = context {
            storeEventLocally(event, in: context)
        }

        // Send to cloud adapters if enabled
        if configuration.enableCloudSync {
            adapters.forEach { adapter in
                adapter.track(event)
            }
        }
    }

    /// Track screen view
    public func trackScreen(_ screenName: String, properties: [String: Any] = [:], context: ModelContext? = nil) {
        var props = properties
        props[EventTaxonomy.PropertyKey.screenName] = screenName

        // Create inline screen view event
        let event = ScreenViewEvent(screenName: screenName, properties: props)
        track(event, context: context)
    }

    // MARK: - User Properties

    /// Set user property
    public func setUserProperty(_ key: String, value: Any) {
        guard configuration.hasUserConsent else { return }

        adapters.forEach { adapter in
            adapter.setUserProperty(key, value: value)
        }
    }

    /// Identify user
    public func identifyUser(_ userId: String) {
        guard configuration.hasUserConsent else { return }

        adapters.forEach { adapter in
            adapter.identifyUser(userId)
        }
    }

    // MARK: - Local Storage (Privacy-First)

    private func storeEventLocally(_ event: AnalyticsEvent, in context: ModelContext) {
        let record = AnalyticsEventRecord(
            name: event.name,
            properties: event.properties,
            timestamp: event.timestamp
        )
        context.insert(record)
        try? context.save()
    }

    /// Get user stats from local SwiftData
    public func getUserStats(from context: ModelContext) -> UserStats? {
        let descriptor = FetchDescriptor<AnalyticsEventRecord>()
        guard let events = try? context.fetch(descriptor) else { return nil }

        return UserStats.calculate(from: events)
    }
}

// MARK: - Internal Screen View Event

private struct ScreenViewEvent: AnalyticsEvent {
    let screenName: String
    let properties: [String: Any]
    let timestamp: Date = Date()

    var name: String { "screen_viewed" }
}
