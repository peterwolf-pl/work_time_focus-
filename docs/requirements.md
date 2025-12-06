# Work Time Focus – Product Requirements

## Goal
An iOS 17+ app (optimized for iOS 16/17) that counts work hours by watching a user-selected Focus mode and provides day-by-day history with exportable reports.

## Personas
- **Individual contributors** who rely on Work Focus or a custom focus to signal “I am working.”
- **Contractors/freelancers** who need verifiable time logs for invoicing.
- **Team leads** who track daily focus trends without sharing private app usage.

## Functional Requirements
### Focus Tracking
- App runs in the background, listening for Focus state changes.
- User can select which Focus modes count as “work.”
- When the selected Focus starts, a work session begins; when it ends, the session closes.
- Handle mid-session app termination by persisting state and reconciling on next launch.
- Detect device reboot or Focus schedule changes and reconcile any open session.

### History & Analytics
- Show daily total hours and session count.
- Support list and chart views (bar for daily totals, line for cumulative trends).
- Filter by date range; defaults to the current week.
- Drill into a day to see individual sessions (start/end, duration, focus mode).
- Local notifications to remind the user when a tracked Focus has been active for long periods (configurable threshold).

### Export
- Export filtered results to a Numbers-compatible CSV file with headers and ISO timestamps.
- Allow sharing via Files, Mail, AirDrop, and iCloud Drive.

### Onboarding & Permissions
- Explain why Focus/Screen Time permissions are required.
- Provide quick-select button for common Focus types (Work, Driving, Custom named focuses).

### Reliability & Edge Cases
- Resilient to missing end events (e.g., phone dies) by auto-closing after configurable timeout and marking as “estimated.”
- Merge back-to-back sessions of the same Focus if separated by less than 2 minutes.
- Prevent duplicates if multiple listeners emit the same event.

## Non-Functional Requirements
- Minimal battery impact: use system notifications rather than polling.
- Privacy: all data stored locally; no analytics by default.
- Accessibility: VoiceOver labels for charts and controls.
- Internationalization: support 12/24h formats and localized date formatting.

## Success Metrics
- < 2% discrepancy between actual focus time and recorded sessions in beta testing.
- App stays within background execution limits and passes TestFlight energy diagnostics.
- Exported CSV opens cleanly in Numbers with correct column formatting.
