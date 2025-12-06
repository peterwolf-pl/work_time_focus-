import SwiftUI
import WorkTimeFocusKit

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    @State private var dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: .now)
        let end = calendar.date(byAdding: .day, value: 6, to: start) ?? start
        return start...end
    }()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                DatePicker(
                    "Start",
                    selection: Binding(
                        get: { dateRange.lowerBound },
                        set: { dateRange = $0...dateRange.upperBound; reload() }
                    ),
                    displayedComponents: .date
                )
                DatePicker(
                    "End",
                    selection: Binding(
                        get: { dateRange.upperBound },
                        set: { dateRange = dateRange.lowerBound...$0; reload() }
                    ),
                    displayedComponents: .date
                )

                List {
                    Section("Daily totals") {
                        ForEach(viewModel.summaries) { summary in
                            VStack(alignment: .leading) {
                                Text(summary.date, style: .date)
                                    .font(.headline)
                                Text("\(summary.sessionCount) sessions – \(summary.totalSeconds / 3600, format: .number.precision(.fractionLength(1)))h")
                                    .foregroundStyle(.secondary)
                            }
                            .onTapGesture { viewModel.select(date: summary.date) }
                        }
                    }

                    if !viewModel.sessionsForSelectedDate.isEmpty {
                        Section(viewModel.selectedDate.formatted(date: .abbreviated, time: .omitted)) {
                            ForEach(viewModel.sessionsForSelectedDate) { session in
                                VStack(alignment: .leading) {
                                    Text(session.focusIdentifier)
                                        .font(.headline)
                                    Text("\(session.start, format: .dateTime.hour().minute()) – \(session.end ?? .now, format: .dateTime.hour().minute())")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                Button {
                    _ = viewModel.export(range: dateRange)
                } label: {
                    Label("Export CSV", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("History")
            .padding()
            .onAppear { reload() }
        }
    }

    private func reload() {
        viewModel.loadSummaries(in: dateRange)
        viewModel.select(date: dateRange.lowerBound)
    }
}

#Preview {
    HistoryView(
        viewModel: HistoryViewModel(
            store: SessionStore(),
            exportManager: ExportManager()
        )
    )
}
