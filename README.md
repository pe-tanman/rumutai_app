# 🏆 HR対抗 App (rumutai_app)

> *The whole school's sports tournament, live on every student's phone.*

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20Android-lightgrey)
![Peak users](https://img.shields.io/badge/peak%20concurrent%20users-1%2C000%2B-brightgreen)


## 🌟 Highlights

- ⚡ **Live scores** — results appear the moment student staff enter them
- 🗓️ **Schedules and brackets** — full league tables and knockout brackets for every grade, plus a per-venue schedule
- 🔔 **Push notifications** — a reminder 10 minutes before your games, and announcements from organizers
- 📣 **Cheer, predict, draw a fortune** — cheer for teams, predict winners, and draw (or write!) おみくじ fortunes
- 🧑‍⚖️ **Staff and admin modes** — a simple, error-resistant result entry flow for rotating student staff
- 👥 **Real-world scale** — more than 1,000 concurrent users at peak on tournament days


## ℹ️ Overview

**HR対抗** (the *inter-homeroom tournament*, nicknamed *ルム対*) is Aichi Prefectural Asahigaoka High School's school-wide sports competition. For years it was run on paper: brackets were taped to gym walls and results were passed along by word of mouth.

This app lets every student check schedules, scores and brackets on their own phone. Student staff enter results through a flow designed for first-time users under time pressure: as few fields as possible and a short, predictable sequence of screens, so entries stay accurate even as staff rotate.

A companion desktop tool, [**rumutai_app_shedule_upload**](https://github.com/pe-tanman/rumutai_app_shedule_upload), imports the official Excel schedule and referee tables into Firestore.


### ✍️ Authors

- [Yuki Ishihara](https://github.com/pe-tanman): app committee founder and lead, product design and development
- [yukiMizo](https://github.com/yukiMizo): development (this app builds on [rumutai_app_v3](https://github.com/yukiMizo/rumutai_app_v3))

Developed by the Asahigaoka High School Student Council app committee.


## 🚀 Features at a Glance

| For everyone | For staff | For admins |
| --- | --- | --- |
| Home dashboard for *your* homeroom | Sign in as tournament staff | Adjust the schedule on the fly |
| Game results by category and grade | Your venue's games and timeline | Send push notifications |
| League tables and knockout brackets | Enter scores in a few taps | Moderate reported fortunes |
| Map with per-venue schedules | | |
| Cheering, predictions, おみくじ, awards | | |
| Rule book (PDF), notifications | | |


## ⬇️ Building from Source

Requirements: [Flutter](https://docs.flutter.dev/get-started/install) **3.7 or earlier** (the project targets Dart 2.18–2.19, before Dart 3), plus Xcode or Android Studio. [fvm](https://fvm.app) makes it easy to switch Flutter versions.

```bash
git clone https://github.com/pe-tanman/rumutai_app.git
cd rumutai_app
flutter pub get
flutter run
```

The app expects a Firebase project with **Firestore**, **Realtime Database** and **Cloud Messaging** enabled. To use your own project, run `flutterfire configure` to regenerate `lib/firebase_options.dart` and the platform config files.


## 💭 Feedback and Contributing

Future app committees are welcome to fork this and adapt it for their own events. Please [open an issue](https://github.com/pe-tanman/rumutai_app/issues) with questions or bug reports.
