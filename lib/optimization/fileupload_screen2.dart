// ignore: unused_import
import 'dart:io';
import 'dart:convert'; // ✅ cần cho jsonEncode/jsonDecode

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 👉 Class client để thêm headers auth (phải để ở ngoài, top-level)
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

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
  bool loading = false;
  String? resultUrl;

  //final previewText = "abcde....\nABCDE....\n123456789.....";

  String previewText = "Chưa có nội dung preview";

  final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));

  // 🔹 Danh sách fonts phát hiện từ server
  List<String> detectedFonts = [];
  // 🔹 Mapping người dùng chọn: {font_gốc: font_mới}
  Map<String, String> fontMapping = {};

  /// 👉 Upload file để detect fonts
  Future<void> detectFontsOnServer(String path) async {
    setState(() => loading = true);
    try {
      final file =
          await MultipartFile.fromFile(path, filename: path.split('/').last);
      final form = FormData.fromMap({'file': file});
      final r = await dio.post('/upload', data: form);

      final fontsFound = List<String>.from(r.data['fonts'] ?? []);
      setState(() {
        detectedFonts = fontsFound;
        fontMapping = {
          for (var f in fontsFound)
            f: selectedFont, // default map hết về 1 font
        };
      });
      // ✅ Gợi ý người dùng chọn convert sau khi detect
      await _handleFontDecision(path);
    } catch (e) {
      _showSnack("Lỗi khi kiểm tra file: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  /// ✅ Hàm xử lý logic popup gợi ý người dùng
  Future<void> _handleFontDecision(String path) async {
    if (detectedFonts.isEmpty) {
      _showSnack("Không phát hiện được font nào trong file!");
      return;
    }

    if (detectedFonts.length == 1) {
      final font = detectedFonts.first;
      if (font == selectedFont) {
        _showSnack("File đã dùng đúng font $selectedFont, không cần đổi.");
      } else {
        final ok = await _showChoiceDialog(
          "Phát hiện font $font.\nBạn có muốn đổi toàn bộ sang $selectedFont không?",
          "Convert luôn",
        );
        if (ok == true) await convertNormal(path);
      }
    } else {
      final choice = await _showOptionDialog();
      if (choice == "normal") {
        await convertNormal(path);
      } else if (choice == "mapping") {
        // _showSnack("Bạn có thể chỉnh mapping phía dưới rồi nhấn Convert.");
        await _showMappingDialog(path);
      }
    }
  }

  /// ✅ Popup chọn kiểu convert
  Future<String?> _showOptionDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nhiều font được phát hiện"),
        content: const Text(
            "Bạn muốn xử lý như thế nào?\n\n- Convert tất cả sang 1 font\n- Hay mapping từng font riêng?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "normal"),
            child: const Text("Tất cả sang 1 font"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, "mapping"),
            child: const Text("Mapping thủ công"),
          ),
        ],
      ),
    );
  }

  /// ✅ Dialog mapping UI (khi nhiều font)
  Future<void> _showMappingDialog(String path) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Mapping từng font"),
            content: SingleChildScrollView(
              child: Column(
                children: detectedFonts.map((f) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text("Font gốc: $f")),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: fontMapping[f],
                            items: fonts
                                .map((ff) => DropdownMenuItem(
                                    value: ff, child: Text(ff)))
                                .toList(),
                            onChanged: (v) {
                              setStateDialog(() {
                                fontMapping[f] = v!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Hủy"),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await convertWithMapping(path);
                },
                icon: const Icon(Icons.check),
                label: const Text("Xác nhận chuyển"),
              ),
            ],
          );
        });
      },
    );
  }

  /// ✅ Popup yes/no đơn giản
  Future<bool?> _showChoiceDialog(String message, String okText) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(okText),
          ),
        ],
      ),
    );
  }

  /// 👉 Gọi API convert thường (toàn bộ về 1 font)
  // Future<void> convertNormal(String path) async {
  //   setState(() => loading = true);
  //   try {
  //     final file =
  //         await MultipartFile.fromFile(path, filename: path.split('/').last);
  //     final form = FormData.fromMap({
  //       'file': file,
  //       'font': selectedFont, // ✅ font mà user chọn
  //     });
  //     final r = await dio.post('/convert', data: form);
  //     final url = r.data['result_url'] as String?;
  //     if (url != null) {
  //       setState(() {
  //         resultUrl = url;
  //       });
  //       _showSnack("Đã chuyển xong. Tải về: $url");
  //     } else {
  //       _showSnack("Convert thất bại");
  //     }
  //   } catch (e) {
  //     _showSnack("Lỗi convert: $e");
  //   } finally {
  //     setState(() => loading = false);
  //   }
  // }
  Future<void> convertNormal(String path) async {
    setState(() => loading = true);
    try {
      final file = await MultipartFile.fromFile(path);
      final form = FormData.fromMap({'file': file, 'font': selectedFont});
      final r = await dio.post('/convert', data: form);
      final url = r.data['result_url'];
      if (url != null) {
        setState(() => resultUrl = url);
        _showSnack("✅ Đã chuyển đổi xong. File tải về: $url");
      }
    } catch (e) {
      _showSnack("Lỗi convert: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> convertWithMapping(String path) async {
    setState(() => loading = true);
    try {
      final file = await MultipartFile.fromFile(path);
      final form = FormData.fromMap({
        'file': file,
        'mapping': jsonEncode(fontMapping),
      });
      final r = await dio.post('/convert-mapping', data: form);
      final url = r.data['result_url'];
      if (url != null) {
        setState(() => resultUrl = url);
        _showSnack("✅ Chuyển đổi mapping thành công! File: $url");
      }
    } catch (e) {
      _showSnack("Lỗi convert mapping: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  /// 👉 Gọi API convert-mapping
  // Future<void> convertWithMapping(String path) async {
  //   setState(() => loading = true);
  //   try {
  //     final file =
  //         await MultipartFile.fromFile(path, filename: path.split('/').last);
  //     final form = FormData.fromMap({
  //       'file': file,
  //       'mapping': jsonEncode(fontMapping), // ✅ map -> JSON
  //     });
  //     final r = await dio.post('/convert-mapping', data: form);
  //     final url = r.data['result_url'] as String?;
  //     if (url != null) {
  //       setState(() {
  //         resultUrl = url;
  //       });
  //       _showSnack("Đã chuyển xong. Tải về: $url");
  //     } else {
  //       _showSnack("Convert mapping thất bại");
  //     }
  //   } catch (e) {
  //     _showSnack("Lỗi convert mapping: $e");
  //   } finally {
  //     setState(() => loading = false);
  //   }
  // }

  // 👉 Chọn file (hiển thị bottom sheet)
  Future<void> pickFile() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text("Chọn từ bộ nhớ máy"),
            onTap: () => Navigator.pop(ctx, "storage"),
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text("Chọn từ Google Drive"),
            onTap: () => Navigator.pop(ctx, "gdrive"),
          ),
        ],
      ),
    );

    if (source == "storage") {
      await _pickFromStorage();
    } else if (source == "gdrive") {
      await _pickFromGoogleDrive();
    }
  }

  /// 👉 Chọn file từ bộ nhớ máy
  Future<void> _pickFromStorage() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'pdf', 'txt'],
      );
      if (res != null) {
        final path = res.files.single.path!;
        setState(() => pickedFilePath = path);
        await _loadFilePreview(path);
        await detectFontsOnServer(path); // ✅ detect luôn sau khi chọn
      }
    } else {
      _showSnack("Bạn cần cấp quyền để tiếp tục");
    }
  }

  /// 👉 Chọn file từ Google Drive
  Future<void> _pickFromGoogleDrive() async {
    try {
      if (!(await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted)) {
        _showSnack("❌ Bạn cần cấp quyền để truy cập Google Drive");
        return;
      }

      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'pdf', 'txt'],
        withData: true,
      );

      if (res == null) {
        _showSnack("❌ Bạn chưa chọn file nào");
        return;
      }

      final name = res.files.single.name;
      String? path = res.files.single.path;

      if (path != null) {
        setState(() => pickedFilePath = path);
        await detectFontsOnServer(path);
        return;
      }

      final bytes = res.files.single.bytes;
      if (bytes != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File("${tempDir.path}/$name");
        await tempFile.writeAsBytes(bytes);

        setState(() => pickedFilePath = tempFile.path);
        await detectFontsOnServer(tempFile.path);
        return;
      }

      _showSnack("❌ Không thể lấy file từ Google Drive");
    } catch (e, st) {
      debugPrint("🔥 Lỗi khi chọn file Google Drive: $e\n$st");
      if (mounted) _showSnack("Lỗi chọn file: $e");
    }
  }

  void _showSnack(String s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s)),
    );
  }

  /// ✅ Đọc nội dung file để hiển thị preview (5 dòng đầu)
  Future<void> _loadFilePreview(String path) async {
    try {
      final ext = path.split('.').last.toLowerCase();
      String content = "";

      if (ext == "txt") {
        final file = File(path);
        if (await file.exists()) {
          final lines = await file.readAsLines();
          content = lines.take(5).join('\n');
        }
      } else if (ext == "docx") {
        // ⚙️ Nếu backend có API /preview, dùng để đọc nội dung 5 dòng đầu
        final file =
            await MultipartFile.fromFile(path, filename: path.split('/').last);
        final form = FormData.fromMap({'file': file});
        final r = await dio.post('/preview', data: form);
        content = (r.data['preview'] ?? '').toString();
      } else if (ext == "pdf") {
        // ⚙️ Nếu backend có /preview-pdf hoặc /upload dùng chung
        final file =
            await MultipartFile.fromFile(path, filename: path.split('/').last);
        final form = FormData.fromMap({'file': file});
        final r = await dio.post('/preview-pdf', data: form);
        content = (r.data['preview'] ?? '').toString();
      } else {
        content = "Không thể xem trước loại file .$ext";
      }

      setState(() {
        previewText =
            content.isNotEmpty ? content : "Không có nội dung hiển thị";
      });
    } catch (e) {
      setState(() => previewText = "Lỗi khi đọc preview: $e");
    }
  }

  Future<void> downloadFile() async {
    if (resultUrl == null) {
      _showSnack("Không có file nào để tải xuống.");
      return;
    }
    _showSnack("Đang tải xuống file từ: $resultUrl");
  }

  String _mapFamily(String fontName) {
    switch (fontName) {
      case 'Arial':
        return 'Arial';
      case 'Calibri':
        return 'Calibri';
      case 'Times New Roman':
        return 'TimesNewRoman';
      case 'Serif':
        return 'Serif';
      case 'Sans-serif':
        return 'SansSerif';
      case 'Script':
        return 'Script';
      default:
        return 'Arial';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = _mapFamily(selectedFont);
    return Scaffold(
      appBar: AppBar(title: const Text("Chuyển đổi Font chữ tự động")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // Upload file
          GestureDetector(
            onTap: pickFile,
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
              child: const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.cloud_upload_outlined, size: 36),
                  SizedBox(height: 6),
                  Text("UPLOAD FILE")
                ]),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chọn font mới
          Row(children: [
            const Text("Font chữ mới:"),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedFont,
                items: fonts
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => selectedFont = v!),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Preview
          const Text("Preview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(12)),
            child: Text(previewText,
                style: TextStyle(fontFamily: fontFamily, fontSize: 22)),
          ),
          const SizedBox(height: 12),

          if (pickedFilePath != null)
            Text("File: ${pickedFilePath!.split('/').last}"),
          if (resultUrl != null) SelectableText("Kết quả: $resultUrl"),
          if (loading)
            const Padding(
                padding: EdgeInsets.only(top: 12),
                child: CircularProgressIndicator()),

          const SizedBox(height: 24),

          // 🔹 Convert thường
          if (pickedFilePath != null) ...[
            ElevatedButton.icon(
              onPressed: () => convertNormal(pickedFilePath!),
              icon: const Icon(Icons.format_size),
              label: Text("Convert tất cả sang $selectedFont"),
            ),
            const SizedBox(height: 16),
          ],

          // 🔹 Mapping UI
          if (detectedFonts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text("Mapping font",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: detectedFonts.map((f) {
                return Row(
                  children: [
                    Expanded(child: Text("Font gốc: $f")),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: fontMapping[f],
                        items: fonts
                            .map((ff) =>
                                DropdownMenuItem(value: ff, child: Text(ff)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            fontMapping[f] = v!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickedFilePath != null
                  ? () => convertWithMapping(pickedFilePath!)
                  : null,
              icon: const Icon(Icons.auto_fix_high),
              label: const Text("Convert theo Mapping"),
            ),
          ], // ✅ nhớ dấu phẩy ở cuối

          const SizedBox(height: 24),

          // Khung kết quả
          const Text("Kết quả chuyển đổi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              child: loading
                  ? const CircularProgressIndicator()
                  : Column(
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
                        Text(
                          resultUrl != null
                              ? "Đã chuyển đổi thành công (${resultUrl!.split('/').last})"
                              : "File đã chuyển đổi sẽ xuất hiện ở đây",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 32),

          // Nút download
          InkWell(
            onTap: downloadFile,
            borderRadius: BorderRadius.circular(50),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        resultUrl != null ? Colors.blue : Colors.grey.shade400,
                  ),
                  child:
                      const Icon(Icons.download, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 4),
                const Text('Tải về', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
