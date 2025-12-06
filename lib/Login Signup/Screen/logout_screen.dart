import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecolive/Login%20With%20Google/google_auth.dart';
import 'package:ecolive/Widget/button.dart';
import 'package:ecolive/loading/loading.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/view/checking_internet.dart';
import 'package:ecolive/view/internet_provider.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr(LocaleData.seeyou),
                  textAlign: TextAlign.center,
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      // ignore: prefer_const_constructors
                      color: Color(0xFF706134)),
                ),

                MyButtons(
                  onTap: () async {
                    showLoadingDialog(context); // Show Loading Dialog
                    await Future.delayed(
                        const Duration(seconds: 2)); // Simulate a task
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    await FirebaseServices().googleSignOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: tr(LocaleData.logoutbtt),
                ),
                // for google sign in ouser detail
                Image.network("${FirebaseAuth.instance.currentUser!.photoURL}"),
                Text("${FirebaseAuth.instance.currentUser!.email}"),
                Text("${FirebaseAuth.instance.currentUser!.displayName}")
              ],
            ),
          ),
        );
      },
    );
  }
}
