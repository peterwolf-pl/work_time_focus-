import SwiftUI
import WorkTimeFocusKit

struct WorkTimeFocusRootView: View {
    @StateObject private var settings = SettingsViewModel()

    private let sessionStore = SessionStore()
    private let trackerService = FocusTrackerService()
    private let exportManager = ExportManager()

    var body: some View {
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
