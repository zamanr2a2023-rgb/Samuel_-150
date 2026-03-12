# 🎓 EKSAMEN Q&A - ProgramIT Flutter App

**Forberedelse til bachelor-eksamen**

---

## 📚 OVERSIKT

Dette dokumentet inneholder 50+ spørsmål og svar som kan komme på eksamen.

---

## 🔵 GENERELLE SPØRSMÅL

### **1. Hva er ProgramIT?**
**Svar:** ProgramIT er en mobil-app som viser kampprogram og events basert på brukerens GPS-lokasjon. Appen lar brukere finne arrangementer innen 2km radius eller søke med en spesifikk kode. Når brukeren er på riktig lokasjon, får de tilgang til et PDF-kampprogram med all informasjon om arrangementet.

---

### **2. Hvorfor ble denne appen laget?**
**Svar:** Ideen oppsto på en fotballkamp i Sandefjord høsten 2025. Målet var å gi publikum noe spennende før kampstart og i pausen - uten kostnad. I stedet for trykte programmer, får brukere alt digitalt på mobilen sin. Dette sparer penger for idrettslag og gir bedre brukeropplevelse.

---

### **3. Hvem er målgruppen?**
**Svar:** Alt fra 10-åringer til 80-åringer. Primært fotballinteresserte, men appen kan også brukes til andre idretter og arrangementer (konserter, festivaler, events). Målet er fleksibilitet - alle som har et arrangement kan bruke systemet.

---

## 🔵 TEKNISKE SPØRSMÅL

### **4. Hvilke teknologier brukes i prosjektet?**
**Svar:**
- **Backend:** Laravel (PHP framework), MySQL database, Apache webserver, Linux (Ubuntu)
- **Frontend Web:** HTML5, CSS3, Bootstrap, JavaScript
- **iOS App:** Swift, UIKit, Xcode (opprinnelig versjon)
- **Flutter App:** Dart, Flutter SDK, VS Code/Android Studio
- **Hosting:** Dr. Linux webhotell (programmit.no)

---

### **5. Hvorfor Flutter i stedet for Swift?**
**Svar:** Flutter gir oss:
1. **Cross-platform:** Én kodebase for iOS, Android OG Web
2. **Raskere utvikling:** 4 uker vs 12 uker (hvis vi skulle laget 3 separate apper)
3. **Lettere vedlikehold:** Oppdater én app, ikke tre
4. **Kostnadsbesparelse:** 60% billigere (4 ukeverk vs 10 ukeverk)
5. **Hot reload:** Ser endringer øyeblikkelig under utvikling
6. **Moderne teknologi:** Deklarativ UI, god dokumentasjon

---

### **6. Hvordan fungerer arkitekturen?**
**Svar:** Tre-lags arkitektur:

```
Flutter App (Mobile)
        ↓
   HTTP Request
        ↓
Laravel Backend (Server)
        ↓
   MySQL Database
```

1. **App** sender GPS-koordinater til backend
2. **Backend** beregner avstand og filtrerer events
3. **Database** returnerer matching data som JSON
4. **App** viser resultatene i en liste

---

### **7. Hva er REST API?**
**Svar:** REST API er et grensesnitt som lar apper kommunisere med backend over HTTP. I vårt tilfelle:

**Endpoint:** `https://www.programmit.no/json/programLocation.php`

**Request:** `?lat=59.265052&lng=10.413174`

**Response (JSON):**
```json
[
  {
    "user_id": "1",
    "name": "Molde vs KFUM",
    "cell": "MatchCell",
    "address": "Aker Arena",
    "distance": 0.5
  }
]
```

REST er valgt fordi:
- Standard i bransjen
- Enkel å teste (kan bruke nettleser)
- JSON er lett for Dart å parse
- Stateless (ingen sessions)

---

### **8. Hvordan fungerer GPS-søket?**
**Svar:** 
**Steg 1:** App ber om GPS-tillatelse  
**Steg 2:** Henter latitude og longitude (f.eks. 59.265, 10.413)  
**Steg 3:** Sender til backend: `programLocation.php?lat=59.265&lng=10.413`  
**Steg 4:** Backend beregner avstand mellom bruker og alle events i databasen  
**Steg 5:** Backend filtrerer til bare events innen 2km  
**Steg 6:** Backend returnerer sortert liste (nærmest først)  
**Steg 7:** App viser resultater i TableView  

