/// API keys are injected at build time via --dart-define.
/// Run: flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key
/// Or use run.ps1 which reads from android/local.properties.
const String googleMapsApiKey =
    String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

/// Firebase Storage token for splash logo. Pass via --dart-define or fetch from Firestore.
const String splashLogoToken =
    String.fromEnvironment('SPLASH_LOGO_TOKEN', defaultValue: '');
