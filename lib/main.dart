import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/app_localizations.dart';
import 'app_locale.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print(' Firebase initialized successfully!');
  } catch (e) {
    print(' Firebase initialization error: $e');
  }

  await loadSavedAppLocale();

  runApp(const ProgramITApp());
}

class ProgramITApp extends StatelessWidget {
  const ProgramITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'ProgramIT',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primaryColor: const Color(0xFFFF8C42),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF8C42),
              primary: const Color(0xFFFF8C42),
              secondary: const Color(0xFF27AE60),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF2C3E50),
            useMaterial3: true,
          ),
          home: HomeScreen(),
        );
      },
    );
  }
}
