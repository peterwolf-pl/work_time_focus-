# Work Time Focus – Technical Architecture

## Overview
The app is written in **SwiftUI** and targets iOS 17+ to leverage FocusStatusCenter APIs and modern background behaviors. Architecture follows MVVM with a light service layer for background listeners and persistence.

## Core Modules
1. **FocusTrackerService**
   - Subscribes to `FocusStatusCenter` for changes to active Focus modes.
   - Maps user-selected Focus identifiers to `WorkSession` lifecycle events.
   - Persists in-progress sessions to disk (via `SessionStore`) so they can be reconciled after termination or reboot.
   - Debounces duplicate events and auto-closes stale sessions with a configurable timeout.

2. **SessionStore**
   - Stores sessions in **Core Data** using an `SQLite` backing store.
   - Indexes by start date for efficient daily queries and date-range filters.
   - Provides lightweight summaries (total duration, session count) for charts.
   - Maintains derived flags (e.g., `isEstimated`) for missing end events.

3. **HistoryViewModel**
   - Fetches summaries by date range, groups by day, and exposes data for both list and chart views.
   - Emits exportable rows and invokes `ExportManager` to create CSV files.

4. **ExportManager**
   - Generates Numbers-compatible CSV with headers: `Date,Focus,Start,End,DurationMinutes,Estimated`.
   - Uses `FileManager` + `ShareLink` for sharing via AirDrop, Mail, Files, etc.
   - Sanitizes file names and applies locale-aware date/time formatting.

5. **SettingsViewModel**
   - Manages tracked Focus selection, notification thresholds, and merge tolerance settings.
   - Surfaces onboarding prompts and permission requests.

## Data Model
- **WorkSession**
  - `id: UUID`
  - `focusIdentifier: String`
  - `start: Date`
  - `end: Date?`
  - `durationSeconds: Double` (derived)
  - `isEstimated: Bool` (true when end was inferred)
- **DailySummary (derived)**
  - `date: Date`
  - `totalSeconds: Double`
  - `sessionCount: Int`

## Background Behavior
- Register for Focus state notifications via `FocusStatusCenter`. On transition to a tracked Focus, start a session; on exit, end it.
- Use `BGProcessingTask` (fallback: `BGAppRefreshTask`) to reconcile open sessions when the app is not foregrounded.
- Persist the latest event timestamp to detect gaps after device restarts.

## UI Composition
- **Home**: shows today’s tracked time, quick toggle for Focus tracking, and last session snippet.
- **History**: segmented control for list vs. chart view; date-range picker.
- **Session Detail**: modal sheet with per-session metadata and edit/end controls.
- **Export Sheet**: format preview, CSV delimiter selection, and share button.
- **Onboarding**: explains Focus permission with call-to-action for selecting modes.

## Error Handling & Reliability
- If the system denies Focus data, show actionable guidance and a retry button.
- Mark sessions as `estimated` if auto-closed after timeout and clearly surface that in history and exports.
- Use background tasks conservatively to minimize battery impact and align with Focus notification timing.

## Telemetry & Privacy
- No remote logging by default. Optional, opt-in crash reporting via Privacy Manifest with explicit consent.
- All session data stays on device; exported files are user-initiated only.

## Testing Strategy
- Unit tests for session merging, duration calculation, CSV formatting.
- UI tests for date-range filtering, chart rendering, and export share sheet availability.
- Integration tests with simulated Focus transitions to verify persistence and reconciliation.
