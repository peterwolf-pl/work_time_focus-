import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @State private var newFocusIdentifier: String = ""

    var body: some View {
        Form {
            Section("Tracked Focuses") {
                ForEach(Array(viewModel.trackedFocuses), id: \.self) { focus in
                    HStack {
                        Text(focus)
                        Spacer()
                        Button(role: .destructive) {
                            viewModel.toggleFocus(identifier: focus)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }

                HStack {
                    TextField("Add identifier", text: $newFocusIdentifier)
                    Button("Add") {
                        guard !newFocusIdentifier.isEmpty else { return }
                        viewModel.toggleFocus(identifier: newFocusIdentifier)
                        newFocusIdentifier = ""
                    }
                }
            }

            Section("Session rules") {
                Stepper(value: $viewModel.autoCloseTimeoutMinutes, in: 5...180, step: 5) {
                    Text("Auto-close after \(viewModel.autoCloseTimeoutMinutes) minutes")
                }
                Stepper(value: $viewModel.mergeToleranceSeconds, in: 30...600, step: 30) {
                    Text("Merge gaps under \(viewModel.mergeToleranceSeconds) seconds")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
