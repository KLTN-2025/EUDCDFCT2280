// // import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
// // ignore: unnecessary_import
// import 'dart:ui';
// import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// // import 'package:flutter_localization/flutter_localization.dart';
// import 'package:font_change_md/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:font_change_md/localization/locales.dart';
// import 'package:font_change_md/localization/translator.dart';
// // import 'package:font_change_md/localization/locales.dart';
// import 'package:font_change_md/messaging/firebase_msg.dart';
// import 'package:font_change_md/view/checking_internet.dart';
// import 'package:font_change_md/view/home/home_view.dart';
// import 'package:font_change_md/view/internet_provider.dart';
// import 'package:font_change_md/view/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:font_change_md/Login%20Signup/Screen/login.dart';
// import 'package:font_change_md/screens/screen1.dart';
// import 'package:font_change_md/screens/screen2.dart';
// import 'package:font_change_md/screens/screen3.dart';
// import 'package:font_change_md/screens/screen4.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ignore: unused_import
// import 'view/language_picker.dart';

// final FlutterLocalization localization = FlutterLocalization.instance;

// // import 'view/theme_provider.dart';

// Future<Widget> _determineStartPage() async {
//   final prefs = await SharedPreferences.getInstance();

//   // ignore: unused_local_variable
//   final saved = prefs.getString('app_lang');

//   // 1. Kiểm tra trạng thái Onboarding
//   final didCompleteOnboarding = prefs.getBool('didCompleteOnboarding') ?? false;

//   // 2. Kiểm tra trạng thái đăng nhập
//   final isAuthenticated = FirebaseAuth.instance.currentUser != null;

//   if (didCompleteOnboarding) {
//     // Nếu đã xem Onboarding, kiểm tra tiếp trạng thái đăng nhập
//     if (isAuthenticated) {
//       // Đã đăng nhập, chuyển thẳng đến màn hình chính
//       return const EcoFontConverterScreen();
//     } else {
//       // Chưa đăng nhập, chuyển đến màn hình đăng nhập
//       return const LoginScreen();
//     }
//   } else {
//     // Nếu chưa xem Onboarding, luôn chuyển đến màn hình Onboarding đầu tiên
//     return const MyHomePage();
//   }
// }

// // Future<Widget> _determineStartPage() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   // ignore: unused_local_variable
// //   final saved = prefs.getString('app_lang');

// //   // if (saved == null) {
// //   //   // no language chosen yet
// //   //   return const LanguagePicker();
// //   // }

// //   // language exists → set it and continue
// //   // localization.translate(saved);
// //   return const SplashScreen()
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseAppCheck.instance.activate(
//     // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
//     // argument for `webProvider`
//     webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
//     // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
//     // your preferred provider. Choose from:
//     // 1. Debug provider
//     // 2. Safety Net provider
//     // 3. Play Integrity provider
//     androidProvider: AndroidProvider.playIntegrity,
//     // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
//     // your preferred provider. Choose from:
//     // 1. Debug provider
//     // 2. Device Check provider
//     // 3. App Attest provider
//     // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
//     appleProvider: AppleProvider.appAttest,
//   );

//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   await localization.ensureInitialized();

//   // Initialize localization
//   localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
//   localization.onTranslatedLanguage = (Locale? locale) {
//     // You can use setState in Stateful widgets to trigger UI updates if needed.
//   };

//   final startPage = await _determineStartPage();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => InternetProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider())
//       ],
//       child: MyApp(startPage),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final Widget firstPage;
//   const MyApp(this.firstPage, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       themeMode: themeProvider.themeMode,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.black),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: Colors.black,
//         scaffoldBackgroundColor: Colors.black,
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(
//             color: Colors.green,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),

//       // 👇 Quan trọng: thêm delegates + locales
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en'), // tiếng Anh
//         Locale('vi'), // tiếng Việt
//       ],

//       debugShowCheckedModeBanner: false,
//       home: AppEntry(firstPage),
//     );
//   }
// }

// // Thêm class AppEntry mới này
// class AppEntry extends StatelessWidget {
//   final Widget firstPage;

//   const AppEntry(this.firstPage, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InternetProvider>(
//       builder: (context, internetProvider, child) {
//         if (!internetProvider.isConnected) {
//           return CheckingInternet();
//         } else {
//           return firstPage;
//         }
//       },
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Future<void> initState() async {
//     super.initState();
//     await FirebaseMsg().initFCM();
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         // ignore: use_build_context_synchronously
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Color.fromARGB(255, 246, 245, 245),
//       body: Center(
//         child: Text(
//           'Écolive',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   PageController pageController = PageController();
//   String buttonText = tr(LocaleData.skip);
//   int currentPageIndex = 0;

//   // Thêm hàm này để lưu trạng thái
//   void _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('didCompleteOnboarding', true);

//     // Sau khi lưu, điều hướng đến màn hình đăng nhập
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InternetProvider>(
//       builder: (context, internetProvider, child) {
//         if (!internetProvider.isConnected) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CheckingInternet()),
//             );
//           });
//         }
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: Stack(
//             children: [
//               PageView(
//                 controller: pageController,
//                 onPageChanged: (index) {
//                   currentPageIndex = index;
//                   if (index == 3) {
//                     setState(() {
//                       buttonText = tr(LocaleData.finish);
//                     });
//                   } else {
//                     setState(() {
//                       buttonText = tr(LocaleData.skip);
//                     });
//                   }
//                   setState(() {});
//                 },
//                 children: const [
//                   Screen1(),
//                   Screen2(),
//                   Screen3(),
//                   Screen4(),
//                 ],
//               ),
//               Container(
//                 alignment: const Alignment(0, 0.8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         // Gọi hàm mới ở đây
//                         _completeOnboarding();
//                       },
//                       child: Text(buttonText),
//                     ),
//                     SmoothPageIndicator(controller: pageController, count: 4),
//                     currentPageIndex == 3
//                         ? const SizedBox(
//                             width: 10,
//                           )
//                         : GestureDetector(
//                             onTap: () {
//                               pageController.nextPage(
//                                   duration: const Duration(milliseconds: 500),
//                                   curve: Curves.easeIn);
//                             },
//                             child: Text(tr(LocaleData.next))),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
// ignore: unnecessary_import
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:font_change_md/firebase_options.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import 'package:font_change_md/messaging/firebase_msg.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:font_change_md/view/theme_provider.dart';
import 'package:font_change_md/Login%20Signup/Screen/login.dart';
import 'package:font_change_md/view/home/home_view.dart';
import 'package:font_change_md/screens/screen1.dart';
import 'package:font_change_md/screens/screen2.dart';
import 'package:font_change_md/screens/screen3.dart';
import 'package:font_change_md/screens/screen4.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
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
  Future<void> initState() async {
    super.initState();
    await FirebaseMsg().initFCM();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
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
  String buttonText = tr(LocaleData.skip);
  int currentPageIndex = 0;

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
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
