import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kAppLocalePrefKey = 'app_locale';

/// Drives [MaterialApp.locale]; persist with [saveAppLocale].
final ValueNotifier<Locale> appLocaleNotifier =
    ValueNotifier(const Locale('nb'));

Future<void> loadSavedAppLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(kAppLocalePrefKey);
  if (code != null && (code == 'en' || code == 'nb')) {
    appLocaleNotifier.value = Locale(code);
  }
}

Future<void> saveAppLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(kAppLocalePrefKey, locale.languageCode);
  appLocaleNotifier.value = locale;
}

void toggleEnNbLocale() {
  final next = appLocaleNotifier.value.languageCode == 'nb'
      ? const Locale('en')
      : const Locale('nb');
  saveAppLocale(next);
}
