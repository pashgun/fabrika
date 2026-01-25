import Foundation
import SwiftData

/// SwiftData model for GDPR/ATT privacy consent
@Model
public final class PrivacyConsent {
    public var id: UUID
    public var analyticsConsent: Bool
    public var marketingConsent: Bool
    public var trackingConsent: Bool
    public var consentDate: Date
    public var lastUpdated: Date

    public init(
        id: UUID = UUID(),
        analyticsConsent: Bool = false,
        marketingConsent: Bool = false,
        trackingConsent: Bool = false,
        consentDate: Date = Date(),
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.analyticsConsent = analyticsConsent
        self.marketingConsent = marketingConsent
        self.trackingConsent = trackingConsent
        self.consentDate = consentDate
        self.lastUpdated = lastUpdated
    }

    /// Update consent preferences
    public func updateConsent(analytics: Bool, marketing: Bool, tracking: Bool) {
        self.analyticsConsent = analytics
        self.marketingConsent = marketing
        self.trackingConsent = tracking
        self.lastUpdated = Date()
    }

    /// Check if all consents are denied
    public var allDenied: Bool {
        !analyticsConsent && !marketingConsent && !trackingConsent
    }

    /// Check if all consents are granted
    public var allGranted: Bool {
        analyticsConsent && marketingConsent && trackingConsent
    }
}
