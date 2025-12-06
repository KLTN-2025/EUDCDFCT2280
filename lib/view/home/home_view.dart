// import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecolive/Login%20With%20Google/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecolive/Login%20Signup/Screen/login.dart';
// import 'package:ecolive/Gemini%20ChatBot/gemini_ai.dart';
import 'package:ecolive/loading/loading.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/view/about_screen.dart';
import 'package:ecolive/view/accountprofile.dart';
import 'package:ecolive/view/ai_choose.dart';
// ignore: unused_import
import 'package:ecolive/view/checking_internet.dart';
// ignore: unused_import
import 'package:ecolive/view/history_screen.dart';
// ignore: unused_import
import 'package:ecolive/view/internet_provider.dart';
import 'package:ecolive/view/language_provider.dart';
import 'package:ecolive/view/settings_screen.dart';
// import 'package:ecolive/view/theme_provider.dart';
// import 'package:ecolive/view/theme_provider.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcoFontConverterScreen extends StatefulWidget {
  const EcoFontConverterScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EcoFontConverterScreenState createState() => _EcoFontConverterScreenState();
}

class _EcoFontConverterScreenState extends State<EcoFontConverterScreen> {
  final GlobalKey _fontDropdownKey = GlobalKey();
  final GlobalKey _inputFieldKey = GlobalKey();
  final GlobalKey _formatBarKey = GlobalKey();
  final GlobalKey _resultContainerKey = GlobalKey();
  final GlobalKey _actionButtonsKey = GlobalKey();
  final GlobalKey _navBarKey = GlobalKey(); // Key cho thanh điều hướng
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      debugPrint("Input: ${_textController.text}");
      setState(() {
        _convertedText = _applyEcoFont(_textController.text);
      });
    });

    // 3. Kiểm tra và hiển thị hướng dẫn sau khi màn hình được vẽ xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  // 4. Hàm kiểm tra (Đã cập nhật Logic xem lại từ Settings)
  Future<void> _checkAndShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Lấy cờ chính (Mặc định true nếu chưa có)
    bool isFirstTime = prefs.getBool('isFirstTimeTutorial') ?? true;

    // 3. Nếu (Lần đầu) HOẶC (Bị ép buộc)
    if (isFirstTime) {
      await prefs.setBool('isFirstTimeTutorial', false);

      // Đợi 1 chút cho UI ổn định rồi mới hiện
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 500));

      _showTutorial();
    }
  }

  // 5. Cấu hình Tutorial
  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      // textSkip: "Bỏ qua",
      hideSkip: true,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        // ignore: avoid_print
        print("Kết thúc hướng dẫn");
        // _markTutorialAsSeen();
      },
      onClickTarget: (target) {
        // ignore: avoid_print
        print('Click vào target: $target');
      },
      onSkip: () {
        // ignore: avoid_print
        print("Người dùng bấm bỏ qua");
        // _markTutorialAsSeen();
        return true;
      },
    );

    tutorialCoachMark.show(context: context);
  }

  // Future<void> _markTutorialAsSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isFirstTimeTutorial', true);
  // }

  // 6. Tạo nội dung hướng dẫn (Đã Fix lỗi hiển thị chữ)
  // 6. Tạo nội dung hướng dẫn (Chuẩn 5 Icon Navigation)
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // --- TARGET 1, 2, 3 GIỮ NGUYÊN ---

    // 1. Chọn Font
    targets.add(TargetFocus(
      identify: "fontKey",
      keyTarget: _fontDropdownKey,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(tr(LocaleData.home_tutorial1),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(tr(LocaleData.home_quote1),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    // 2. Nhập văn bản
    targets.add(TargetFocus(
      identify: "inputKey",
      keyTarget: _inputFieldKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(tr(LocaleData.home_tutorial2),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(tr(LocaleData.home_quote2),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    //3. Tùy chỉnh
    targets.add(TargetFocus(
      identify: "formatKey",
      keyTarget: _formatBarKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.bottom, // Hiển thị chữ ở dưới thanh công cụ
          builder: (context, controller) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Canh giữa cho đẹp
                children: <Widget>[
                  Text(
                    tr(LocaleData
                        .home_tutorial3), // Đẩy số thứ tự các bước sau lên (3 -> 4, 4 -> 5...)
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      tr(LocaleData.home_quote3),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    //4. Đã chuyển đổi
    targets.add(TargetFocus(
      identify: "resultKey",
      keyTarget: _resultContainerKey,
      shape: ShapeLightFocus.RRect,
      radius: 10,
      contents: [
        TargetContent(
          align: ContentAlign.top, // Chữ nằm trên vì khung này ở thấp
          builder: (context, controller) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(tr(LocaleData.home_tutorial4), // Bước 4 mới
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(tr(LocaleData.home_quote4),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    // 5. Nút chức năng
    targets.add(TargetFocus(
      identify: "actionKey",
      keyTarget: _actionButtonsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(tr(LocaleData.home_tutorial5),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(tr(LocaleData.home_quote5),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ));

    //Target 4: Thanh dieu huong
    targets.add(TargetFocus(
        identify: "navKey",
        keyTarget: _navBarKey,
        alignSkip: Alignment.topRight,

        // 👇 1. THAY ĐỔI HÌNH DÁNG: Chuyển sang hình chữ nhật bo góc
        shape: ShapeLightFocus.RRect,
        // Bo góc khoảng 25-30 để phù hợp với độ cong của thanh điều hướng
        radius: 25,
        contents: [
          TargetContent(
              // 👇 2. VỊ TRÍ: align top là CHÍNH XÁC để đặt chữ nằm TRÊN khung sáng
              align: ContentAlign.top,
              builder: (context, controller) {
                return Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // Thêm canh giữa để văn bản đẹp hơn khi ở trên cao
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // 👇 3. CẬP NHẬT TIÊU ĐỀ MỚI
                        tr(LocaleData.home_tutorial6),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                      Padding(
                        // Padding để tách tiêu đề và mô tả ra một chút
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          // 👇 4. CẬP NHẬT MÔ TẢ MỚI
                          tr(LocaleData.home_quote6),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center, // Canh giữa đoạn văn
                        ),
                      ),
                    ],
                  ),
                );
              })
        ]));

    // --- TÍNH TOÁN VỊ TRÍ 5 ICON ---
    final screenSize = MediaQuery.of(context).size;
    final double iconWidth = screenSize.width / 5;
    // ⚠️ Lưu ý: Nếu icon giữa (Rocket) đang được chọn (index 2), nó sẽ nổi lên cao hơn.
    // Ta tính toán vị trí trung bình cho các icon nằm dưới bar.
    // ignore: prefer_const_declarations
    final double navBarHeight = 75.0;
    final double yPositionBottom =
        screenSize.height - (navBarHeight / 2) - 15; // Vị trí icon thường
    final double yPositionFloating =
        screenSize.height - navBarHeight - 15; // Vị trí icon nổi (Rocket)

    // Hàm helper tạo Target
    // ignore: no_leading_underscores_for_local_identifiers
    TargetFocus _createNavTarget({
      required String id,
      required String title,
      required String desc,
      required int index,
      bool isFloating = false, // Check xem có phải nút giữa đang nổi không
    }) {
      return TargetFocus(
        identify: id,
        targetPosition: TargetPosition(
          const Size(50, 50), // Kích thước vùng sáng
          Offset(
              (iconWidth * index) +
                  (iconWidth / 2) -
                  25, // X: Canh giữa từng phần 1/5
              isFloating
                  ? yPositionFloating
                  : yPositionBottom // Y: Tùy thuộc icon nổi hay chìm
              ),
        ),
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(desc,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    }

    // 4. Profile (Index 0)
    targets.add(_createNavTarget(
        id: "navProfile",
        title: tr(LocaleData.home_tutorial7),
        desc: tr(LocaleData.home_quote7),
        index: 0));

    // 5. About (Index 1)
    targets.add(_createNavTarget(
        id: "navAbout",
        title: tr(LocaleData.home_tutorial8),
        desc: tr(LocaleData.home_quote8),
        index: 1));

    // 6. AI Tool (Index 2 - Đang được chọn nên nổi lên)
    targets.add(_createNavTarget(
        id: "navAI",
        title: tr(LocaleData.home_tutorial9),
        desc: tr(LocaleData.home_quote9),
        index: 2,
        isFloating:
            true // 👈 Quan trọng: Vì nút này đang được chọn (index: 2 ở build)
        ));

    // 7. Settings (Index 3)
    targets.add(_createNavTarget(
        id: "navSettings",
        title: tr(LocaleData.home_tutorial10),
        desc: tr(LocaleData.home_quote10),
        index: 3));

    // 8. Logout (Index 4)
    targets.add(_createNavTarget(
        id: "navLogout",
        title: tr(LocaleData.home_tutorial11),
        desc: tr(LocaleData.home_quote11),
        index: 4));

    return targets;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    _fontColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  Color getNavIconColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

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
  // ignore: prefer_final_fields, unused_field
  Color _highlightColor = Colors.transparent;

  List<Widget> _navigationItem(BuildContext context) {
    final iconColor = getNavIconColor(context);

    return [
      Icon(Icons.account_circle, color: iconColor),
      Icon(Icons.info, color: iconColor),
      Icon(Icons.rocket, color: iconColor),
      Icon(Icons.settings, color: iconColor),
      Icon(Icons.logout, color: iconColor),
    ];
  }

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
  final TextEditingController _textController = TextEditingController();
  String _convertedText = "";
  // List<String> _historyList = [];

  void _resetText() async {
    setState(() {
      _textController.clear();
      _convertedText = "";
    });

    showLoadingDialog(context);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);

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

      // // ✅ Save to history
      // await _addToHistory(_convertedText, _selectedFont);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr(LocaleData.confirmlogout)),
        content: Text(tr(LocaleData.logoutDS)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                  dialogContext); // Đóng dialog bằng context của dialog
            },
            child: Text(tr(LocaleData.cancel)),
          ),
          TextButton(
            onPressed: () async {
              // 1. Đóng hộp thoại xác nhận NGAY LẬP TỨC
              Navigator.pop(dialogContext);

              // 2. Hiện Loading Dialog (Dùng context của màn hình cha)
              showLoadingDialog(context);

              // 3. Thực hiện đăng xuất (Chờ cho xong)
              await FirebaseServices().googleSignOut();

              // 4. CHỐT CHẶN AN TOÀN: Kiểm tra xem màn hình còn "sống" không
              if (!mounted) return;

              // 5. Đóng Loading Dialog
              // Dùng rootNavigator: true để chắc chắn đóng đúng cái Dialog đang đè lên trên cùng
              Navigator.of(context, rootNavigator: true).pop();

              // 6. Chuyển về màn hình Login và XÓA SẠCH lịch sử cũ
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Xóa hết các route trước đó
                );
              }
            },
            child: Text(tr(LocaleData.exit),
                style: const TextStyle(color: Colors.red)),
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

  /// Hàm chuyển đổi chữ demo
  String _applyEcoFont(String text) {
    if (text.isEmpty) return "";
    // Chuyển vài ký tự để bạn thấy có hiệu ứng
    return text.replaceAll("o", "o").replaceAll("e", "e").replaceAll("a", "a");
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(LocaleData.app_name),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        actions: [
          // 🟢 NÚT XEM LẠI TUTORIAL (HOME)
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: "Hướng dẫn sử dụng",
            onPressed: () {
              // Gọi trực tiếp hàm hiện hướng dẫn, không cần check SharedPreferences
              _showTutorial();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr(LocaleData.previewscreen),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            // 7. GẮN KEY VÀO WIDGET: Dropdown
            Container(
              key: _fontDropdownKey, // <--- Gắn key
              child: DropdownButton<String>(
                value: _selectedFont,
                isExpanded: true, // Thêm cái này cho đẹp layout
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
            ),

            Container(
              key: _inputFieldKey, // <--- Gắn key
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: tr(LocaleData.enter_text),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
                style: TextStyle(
                  color: _fontColor,
                  fontFamily: _selectedFont,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),

            Row(
              key: _formatBarKey,
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
                          title: Text(tr(LocaleData.pickatextcolor)),
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
              key: _resultContainerKey,
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
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              key: _actionButtonsKey, // <--- Gắn key
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
        key: _navBarKey, // <--- Gắn key
        backgroundColor: Colors.blueAccent,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black // 🌙 Dark => black bar
            : Colors.white,
        buttonBackgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
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
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
