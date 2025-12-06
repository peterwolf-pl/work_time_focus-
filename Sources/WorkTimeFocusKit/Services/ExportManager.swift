import Foundation

public struct ExportConfiguration {
    public var dateRange: ClosedRange<Date>
    public var delimiter: String

    public init(dateRange: ClosedRange<Date>, delimiter: String = ",") {
        self.dateRange = dateRange
        self.delimiter = delimiter
    }
}

public protocol ExportManaging {
    func makeCSV(from sessions: [WorkSession], configuration: ExportConfiguration) -> Data
}

/// Simplified CSV exporter; integrate with ShareLink in the app target later.
public final class ExportManager: ExportManaging {
    private let dateFormatter: ISO8601DateFormatter

    public init(dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()) {
        self.dateFormatter = dateFormatter
        self.dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    public func makeCSV(from sessions: [WorkSession], configuration: ExportConfiguration) -> Data {
        let header = ["Date", "Focus", "Start", "End", "DurationSeconds", "Estimated"]
            .joined(separator: configuration.delimiter)

        let rows = sessions
            .filter { configuration.dateRange.contains($0.start) }
            .sorted(by: { $0.start < $1.start })
            .map { session -> String in
                let startString = dateFormatter.string(from: session.start)
                let endString = session.end.map { dateFormatter.string(from: $0) } ?? ""
                let duration = Int(session.durationSeconds)
                let cells: [CustomStringConvertible] = [
                    dateFormatter.string(from: session.start),
                    session.focusIdentifier,
                    startString,
                    endString,
                    duration,
                    session.isEstimated
                ]
                return cells.map { "\($0)" }.joined(separator: configuration.delimiter)
            }

        let body = ([header] + rows).joined(separator: "\n")
        return Data(body.utf8)
    }
}
