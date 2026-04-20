# ProgramIT — Table of Figures

**Document:** Full-application figure list (Flutter client, Laravel/JSON backend, Firebase)  
**Project:** `flutter_programmit` (ProgramIT — kampprogram på mobilen)  
**Usage:** Replace the **Page** column with final page numbers after you insert screenshots and diagrams into your thesis or report (Word/LaTeX/Google Docs).

---

## List of figures

| Figure | Title | Page |
|--------|--------|------|
| 1 | Flutter layered architecture (framework, engine, embedder) — conceptual overview | |
| 2 | ProgramIT repository and `lib/` folder structure | |
| 3 | Application entry: `main.dart` (Firebase init, anonymous auth, locale load, `runApp`) | |
| 4 | Root widget: `ProgramITApp` in `app.dart` (theme, localization, `HomeScreen`) | |
| 5 | High-level system architecture: Flutter app ↔ HTTPS JSON API ↔ Laravel/PHP ↔ MySQL | |
| 6 | API base URL and `programLocation.php` request (lat/lng query parameters) | |
| 7 | Sample JSON response: `MatchCell` vs `EventCell` and distance field | |
| 8 | `Event` data model mapping (`fromJson` / fields used in UI) | |
| 9 | `ApiService`: `fetchEventsByLocation` and `searchByCode` flow | |
| 10 | Home screen — initial layout and orange header | |
| 11 | Home screen — GPS permission and location acquisition (`Geolocator`) | |
| 12 | Home screen — events list after location search (sorted by distance) | |
| 13 | Home screen — code search filtered results | |
| 14 | Home screen — error states (GPS off, denied, search failed) | |
| 15 | `MatchCard` widget — match row (logos, vs, date/time, arena, code, PDF, map) | |
| 16 | `EventCard` widget — event row (single logo, name, badges, actions) | |
| 17 | Match detail screen — header, actions, navigation to chat/settings | |
| 18 | Match detail screen — PDF and external maps (`url_launcher`) | |
| 19 | Map screen — Google Map with venue marker and route polyline | |
| 20 | Map screen — distance/duration or loading state | |
| 21 | Chat screen — message list and composer (per-event chat) | |
| 22 | Chat screen — Firebase anonymous user and nickname (`SharedPreferences`) | |
| 23 | `ChatService` / Firestore integration (high-level sequence) | |
| 24 | `ChatMessage` model structure | |
| 25 | Settings screen — nickname and font size controls | |
| 26 | Settings screen — persistence with `SharedPreferences` | |
| 27 | App theme: `buildAppTheme()` and color tokens (`app_colors.dart`) | |
| 28 | Reusable UI: `CustomButton`, `CustomTextField`, `LoadingWidget` | |
| 29 | Localization: `AppLocalizations` (English / Norwegian Bokmål) | |
| 30 | `storage_service.dart` — saved app locale notifier | |
| 31 | `AppRoutes` and navigation pattern (`MaterialPageRoute` from home/detail) | |
| 32 | `firebase_options.dart` — platform Firebase configuration | |
| 33 | Android build: `google-services.json` placement and Gradle integration | |
| 34 | iOS: location usage strings and permissions (`Info.plist`) | |
| 35 | Android: `INTERNET` and location permissions (`AndroidManifest.xml`) | |
| 36 | Pull-to-refresh on home list (user-visible behavior) | |
| 37 | External PDF viewer / browser handoff (user flow screenshot) | |
| 38 | Release build outputs: APK / iOS / web (folder screenshot) | |

---

## Suggested figure groups (for your report)

1. **Figures 1–8** — Introduction, stack, and data contract.  
2. **Figures 9–16** — Core discovery UX (home, cards, API).  
3. **Figures 17–26** — Detail, map, chat, settings, Firebase.  
4. **Figures 27–38** — Cross-cutting: theme, widgets, i18n, config, deployment.

---

## Captions you can paste under screenshots

- **Figure 5:** End-to-end data flow from device GPS coordinates to sorted event list.  
- **Figure 9:** Client-side HTTP GET, JSON parse, and client-side code filter.  
- **Figure 23:** Optional sequence: anonymous sign-in → chat document path → Firestore read/write.

---

## File reference index (for appendix cross-links)

| Topic | Primary path |
|--------|----------------|
| Entry | `lib/main.dart` |
| App shell | `lib/app.dart` |
| Home | `lib/features/home/presentation/screens/home_screen.dart` |
| Cards | `lib/features/home/presentation/widgets/match_card.dart`, `event_card.dart` |
| Detail | `lib/features/events/presentation/screens/match_detail_screen.dart` |
| Map | `lib/features/map/presentation/screens/map_screen.dart` |
| Chat | `lib/features/chat/presentation/screens/chat_screen.dart` |
| Settings | `lib/features/profile/presentation/screens/settings_screen.dart` |
| Event model | `lib/features/events/data/models/event.dart` |
| API | `lib/services/api_service.dart`, `lib/core/constants/api_endpoints.dart` |
| Chat backend helper | `lib/services/chat_service.dart` |
| Routes | `lib/routes/app_routes.dart` |

---

*Generated for the ProgramIT Flutter codebase. Update the Page column after pagination.*
