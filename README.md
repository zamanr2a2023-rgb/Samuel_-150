# ProgramIT - Flutter App

**Kampprogram på mobilen - Flutter versjon**

Dette er Flutter- versjon av iOS appen som ble utviklet i Swift/UIKit av gruppemedlem.

---

## 📱 OM APPEN

ProgramIT lar brukere finne kampprogram og events basert på GPS-lokasjon eller kode.

**Funksjonalitet:**
- ✅ GPS-søk (innen 2km radius)
- ✅ Søk med kode
- ✅ MatchCell (Kamp: Hjemmelag vs Bortelag)
- ✅ EventCell (Event: Enkelt arrangement)
- ✅ PDF-visning av kampprogram
- ✅ Kart til arena/lokasjon
- ✅ Avstand i luftlinje

---

## 🏗️ ARKITEKTUR

### **Backend: Laravel PHP**
- URL: `https://www.programmit.no`
- API: `https://www.programmit.no/json/programLocation.php?lat=X&lng=Y`
- Database: MySQL
- Webhotell: Dr. Linux

### **Frontend: Flutter/Dart**
- Framework: Flutter 3.0+
- Språk: Dart
- Plattformer: iOS, Android, Web

### **Design:**
- Oransje header: `#FF8C42`
- Mørk bakgrunn: `#2C3E50`
- Grønn knapp: `#27AE60`
- Cards: `#34495E`

---

## 📦 INSTALLASJON

### **1. Klon eller last ned prosjektet**
```bash
cd flutter_programmit
```

### **2. Installer dependencies**
```bash
flutter pub get
```

### **3. Kjør appen**

**iOS Simulator:**
```bash
flutter run -d "iPhone 15"
```

**Android Emulator:**
```bash
flutter run -d emulator-5554
```

**Fysisk enhet:**
```bash
flutter run
```

---

## 🗂️ FILSTRUKTUR

```
flutter_programmit/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/
│   │   └── event.dart            # Event data model
│   ├── services/
│   │   └── api_service.dart      # Laravel API calls
│   ├── screens/
│   │   └── home_screen.dart      # Hovedskjerm
│   └── widgets/
│       ├── match_card.dart       # MatchCell widget
│       └── event_card.dart       # EventCell widget
├── pubspec.yaml                   # Dependencies
├── android/                       # Android config
├── ios/                           # iOS config
└── README.md                      # Denne filen
```

---

## 🔌 API INTEGRASJON

### **Laravel Backend Endpoint:**
```
GET https://www.programmit.no/json/programLocation.php
```

**Parameters:**
- `lat` (required): Latitude (f.eks. 59.265052306965)
- `lng` (required): Longitude (f.eks. 10.413174069409)

**Response (JSON):**
```json
[
  {
    "user_id": "1",
    "name": "Party i heimen",
    "cell": "EventCell",
    "address": "Bakkenteigen",
    "homeTeam": "data/yXhz3dUbZTylGt36Flij.jpg",
    "awayTeam": "bareenlogo",
    "homeTeamText": "blank",
    "awayTeamText": "blank",
    "lat": "59.265052306965",
    "longi": "10.413174069409",
    "dag": "2025-10-18",
    "tid": "20:00",
    "PDFPath": "test.pdf",
    "kode": "party",
    "distance": 0
  },
  {
    "user_id": "1",
    "name": "ikke",
    "cell": "MatchCell",
    "address": "Aker Arena",
    "homeTeam": "data/SlwmsL4tOxUt8Y8w4ZNT.png",
    "awayTeam": "data/KMzMpWfvIG7ILQeECpii.png",
    "homeTeamText": "Molde",
    "awayTeamText": "KFUM",
    "lat": "59.265052306965",
    "longi": "10.413174069409",
    "dag": "2025-10-11",
    "tid": "12:00",
    "PDFPath": "test.pdf",
    "kode": "molde",
    "distance": 0
  }
]
```

---

## 🎨 DESIGNSYSTEM

### **Fargepalett:**
```dart
// Orange (Header, accents)
Color(0xFFFF8C42)

// Dark blue/gray (Background)
Color(0xFF2C3E50)

// Card background
Color(0xFF34495E)

// Green (GPS button, Match badge)
Color(0xFF27AE60)

// Red (PDF button)
Colors.red[700]

// Blue (Distance)
Colors.blue[300]
```

### **Typografi:**
- Headers: Bold, 28px, white
- Body: Regular, 14-16px, white70
- Badges: Bold, 12px, colored

---

## 📱 WIDGETS

### **MatchCard** (MatchCell)
Viser kamper med:
- Hjemmelag logo (venstre)
- Bortelag logo (høyre)
- "vs" tekst mellom
- Dato og tid
- Arena/adresse
- Avstand (hvis >0 km)
- Kode badge (grønn)
- PDF-knapp (rød)
- Kart-ikon (oppe til høyre)

### **EventCard** (EventCell)
Viser events med:
- Event logo (venstre)
- Event navn (høyre)
- Dato og tid inline
- Adresse
- Avstand (hvis >0 km)
- Kode badge (oransje)
- PDF-knapp (rød)
- Kart-ikon (oppe til høyre)

---

## 🧪 TESTING

