import Foundation

/// Event naming conventions and validation
public struct EventTaxonomy {
    // MARK: - Validation

    /// Validate event name (snake_case, max 40 chars)
    public static func validateEventName(_ name: String) -> Bool {
        let regex = "^[a-z][a-z0-9_]{0,39}$"
        return name.range(of: regex, options: .regularExpression) != nil
    }

    /// Validate property name (snake_case, max 40 chars)
    public static func validatePropertyName(_ name: String) -> Bool {
        let regex = "^[a-z][a-z0-9_]{0,39}$"
        return name.range(of: regex, options: .regularExpression) != nil
    }

    // MARK: - Standard Property Keys

    /// Common property keys (standardized across all apps)
    public enum PropertyKey {
        public static let screenName = "screen_name"
        public static let featureName = "feature_name"
        public static let duration = "duration_seconds"
        public static let count = "count"
        public static let success = "success"
        public static let errorMessage = "error_message"
        public static let userId = "user_id"
        public static let sessionId = "session_id"
        public static let platform = "platform"
        public static let appVersion = "app_version"
        public static let buildNumber = "build_number"
    }

    // MARK: - Naming Guidelines

    /// Event naming conventions
    public static let namingGuidelines = """
    Event Naming Conventions:
    - Use snake_case (e.g., study_session_started)
    - Use past tense (e.g., card_rated, not rate_card)
    - Maximum 40 characters
    - Start with lowercase letter
    - Only use letters, numbers, and underscores

    Examples:
    ✅ app_launched
    ✅ study_session_completed
    ✅ card_rated
    ❌ StudySessionComplete (not snake_case)
    ❌ rateCard (not past tense)
    ❌ new-deck (no hyphens)
    """
}
