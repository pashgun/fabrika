import Foundation

#if !os(Linux)
import AppsFlyerLib

/// AppsFlyer adapter for attribution and deep linking
public class AppsFlyerAdapter: NSObject, AnalyticsAdapter {
    private let appId: String
    private let devKey: String

    public init(appId: String, devKey: String) {
        self.appId = appId
        self.devKey = devKey

        super.init()

        AppsFlyerLib.shared().appsFlyerDevKey = devKey
        AppsFlyerLib.shared().appleAppID = appId
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self
    }

    /// Start AppsFlyer SDK
    public func start() {
        AppsFlyerLib.shared().start()
    }

    public func track(_ event: AnalyticsEvent) {
        AppsFlyerLib.shared().logEvent(event.name, withValues: event.properties)
    }

    public func setUserProperty(_ key: String, value: Any) {
        AppsFlyerLib.shared().customData = [key: value]
    }

    public func identifyUser(_ userId: String) {
        AppsFlyerLib.shared().customerUserID = userId
    }
}

// MARK: - AppsFlyerLibDelegate

extension AppsFlyerAdapter: AppsFlyerLibDelegate {
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("[FabrikaAnalytics][AppsFlyer] Conversion data received: \(conversionInfo)")
    }

    public func onConversionDataFail(_ error: Error) {
        print("[FabrikaAnalytics][AppsFlyer] Conversion data failed: \(error)")
    }
}

// MARK: - DeepLinkDelegate

extension AppsFlyerAdapter: DeepLinkDelegate {
    public func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            if let deepLinkValue = result.deepLink?.deeplinkValue {
                print("[FabrikaAnalytics][AppsFlyer] Deep link found: \(deepLinkValue)")
                // Apps can observe this and handle navigation
                NotificationCenter.default.post(
                    name: NSNotification.Name("AppsFlyerDeepLink"),
                    object: nil,
                    userInfo: ["deepLink": deepLinkValue]
                )
            }
        case .notFound:
            print("[FabrikaAnalytics][AppsFlyer] Deep link not found")
        @unknown default:
            break
        }
    }
}
#endif
