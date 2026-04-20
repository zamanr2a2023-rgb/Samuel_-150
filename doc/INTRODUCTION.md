# 1 Introduction

*Draft for thesis or project report — ProgramIT (Flutter). Adjust names, course codes, and dates to match your submission.*

---

## 1.1 Background and problem statement

If you have ever stood outside a small sports hall on a Saturday, wondering whether kick-off was moved or which pitch you are supposed to find, you already know the kind of friction this project is about. The information usually exists somewhere: on a club website, inside a PDF, on a poster taped to a door. The annoying part is not lack of data, but the way it is scattered. On a phone, that scatter becomes taps, zooming, slow PDFs, and half-remembered codes you were told once in a group chat.

**ProgramIT** was created to sit in the middle of that mess and answer a narrower question: *what is happening near me right now, or what matches this code I have?* The original solution was an **iOS app** built with **Swift** and **UIKit**. It worked for people on iPhones, talked to a **Laravel** backend on **programmit.no**, and pulled down JSON describing matches and events in the area. That was already a useful product for its audience.

The limitation was mostly practical. Android users were left out unless they used the website. Maintaining two separate native codebases was never really on the table for a student-sized scope. At the same time, **Flutter** had matured enough that a single **Dart** codebase could plausibly cover **iOS**, **Android**, and **web** without pretending to be identical everywhere, but close enough that one team could keep feature parity.

This report describes the **Flutter** version of ProgramIT: same backend contract, same basic idea (location or code → list → detail → PDF and maps), with a few additions that the old stack did not emphasize as strongly—**in-app chat** tied to an event, **settings** that persist on the device, and **bilingual** UI text. None of that changes the core problem statement. It only sharpens it: people need **fast**, **low-friction** access to programmes they can trust, on the device they already carry.

---

## 1.2 Goals, scope, and delimitations

The main goal of the client work was straightforward: **reimplement** the ProgramIT experience in Flutter so that **Android** (and optionally **web**) users get the same core journey as on iOS, without rewriting the server. Concretely, that meant **GPS-based discovery**, **code search**, list presentation for **matches** and **events**, opening **PDFs** and **external maps**, and a clear path from a list row into a **detail** view.

A secondary goal was to show that you can bolt on **Firebase**-backed chat without forcing the legacy PHP API to become a real-time system overnight. Chat lives in **Firestore**; programmes still come from **MySQL** via JSON. That split is intentional. It keeps scope honest.

What we deliberately did **not** try to do matters as well. There is no new admin panel here, no rewrite of the Laravel code, and no claim that the Flutter UI pixel-matches the Swift app on every screen. **Backend business rules** (distance filtering, which rows return, how images are stored) stay on the server. The Flutter app assumes the JSON shape it was given and handles **bad network**, **permission denial**, and **empty results** as gracefully as time allowed. **Security** beyond HTTPS, platform stores, and Firebase rules is mostly out of scope for this document unless you extend it yourself.

---

## 1.3 Method and report structure

The work was carried out as **iterative development**: read the existing API, model the responses in Dart, build the **home** list first, then **detail**, **map**, **chat**, and **settings**, testing on emulators and physical devices when something only breaks on real hardware (GPS is the usual suspect).

The report follows that same order of increasing specificity. **Chapter 2** walks through the **technologies**—Flutter, Dart, the Laravel/JSON side, Firebase, maps, and the everyday tools (editor, Git, API testing). **Chapter 3** is the **development** narrative: architecture, UI decisions, how the client talks to **programmit.no**, and where the tricky bits showed up. **Chapter 4** steps back and asks what worked, what did not, and what a sensible next student might pick up.

If something in Chapter 3 reads like a detail you already know from building the app yourself, that is fine. The point of the introduction is simply to say why the project existed, what it promised, and where the rest of the document will take the reader—without sounding like a brochure.

---

*Replace placeholder phrasing ("this report", "we") with your institution’s preferred voice (first person singular, passive, or group name) before final submission.*
