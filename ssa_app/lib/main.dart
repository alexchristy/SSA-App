import 'package:flutter/material.dart';
import 'package:ssa_app/theme/app_theme.dart'; // Import your theme
import 'package:ssa_app/screens/home/home_screen.dart'; // Import your home screen
import 'services/firebase/firebase_init.dart'; // Import the Firebase initializer

void main() async {
  await FirebaseInitializer.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSpaceA',
      theme: AppTheme.lightTheme, // Apply the theme here
      home: const HomeScreen(),
    );
  }
}
