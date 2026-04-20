import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:programmit_app/app.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/firebase_options.dart';
import 'package:programmit_app/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _startFirebase();
  await loadSavedAppLocale();

  runApp(const ProgramITApp());
}

Future<void> _startFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    appLog('firebase ok');
  } catch (e, st) {
    appLog('firebase init: $e\n$st');
  }

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    appLog('auth ${FirebaseAuth.instance.currentUser?.uid ?? "none"}');
  } catch (e, st) {
    appLog('auth anon (check Console): $e\n$st');
  }
}
