# 2 Technologies and tools

*Draft chapter for thesis or project report — ProgramIT (Flutter). Trim or expand subsections to match your page budget and faculty guidelines.*

---

## 2.1 Cross-platform mobile development overview

Mobile development has always been a trade-off between **control** and **reach**. You can squeeze every last frame out of a platform if you write **twice**, once per vendor language and SDK. Most student projects—and plenty of professional ones—cannot pretend that double maintenance is free.

### 2.1.1 Native development

**Native** usually means **Swift** or **Objective-C** on Apple’s side, **Kotlin** or **Java** on Google’s. You get excellent tooling, predictable performance, and UI that “feels” right on that OS because you are literally using the same widgets the system uses. The cost is what you already know from the ProgramIT history: an **iOS-only** app leaves Android users on the website, and feature drift between two apps is almost guaranteed unless someone pays for synchronization discipline.

### 2.1.2 Cross-platform development

**Cross-platform** tries to carry **one** primary codebase across several targets. The old joke—that you write once and debug everywhere—still contains a grain of truth, but the situation is better than it was ten years ago. Modern frameworks compile down to real native binaries or embed a controlled runtime, and plugins bridge into GPS, cameras, and storage without you writing JNI or Objective-C bridges by hand for every feature.

ProgramIT’s Flutter client belongs in this second bucket. Nobody chose it because it is magic; they chose it because **one Dart codebase** could realistically ship **Android** and **iOS** (and **web**, if you care) against an API that was already live.

---

## 2.2 Comparison of cross-platform development frameworks

A fair comparison would deserve its own literature review. Here is the shorter version that actually informed this project.

**React Native** shares JavaScript with a huge web hiring pool and a mature package ecosystem. It also carries JavaScript’s runtime surprises and the mental overhead of bridging into native modules when something is missing. **Xamarin** (and later **.NET MAUI**) fits shops already invested in C#; it never dominated small Norwegian student projects the way web stacks did.

**Flutter** sits differently. It does not wrap the platform’s built-in buttons; it **draws** the UI with **Skia** (or Impeller where enabled), so a Flutter `Text` is not literally an Android `TextView`, even if it looks close. That bothered purists at first. In practice it bought **layout consistency** and **fast iteration** with **hot reload**, which matters when you are tuning list cards at midnight before a deadline.

For ProgramIT specifically, Flutter also had straightforward answers for **maps**, **HTTP**, **localization**, and **Firebase**—all boxes the app had to tick without writing a custom rendering engine.

---

## 2.3 Flutter

**Flutter** is Google’s open-source UI toolkit. Apps are built from **widgets**—everything is a widget, including padding and alignment—which sounds tedious until you discover how easy it is to split a screen into composable pieces and test layout in isolation.

Two details matter for a report like this. First, Flutter’s **layout model** (constraints passing down, sizes passing up) takes a week to internalize and then feels obvious. Second, **platform channels** exist for the rare moment when a plugin does not cover your need; ProgramIT mostly stayed on the beaten path.

The project targets a modern **Dart 3** SDK (`>=3.0.0 <4.0.0` in `pubspec.yaml`), uses **Material** widgets, and relies on **MaterialApp** with generated localizations. Nothing exotic—on purpose.

---

## 2.4 Dart

**Dart** is the language Flutter compiles from. If you arrive from **Java** or **C#**, the syntax feels familiar. If you arrive from **Kotlin**, you miss a few conveniences until you get used to **null safety**, which Dart enforces in sound mode: types tell you whether `null` is allowed, and the analyzer complains before runtime blows up.

For ProgramIT, Dart’s **async/await** model mattered more than clever language features. Network calls and GPS reads are **Futures**; the UI thread stays responsive when you remember not to block it. **jsonDecode** turns strings into structures you still have to shape into typed models yourself—there is no free ORM on the client—but that keeps dependencies thin.

---

## 2.5 Backend for ProgramIT

The Flutter app is not a greenfield system. It talks to a **Laravel** installation that was already serving the original iOS client. That constraint was useful: it forced the student work to stay honest about **integration** instead of inventing a fantasy stack.

### 2.5.1 Laravel, PHP, and REST-style JSON endpoints

**Laravel** is a **PHP** framework people like because it makes routing, configuration, and database access readable. “REST” in the wild often means “JSON over HTTP with sensible verbs”; ProgramIT’s endpoint behaves like a **read-heavy GET** that returns an array (or a wrapper object) the client must parse defensively. Nobody claimed full REST purity here, and that is fine.

### 2.5.2 MySQL and deployment (e.g. programmit.no)

Persistent data—users, events, file paths—lives in **MySQL** on the server side. From the Flutter team’s perspective that database is **invisible**, which is how it should be: you see **URLs** and **JSON fields**, not tables. Hosting on **programmit.no** means real-world latency, HTTPS certificates that must stay valid, and the occasional lesson that **production** does not forgive hard-coded IP addresses.

### 2.5.3 JSON API contract (`programLocation.php`, lat/lng parameters)

The client calls something shaped like `programLocation.php?lat=…&lng=…`. Rows come back with enough information to distinguish a **match** from an **event** (via a `cell` field in practice), show **logos**, **times**, **addresses**, and build **PDF** and **map** links. The exact schema is better shown in an appendix with a sample response; the important point is that **the server owns distance logic** and the app mostly **sorts** and **filters** (for example by code) on top of what it receives.

