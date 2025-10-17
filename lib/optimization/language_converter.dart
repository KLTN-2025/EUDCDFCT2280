// import 'package:flutter/material.dart';

// class LanguageConverterScreen extends StatefulWidget {
//   const LanguageConverterScreen({super.key});

//   @override
//   State<LanguageConverterScreen> createState() =>
//       _LanguageConverterScreenState();
// }

// class _LanguageConverterScreenState extends State<LanguageConverterScreen> {
//   // Biến để lưu trữ tên file đã tải lên
//   // ignore: unused_field
//   String? _uploadedFileName;

//   // Biến để lưu trữ ngôn ngữ mới đã chọn
//   String _selectedLanguage = 'Korean';

//   // Biến để hiển thị trạng thái của file đã chuyển đổi
//   // ignore: prefer_final_fields
//   String _outputStatusText = 'Nội dung file đã chuyển đổi nằm ở đây';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('LANGUAGE TO LANGUAGE'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Vùng Upload File
//             GestureDetector(
//               onTap: () {
//                 // TODO: Triển khai chức năng chọn file ở đây
//               },
//               child: Container(
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
//                     SizedBox(height: 10),
//                     Text('UPLOAD FILE', style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Phần chọn Ngôn ngữ mới
//             const Text('Ngôn ngữ mới', style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 8),
//             DropdownButtonFormField<String>(
//               value: _selectedLanguage,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: <String>[
//                 'Korean',
//                 'Chinese',
//                 'Japanese',
//                 'English',
//                 'French'
//               ].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedLanguage = newValue!;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),

//             // Phần Output
//             const Text('Output', style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 8),
//             Container(
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Center(
//                 child: Text(
//                   _outputStatusText,
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50),

//             // Nút Tải về
//             Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     // TODO: Triển khai chức năng tải file về ở đây
//                   },
//                   borderRadius: BorderRadius.circular(50),
//                   child: Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.blue[600],
//                     ),
//                     child: const Icon(Icons.download,
//                         color: Colors.white, size: 30),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text('Tải về', style: TextStyle(color: Colors.blue)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

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

  // 🟢 Thay IP bên dưới bằng IP LAN của backend bạn (xem bằng /get-server-ip)
  final String backendBaseUrl = "http://192.168.1.5:8000";

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

      // 🧠 1️⃣ Gửi file lên để phát hiện ngôn ngữ
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

      // 🌍 2️⃣ Tiến hành dịch tài liệu
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
        setState(() {
          _downloadUrl = jsonResponse['result_url'];
          _outputStatusText =
              "✅ Dịch thành công!\n(${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()})";
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

  Future<void> _downloadFile() async {
    if (_downloadUrl == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("URL tải về: $_downloadUrl")),
    );
    // Có thể dùng open_filex.open(downloadPath) nếu muốn mở trực tiếp
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
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  _outputStatusText,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50),
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
