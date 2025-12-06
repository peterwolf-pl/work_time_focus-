import Foundation
import WorkTimeFocusKit

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var summaries: [DailySummary] = []
    @Published var selectedDate: Date = .now
    @Published var sessionsForSelectedDate: [WorkSession] = []

    private let store: SessionStoreType
    private let exportManager: ExportManaging
    private let calendar: Calendar

    init(
        store: SessionStoreType,
        exportManager: ExportManaging,
        calendar: Calendar = .current
    ) {
        self.store = store
        self.exportManager = exportManager
        self.calendar = calendar
    }

    func loadSummaries(in range: ClosedRange<Date>) {
        summaries = store.summaries(in: range)
    }

    func select(date: Date) {
        selectedDate = date
        sessionsForSelectedDate = store.sessions(on: date)
    }

    func export(range: ClosedRange<Date>) -> Data {
        let sessions = store.summaries(in: range)
            .flatMap { summary in store.sessions(on: summary.date) }
        let configuration = ExportConfiguration(dateRange: range)
        return exportManager.makeCSV(from: sessions, configuration: configuration)
    }
}
