# Work Time Focus

WTF (Work Time Focus) counts your time at work by watching Focus mode changes and surfaces day-by-day history with exportable reports.

## Modules
- **Focus tracking (Module 1)**: runs in the background, monitors Focus state transitions, and starts/stops work sessions for user-selected Focus modes.
- **History & export (Module 2)**: shows daily totals and charts, supports date-range filtering, and exports results to a Numbers-friendly CSV.

## Key Requirements
- Runs on iOS 17+ using SwiftUI and FocusStatusCenter.
- Stores data locally (Core Data with SQLite backend) and reconciles sessions after app restarts.
- Provides list and chart history, session drill-down, and CSV export via Share Sheet.
- Handles edge cases like missing end events, duplicates, and short gaps between sessions.

See [`docs/requirements.md`](docs/requirements.md) for detailed functional scope and [`docs/architecture.md`](docs/architecture.md) for the technical blueprint.

## Code skeleton
- `Package.swift` defines an iOS 17+ SwiftUI app target (`WorkTimeFocus`) and a shared logic library (`WorkTimeFocusKit`).
- `Sources/WorkTimeFocusKit` contains stubbed models (`WorkSession`, `DailySummary`) and placeholder services for focus tracking, session storage, and CSV export.
- `Sources/WorkTimeFocus` wires basic SwiftUI tabs for Home, History, and Settings with view models that exercise the services and a simple simulation flow until FocusStatusCenter is integrated.
