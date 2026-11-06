# Semi-A-Use - Flutter source

Offline-first Android learning app about superconducting materials.

## Features
- SQLite database seeded locally on first launch with 12 materials
- Material details: name, formula, Tc, Type-I/II classification, critical magnetic field, applications and notes
- Search by name/formula and Type-I/Type-II filters
- Six expandable learning modules
- Eight-question interactive quiz with feedback and score
- About page
- No network calls, account, API or server required at runtime

## Build on Windows
1. Install Flutter SDK and Android Studio (Android SDK).
2. Open PowerShell in this folder.
3. Run:
   ```powershell
   flutter create --platforms=android .
   flutter pub get
   flutter run
   ```
4. Set `android:label="Semi-A-Use"` in `android/app/src/main/AndroidManifest.xml`.
5. Build release APK:
   ```powershell
   flutter build apk --release
   ```
6. APK location: `build\app\outputs\flutter-apk\app-release.apk`

## Offline test
Install and launch once, then enable airplane mode. Open all tabs, search/filter materials, open details, read lessons and finish the quiz. The app stores its records in a local SQLite database and makes no HTTP requests.

## Scientific caution
Values are approximate representative values, not universal constants. Composition, pressure, sample quality, temperature and field orientation affect reported values. Type-I materials are described by Hc; Type-II materials by Hc1 and Hc2. H3S requires extreme pressure (around 150 GPa) for its high-temperature superconducting phase. Add a bibliography and verify each record against primary scientific sources before submission.
