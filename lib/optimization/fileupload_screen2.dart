import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/optimization/font_partial_screen.dart';
import 'package:ecolive/view/history_font_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecolive/view/font_tutorial_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';

class FontConverterScreen extends StatefulWidget {
  const FontConverterScreen({Key? key}) : super(key: key);

  @override
  State<FontConverterScreen> createState() => _FontConverterScreenState();
}

class _FontConverterScreenState extends State<FontConverterScreen> {
  final List<String> fonts = [
    "Times New Roman",
    "Calibri",
    "Arial",
    "Serif",
    "Sans-serif",
    "Script",
  ];

  String selectedFont = "Arial";
  String? pickedFilePath;
  String? s3FileUrl;
  bool loading = false;
  String? resultUrl;

  final dio = Dio(BaseOptions(
    baseUrl: "https://ecolive-font-converter-docker.onrender.com",
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeFontConvert') ?? true;
    if (isFirstTime) {
      _showFontTutorial();
      await prefs.setBool('isFirstTimeFontConvert', false);
    }
  }

  void _showFontTutorial() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return FontTutorialOverlay(
          onClose: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  // 🟢 HÀM GỘP: Chỉ cần gọi hàm này là mở File Picker
  Future<void> pickFile() async {
    if (loading) return;

    try {
      // Gọi trình chọn file hệ thống
      // Người dùng có thể chọn Google Drive/iCloud ngay trong giao diện này
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'pdf', 'txt'],
        // Không cần withData: true vì FilePicker trên mobile tự cache file ra path
      );

      if (res == null) {
        // Người dùng hủy chọn
        return;
      }

      final path = res.files.single.path;

      if (path == null) {
        _showSnack(tr(LocaleData.font_error_file));
        return;
      }

      final file = File(path);

      setState(() {
        pickedFilePath = path;
        resultUrl = null; // Reset kết quả cũ
      });

      // Có file rồi -> Hỏi phương thức chuyển đổi ngay
      await _showConversionMethodDialog(file);
    } catch (e) {
      debugPrint("🔥 Lỗi chọn file: $e");
      _showSnack("Lỗi chọn file: $e");
    }
  }

