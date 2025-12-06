import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecolive/Services/authentication.dart';
import 'package:ecolive/Widget/button.dart';
import 'package:ecolive/Widget/snackbar.dart';
import 'package:ecolive/Widget/text_field.dart';
import 'package:ecolive/loading/loading.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/view/home/home_view.dart';
import 'package:ecolive/view/privacy_terms_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool _isObscure = true; //State variable for password visibility
  bool _isObscureConfirm = true; //State variable for password visibility
  bool _canResendEmail = true;
  int _secondsRemaining = 60;
  Timer? _timer;

  // Hàm xử lý chuyển màn hình sau khi Đăng ký thành công
  Future<void> _navigateAfterSignup() async {
    final prefs = await SharedPreferences.getInstance();
    // Kiểm tra xem đã đồng ý chưa (thường đăng ký mới là false)
    bool hasAgreed = prefs.getBool('hasAgreedToTerms') ?? false;

    if (!mounted) return;

    if (hasAgreed) {
      // Nếu (vì lý do nào đó) đã đồng ý rồi -> Vào thẳng Home
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const EcoFontConverterScreen()),
        (route) => false,
      );
    } else {
      // Chưa đồng ý -> Đẩy sang màn hình PrivacyTermsDialog
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        // Dùng pushReplacement để không quay lại màn Signup được
        MaterialPageRoute(
          builder: (context) => PrivacyTermsDialog(
            onAgreed: () async {
              // Khi user bấm "Tiếp tục": Lưu lại và vào Home
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

  void _startResendCooldown() {
    setState(() {
      _canResendEmail = false;
      _secondsRemaining = 60;
    });

    // ignore: prefer_const_constructors
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel(); // Stop timer when countdown finishes
        setState(() => _canResendEmail = true);
      }
    });
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
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); //Confirm Password
    nameController.dispose();
    _timer?.cancel(); // Cancel timer when widget is removed
    super.dispose();
  }

  void signupUser() async {
    showLoadingDialog(context); // Show Loading Dialog
    await Future.delayed(const Duration(seconds: 2)); // Simulate a task
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if (passwordController.text != confirmPasswordController.text) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, tr(LocaleData.signupdonmatch));
      return;
    }

    // set is loading to true.
    setState(() {
      isLoading = true;
    });

    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    if (!mounted) return;

    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      setState(() => isLoading = false);
      await _navigateAfterSignup();
    } else {
      setState(() => isLoading = false);
      // show error
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: height / 2.8,
            //   child: Image.asset('assets/images/signup.jpeg'),
            // ),
            Lottie.asset(
              'assets/lottie/signup.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
              frameRate: const FrameRate(30),
            ),
            TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: tr(LocaleData.signup_name),
                textInputType: TextInputType.text),
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: tr(LocaleData.signup_email),
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: tr(LocaleData.signup_password),
              textInputType: TextInputType.text,
              // isPass: true,
              isPass: _isObscure, //Use _isObscure to toggle password visibility
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: confirmPasswordController,
              hintText: tr(LocaleData.signup_confirmpassword),
              textInputType: TextInputType.text,
              isPass: _isObscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isObscureConfirm = !_isObscureConfirm;
                  });
                },
              ),
            ),
            MyButtons(onTap: signupUser, text: tr(LocaleData.signup_btt)),
            const SizedBox(height: 1),
            ElevatedButton(
              onPressed: _canResendEmail
                  ? () async {
                      showLoadingDialog(context); // Show Loading Dialog
                      await Future.delayed(
                          const Duration(seconds: 2)); // Simulate a task
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      _startResendCooldown(); // Start countdown timer

                      String result =
                          await AuthMethod().resendVerificationEmail();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result)),
                      );
                    }
                  : null, // Disable button during cooldown
              child: _canResendEmail
                  ? Text(tr(LocaleData.resendEmail)) // Normal text
                  // ignore: prefer_interpolation_to_compose_strings
                  : Text(tr(LocaleData.resendWait) +
                      " $_secondsRemaining s"), // Countdown timer
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tr(LocaleData.signup_alreadyDS)),
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
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    tr(LocaleData.login_signup_btt),
                    // ignore: prefer_const_constructors
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
