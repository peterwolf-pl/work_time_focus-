import Foundation
import WorkTimeFocusKit

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var activeSession: WorkSession?
    @Published var trackedFocuses: [String]

    let tracker: FocusTrackerServiceType
    private let store: SessionStoreType

    init(tracker: FocusTrackerServiceType, store: SessionStoreType, trackedFocuses: [String]) {
        self.tracker = tracker
        self.store = store
        self.trackedFocuses = trackedFocuses

        tracker.onSessionStarted = { [weak self] session in
            self?.store.save(session: session)
            Task { @MainActor in
                self?.activeSession = session
            }
        }

        tracker.onSessionEnded = { [weak self] session in
            self?.store.close(session: session)
            Task { @MainActor in
                self?.activeSession = nil
            }
        }
    }

    func startTracking() {
        tracker.configure(trackedIdentifiers: trackedFocuses)
        tracker.start()
    }

    func stopTracking() {
        tracker.stop()
        activeSession = nil
    }
}
