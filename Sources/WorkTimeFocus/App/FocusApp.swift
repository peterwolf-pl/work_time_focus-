import SwiftUI
import WorkTimeFocusKit

@main
struct WorkTimeFocusApp: App {
    private let sessionStore = SessionStore()
    private let trackerService = FocusTrackerService()
    private let exportManager = ExportManager()

    @StateObject private var settings = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(
                    viewModel: HomeViewModel(
                        tracker: trackerService,
                        store: sessionStore,
                        trackedFocuses: Array(settings.trackedFocuses)
                    )
                )
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

                HistoryView(
                    viewModel: HistoryViewModel(
                        store: sessionStore,
                        exportManager: exportManager
                    )
                )
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

                SettingsView(viewModel: settings)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
