import 'package:firebase_auth/firebase_auth.dart';

// Anonymously sign in the user
Future<UserCredential> signInAnonymously() async {
  return await FirebaseAuth.instance.signInAnonymously();
}
