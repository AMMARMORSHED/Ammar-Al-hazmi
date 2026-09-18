# This is the current phase of the project: foundation + accounting engine + app shell.

## Project status
The repository now contains a structured Flutter app foundation with:
- SQLite database layer
- multi-ledger / multi-currency models
- localization for Arabic and English
- dashboard and person/account screens
- app state management via Provider
- account balance calculation based on transactions, not saved cache

## Requirements
- Flutter 3.3+
- Android Studio or VS Code
- Android SDK 21+

## Run
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Build APK
```bash
flutter build apk --release
```

## Architecture overview
- `lib/core` : localization, theme, constants
- `lib/data/database` : SQLite schema and initialization
- `lib/data/models` : domain models
- `lib/data/repositories` : repository access layer
- `lib/domain/services` : business logic such as balance calculation
- `lib/presentation` : screens, widgets, providers

## Notes
This is a step-by-step implementation of the full requested system. The core architecture is ready for extension toward backup/restore, reminders, PDFs, Excel reporting, and advanced reports.
