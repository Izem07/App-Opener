# Fed Progress Connect — iOS Flutter WebView Wrapper

A clean iOS wrapper app that loads the Fed Progress Connect Google Apps Script web app inside a native WebView, with persistent session state and a green brand theme.

---

## Project Structure

```
Fed-Progress-Connect/
├── lib/
│   └── main.dart            # All app logic — WebView, theme, nav, state
├── ios/
│   └── Runner/
│       └── Info.plist       # iOS permissions (network, orientations)
├── assets/
│   └── icon/
│       └── app_icon.png     # ← Place your app icon here (1024×1024 px PNG)
├── pubspec.yaml             # Dependencies and flutter_launcher_icons config
└── README.md
```

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `webview_flutter` | ^4.7.0 | Renders the web app inside iOS |
| `shared_preferences` | ^2.2.3 | Persists the last active tab across sessions |
| `flutter_launcher_icons` | ^0.13.1 | Auto-generates iOS app icon sizes |

---

## First-Time Setup

### 1. Install Flutter dependencies

```bash
flutter pub get
```

### 2. Add your app icon

- Export or save a **1024×1024 px PNG** of your green app icon.
- Drop it into: `assets/icon/app_icon.png`
- Then run:

```bash
dart run flutter_launcher_icons
```

This auto-generates all required iOS icon sizes and updates `Assets.xcassets/AppIcon.appiconset` in Xcode.

### 3. Run on iOS Simulator or device

```bash
flutter run
```

Or open `ios/Runner.xcworkspace` in Xcode and build from there.

---

## Adding More Links

Open `lib/main.dart` and add entries to the `appDestinations` list at the top:

```dart
final List<AppDestination> appDestinations = [
  AppDestination(
    title: 'Connect',
    url: 'https://your-google-apps-script-url/exec',
    icon: Icons.bolt,
  ),
  AppDestination(
    title: 'Portal 2',
    url: 'https://your-other-link-here.com',
    icon: Icons.link,
  ),
];
```

The bottom navigation bar appears **automatically** when you have 2 or more links, and hides itself when there's only 1.

---

## Theme Colors

| Role | Hex | Usage |
|---|---|---|
| Background | `#121814` | Scaffold / page background |
| Surface | `#1B241E` | AppBar, bottom nav bar |
| Primary | `#2E6F40` | Progress indicator, primary actions |
| Selected | `#4E9F63` | Active bottom nav icon |

---

## iOS Permissions (Info.plist)

- `NSAllowsArbitraryLoadsInWebContent: true` — required for Google Apps Script URLs to load inside WKWebView.
- `io.flutter.embedded_views_preview: true` — enables WKWebView rendering on iOS.
- Supports portrait and landscape orientations by default.

---

## Notes

- The app remembers the last active tab using `shared_preferences`. On next launch it restores that tab automatically.
- The refresh button (↻) in the top-right reloads the current page.
- A slim green progress bar shows page load progress.
