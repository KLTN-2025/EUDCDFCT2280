import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import '../Widget/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            myDialogBox(context);
          },
          child: Text(
            tr(LocaleData.forgotpassword),
            // ignore: prefer_const_constructors
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  void myDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        tr(LocaleData.forgotpasswordWord),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      // ignore: prefer_const_constructors
                      border: OutlineInputBorder(),
                      labelText: tr(LocaleData.forgotpasswordHint),
                      hintText: tr(LocaleData.forgotpasswordEx),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      showLoadingDialog(context); // Show Loading Dialog
                      await Future.delayed(
                          const Duration(seconds: 2)); // Simulate a task
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      String email = emailController.text.trim();

                      if (email.isNotEmpty) {
                        try {
                          // ignore: use_build_context_synchronously
                          showLoadingDialog(context); // Show Loading Dialog
                          await Future.delayed(
                              const Duration(seconds: 2)); // Simulate a task
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // Send password reset email
                          await auth.sendPasswordResetEmail(email: email);

                          // Search for the user in Firestore
                          var querySnapshot = await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: email)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            String userId = querySnapshot.docs.first.id;

                            // Update Firestore with password reset request time
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(userId)
                                .update({
                              "passwordResetRequestedAt":
                                  FieldValue.serverTimestamp(),
                            });
                          }

                          showSnackBar(
                              // ignore: use_build_context_synchronously
                              context, tr(LocaleData.forgotpasswordnotify));
                        } catch (error) {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, error.toString());
                        }

                        // Close the dialog and clear the text field
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        emailController.clear();
                      } else {
                        showSnackBar(
                            // ignore: use_build_context_synchronously
                            context, tr(LocaleData.forgotpasswordEmail));
                      }
                    },

                    // if we remember the password then we can easily login
                    // if we forget the password then we apply this method
                    child: Text(
                      tr(LocaleData.forgotpasswordbtt),
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
