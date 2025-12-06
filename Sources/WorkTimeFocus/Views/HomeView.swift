import SwiftUI
import WorkTimeFocusKit

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var simulatedFocus = "com.apple.focus.work"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                statusSection
                simulationSection
                Spacer()
            }
            .padding()
            .navigationTitle("Work Time Focus")
        }
        .onAppear { viewModel.startTracking() }
        .onDisappear { viewModel.stopTracking() }
    }

    private var statusSection: some View {
        GroupBox("Status") {
            if let session = viewModel.activeSession {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Tracking \(session.focusIdentifier)", systemImage: "bolt.fill")
                        .foregroundStyle(.green)
                    Text("Started: \(session.start, format: .dateTime.hour().minute())")
                    if let end = session.end {
                        Text("Ended: \(end, format: .dateTime.hour().minute())")
                    }
                }
            } else {
                Label("Not tracking", systemImage: "bolt.slash")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var simulationSection: some View {
        GroupBox("Simulate Focus") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Use this until FocusStatusCenter hooks are implemented.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Focus", selection: $simulatedFocus) {
                    ForEach(viewModel.trackedFocuses, id: \.self) { focus in
                        Text(focus).tag(focus)
                    }
                }
                .pickerStyle(.menu)

                HStack {
                    Button {
                        viewModel.startTracking()
                        tracker.simulateFocusStart(identifier: simulatedFocus)
                    } label: {
                        Label("Start session", systemImage: "play.circle")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        tracker.simulateFocusEnd()
                    } label: {
                        Label("End session", systemImage: "stop.circle")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var tracker: FocusTrackerService {
        viewModel.tracker as? FocusTrackerService ?? FocusTrackerService()
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            tracker: FocusTrackerService(),
            store: SessionStore(),
            trackedFocuses: ["com.apple.focus.work", "com.company.custom"]
        )
    )
}
