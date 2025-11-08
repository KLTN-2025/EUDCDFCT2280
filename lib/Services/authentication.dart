import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';

// Hashing Password
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // ignore: avoid_print
      print("Login Result: ${loginResult.status}"); // Debugging

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        // ignore: avoid_print
        print("Access Token: $accessToken"); // Debugging

        if (accessToken == null) {
          // ignore: avoid_print
          print("Facebook access token is null");
          return null;
        }

        // final OAuthCredential credential = FacebookAuthProvider.credential(
        //   accessToken.token,
        // );
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                '${loginResult.accessToken?.tokenString}');

        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        // ignore: avoid_print
        print("Facebook login failed: ${loginResult.status}");
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error during Facebook sign-in: $e");
      return null;
    }
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = tr(LocaleData.signup_field);
    try {
      email = email.trim(); // Remove spaces

      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Email Validation
        if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
            .hasMatch(email)) {
          return tr(LocaleData.signup_email_format);
        }
        if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$")
            .hasMatch(password)) {
          return tr(LocaleData.signup_password_format);
        }

        // Create user account
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await cred.user!.sendEmailVerification();

        // Store user data in Firestore (before verifying email)
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'isEmailVerified': false, // Mark as unverified initially
        });

        res = tr(LocaleData.signup_email_inbox);
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return tr(LocaleData.resendEmailVerify);
      } else if (user == null) {
        return tr(LocaleData.resendUserno);
      } else {
        return tr(LocaleData.resendEmailVerify);
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = tr(LocaleData.signup_field);
    try {
      email = email.trim(); // Remove spaces

      if (email.isNotEmpty && password.isNotEmpty) {
        // Email Validation
        if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
            .hasMatch(email)) {
          return tr(LocaleData.login_email_auth);
        }

        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if email is verified
        if (!userCredential.user!.emailVerified) {
          return tr(LocaleData.login_email_verify);
        }

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // for sighout
  signOut() async {
    await _auth.signOut();
  }

  // Reset Password and Update Firestore
  Future<String> resetPassword(String email) async {
    String res = tr(LocaleData.resPP_notify);
    try {
      if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
          .hasMatch(email)) {
        return tr(LocaleData.resPP_email_auth);
      }
      await _auth.sendPasswordResetEmail(email: email);

      // Lấy user ID từ Firestore dựa trên email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await _firestore.collection('users').doc(userId).update({
          'lastPasswordReset': DateTime.now(),
        });
      }

      res = tr(LocaleData.resPP_email_send);
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
