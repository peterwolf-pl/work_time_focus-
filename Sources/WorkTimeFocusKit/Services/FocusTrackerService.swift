import Foundation

public protocol FocusTrackerServiceType: AnyObject {
    var onSessionStarted: ((WorkSession) -> Void)? { get set }
    var onSessionEnded: ((WorkSession) -> Void)? { get set }
    func configure(trackedIdentifiers: [String])
    func start()
    func stop()
}

/// Stub implementation that will later hook into FocusStatusCenter.
public final class FocusTrackerService: FocusTrackerServiceType {
    public var onSessionStarted: ((WorkSession) -> Void)?
    public var onSessionEnded: ((WorkSession) -> Void)?

    private(set) var trackedIdentifiers: [String] = []
    private var activeSession: WorkSession?

    public init() {}

    public func configure(trackedIdentifiers: [String]) {
        self.trackedIdentifiers = trackedIdentifiers
    }

    public func start() {
        // TODO: Replace with FocusStatusCenter subscriptions.
        activeSession = nil
    }

    public func stop() {
        activeSession = nil
    }

    /// Simulates a focus activation for preview/testing until real hooks are added.
    public func simulateFocusStart(identifier: String, date: Date = .now) {
        guard trackedIdentifiers.contains(identifier) else { return }
        let session = WorkSession(focusIdentifier: identifier, start: date)
        activeSession = session
        onSessionStarted?(session)
    }

    public func simulateFocusEnd(date: Date = .now) {
        guard var session = activeSession else { return }
        session.end = date
        activeSession = nil
        onSessionEnded?(session)
    }
}