### **Test følgende:**
1. ✅ Åpne appen → Skal vise oransje header
2. ✅ Trykk GPS-knapp → Skal be om tillatelse
3. ✅ Søk med GPS → Skal vise kamper i nærheten
4. ✅ Søk med kode (f.eks. "molde") → Skal filtrere
5. ✅ Trykk på kampkort → Skal åpne PDF
6. ✅ Trykk på kart-ikon → Skal åpne Google Maps
7. ✅ Pull-to-refresh → Skal oppdatere listen

### **Test på flere enheter:**
```bash
# iOS Simulator
flutter run -d "iPhone 15"
flutter run -d "iPhone SE"
flutter run -d "iPad Pro"

# Android Emulator
flutter run -d emulator-5554

# Fysisk enhet
flutter devices
flutter run -d <device-id>
```

---

## 🚀 BYGGING FOR PRODUKSJON

### **Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### **iOS IPA:**
```bash
flutter build ios --release
```
**NB:** Krever Apple Developer konto og Xcode.

### **Web:**
```bash
flutter build web --release
```
Output: `build/web/`

---

## 🔒 PERMISSIONS

### **Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### **iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Appen trenger GPS for å finne kamper i nærheten</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Appen trenger GPS for å finne kamper i nærheten</string>
```

---

##  FEILSØKING

### **Problem: GPS fungerer ikke**
**Løsning:**
1. Sjekk at permissions er lagt til (se over)
2. Sjekk at GPS er på i telefonen
3. Test på fysisk enhet (ikke simulator)

### **Problem: API returnerer ingen data**
**Løsning:**
1. Sjekk internett-tilkobling
2. Test API-URL i nettleser:
   ```
   https://www.programmit.no/json/programLocation.php?lat=59.265052&lng=10.413174
   ```
3. Sjekk console-output for feilmeldinger

### **Problem: Bilder vises ikke**
**Løsning:**
1. Sjekk at bildestier i JSON er korrekte
2. Bilder skal ha full URL: `https://www.programmit.no/data/xyz.jpg`
3. Sjekk at `INTERNET` permission er aktivert

### **Problem: PDF åpnes ikke**
**Løsning:**
1. Sjekk at `url_launcher` pakke er installert
2. PDF-URL må være korrekt
3. Test med en kjent PDF-URL først

---

## 📝 BACHELOR-OPPGAVE DETALJER

### **Original iOS App:**
- Språk: Swift
- Framework: UIKit
- Platform: iOS only
- Utviklet av: Gruppemedlem Øystein

### **Flutter Android utvikler Samuel:**
- Språk: Dart
- Framework: Flutter
- Plattformer: iOS, Android, Web
- Samme funksjonalitet og design

### **Backend (Uendret):**
- Laravel PHP
- MySQL database
- REST API
- Webhotell: Dr. Linux (programmit.no)

---

## 🎓 FOR EKSAMEN

### **Sentrale konsepter å forklare:**

**1. Hvorfor Flutter i stedet for native?**
- **Svar:** Én kodebase for iOS, Android og Web. Raskere utvikling (4 uker vs 12 uker). Enklere vedlikehold. Samme design på alle plattformer.

**2. Hvordan fungerer GPS-søket?**
- **Svar:** 
  1. Få GPS-posisjon fra telefonen (Geolocator)
  2. Send lat/lng til Laravel API
  3. Backend beregner avstand (server-side)
  4. Returner JSON med events innen 2km
  5. Vis i appen sortert etter avstand

**3. Hva er forskjellen på MatchCell og EventCell?**
- **Svar:** MatchCell viser kamper (2 logoer, hjemmelag vs bortelag). EventCell viser events (1 logo, eventnavn). Backend bestemmer type via `cell`-feltet i JSON.

**4. Hvordan håndteres bilder?**
- **Svar:** Bilder lagres på backend (`/data/` mappe). Full URL sendes i JSON. Flutter laster ned og cacher automatisk med `Image.network()`.

**5. Hva skjer når man trykker på et kampkort?**
- **Svar:** `url_launcher` pakke åpner PDF-URL i ekstern nettleser/PDF-viser. Samme for kart-ikon (Google Maps).

---

## 🔗 VIKTIGE LINKER

- **Backend:** https://www.programmit.no
- **Admin:** https://www.programmit.no/login
- **API Endpoint:** https://www.programmit.no/json/programLocation.php
- **Flutter Docs:** https://docs.flutter.dev
- **Dart Docs:** https://dart.dev/guides

---

##  SUPPORT

Hvis du har spørsmål, kontakt:
- **Prosjekt:** ProgramIT Bachelor Gruppe 4
- **Institusjon:** Universitetet i Sørøst-Norge
- **Fakultet:** Teknologi, naturvitenskap og maritime fag

---

## ✅ SJEKKLISTE FØR INNLEVERING

- [ ] Testet på iOS simulator
- [ ] Testet på Android emulator
- [ ] Testet GPS-søk
- [ ] Testet kode-søk
- [ ] Testet PDF-åpning
- [ ] Testet kart-åpning
- [ ] Bygget release APK
- [ ] Dokumentert kode
- [ ] Skrevet README
- [ ] Lagret alle filer

---

**Ferdig! 🎓🚀⚽**
