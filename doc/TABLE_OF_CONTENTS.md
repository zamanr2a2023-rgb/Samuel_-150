# ProgramIT — Contents (Table of Contents)

**Application:** ProgramIT Flutter client (`flutter_programmit`)  
**Backend:** Laravel / PHP, MySQL, JSON API at `https://www.programmit.no/json`  
**Supporting services:** Firebase (anonymous auth, chat), Google Maps, device GPS  

**Usage:** Fill in the **Page** column after your report is paginated. For a layout like your sample (dot leaders, right-aligned pages), paste this structure into Microsoft Word and apply a TOC style or tab leaders.

---

## Front matter

| Section | Page |
|---------|------|
| Abstract | |
| Table of Figures | |
| Table of Contents | |

---

## Main chapters

| Section | Page |
|---------|------|
| **1** Introduction | |
| **2** Technologies and tools | |
| **3** Development of the mobile application | |
| **4** Summary and reflection | |
| References | |
| Appendices | |

---

## 1 Introduction

| Section | Page |
|---------|------|
| 1.1 Background and problem statement | |
| 1.2 Goals, scope, and delimitations | |
| 1.3 Method and report structure | |

---

## 2 Technologies and tools

| Section | Page |
|---------|------|
| **2.1** Cross-platform mobile development overview | |
| 2.1.1 Native development | |
| 2.1.2 Cross-platform development | |
| **2.2** Comparison of cross-platform development frameworks | |
| **2.3** Flutter | |
| **2.4** Dart | |
| **2.5** Backend for ProgramIT | |
| 2.5.1 Laravel, PHP, and REST-style JSON endpoints | |
| 2.5.2 MySQL and deployment (e.g. programmit.no) | |
| 2.5.3 JSON API contract (`programLocation.php`, lat/lng parameters) | |
| **2.6** Firebase | |
| 2.6.1 Firebase Core and project configuration (`firebase_options.dart`) | |
| 2.6.2 Anonymous authentication for chat identity | |
| 2.6.3 Firestore and chat persistence | |
| **2.7** Location, maps, and external content | |
| 2.7.1 Geolocator and platform permissions | |
| 2.7.2 Google Maps Flutter (`MapScreen`) | |
| 2.7.3 Opening PDFs and maps in external apps (`url_launcher`) | |
| **2.8** Supporting Flutter packages | |
| 2.8.1 HTTP client and JSON parsing | |
| 2.8.2 Internationalization (`flutter gen-l10n`, English / Norwegian) | |
| 2.8.3 Local preferences (`SharedPreferences`) | |
| **2.9** Visual Studio Code | |
| 2.9.1 Extensions for Flutter and Dart | |
| **2.10** Postman (or browser) for API testing | |
| **2.11** Git | |
| 2.11.1 GitHub or equivalent remote repository | |
| **2.12** Selection criteria for technologies and tools | |

---

## 3 Development of the mobile application

| Section | Page |
|---------|------|
| **3.1** System architecture and design | |
| **3.2** User interface design and implementation | |
| 3.2.1 Design system (colors, typography, reusable widgets) | |
| 3.2.2 Home screen: GPS search, code search, lists, errors | |
| 3.2.3 Match and event cards (`MatchCard`, `EventCard`) | |
| 3.2.4 Match detail, map, chat, and settings screens | |
| **3.3** Backend integration (Laravel JSON API) | |
| 3.3.1 `ApiService` and endpoint configuration | |
| 3.3.2 `Event` model and parsing edge cases | |
| **3.4** Frontend development using Flutter | |
| 3.4.1 Application entry and dependency injection patterns | |
| 3.4.2 Navigation and state on key screens | |
| 3.4.3 Chat feature (`ChatService`, Firestore) | |
| 3.4.4 Localization and persisted settings | |
| **3.5** Testing and build | |
| 3.5.1 Manual test scenarios (GPS, search, PDF, maps) | |
| 3.5.2 Debug and release builds (APK, iOS, web) | |

---

## 4 Summary and reflection

| Section | Page |
|---------|------|
| 4.1 Results compared to objectives | |
| 4.2 Limitations and future work | |
| 4.3 Learning outcomes | |

---

## References

| Section | Page |
|---------|------|
| Bibliography | |

---

## Appendices

| Section | Page |
|---------|------|
| A. API example response (JSON) | |
| B. Project folder structure (`lib/` tree) | |
| C. Table of Figures (see `doc/TABLE_OF_FIGURES.md`) | |
| D. Permissions summary (Android / iOS) | |

---

## Plain-text outline (copy for Word dot leaders)

```
Abstract ...........................................................
Table of Figures ....................................................
Table of Contents ...................................................

1 Introduction ......................................................
2 Technologies and tools ............................................
  2.1 Cross-platform mobile development overview ....................
    2.1.1 Native development ........................................
    2.1.2 Cross-platform development ................................
  2.2 Comparison of cross-platform development frameworks ...........
  2.3 Flutter .......................................................
  2.4 Dart ..........................................................
  2.5 Backend for ProgramIT .........................................
    2.5.1 Laravel, PHP, and REST-style JSON endpoints .................
    2.5.2 MySQL and deployment ......................................
    2.5.3 JSON API contract .........................................
  2.6 Firebase ......................................................
    2.6.1 Firebase Core and configuration ...........................
    2.6.2 Anonymous authentication ................................
    2.6.3 Firestore and chat ......................................
  2.7 Location, maps, and external content ............................
  2.8 Supporting Flutter packages ...................................
  2.9 Visual Studio Code ............................................
  2.10 Postman / API testing ........................................
  2.11 Git ..........................................................
  2.12 Selection criteria for technologies and tools ................

3 Development of the mobile application .............................
  3.1 System architecture and design ................................
  3.2 User interface design and implementation ......................
  3.3 Backend integration (Laravel JSON API) ........................
  3.4 Frontend development using Flutter ............................
  3.5 Testing and build .............................................

4 Summary and reflection ............................................
References ..........................................................
Appendices ..........................................................
```

---

*This contents list matches your application stack (Flutter + Laravel/MySQL JSON API + Firebase + maps). It replaces the sample thesis sections that referred to Node.js, Express, MongoDB, JWT, and Bcrypt.*