---

## 2.6 Firebase

Chat could have been bolted onto PHP with WebSockets and a lot more server time. **Firebase** offered a faster path for a bounded feature: **Firestore** for messages, **Firebase Auth** for a stable user id without building registration screens on day one.

### 2.6.1 Firebase Core and project configuration (`firebase_options.dart`)

**FlutterFire** tooling generates `firebase_options.dart` so each platform (Android, iOS, web) picks the correct keys at compile time. It is easy to get wrong once—wrong bundle id, wrong `google-services.json`—and then nothing works until you notice the typo. That friction is normal.

### 2.6.2 Anonymous authentication for chat identity

The app uses **anonymous sign-in** so every install gets a **uid** without forcing email/password flows in a sports programme app. That is a product choice as much as a technical one: lower barrier, less GDPR surface for credentials you never wanted to store. Trade-off: recovery if the user wipes data is weak unless you add linking later.

### 2.6.3 Firestore and chat persistence

**Firestore** stores chat messages in collections you design yourself. Queries are cheap until they are not; for a student scope, the important habit is **structuring documents** so listeners fetch a sane amount of text, not the whole history of Norwegian grassroots football since 1987.

---

## 2.7 Location, maps, and external content

### 2.7.1 Geolocator and platform permissions

**Geolocator** wraps the platform location services. On paper it is a few lines of Dart; in reality you spend time on **permission strings** in `Info.plist`, manifest entries on Android, and user education when GPS is disabled. None of that is Flutter’s fault, but it is part of the real workload.

### 2.7.2 Google Maps Flutter (`MapScreen`)

**google_maps_flutter** embeds a **Google Map** in the widget tree. You need API keys, billing enabled on Google Cloud (even if usage stays inside free tiers), and patience when debugging on emulators without Play services. The map screen in ProgramIT ties markers and polylines to the **event** the user selected.

### 2.7.3 Opening PDFs and maps in external apps (`url_launcher`)

Not every document belongs inside a WebView. **url_launcher** hands **PDFs** and **external map URLs** to whatever app the user already trusts—Chrome, Adobe, Google Maps. That keeps maintenance smaller and often gives a better PDF experience than embedding your own renderer.

---

## 2.8 Supporting Flutter packages

### 2.8.1 HTTP client and JSON parsing

The **`http`** package is deliberately small: you build a `Uri`, await `get` or `post`, read `body`, decode JSON. No hidden magic. Timeouts and error messages are your responsibility, which ProgramIT handles at the service layer with logging helpers.

### 2.8.2 Internationalization (`flutter gen-l10n`, English / Norwegian)

Flutter’s **`flutter_localizations`** plus ARB files generate **`AppLocalizations`**, so widgets call `AppLocalizations.of(context)` instead of scattering hard-coded strings. Norwegian **Bokmål** sits next to English because the product audience is not only international students writing reports about it.

### 2.8.3 Local preferences (`SharedPreferences`)

**SharedPreferences** stores lightweight key–value data—nickname, font size, locale choice—without shipping SQLite for everything. It is not encrypted storage; do not treat it like a vault.

---

## 2.9 Visual Studio Code

**Visual Studio Code** is the editor most people on the team already had installed. It starts fast, handles **Dart** analysis through the official extension, and integrates with **Flutter** tooling for run/debug. Android Studio remains valid for Android-only developers; nobody needs a religious war in Chapter 2.

### 2.9.1 Extensions for Flutter and Dart

The **Flutter** and **Dart** extensions supply debugging, device selection, and the boring quality-of-life features—go to definition, rename—that save hours. **Error Lens**-style extensions are optional; the minimum bar is “analyzer stays green enough that you notice red.”

---

## 2.10 Postman (or browser) for API testing

**Postman** is useful when you want to save a **GET** with query parameters and show a lecturer exactly what the server returned on Tuesday. A normal browser address bar works too for simple JSON endpoints; Postman shines when you add headers or repeat calls while the PHP side changes.

---

## 2.11 Git

**Git** is version control: branches, commits, the ability to revert when you “fix” something at 2 a.m. and make it worse. Even solo student work benefits from small commits with messages that future-you can read.

### 2.11.1 GitHub or equivalent remote repository

**GitHub** (or GitLab, or Bitbucket) is where the remote lives: backup, collaboration, and the place CI might run later if you add it. The important habit is not the vendor name but that **`main`** is never the only copy of your degree project.

---

## 2.12 Selection criteria for technologies and tools

If you compress the decision into one paragraph: ProgramIT needed **cross-platform** delivery without abandoning a **working Laravel API**, needed **maps** and **GPS** with mainstream plugins, needed **chat** without becoming a backend thesis, and needed a toolchain a student can install on a mediocre laptop. **Flutter + Dart + Firebase + VS Code + Git** satisfied those constraints without pretending Node.js or MongoDB were part of the story—because they were not.

That is not the same as claiming Flutter is universally best. It means the stack **fit this project’s reality**, including people’s prior skills and the deadline.

---

*Swap in citations (Flutter docs, Laravel docs, Firebase pricing pages) where your examiner expects references. Remove vendor opinions if your institution prefers strictly neutral prose.*
