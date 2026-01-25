import Foundation

#if !os(Linux)
import Amplitude

/// Amplitude adapter for product analytics
public class AmplitudeAdapter: AnalyticsAdapter {
    private let amplitude: Amplitude

    public init(apiKey: String) {
        self.amplitude = Amplitude.instance()
        amplitude.initializeApiKey(apiKey)
        amplitude.trackingSessionEvents = true
    }

    public func track(_ event: AnalyticsEvent) {
        amplitude.logEvent(event.name, withEventProperties: event.properties)
    }

    public func setUserProperty(_ key: String, value: Any) {
        let identify = AMPIdentify()
        identify.set(key, value: value as? NSObject)
        amplitude.identify(identify)
    }

    public func identifyUser(_ userId: String) {
        amplitude.setUserId(userId)
    }

    /// Flush events to server immediately
    public func flush() {
        amplitude.uploadEvents()
    }
}
#endif
