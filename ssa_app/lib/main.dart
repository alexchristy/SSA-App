import 'package:flutter/material.dart';
import 'package:ssa_app/screens/terminal-list/terminal_list_screen.dart';
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
      title: 'Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
      ),
      home: TerminalsList(),
    );
  }
}
