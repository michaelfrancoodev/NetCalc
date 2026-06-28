# NetCalc Pro

A premium, fully offline scientific calculator built with Flutter. Designed for professionals and students who value precision, privacy, and a clean user experience. It handles everything from basic arithmetic to advanced trigonometry, logarithms, and scientific notation.

---

## Core Features

**Scientific Calculator** — The heart of the app. Supports standard arithmetic, trigonometry (sin, cos, tan), inverse functions, logarithms (log, ln), square/cube roots, factorials, and percentages. Features include right-associative power operator (^), ANS recall, and a sign toggle (+/-).

**Live Calculation** — Results update in real-time as you type. Expressions are automatically validated, and results can be saved to Favorites with a single tap.

**Unit Converter** — Effortlessly convert between units in categories like Length, Weight, Temperature, Area, Volume, and Speed. Includes a quick-swap feature for bidirectional conversion.

**History Management** — Automatically saves every successful calculation locally. Users can swipe to delete entries or tap to reload them back into the calculator for further work.

**Saved Favorites** — A dedicated space for important calculations. Save, manage, and reuse your most frequent expressions.

**Premium Theme** — Features a custom "Obsidian" dark theme with a glassmorphism design for a modern, eye-friendly experience.

---

## Privacy & Security

- **100% Offline** — No internet permissions requested. Your data never leaves your device.
- **No Advertisements** — A clean workspace with zero distractions.
- **Zero Tracking** — No analytics, no data collection, and no tracking SDKs.
- **Local Persistence** — History and favorites are stored securely using `shared_preferences`.

---

## Screens

| Screen | File Path |
|---|---|
| Calculator | `lib/screens/calculator_screen.dart` |
| Unit Converter | `lib/screens/unit_conversion_screen.dart` |
| History | `lib/screens/history_screen.dart` |
| Saved Favorites | `lib/screens/favorites_screen.dart` |
| Settings | `lib/screens/settings_screen.dart` |
| Help & Guide | `lib/screens/help_screen.dart` |
| Privacy Policy | `lib/screens/privacy_screen.dart` |
| Terms of Service | `lib/screens/terms_screen.dart` |
| About | `lib/screens/about_screen.dart` |
| Splash | `lib/screens/splash_screen.dart` |

---

## Tech Stack

- **Flutter** 3.x / Dart 3
- **shared_preferences** — Secure local data persistence.
- **flutter_launcher_icons** — Custom branding.

---

## Getting Started

```bash
# Clone the repository
git clone https://github.com/michaelfrancoodev/netcalc-pro.git

# Install dependencies
cd netcalc-pro
flutter pub get

# Run the app
flutter run
```

### Building for Release

```bash
flutter build apk --release
```

---

## Project Structure

```
lib/
  main.dart                  — Entry point and app configuration.
  theme/
    app_theme.dart           — Premium Obsidian theme definitions.
  database/
    local_storage.dart       — Data management logic.
  widgets/
    glass_calc_button.dart   — Custom glassmorphism button components.
  screens/
    ...                      — Individual feature screens.
```

---

## License

© 2025 NetCalc Pro. All rights reserved. Built as a professional academic project.
