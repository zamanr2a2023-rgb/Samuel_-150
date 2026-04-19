lib/
├── main.dart
├── app.dart
├── firebase_options.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── api_endpoints.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── app_log.dart
│   │   ├── helpers.dart
│   │   └── input_checks.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       └── loading_widget.dart
│
├── features/
│   ├── chat/
│   │   ├── data/models/chat_message.dart
│   │   └── presentation/screens/chat_screen.dart
│   ├── events/
│   │   ├── data/models/event.dart
│   │   └── presentation/screens/match_detail_screen.dart
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/home_screen.dart
│   │       └── widgets/
│   │           ├── event_card.dart
│   │           └── match_card.dart
│   ├── map/
│   │   └── presentation/screens/map_screen.dart
│   └── profile/
│       └── presentation/screens/settings_screen.dart
│
├── l10n/
├── routes/
│   └── app_routes.dart
└── services/
    ├── api_service.dart
    ├── chat_service.dart
    └── storage_service.dart
