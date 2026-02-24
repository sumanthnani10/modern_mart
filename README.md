# Modern Mart

A Flutter-based mobile app for local grocery and essentials delivery. Customers browse products, place orders, and receive push notifications.

## Features

- **Phone authentication** — Sign in via OTP
- **Location-based delivery** — Set address with Google Maps and Places autocomplete
- **Product catalog** — Browse categories and products
- **Cart & checkout** — Add items and place orders
- **Order tracking** — View order status
- **Push notifications** — Alerts for new orders (requires backend)

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter |
| Backend | Firebase (Auth, Firestore, Realtime DB, Cloud Messaging) |
| Maps & Location | Google Maps, Google Places API, Geolocator |

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio)
- Firebase project
- Google Cloud project (Maps & Places APIs enabled)

## Setup

### 1. Clone and install dependencies

```bash
git clone <repository-url>
cd modern_mart
flutter pub get
```

### 2. Configure API keys

**Do not commit** `local.properties`, `google-services.json`, or `GoogleService-Info.plist`.

#### Google Maps API key

1. Copy `android/local.properties.example` → `android/local.properties`
2. Add your key:
   ```properties
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```
3. Enable [Maps SDK for Android](https://console.cloud.google.com/apis/library/maps-android-backend.googleapis.com) and [Places API](https://console.cloud.google.com/apis/library/places-backend.googleapis.com) in Google Cloud Console.

#### Optional: Splash logo

Add `SPLASH_LOGO_TOKEN=your_firebase_storage_token` to `local.properties` for the splash screen logo.

#### Firebase

1. Create a project at [Firebase Console](https://console.firebase.google.com)
2. Add Android and iOS apps
3. Download `google-services.json` → `android/app/google-services.json`
4. Download `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`

If `google-services.json` was previously committed:

```bash
git rm --cached android/app/google-services.json
```

### 3. Run the app

**Windows (PowerShell):**

```powershell
.\run.ps1
```

**Manual:**

```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key
```

## Push notifications

The FCM **server key must never be in client code**. Use a backend (e.g. Firebase Cloud Functions triggered by Firestore writes) to send notifications. Rotate the key immediately if it was ever committed.

## Security

- API keys and secrets live in gitignored files
- Rotate any keys that were ever committed
- See [SECURING_REPO_KEYS_GUIDE.md](../SECURING_REPO_KEYS_GUIDE.md) in the workspace for a full checklist

## License

Proprietary. All rights reserved.
