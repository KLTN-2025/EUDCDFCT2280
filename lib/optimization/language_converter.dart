import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
      translateReq.fields['target_lang'] = _selectedLanguage.toLowerCase();

      var transResp = await translateReq.send();
      var transBody = await transResp.stream.bytesToString();

      if (transResp.statusCode == 200) {
        var jsonResponse = json.decode(transBody);

        // ✅ backend nên trả cả 'translated_text' và 'result_url'
        setState(() {
          _downloadUrl = jsonResponse['result_url'];
          _outputStatusText = jsonResponse['translated_text'] ??
              "✅ Dịch thành công! (${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()})";
        });
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

  // Future<void> _downloadFile() async {
  //   if (_downloadUrl == null) return;

  //   try {
  //     // 🟢 Yêu cầu quyền truy cập bộ nhớ (Android 11+)
  //     if (Platform.isAndroid) {
  //       await Permission.storage.request();
  //     }

  //     setState(() => _isLoading = true);

  //     // 📂 Đường dẫn thư mục "Download"
  //     Directory downloadDir = Directory('/storage/emulated/0/Download');
  //     if (!await downloadDir.exists()) {
  //       downloadDir =
  //           await getExternalStorageDirectory() ?? Directory.systemTemp;
  //     }

  //     String fileName = _uploadedFileName != null
  //         // ignore: prefer_interpolation_to_compose_strings
  //         ? _uploadedFileName!.split('.').first + '_translated.docx'
  //         : 'translated_file.docx';
  //     String savePath = '${downloadDir.path}/$fileName';

  //     await Dio().download(_downloadUrl!, savePath);

  //     setState(() => _isLoading = false);

  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("✅ Đã tải về: $savePath")),
  //     );

  //     // 🔓 Mở trực tiếp file
  //     await OpenFilex.open(savePath);
  //   } catch (e) {
  //     setState(() => _isLoading = false);
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("❌ Lỗi khi tải: $e")),
  //     );
  //   }
  // }
  Future<void> _downloadFile() async {
    if (_downloadUrl == null) return;

    try {
      if (await Permission.storage.request().isGranted) {
        Directory? directory;

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        String filename = _uploadedFileName != null
            // ignore: prefer_interpolation_to_compose_strings
            ? _uploadedFileName!.split('.').first + '_translated.docx'
            : 'translated_file.docx';
        String savePath = '${directory!.path}/$filename';

        // ignore: avoid_print
        print("📥 Đang tải về: $savePath");

        await Dio().download(
          _downloadUrl!,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              // ignore: avoid_print
              print("📦 ${(received / total * 100).toStringAsFixed(0)}%");
            }
          },
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Đã tải về: $savePath")),
        );

        await OpenFilex.open(savePath);
      } else {
        await Permission.storage.request();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Không có quyền truy cập bộ nhớ!")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi khi tải: $e")),
      );
    }
  }

  void _showFullText() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xem nội dung sau khi dịch"),
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
    return Scaffold(
      appBar: AppBar(title: const Text('LANGUAGE TO LANGUAGE')),
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
            const Text('Ngôn ngữ mới', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                'Korean',
                'Chinese',
                'Japanese',
                'English',
                'French'
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
            const SizedBox(height: 30),
            const Text('Output', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showFullText,
              child: Container(
                height: 120,
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
                      color:
                          _downloadUrl != null ? Colors.blue[600] : Colors.grey,
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
    );
  }
}
