import Foundation
import SwiftData

/// SwiftData model for tracking user sessions
@Model
public final class SessionRecord {
    public var id: UUID
    public var startedAt: Date
    public var endedAt: Date?
    public var eventCount: Int

    public init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        eventCount: Int = 0
    ) {
        self.id = id
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.eventCount = eventCount
    }

    /// Session duration in seconds
    public var duration: TimeInterval {
        guard let end = endedAt else { return 0 }
        return end.timeIntervalSince(startedAt)
    }

    /// Check if session is still active
    public var isActive: Bool {
        endedAt == nil
    }
}