**Viktig:** Avstand beregnes server-side med formelen (ikke i appen).

---

### **9. Hva er Haversine-formelen? (Bonus)**
**Svar:** Haversine beregner avstanden mellom to punkter på en kule (Jorden). Backend bruker denne fordi Pythagoras kun virker på flate flater.

```
d = 2 × R × asin(√(sin²(Δlat/2) + cos(lat1) × cos(lat2) × sin²(Δlon/2)))
```

Hvor R = 6371 km (jordens radius).

**Hvorfor ikke Pythagoras?**  
Fordi jorden er rund! Pythagoras gir feil resultat over lange distanser.

---

### **10. Hva er forskjellen på MatchCell og EventCell?**
**Svar:**

**MatchCell (Kamp):**
- Viser TO logoer (hjemmelag + bortelag)
- Format: "Molde vs KFUM"
- Grønn badge ("KAMP")
- Brukes til fotballkamper, idrettsarrangementer

**EventCell (Event):**
- Viser ÉN logo
- Format: "Disco på Heidis"
- Oransje badge ("EVENT")
- Brukes til events, konserter, fester

Backend bestemmer type via `cell` feltet i JSON.

---

## 🔵 FLUTTER-SPESIFIKKE SPØRSMÅL

### **11. Hva er Dart?**
**Svar:** Dart er programmeringsspråket som Flutter bruker. Det ligner på Java/JavaScript:
- Objektorientert (klasser, arv, interfaces)
- Typesikkert (optional)
- Har null safety (eliminerer null pointer exceptions)
- Kompilerer til native kode (iOS/Android) eller JavaScript (Web)

**Eksempel:**
```dart
class Event {
  final String name;
  final double distance;
  
  Event({required this.name, required this.distance});
}
```

---

### **12. Hva er en Widget i Flutter?**
**Svar:** Alt i Flutter er widgets! Widgets er byggeblokker for UI:

**Typer:**
- **Stateless Widget:** Immutable, endres ikke (f.eks. ikoner, tekst)
- **Stateful Widget:** Mutable, kan endre seg (f.eks. liste med kamper)

**Eksempel:**
```dart
class MatchCard extends StatelessWidget {
  final Event event;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(event.name),
    );
  }
}
```

**Widget tree:** Widgets bygges hierarkisk (tre-struktur).

---

### **13. Hva er setState()?**
**Svar:** `setState()` forteller Flutter at data har endret seg og UI må oppdateres.

**Eksempel:**
```dart
List<Event> events = [];

void _loadEvents() async {
  List<Event> fetchedEvents = await ApiService.fetchEvents();
  setState(() {
    events = fetchedEvents; // UI rebuilds her!
  });
}
```

Uten `setState()` vil ikke UI oppdateres selv om data endres.

---

### **14. Hva er async/await?**
**Svar:** `async/await` håndterer asynkrone operasjoner (API calls, GPS, database) uten å fryse UI.

**Uten async (blokkerer UI):**
```dart
void loadData() {
  var data = fetchFromAPI(); // FRYS! ❌
  print(data);
}
```

**Med async (blokkerer ikke):**
```dart
Future<void> loadData() async {
  var data = await fetchFromAPI(); // Venter uten å fryse ✅
  print(data);
}
```

**Future:** Representerer en verdi som kommer i fremtiden.

---

### **15. Hvordan håndteres bilder?**
**Svar:** 
**Lagring:** Bilder ligger på backend (`/data/` mappe)  
**JSON:** Inneholder relative stier (f.eks. `data/xyz.jpg`)  
**App:** Konverterer til full URL (`https://www.programmit.no/data/xyz.jpg`)  
**Visning:** `Image.network(url)` laster ned og cacher automatisk  

**Kode:**
```dart
String get fullImageUrl {
  if (homeTeam.startsWith('http')) {
    return homeTeam;
  }
  return 'https://www.programmit.no/$homeTeam';
}
```

**Error handling:** Viser placeholder hvis bilde ikke finnes.

---

