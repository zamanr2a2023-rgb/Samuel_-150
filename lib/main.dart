import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  // VIKTIG: Initialiser Flutter bindings før Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  try {
    await Firebase.initializeApp();
    print(' Firebase initialized successfully!');
  } catch (e) {
    print(' Firebase initialization error: $e');
  }

  runApp(ProgramITApp());
}

class ProgramITApp extends StatelessWidget {
  const ProgramITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProgramIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF8C42), // Orange
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8C42),
          primary: const Color(0xFFFF8C42),
          secondary: const Color(0xFF27AE60),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF2C3E50), // Dark blue/gray
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
