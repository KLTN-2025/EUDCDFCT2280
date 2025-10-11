import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Updated function to return a UserCredential
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // ignore: avoid_print
      print("🚀 Google Sign-In started...");
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // ignore: avoid_print
        print("⚠️ User canceled Google Sign-In");
        return null; // Return null if the user cancels sign-in
      }

      // ignore: avoid_print
      print("✅ Google User Selected: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // ignore: avoid_print
      print("🎉 Firebase Sign-In Success: ${userCredential.user?.email}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("🔥 FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("🔥 Unknown Sign-In Error: $e");
      return null;
    }
  }

  // Sign out function
  Future<void> googleSignOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    // ignore: avoid_print
    print("🔴 User Signed Out");
  }
}
