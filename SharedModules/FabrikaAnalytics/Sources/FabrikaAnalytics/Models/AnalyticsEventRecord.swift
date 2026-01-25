import Foundation
import SwiftData

/// SwiftData model for storing analytics events locally (privacy-first)
@Model
public final class AnalyticsEventRecord {
    public var id: UUID
    public var name: String
    public var propertiesJSON: String
    public var timestamp: Date
    public var synced: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        properties: [String: Any],
        timestamp: Date = Date(),
        synced: Bool = false
    ) {
        self.id = id
        self.name = name
        self.propertiesJSON = Self.encodeProperties(properties)
        self.timestamp = timestamp
        self.synced = synced
    }

    /// Get properties as dictionary
    public var properties: [String: Any] {
        Self.decodeProperties(propertiesJSON)
    }

    // MARK: - JSON Encoding/Decoding

    private static func encodeProperties(_ properties: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: properties),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    private static func decodeProperties(_ json: String) -> [String: Any] {
        guard let data = json.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return dict
    }
}
