import Foundation

/// Protocol for analytics adapters (Amplitude, AppsFlyer, etc.)
public protocol AnalyticsAdapter {
    /// Track an analytics event
    func track(_ event: AnalyticsEvent)

    /// Set user property
    func setUserProperty(_ key: String, value: Any)

    /// Identify user with ID
    func identifyUser(_ userId: String)
}

public extension AnalyticsAdapter {
    /// Default implementation (optional)
    func identifyUser(_ userId: String) {
        // Optional - not all adapters need user identification
    }
}
