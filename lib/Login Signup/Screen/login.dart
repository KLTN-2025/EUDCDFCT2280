import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/Login%20With%20Google/google_auth.dart';
import 'package:ecolive/Password%20Forgot/forgot_password.dart';
import 'package:ecolive/Widget/button.dart';
import 'package:ecolive/loading/loading.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/view/checking_internet.dart';
import 'package:ecolive/view/home/home_view.dart';
import 'package:ecolive/view/internet_provider.dart';
import 'package:ecolive/view/privacy_terms_dialog.dart';
import 'package:provider/provider.dart';
// import 'package:ecolive/view/home/home_view.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/authentication.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/text_field.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  // Hàm xử lý chuyển màn hình (Dùng chung cho cả Login thường và Google)
  Future<void> _navigateAfterLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // Kiểm tra xem đã đồng ý chưa
    bool hasAgreed = prefs.getBool('hasAgreedToTerms') ?? false;

    if (hasAgreed) {
      // Đã đồng ý rồi -> Vào thẳng Home
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const EcoFontConverterScreen()),
        (route) => false,
      );
    } else {
      // Chưa đồng ý -> Vào màn hình Terms
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PrivacyTermsDialog(
            onAgreed: () async {
              // Khi user bấm Đồng ý: Lưu lại và vào Home
              await prefs.setBool('hasAgreedToTerms', true);
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const EcoFontConverterScreen()),
                (route) => false,
              );
            },
          ),
        ),
      );
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true; //State variable for password visibility

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    showLoadingDialog(context); // Show Loading Dialog
    await Future.delayed(const Duration(seconds: 2)); // Simulate a task
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // Check if fields are empty
    // if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    //   showSnackBar(context, "Email and password cannot be empty");
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (!mounted) return;

    if (res == "success") {
      setState(() => isLoading = false);
      await _navigateAfterLogin();
    } else {
      setState(() => isLoading = false);
      // show error
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
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
        // double height = MediaQuery.of(context).size.height;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/login.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                  frameRate: const FrameRate(30),
                ),
                TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: tr(LocaleData.emailtxt),
                    textInputType: TextInputType.text),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: tr(LocaleData.passwordtxt),
                  textInputType: TextInputType.text,
                  //isPass: true,
                  isPass:
                      _isObscure, //Use _isObscure to toggle password visibility
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                MyButtons(onTap: loginUser, text: tr(LocaleData.loginbtt)),
                //  we call our forgot password below the login in button
                const ForgotPassword(),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    ),
                    Text(
                      tr(LocaleData.or),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    )
                  ],
                ),
                // for google login
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () async {
                      if (!context.mounted)
                        // ignore: curly_braces_in_flow_control_structures
                        return; // Ensure the widget is still in the tree

                      try {
                        showLoadingDialog(context); // Show loading indicator

                        UserCredential? userCredential =
                            await FirebaseServices().signInWithGoogle();

                        if (!context.mounted)
                          // ignore: curly_braces_in_flow_control_structures
                          return; // Prevent actions if widget is disposed

                        Navigator.pop(context); // Close loading screen

                        if (userCredential != null) {
                          // ignore: avoid_print
                          print(
                              "🎯 Google Sign-In successful. Navigating to Home...");

                          await _navigateAfterLogin();
                        } else {
                          // ignore: avoid_print
                          print("⚠️ Google Sign-In failed.");
                          showSnackBar(context, tr(LocaleData.ggcheckfail));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(
                              context); // Close loading screen if it's still active
                          showSnackBar(context, "Error: ${e.toString()}");
                        }
                        // ignore: avoid_print
                        print("🔥 Error during Google Sign-In: $e");
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Image.network(
                            "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                            height: 35,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          tr(LocaleData.googletxt),
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // Don't have an account? got to signup screen
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr(LocaleData.signuptxt),
                          // ignore: prefer_const_constructors
                          style: TextStyle(color: Colors.black)),
                      GestureDetector(
                        onTap: () async {
                          showLoadingDialog(context); // Show Loading Dialog
                          await Future.delayed(
                              const Duration(seconds: 2)); // Simulate a task
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          tr(LocaleData.signupbtt),
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
      ),
      child: Image.network(
        image,
        height: 40,
      ),
    );
  }
}