  // ... (Giữ nguyên phần Dialog chọn phương thức) ...
  Future<void> _showConversionMethodDialog(File file) async {
    String? mode = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(tr(LocaleData.file_choose_method)),
        content: Text(tr(LocaleData.file_ask)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, "full"),
            child: Text(tr(LocaleData.file_all)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, "partial"),
            child: Text(tr(LocaleData.file_seperate)),
          ),
        ],
      ),
    );

    if (mode == null) return;

    if (mode == "full") {
      await _convertFullMode(file);
    } else {
      await _handlePartialFlow(file);
    }
  }

  // ... (Giữ nguyên các hàm logic upload/convert bên dưới không đổi) ...

  Future<void> _convertFullMode(File file) async {
    setState(() => loading = true);
    try {
      String fileName = file.path.split('/').last;
      final user = FirebaseAuth.instance.currentUser;

      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'target_font': selectedFont,
        'user_id': user?.uid ?? "anon",
      });

      var response = await dio.post("/convert-font-all", data: formData);

      if (response.statusCode == 200) {
        String url = response.data['result_url'];
        setState(() => resultUrl = url);
        // ignore: prefer_interpolation_to_compose_strings
        _showSnack(tr(LocaleData.font_converted) +
            " $selectedFont. " +
            tr(LocaleData.font_link_below));
      } else {
        _showSnack("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      _showSnack("Lỗi convert full: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // Trong _handlePartialFlow
  Future<void> _handlePartialFlow(File file) async {
    setState(() => loading = true);
    try {
      // 1. Upload
      String? s3Url = await _uploadToS3(file.path);
      if (s3Url == null) return;

      // 2. Detect Font
      final response = await dio.post(
        "/detect-fonts",
        data: {"file_url": s3Url},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Lấy danh sách đoạn văn (kèm font) từ Server
        final List<dynamic> rawParagraphs = data['paragraphs'] ?? [];
        final List<Map<String, dynamic>> paragraphs =
            rawParagraphs.map((e) => Map<String, dynamic>.from(e)).toList();

        if (paragraphs.isEmpty) {
          _showSnack(tr(LocaleData.font_no_text));
          return;
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FontPartialScreen(
                paragraphs: paragraphs, // 👈 Dữ liệu quan trọng nhất
                originalFilePath: file.path,
                userId: FirebaseAuth.instance.currentUser?.uid ?? "anon",
                backendBaseUrl: dio.options.baseUrl,
                // Dòng dưới đây không còn quan trọng, vì ta sẽ lấy font từ paragraphs
                selectedFont: "Arial",
              ),
            ),
          );
        }
      } else {
        _showSnack("Lỗi phân tích file: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🔥 Lỗi partial: $e");
      _showSnack("Lỗi xử lý từng đoạn: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<String?> _uploadToS3(String path) async {
    try {
      final fileName = path.split('/').last;
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename: fileName),
      });
      final response = await dio.post("/upload-to-s3", data: formData);
      return response.data["url"];
    } catch (e) {
      _showSnack("Lỗi upload file: $e");
      return null;
    }
  }

  void _showSnack(String s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  Future<void> downloadFile() async {
    if (resultUrl == null) {
      _showSnack(tr(LocaleData.nofiledownload));
      return;
    }

    setState(() => loading = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final extension = resultUrl!.split('.').last;
      final fileName =
          "converted_${DateTime.now().millisecondsSinceEpoch}.$extension";
      final savePath = "${tempDir.path}/$fileName";

      debugPrint("⬇️ Đang tải về: $savePath");

      await dio.download(resultUrl!, savePath);

      setState(() => loading = false);

      final result = await OpenFilex.open(savePath);

      if (result.type != ResultType.done) {
        // ignore: prefer_interpolation_to_compose_strings
        _showSnack(tr(LocaleData.font_cannot_open) +
            " ${result.message}. " +
            tr(LocaleData.font_install));
      }
    } catch (e) {
      debugPrint("🔥 Lỗi download: $e");
      setState(() => loading = false);
      _showSnack("Lỗi tải file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(LocaleData.font_converter_title)),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: tr(LocaleData.font_instruction),
              onPressed: _showFontTutorial,
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: tr(LocaleData.font_history),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  _showSnack("⚠️ Bạn cần đăng nhập để xem lịch sử!");
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FontHistoryScreen(
                      userId: user.uid,
                      apiBaseUrl: dio.options.baseUrl,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Upload Button (GỘP CHUNG)
                GestureDetector(
                  onTap: loading ? null : pickFile, // Gọi thẳng hàm pickFile
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8)
                      ],
                    ),
                    child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.cloud_upload_outlined, size: 36),
                        const SizedBox(height: 6),
                        // Text hiển thị rõ ràng hơn
                        Text(tr(LocaleData.uploadfile)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Dropdown (Chỉ có tác dụng khi chọn 'Toàn bộ')
                Row(children: [
                  Text(tr(LocaleData.new_font)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedFont,
                      items: fonts
                          .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: loading
                          ? null
                          : (v) => setState(() => selectedFont = v!),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ]),

                const SizedBox(height: 24),

                // 3. Info & Loading
                if (pickedFilePath != null)
                  Text("File: ${pickedFilePath!.split('/').last}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                if (loading)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(tr(LocaleData.file_processing)),
                        ],
                      )),

                // 4. Result Box
                const SizedBox(height: 24),
                Text(tr(LocaleData.result_converted),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          resultUrl != null
                              ? Icons.check_circle
                              : Icons.description_outlined,
                          size: 36,
                          color: resultUrl != null ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            resultUrl != null
                                // ignore: prefer_interpolation_to_compose_strings
                                ? tr(LocaleData.font_done) +
                                    "\n(${resultUrl!.split('/').last})"
                                : tr(LocaleData.fileconverted),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 5. Download Button
                InkWell(
                  onTap: (loading || resultUrl == null) ? null : downloadFile,
                  borderRadius: BorderRadius.circular(50),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (resultUrl != null && !loading)
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                        child: const Icon(Icons.download,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 4),
                      Text(tr(LocaleData.downloadbtt),
                          style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
