import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var trackedFocuses: Set<String>
    @Published var autoCloseTimeoutMinutes: Int
    @Published var mergeToleranceSeconds: Int

    init(
        trackedFocuses: Set<String> = ["com.apple.focus.work"],
        autoCloseTimeoutMinutes: Int = 30,
        mergeToleranceSeconds: Int = 120
    ) {
        self.trackedFocuses = trackedFocuses
        self.autoCloseTimeoutMinutes = autoCloseTimeoutMinutes
        self.mergeToleranceSeconds = mergeToleranceSeconds
    }

    func toggleFocus(identifier: String) {
        if trackedFocuses.contains(identifier) {
            trackedFocuses.remove(identifier)
        } else {
            trackedFocuses.insert(identifier)
        }
    }
}
