import 'package:flutter/material.dart';
import 'package:programmit_app/core/constants/app_strings.dart';
import 'package:programmit_app/core/theme/app_theme.dart';
import 'package:programmit_app/features/home/presentation/screens/home_screen.dart';
import 'package:programmit_app/l10n/app_localizations.dart';
import 'package:programmit_app/services/storage_service.dart';

class ProgramITApp extends StatelessWidget {
  const ProgramITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildAppTheme(),
          home: const HomeScreen(),
        );
      },
    );
  }
}
