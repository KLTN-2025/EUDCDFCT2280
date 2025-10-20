import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_change_md/view/translate_history_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class LanguageConverterScreen extends StatefulWidget {
  const LanguageConverterScreen({super.key});

  @override
  State<LanguageConverterScreen> createState() =>
      _LanguageConverterScreenState();
}

class _LanguageConverterScreenState extends State<LanguageConverterScreen> {
  String? _uploadedFileName;
  String _selectedLanguage = 'Korean';
  String _outputStatusText = 'Nội dung file đã chuyển đổi nằm ở đây';
  String? _downloadUrl;
  bool _isLoading = false;

  // 🔗 Backend URL của bạn (chú ý đổi thành IP thực tế)
  final String backendBaseUrl = "https://ecolive-font-converter.onrender.com";
  final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous_user";

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
      );
      if (result == null) return;

      File file = File(result.files.single.path!);
      setState(() {
        _uploadedFileName = result.files.single.name;
        _outputStatusText = "🔍 Đang phát hiện ngôn ngữ...";
        _isLoading = true;
        _downloadUrl = null; // 👈 thêm dòng này
      });

      // 1️⃣ Gửi file phát hiện ngôn ngữ
      var detectReq = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/detect-language'),
      );
      detectReq.files.add(await http.MultipartFile.fromPath('file', file.path));

      var detectResp = await detectReq.send();
      var detectBody = await detectResp.stream.bytesToString();

      if (detectResp.statusCode != 200) {
        setState(() {
          _outputStatusText =
              "❌ Lỗi khi phát hiện ngôn ngữ (${detectResp.statusCode})";
          _isLoading = false;
        });
        return;
      }

      var detectData = json.decode(detectBody);
      String detectedLang = detectData['detected_lang'] ?? "unknown";

      setState(() {
        _outputStatusText =
            "🌐 Phát hiện: ${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()}\n⏳ Đang dịch...";
      });

      // 2️⃣ Gửi file dịch
      var translateReq = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/translate-doc'),
      );
      translateReq.files
          .add(await http.MultipartFile.fromPath('file', file.path));
      // translateReq.fields['target_lang'] = _selectedLanguage.toLowerCase();
      String targetLang = _selectedLanguage.toLowerCase();
      if (targetLang.contains('simplified')) {
        targetLang = 'chinese'; // zh-CN
      } else if (targetLang.contains('traditional')) {
        targetLang = 'chinese_traditional'; // zh-TW
      }

      translateReq.fields['target_lang'] = targetLang;

      var transResp = await translateReq.send();
      var transBody = await transResp.stream.bytesToString();

      if (transResp.statusCode == 200) {
        var jsonResponse = json.decode(transBody);

        _downloadUrl = jsonResponse['download_url'] ??
            jsonResponse['result_url'] ??
            jsonResponse['resultUrl'] ??
            jsonResponse['url'];

        setState(() {}); // 👈 đảm bảo Flutter rebuild để nút tải sáng ngay

        // 🔹 Thêm đoạn kiểm tra này
        if (jsonResponse['status'] == 'success' && _downloadUrl != null) {
          setState(() {
            _outputStatusText =
                "✅ Dịch thành công! (${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()})";
          });
        } else {
          setState(() {
            _outputStatusText = "❌ Lỗi khi dịch file!";
          });
        }

        // ignore: avoid_print
        print("✅ Đã nhận URL tải về: $_downloadUrl");
      } else {
        setState(() {
          _outputStatusText =
              "❌ Lỗi khi dịch (${transResp.statusCode})\nTừ ${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()}";
        });
      }
    } catch (e) {
      setState(() {
        _outputStatusText = "⚠️ Lỗi: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadFile() async {
    if (_downloadUrl == null) return;

    try {
      setState(() => _isLoading = true);

      // 📱 Yêu cầu quyền lưu trữ
      var status = await Permission.manageExternalStorage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Không có quyền truy cập bộ nhớ!")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // 📂 Tạo thư mục riêng trong bộ nhớ ngoài
      Directory? dir = await getExternalStorageDirectory();
      String appFolder = '${dir!.path}/Ecolive_Translated';
      await Directory(appFolder).create(recursive: true);

      // 📄 Đặt tên file đầu ra
      String fileName = _uploadedFileName != null
          // ignore: prefer_interpolation_to_compose_strings
          ? _uploadedFileName!.split('.').first + '_translated.docx'
          : 'translated_file.docx';
      String savePath = '$appFolder/$fileName';

      // ignore: avoid_print
      print("📥 Lưu file tại: $savePath");

      // 🔁 Thử tải 3 lần (tránh lỗi file chưa sẵn sàng từ backend)
      for (int i = 0; i < 3; i++) {
        try {
          await Dio().download(
            _downloadUrl!,
            savePath,
            onReceiveProgress: (rec, total) {
              if (total != -1) {
                // ignore: avoid_print
                print("⬇️ ${(rec / total * 100).toStringAsFixed(0)}%");
              }
            },
          );
          break; // ✅ tải thành công thì thoát
        } catch (e) {
          if (i == 2) rethrow; // thử 3 lần rồi mới báo lỗi
          // ignore: avoid_print
          print("⚠️ File chưa sẵn sàng, thử lại sau 2s...");
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      setState(() => _isLoading = false);

      // ✅ Thông báo thành công
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ File đã tải về: $savePath")),
      );

      // 📂 Mở file ngay sau khi tải
      await OpenFilex.open(savePath);
    } catch (e) {
      setState(() => _isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi khi tải file: $e")),
      );
    }
  }

  void _showFullText() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Trạng thái chuyển đổi"),
        content: SingleChildScrollView(
          child: Text(
            _outputStatusText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          // 🔒 Khi đang chuyển đổi → chặn thoát và hiện cảnh báo
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Không thể thoát"),
              content: const Text(
                "Đang trong quá trình chuyển đổi. Vui lòng chờ hoàn tất trước khi quay lại.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return false; // ❌ Không cho phép thoát
        }
        return true; // ✅ Cho phép thoát khi không còn chuyển đổi
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LANGUAGE TO LANGUAGE'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: "Xem lịch sử chuyển đổi",
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("⚠️ Bạn cần đăng nhập để xem lịch sử!")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TranslateHistoryScreen(
                      userId: user.uid, // ✅ user id thật
                      apiBaseUrl: "https://ecolive-font-converter.onrender.com",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickAndUploadFile,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('UPLOAD FILE',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
              ),
              if (_uploadedFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "📄 File đã chọn: $_uploadedFileName",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              // Ẩn dropdown trong khi đang xử lý (_isLoading == true)
              if (!_isLoading) ...[
                const Text('Ngôn ngữ mới', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: const [
                    'Korean',
                    'Japanese',
                    'English',
                    'French',
                    'Chinese (Simplified)',
                    'Chinese (Traditional)',
                  ]
                      .map((lang) =>
                          DropdownMenuItem(value: lang, child: Text(lang)))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
              ] else ...[
                // Khi đang chuyển đổi thì chỉ hiện trạng thái
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(width: 12),
                    Text("Đang xử lý... Vui lòng chờ",
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 30),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showFullText,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _outputStatusText,
                      style: const TextStyle(color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  InkWell(
                    onTap: _downloadUrl != null ? _downloadFile : null,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _downloadUrl != null
                            ? Colors.blue[600]
                            : Colors.grey,
                      ),
                      child: const Icon(Icons.download,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Tải về', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
