import Foundation

public protocol SessionStoreType {
    func save(session: WorkSession)
    func close(session: WorkSession)
    func activeSession() -> WorkSession?
    func summaries(in range: ClosedRange<Date>) -> [DailySummary]
    func sessions(on date: Date) -> [WorkSession]
}

/// Lightweight in-memory placeholder that mimics persistence until Core Data is wired up.
public final class SessionStore: SessionStoreType {
    private var sessions: [UUID: WorkSession] = [:]
    private let calendar: Calendar

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    public func save(session: WorkSession) {
        sessions[session.id] = session
    }

    public func close(session: WorkSession) {
        sessions[session.id] = session
    }

    public func activeSession() -> WorkSession? {
        sessions.values.first(where: { $0.end == nil })
    }

    public func summaries(in range: ClosedRange<Date>) -> [DailySummary] {
        let filtered = sessions.values.filter { session in
            let end = session.end ?? session.start.addingTimeInterval(1)
            return range.contains(session.start) || range.contains(end)
        }

        let grouped = Dictionary(grouping: filtered) { session -> Date in
            calendar.startOfDay(for: session.start)
        }

        return grouped
            .map { day, sessions in
                let totalSeconds = sessions.reduce(into: 0) { total, session in
                    total += session.durationSeconds
                }
                return DailySummary(date: day, totalSeconds: totalSeconds, sessionCount: sessions.count)
            }
            .sorted(by: { $0.date < $1.date })
    }

    public func sessions(on date: Date) -> [WorkSession] {
        sessions.values
            .filter { calendar.isDate($0.start, inSameDayAs: date) }
            .sorted(by: { $0.start < $1.start })
    }
}
