import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssa_app/theme/app_theme.dart';
import 'package:ssa_app/screens/home/home_screen.dart';
import 'package:ssa_app/utils/authentication_utils.dart';
import 'services/firebase/firebase_init.dart';
import 'package:ssa_app/providers/global_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initializeFirebase();

  // Create the GlobalProvider and wrap the app with it
  GlobalProvider globalProvider = GlobalProvider();

  // Sign in with an anonymous account if the user is not signed in
  // Treating anonymous users as not signed in
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      globalProvider.setSignedIn(true);
    } else {
      signInWithAnonymous();
      globalProvider.setSignedIn(false);
    }
  });

  runApp(Provider(
    create: (context) => globalProvider,
    child: const MyApp(),
  ));
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
