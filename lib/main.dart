import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:programmit_app/app.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/firebase_options.dart';
import 'package:programmit_app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    appLog('Firebase init OK');
  } catch (e, st) {
    appLog('Firebase init failed: $e\n$st');
  }

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    appLog('Firebase auth uid: ${FirebaseAuth.instance.currentUser?.uid}');
  } catch (e, st) {
    appLog(
      'Anonymous sign-in failed (enable Anonymous in Firebase Console): '
      '$e\n$st',
    );
  }

  await loadSavedAppLocale();

  runApp(const ProgramITApp());
}
