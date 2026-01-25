import Foundation

/// Standard analytics events that all Fabrika apps should track
public enum StandardEvent: AnalyticsEvent {
    case appLaunched
    case sessionStart
    case sessionEnd(duration: TimeInterval)
    case screenViewed(screen: String, properties: [String: Any] = [:])
    case featureUsed(feature: String)
    case settingChanged(setting: String, value: Any)
    case errorOccurred(error: String, context: [String: Any] = [:])

    public var name: String {
        switch self {
        case .appLaunched: return "app_launched"
        case .sessionStart: return "session_started"
        case .sessionEnd: return "session_ended"
        case .screenViewed: return "screen_viewed"
        case .featureUsed: return "feature_used"
        case .settingChanged: return "setting_changed"
        case .errorOccurred: return "error_occurred"
        }
    }

    public var properties: [String: Any] {
        var props: [String: Any] = [:]

        switch self {
        case .appLaunched:
            props["platform"] = "ios"
            #if !os(Linux)
            props["app_version"] = Bundle.main.appVersion
            props["build_number"] = Bundle.main.buildNumber
            #endif

        case .sessionStart:
            props["session_id"] = UUID().uuidString

        case .sessionEnd(let duration):
            props["duration_seconds"] = duration

        case .screenViewed(let screen, let additionalProps):
            props["screen_name"] = screen
            props.merge(additionalProps) { (_, new) in new }

        case .featureUsed(let feature):
            props["feature_name"] = feature

        case .settingChanged(let setting, let value):
            props["setting_name"] = setting
            props["value"] = "\(value)"

        case .errorOccurred(let error, let context):
            props["error_message"] = error
            props.merge(context) { (_, new) in new }
        }

        return props
    }
}

// MARK: - Bundle Extensions

#if !os(Linux)
extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
    }
}
#endif
