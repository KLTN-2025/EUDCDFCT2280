// ignore: unnecessary_import
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:ecolive/view/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ecolive/firebase_options.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/messaging/firebase_msg.dart';
import 'package:ecolive/view/checking_internet.dart';
import 'package:ecolive/view/internet_provider.dart';
import 'package:ecolive/view/theme_provider.dart';
import 'package:ecolive/Login%20Signup/Screen/login.dart';
import 'package:ecolive/view/home/home_view.dart';
import 'package:ecolive/screens/screen1.dart';
import 'package:ecolive/screens/screen2.dart';
import 'package:ecolive/screens/screen3.dart';
import 'package:ecolive/screens/screen4.dart';

final FlutterLocalization localization = FlutterLocalization.instance;

/// Xác định màn hình khởi động đầu tiên
Future<Widget> _determineStartPage() async {
  final prefs = await SharedPreferences.getInstance();
  final didCompleteOnboarding = prefs.getBool('didCompleteOnboarding') ?? false;
  final isAuthenticated = FirebaseAuth.instance.currentUser != null;

  if (didCompleteOnboarding) {
    return isAuthenticated
        ? const EcoFontConverterScreen()
        : const LoginScreen();
  } else {
    return const MyHomePage();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (const bool.fromEnvironment('dart.vm.product')) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Kích hoạt App Check để bảo mật
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  // Khởi tạo Localization
  await localization.ensureInitialized();
  localization.init(mapLocales: LOCALES, initLanguageCode: 'en');

  final startPage = await _determineStartPage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(startPage),
    ),
  );
}

/// Ứng dụng chính
class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp(this.firstPage, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.currentLocale,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Hỗ trợ đa ngôn ngữ
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: [
        ...localization.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AppEntry(firstPage),
    );
  }
}

/// Lớp bao bọc kiểm tra Internet
class AppEntry extends StatelessWidget {
  final Widget firstPage;
  const AppEntry(this.firstPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          return CheckingInternet();
        } else {
          return firstPage;
        }
      },
    );
  }
}

/// Màn hình Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMsg().initFCM();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 245, 245),
      body: Center(
        child: Text(
          'Écolive',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Màn hình Onboarding
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  // ✅ SỬA LỖI: Khởi tạo là chuỗi rỗng
  String buttonText = "";
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // ✅ Di chuyển logic khởi tạo vào đây.
    // Lúc này, `tr()` đã an toàn để gọi.
    buttonText = tr(LocaleData.skip);
    // Ngay khi Onboarding hiện lên, Popup xin quyền sẽ xuất hiện
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseMsg().requestPermission();
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('didCompleteOnboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckingInternet()),
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                    buttonText = (index == 3)
                        ? tr(LocaleData.finish)
                        : tr(LocaleData.skip);
                  });
                },
                children: const [
                  Screen1(),
                  Screen2(),
                  Screen3(),
                  Screen4(),
                ],
              ),
              Align(
                alignment: const Alignment(0, 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _completeOnboarding,
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SmoothPageIndicator(controller: pageController, count: 4),
                    currentPageIndex == 3
                        ? const SizedBox(width: 10)
                        : GestureDetector(
                            onTap: () {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            child: Text(
                              tr(LocaleData.next),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
