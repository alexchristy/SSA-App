import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Anonymously sign in the user
Future<UserCredential> signInWithAnonymous() async {
  return await FirebaseAuth.instance.signInAnonymously();
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Check if the user is already signed in with another account
    if (FirebaseAuth.instance.currentUser != null) {
      // Link the new credential with the existing account
      return await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } else {
      // Sign in with the new credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