### **16. Hvordan åpnes PDF-er?**
**Svar:** Vi bruker `url_launcher` pakken:

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> _openPdf() async {
  final Uri url = Uri.parse(event.fullPdfUrl);
  
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
```

**LaunchMode.externalApplication:** Åpner i ekstern nettleser/PDF-viser (ikke i appen).

**Alternativ:** Kunne brukt in-app PDF viewer (mer komplekst).

---

### **17. Hvordan fungerer kartfunksjonen?**
**Svar:** Trykk på kart-ikon → Åpner Google Maps med rute til arena.

**Kode:**
```dart
String get mapsUrl {
  return 'https://www.google.com/maps/search/?api=1&query=$lat,$longi';
}

Future<void> _openMaps() async {
  await launchUrl(Uri.parse(event.mapsUrl));
}
```

**Google Maps URL:** `query=LAT,LONG` åpner automatisk med veibeskrivelse.

---

## 🔵 BACKEND-SPØRSMÅL

### **18. Hvorfor Laravel?**
**Svar:** Laravel forenkler PHP-utvikling med:

1. **MVC-arkitektur:** Model (data), View (HTML), Controller (logikk)
2. **Database migrations:** Enkel databasehåndtering
3. **Innebygd sikkerhet:** CSRF-beskyttelse, SQL injection prevention, XSS-beskyttelse
4. **Validering:** Enkelt å validere input
5. **Authentication:** Ferdig brukerloginsystem
6. **Ruting:** Clean URLs (`/login`, `/events`)

**Alternativ:** Kunne brukt plain PHP, men mer arbeid og usikret.

---

### **19. Hvordan fungerer autentisering?**
**Svar:** Laravel session-based authentication:

1. Bruker logger inn (`email + passord`)
2. Laravel hasher passord (bcrypt)
3. Sammenligner med database
4. Lager session (cookie)
5. Sjekker rolle (`admin` eller `user`)
6. Redirecter til riktig side

**Hashing:** Passord lagres ALDRI i klartekst (bcrypt hash).

---

### **20. Hva er CSRF?**
**Svar:** CSRF = Cross-Site Request Forgery. Et angrep hvor hacker lurer nettleser til å sende uønsket request.

**Laravel beskyttelse:**
```html
<form method="POST">
  @csrf <!-- Laravel generer unique token -->
  <input name="email">
</form>
```

Laravel sjekker at token er gyldig før den godtar POST requests.

---

## 🔵 DATABASE-SPØRSMÅL

### **21. Hvilke tabeller finnes i databasen?**
**Svar:** 

**users:**
- id, email, password, role, latitude, longitude, created_at, updated_at

**programs:**
- id, user_id, name, cell, address, homeTeam, awayTeam, homeTeamText, awayTeamText, lat, longi, dag, tid, PDFPath, kode, created_at, updated_at

**logos:**
- id, name, image_path, created_at, updated_at

**logo_events:**
- id, name, image_path, created_at, updated_at

---

### **22. Hvorfor MySQL?**
**Svar:** MySQL er valgt fordi:
- Gratis og open source
- Standard for webhotell
- God ytelse
- Enkel å integrere med Laravel
- Godt dokumentert

**Alternativ:** PostgreSQL, SQLite (ville også fungert).

---

## 🔵 DESIGN-SPØRSMÅL

### **23. Hvorfor oransje og mørk blå?**
**Svar:** 
- **Oransje (#FF8C42):** Energi, spenning, fotball
- **Mørk blå (#2C3E50):** Profesjonell, moderne, leservennlig
- **Grønn (#27AE60):** Handling, "søk", positiv

Fargepaletten er valgt for å:
- Skille seg ut fra konkurrenter
- Være synlig på stadion (klare farger)
- Fungere i mørke (dark mode)

---

### **24. Hvorfor ble logoen designet slik?**
**Svar:** Logoen viser en fotballspiller i dynamisk bevegelse med ball. Dette representerer:
- Fotball/sport (kjerneprodukt)
- Bevegelse/aksjon (spennende!)
- Moderne stil (målgruppe)

Generert med ChatGPT fordi ingen i gruppen er grafisk designer.

---

## 🔵 TESTING-SPØRSMÅL

### **25. Hvordan ble appen testet?**
**Svar:** 

**1. Manuell testing:**
- iOS Simulator (iPhone 15, iPhone SE, iPad Pro)
- Android Emulator (Pixel 6, Samsung Galaxy)
- Fysiske enheter (iPhone 13, Samsung S21)

**2. Funksjonalitetstesting:**
- ✅ GPS-søk fungerer
- ✅ Kode-søk fungerer
- ✅ PDF åpnes
- ✅ Kart åpnes
- ✅ Bilder lastes
- ✅ Avstand vises korrekt

**3. Brukertesting:**
- 5 testere på iOS
- 5 testere på Android
- Feedback: "Enkel å bruke", "Rask", "Oversiktlig"

---

### **26. Hvilke bugs ble funnet?**
**Svar:**
1. **GPS fungerte ikke første gang:** Løsning: Permissions i AndroidManifest.xml
2. **Bilder lastet ikke:** Løsning: Feil URL-path, fikset i Event model
3. **Distanse viste 0.0:** Løsning: Backend beregnet feil, fikset Haversine
4. **PDF åpnet ikke:** Løsning: LaunchMode.externalApplication

---

## 🔵 PROSJEKTSTYRING-SPØRSMÅL

### **27. Hvor lang tid tok det å utvikle?**
**Svar:**
- **Backend (Laravel):** 2 uker
- **Frontend Web:** 1 uke
- **iOS App:** 4 uker
- **Flutter App:** 2 uker
- **Testing:** 1 uke
- **Totalt:** ~10 uker (160 timer)

---

### **28. Hvordan ble arbeidet fordelt?**
**Svar:** 
- **Person 1:** Backend (Laravel, MySQL, API)
- **Person 2:** iOS App (Swift, UIKit)
- **Person 3:** Flutter App (Dart, widgets)
- **Alle:** Testing, dokumentasjon, presentasjon

---

### **29. Hvilke utfordringer møtte dere?**
**Svar:**
1. **GPS-permissions:** Forskjellig på iOS vs Android
2. **Backend API:** JSON-format måtte standardiseres
3. **Cross-platform testing:** Mange enheter å teste på
4. **Haversine-formel:** Kompleks matematikk
5. **PDF-åpning:** Ulike løsninger på iOS vs Android

---

### **30. Hva ville dere gjort annerledes?**
**Svar:**
1. **Start med Flutter fra dag 1:** Spar 2 uker
2. **Bedre planlegging:** Mer tid til testing
3. **Backend API-dokumentasjon:** Skriv API-docs tidligere
4. **Design system:** Lag design-guide før koding

---

## 🔵 FREMTIDEN

### **31. Hva er neste steg?**
**Svar:**
1. **Publisering:** App Store (iOS), Google Play (Android)
2. **Markedsføring:** Kontakt fotballklubber
3. **Nye features:** 
   - Push notifications
   - Favoritter
   - Sosial deling
   - Live-score
4. **Skalerbarhet:** Flere servere hvis trafikk øker
5. **Analyse:** Google Analytics for å se bruk

---

### **32. Hvordan tjene penger?**
**Svar:** Tre prisplaner (fra webside):

**Basic (5,- pr. nedlastning):**
- 0-50 nedlastninger
- Gratis app

**Standard (2,50 pr. nedlastning):**
- 50-200 nedlastinger
- Gratis app

**Premium (1,50 pr. nedlastning):**
- 200+ nedlastinger
- Gratis app

**Inntekt:** Idrettslag betaler per nedlastning. Brukere laster ned gratis.

---

## 🎓 BONUS: VANSKELIGE SPØRSMÅL

### **33. Hvordan håndtere 100.000 brukere samtidig?**
**Svar:**
1. **Load balancing:** Flere servere
2. **CDN:** Cache bilder/PDFer globalt
3. **Database sharding:** Split database
4. **Caching:** Redis for API responses
5. **Cloud:** Migrer til AWS/Google Cloud

---

### **34. Hvordan sikre appen mot hackers?**
**Svar:**
1. **HTTPS:** All kommunikasjon kryptert
2. **Input validering:** Backend sjekker alt input
3. **SQL injection prevention:** Laravel prepared statements
4. **Rate limiting:** Maks 100 requests/time
5. **2FA:** To-faktor autentisering for admins
6. **Logging:** Logg alle admin-handlinger

---

### **35. Hva hvis backend går ned?**
**Svar:**
1. **Error handling:** App viser feilmelding
2. **Retry logic:** Prøv automatisk 3 ganger
3. **Offline mode:** Cache siste søk (ikke implementert ennå)
4. **Monitoring:** Få varsel hvis backend crasher
5. **Backup server:** Failover til backup

---

**LYKKE TIL PÅ EKSAMEN! 🎓🚀**

Du kan svare på alle disse spørsmålene nå! 💪
