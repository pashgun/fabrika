import Foundation

/// Configuration for FabrikaAnalytics
public struct AnalyticsConfiguration {
    /// Enable Amplitude product analytics
    public let enableAmplitude: Bool

    /// Enable AppsFlyer attribution
    public let enableAppsFlyer: Bool

    /// Enable cloud sync (requires user consent)
    public let enableCloudSync: Bool

    /// User has given consent for analytics
    public let hasUserConsent: Bool

    /// Amplitude API key
    public let amplitudeApiKey: String

    /// AppsFlyer App ID
    public let appsFlyerAppId: String

    /// AppsFlyer Dev Key
    public let appsFlyerDevKey: String

    /// Default configuration (privacy-first: all disabled)
    public static let `default` = AnalyticsConfiguration(
        enableAmplitude: false,
        enableAppsFlyer: false,
        enableCloudSync: false,
        hasUserConsent: false,
        amplitudeApiKey: "",
        appsFlyerAppId: "",
        appsFlyerDevKey: ""
    )

    public init(
        enableAmplitude: Bool,
        enableAppsFlyer: Bool,
        enableCloudSync: Bool,
        hasUserConsent: Bool,
        amplitudeApiKey: String = "",
        appsFlyerAppId: String = "",
        appsFlyerDevKey: String = ""
    ) {
        self.enableAmplitude = enableAmplitude
        self.enableAppsFlyer = enableAppsFlyer
        self.enableCloudSync = enableCloudSync
        self.hasUserConsent = hasUserConsent
        self.amplitudeApiKey = amplitudeApiKey
        self.appsFlyerAppId = appsFlyerAppId
        self.appsFlyerDevKey = appsFlyerDevKey
    }
}
