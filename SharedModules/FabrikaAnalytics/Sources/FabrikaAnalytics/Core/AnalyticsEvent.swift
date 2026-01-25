import Foundation

/// Protocol for analytics events
public protocol AnalyticsEvent {
    /// Event name (snake_case, max 40 chars)
    var name: String { get }

    /// Event properties dictionary
    var properties: [String: Any] { get }

    /// Event timestamp (default: now)
    var timestamp: Date { get }
}

public extension AnalyticsEvent {
    var timestamp: Date { Date() }
}
