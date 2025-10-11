import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_change_md/Login%20Signup/Screen/login.dart';
// import 'package:font_change_md/Gemini%20ChatBot/gemini_ai.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import 'package:font_change_md/view/about_screen.dart';
import 'package:font_change_md/view/accountprofile.dart';
import 'package:font_change_md/view/ai_choose.dart';
// ignore: unused_import
import 'package:font_change_md/view/checking_internet.dart';
// ignore: unused_import
import 'package:font_change_md/view/history_screen.dart';
// ignore: unused_import
import 'package:font_change_md/view/internet_provider.dart';
import 'package:font_change_md/view/settings_screen.dart';
// import 'package:font_change_md/view/theme_provider.dart';
// import 'package:font_change_md/view/theme_provider.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EcoFontConverterScreen extends StatefulWidget {
  const EcoFontConverterScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EcoFontConverterScreenState createState() => _EcoFontConverterScreenState();
}

class _EcoFontConverterScreenState extends State<EcoFontConverterScreen> {
  Color getContrastingTextColor(Color backgroundColor) {
    // Check if the background is dark
    double brightness = (backgroundColor.red * 0.299) +
        (backgroundColor.green * 0.587) +
        (backgroundColor.blue * 0.114);
    return brightness > 128 ? Colors.black : Colors.white;
  }

  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Color _fontColor = Colors.black;
  // ignore: prefer_final_fields
  Color _highlightColor = Colors.transparent;
  List<Widget> _navigationItem(BuildContext context) => [
        Icon(Icons.account_circle, color: Theme.of(context).iconTheme.color),
        Icon(Icons.info, color: Theme.of(context).iconTheme.color),
        Icon(Icons.rocket, color: Theme.of(context).iconTheme.color),
        Icon(Icons.history, color: Theme.of(context).iconTheme.color),
        Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
        Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
      ];
  final List<String> _fontList = [
    "Times New Roman",
    "Calibri",
    "Arial",
    "Serif",
    "Sans-serif",
    "Script"
  ];

