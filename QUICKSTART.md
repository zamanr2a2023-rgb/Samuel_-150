# 🚀 QUICK START GUIDE - ProgramIT Flutter

**Fra 0 til **

---

## ✅ TRINN 1: SJEKK AT FLUTTER ER INSTALLERT

```bash
flutter --version
```

Hvis ikke installert, gå til: https://docs.flutter.dev/get-started/install

---

## ✅ TRINN 2: NAVIGER TIL PROSJEKTET

```bash
cd flutter_programmit
```

---

## ✅ TRINN 3: INSTALLER PAKKER

```bash
flutter pub get
```

Dette laster ned:
- `http` - For API calls
- `geolocator` - For GPS
- `url_launcher` - For PDF og kart
- `shared_preferences` - For lokal lagring
- `flutter_spinkit` - For loading indicator

---

## ✅ TRINN 4: KJØR APPEN

### **På iOS Simulator:**
```bash
open -a Simulator
flutter run
```

### **På Android Emulator:**
```bash
# Start emulator først i Android Studio
flutter run
```

### **På fysisk enhet:**
```bash
flutter devices
flutter run -d <device-id>
```

---

## ✅ TRINN 5: TEST APPEN

1. **Trykk GPS-knapp** → Godta tillatelse
2. **Vent på resultater** → Skal vise kamper
3. **Trykk på kampkort** → Skal åpne PDF
4. **Trykk kart-ikon** → Skal åpne Google Maps

---

## 🎨 HVIS DU VIL ENDRE DESIGN:

### **Farger** (`lib/main.dart`):
```dart
Color(0xFFFF8C42)  // Orange header
Color(0xFF2C3E50)  // Mørk bakgrunn
Color(0xFF27AE60)  // Grønn knapp
```

### **Logo** (erstatt placeholder):
1. Legg logo i `assets/logo.png`
2. Oppdater `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/logo.png
   ```
3. Oppdater `lib/screens/home_screen.dart`:
   ```dart
   Image.asset('assets/logo.png', width: 100, height: 100)
   ```

---

## 🔧 HVIS NOEN PROBLEMER:

### **GPS fungerer ikke:**
```bash
# Sjekk permissions er lagt til
cat android/app/src/main/AndroidManifest.xml
cat ios/Runner/Info.plist
```

### **API returnerer ingen data:**
```bash
# Test API i nettleser
open "https://www.programmit.no/json/programLocation.php?lat=59.265052&lng=10.413174"
```

### **Build feil:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📦 BYGG FOR PRODUKSJON:

### **Android APK:**
```bash
flutter build apk --release
# Finn APK: build/app/outputs/flutter-apk/app-release.apk
```

### **iOS IPA:**
```bash
flutter build ios --release
# Krever Apple Developer konto
```

---

## 🎯 NESTE STEG:

1. ✅ Test på flere enheter
2. ✅ Legg til ekte logo
3. ✅ Test med ekte GPS-data
4. ✅ Bygg release versjon
5. ✅ Publiser til App Store / Google Play

---

**DET ER ALT! Appen skal nå kjøre! **

Hvis du har problemer, sjekk README.md for mer detaljert info.
