import 'package:flutter/material.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import 'package:font_change_md/optimization/converter_image.dart';
import 'package:font_change_md/optimization/fileupload_screen2.dart';
import 'package:font_change_md/optimization/language_converter.dart';
// import 'package:font_change_md/view/about_ai.dart';
import 'package:font_change_md/view/home/home_view.dart';

class AIChoose extends StatefulWidget {
  const AIChoose({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AIChooseState createState() => _AIChooseState();
}

class _AIChooseState extends State<AIChoose> {
  double _fabX = 300; // Initial X position
  double _fabY = 600; // Initial Y position

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
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB0926A), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Title
                Padding(
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    tr(LocaleData.toolsselection),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // ignore: prefer_const_constructors
                      color: Color(0xFF706134),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Instruction Text
                Padding(
                  // ignore: prefer_const_constructors
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    tr(LocaleData.aiinstruction),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // ignore: prefer_const_constructors
                      color: Color(0xFF706134),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 50),

                // Quiz Buttons
                buildQuizButton2(
                    tr(LocaleData.tool1), "TOOL", Icons.text_fields_outlined),
                buildQuizButton5(
                    tr(LocaleData.aibtt2), "TOOL", Icons.adf_scanner_outlined),
                buildQuizButton6(
                    tr(LocaleData.aibtt3), "TOOL", Icons.translate_outlined),
                // buildQuizButton3(tr(LocaleData.aiinfo), "", Icons.info,
                //     isIntro: true),
              ],
            ),
          ),

          // Draggable Floating Action Button
          Positioned(
            left: _fabX,
            top: _fabY,
            child: Draggable(
              feedback: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.home, color: Colors.blue, size: 30),
                onPressed: () {},
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  _fabX = details.offset.dx;
                  _fabY = details.offset.dy;
                });
              },
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.home, color: Colors.blue, size: 30),
                onPressed: () async {
                  showLoadingDialog(context);
                  await Future.delayed(const Duration(seconds: 2));
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => EcoFontConverterScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuizButton2(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            // ignore: unnecessary_const
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: Colors.orange, size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                    builder: (context) => const FontConverterScreen()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }

  // Widget buildQuizButton3(String text, String subtitle, IconData icon,
  //     {bool isIntro = false}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(30),
  //         boxShadow: const [
  //           // ignore: unnecessary_const
  //           const BoxShadow(
  //             color: Color(0xFFFAE7C9),
  //             blurRadius: 10,
  //             offset: Offset(4, 4),
  //           ),
  //         ],
  //       ),
  //       child: ListTile(
  //         leading: isIntro
  //             // ignore: prefer_const_constructors
  //             ? Icon(icon, color: Color(0xFF706134), size: 40)
  //             : Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(icon, color: Colors.black),
  //                   Text(subtitle, style: const TextStyle(fontSize: 10)),
  //                 ],
  //               ),
  //         title: Text(
  //           text,
  //           style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xFF706134)),
  //         ),
  //         onTap: () async {
  //           showLoadingDialog(context);
  //           await Future.delayed(const Duration(seconds: 2));
  //           // ignore: use_build_context_synchronously
  //           Navigator.pop(context);
  //           // ignore: use_build_context_synchronously
  //           Navigator.push(
  //               // ignore: use_build_context_synchronously
  //               context,
  //               // ignore: prefer_const_constructors
  //               MaterialPageRoute(builder: (context) => AboutAIScreen()));
  //           // Add navigation logic here
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget buildQuizButton5(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            // ignore: unnecessary_const
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: const Color(0xFF706134), size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                    builder: (context) => const FileConverterImageScreen()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }

  Widget buildQuizButton6(String text, String subtitle, IconData icon,
      {bool isIntro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            // ignore: unnecessary_const
            const BoxShadow(
              color: Color(0xFFFAE7C9),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: isIntro
              ? Icon(icon, color: const Color(0xFF706134), size: 40)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.black),
                    Text(subtitle, style: const TextStyle(fontSize: 10)),
                  ],
                ),
          title: Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF706134)),
          ),
          onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageConverterScreen()));
            // Add navigation logic here
          },
        ),
      ),
    );
  }
}