  String _selectedFont = "Times New Roman";
  Color bgColor = Colors.blue;
  // ignore: prefer_final_fields
  TextEditingController _textController = TextEditingController();
  String _convertedText = "";
  List<String> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); //Load history when the screen is opened
    _textController.addListener(() {
      setState(() {
        _convertedText = _applyEcoFont(_textController.text);
        // _fontColor = getContrastingTextColor(bgColor);
      });
    });
  }

  void _resetText() async {
    setState(() async {
      _textController.clear();
      _convertedText = "";
      showLoadingDialog(context); // Show Loading Dialog
      await Future.delayed(const Duration(seconds: 2)); // Simulate a task
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      await _saveHistory(); // Save history when the text is reset
    });
    _triggerVibration("reset");
  }

  void _copyText() async {
    if (_convertedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _convertedText));
      _triggerVibration("copy");
      ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(content: Text("Copied to clipboard!")),
      );

      // ✅ Save to history
      await _addToHistory(_convertedText, _selectedFont);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(LocaleData.confirmlogout)),
        content: Text(tr(LocaleData.logoutDS)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(tr(LocaleData.cancel)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog first

              // 🎯 Gọi phương thức đăng xuất của Firebase
              await FirebaseAuth.instance.signOut();

              if (mounted) {
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            child:
                // ignore: prefer_const_constructors
                Text(tr(LocaleData.exit), style: TextStyle(color: Colors.red)),
          ),
        ],
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

  Future<void> _addToHistory(String text, String font) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];

    // Save text and font together in JSON format
    history.add(jsonEncode({'text': text, 'font': font}));

    await prefs.setStringList('history', history);
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("history", _historyList);
    // ignore: avoid_print
    print("History saved: $_historyList"); // Debugging output
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _historyList = prefs.getStringList("history") ?? [];
    });
    // ignore: avoid_print
    print("History loaded: $_historyList"); // Debugging output
  }

  void _triggerVibration(String action) async {
    if (await Vibration.hasVibrator()) {
      switch (action) {
        case "copy":
          Vibration.vibrate(pattern: [0, 100, 50, 100]);
          break;
        case "reset":
          Vibration.vibrate(pattern: [0, 300, 100, 400]);
          break;
      }
    }
  }

  String _applyEcoFont(String text) {
    String converted =
        text.replaceAll("o", "◎").replaceAll("e", "℮").replaceAll("a", "a");

    // ignore: avoid_print
    print("Converted Text: $converted"); // Debugging output

    if (converted.isNotEmpty && !_historyList.contains(converted)) {
      setState(() {
        _historyList.insert(0, converted);
        _saveHistory(); // Save history when a new conversion happens
      });
    }

    return converted;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    // List<String> _historyList = [];
    // return Consumer<InternetProvider>(
    // builder: (context, internetProvider, child) {
    // if (!internetProvider.isConnected) {
    //   //Future.microtask
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => CheckingInternet()),
    //     );
    //   });
    // }
    return Scaffold(
      appBar: AppBar(
        title:
            //     Text(
            //   tr(LocaleData.settings), // 👈 use helper
            //   style: Theme.of(context).textTheme.bodyLarge,
            // ),
            Text(
          tr(LocaleData.app_name),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ignore: prefer_const_constructors
            Text(
              "Preview Screen",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedFont,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFont = newValue!;
                });
              },
              items: _fontList.map<DropdownMenuItem<String>>((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font, style: TextStyle(fontFamily: font)),
                );
              }).toList(),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: tr(LocaleData.enter_text),
                border: const OutlineInputBorder(),
              ),
              maxLines: 5,
              style: TextStyle(
                fontFamily: _selectedFont,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: _isBold ? Colors.blue : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_italic,
                      color: _isItalic ? Colors.blue : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_underline,
                      color: _isUnderline ? Colors.blue : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isUnderline = !_isUnderline;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.color_lens, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Pick a text color"),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _fontColor,
                              onColorChanged: (color) {
                                setState(() {
                                  _fontColor = color;
                                });
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              tr(LocaleData.converted_text),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _convertedText.isNotEmpty
                    ? _convertedText
                    : tr(LocaleData.converted_text_description),
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: _selectedFont,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: _fontColor,
                  backgroundColor: _highlightColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Icons.copy, tr(LocaleData.copy), _copyText,
                    _convertedText.isNotEmpty),
                _buildActionButton(
                    Icons.refresh, tr(LocaleData.reset), _resetText, true),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: bgColor,
        items: _navigationItem(context),
        index: 2, // Set the current index
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) async {
          if (index == 0) {
            showLoadingDialog(context); // Show Loading Dialog
            await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close the loading dialog
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else if (index == 1) {
            showLoadingDialog(context); // Show Loading Dialog
            await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close the loading dialog
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          } else if (index == 2) {
            showLoadingDialog(context); // Show Loading Dialog
            await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close the loading dialog
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const AIChoose()),
            );
            // } else if (index == 3) {
            //   showLoadingDialog(context); // Show Loading Dialog
            //   await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            //   // ignore: use_build_context_synchronously
            //   Navigator.pop(context); // Close the loading dialog
            //   Navigator.push(
            //     // ignore: use_build_context_synchronously
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>
            //           const HistoryScreen(userId: '', apiBaseUrl: ''),
            //     ),
            //   );
          } else if (index == 3) {
            showLoadingDialog(context); // Show Loading Dialog
            await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close the loading dialog
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          } else if (index == 4) {
            showLoadingDialog(context); // Show Loading Dialog
            await Future.delayed(const Duration(seconds: 2)); // Simulate a task
            // ignore: use_build_context_synchronously
            Navigator.pop(context); // Close the loading dialog
            _showLogoutDialog();
          }
          setState(() {});
        },
      ),
    );
    // },
    // );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon,
                //Colors.blue : Colors.grey
                size: 30,
                color: isEnabled ? Colors.blue : Colors.grey),
            onPressed: isEnabled ? onPressed : null,
          ),
          Text(
            label,
            //Colors.black : Colors.grey
            style: TextStyle(
              color: isEnabled
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
