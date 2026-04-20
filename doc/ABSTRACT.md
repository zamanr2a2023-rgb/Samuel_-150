# Abstract — ProgramIT (Flutter)

## English

Spectators and visitors often need quick access to local match programmes and event information without navigating fragmented websites or paper schedules. **ProgramIT** is a cross-platform mobile application that addresses this by letting users discover nearby fixtures and events using **GPS coordinates** or a **short search code**, then view details, open **programme PDFs**, see the **venue on a map**, and participate in **per-event chat**.

The client is implemented in **Flutter** and **Dart**, targeting Android, iOS, and web from a single codebase. Event data is retrieved over **HTTPS** from an existing **Laravel/PHP** backend on **programmit.no**, which exposes a **JSON** endpoint keyed by latitude and longitude; the app parses responses that distinguish **match** and **event** row types and presents them in dedicated list widgets. **Geolocator** supplies device location under platform permissions; **Google Maps** supports in-app routing context where implemented; **url_launcher** hands off PDFs and external map links to the system viewer. **Firebase** provides **anonymous sign-in** and **Firestore**-backed chat tied to the selected event. The interface supports **English** and **Norwegian (Bokmål)** via Flutter localization, with user preferences such as nickname and font size stored locally.

The work demonstrates how a **native-legacy API** can be integrated into a **modern cross-platform UI** while adding real-time collaboration features, within the constraints of a production-hosted backend and mobile platform policies.

---

## Norsk (sammendrag)

**ProgramIT** er en kryssplattform mobilapp som lar brukere finne **kampprogram** og **arrangement** i nærheten via **GPS** eller **kodesøk**, åpne **PDF-program**, se **arena på kart** og bruke **chat per arrangement**. Klienten er bygget med **Flutter/Dart** og henter data som **JSON** fra et eksisterende **Laravel/PHP**-API på **programmit.no**. Appen bruker **Firebase** (anonym innlogging og **Firestore** for chat), **Geolocator** for posisjon, **Google Maps** der det er relevant, og **url_launcher** for eksterne PDF- og kartlenker. Grensesnittet er tilgjengelig på **engelsk** og **norsk (bokmål)**.

---

*Adjust word count, author names, and institution to match your faculty template.*
