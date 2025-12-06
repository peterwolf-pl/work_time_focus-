import Foundation

public struct WorkSession: Identifiable, Codable, Hashable {
    public let id: UUID
    public var focusIdentifier: String
    public var start: Date
    public var end: Date?
    public var isEstimated: Bool

    public init(
        id: UUID = UUID(),
        focusIdentifier: String,
        start: Date,
        end: Date? = nil,
        isEstimated: Bool = false
    ) {
        self.id = id
        self.focusIdentifier = focusIdentifier
        self.start = start
        self.end = end
        self.isEstimated = isEstimated
    }

    public var durationSeconds: TimeInterval {
        guard let end else { return 0 }
        return end.timeIntervalSince(start)
    }
}

public struct DailySummary: Identifiable, Hashable {
    public var id: Date { date }
    public var date: Date
    public var totalSeconds: TimeInterval
    public var sessionCount: Int

    public init(date: Date, totalSeconds: TimeInterval, sessionCount: Int) {
        self.date = date
        self.totalSeconds = totalSeconds
        self.sessionCount = sessionCount
    }
}
