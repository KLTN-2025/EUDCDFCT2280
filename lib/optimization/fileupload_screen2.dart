// ignore: unused_import
import 'dart:io';
import 'dart:convert'; // ✅ cần cho jsonEncode/jsonDecode

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:font_change_md/optimization/font_mapping_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? s3FileUrl;
  bool loading = false;
  String? resultUrl;

  //final previewText = "abcde....\nABCDE....\n123456789.....";

  String previewText = "Chưa có nội dung preview";

  final dio = Dio(BaseOptions(
    baseUrl: "https://ecolive-font-converter-docker.onrender.com",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // 🔹 Danh sách fonts phát hiện từ server
  List<String> detectedFonts = [];
  // 🔹 Mapping người dùng chọn: {font_gốc: font_mới}
  Map<String, String> fontMapping = {};

  Future<void> detectFontsOnServer(String fileUrl) async {
    setState(() => loading = true);
    try {
      debugPrint("🔍 Gọi detect-fonts cho file S3: $fileUrl");

      // 🧾 Kiểm tra URL trước khi gửi request
      if (!fileUrl.startsWith("http")) {
        _showSnack("❌ URL không hợp lệ: $fileUrl");
        setState(() => loading = false);
        return;
      }

      final response = await dio.post(
        "/detect-fonts",
        data: {"file_url": fileUrl},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      debugPrint("📨 Status detect-fonts: ${response.statusCode}");
      debugPrint("📩 Response data: ${response.data}");

      if (response.statusCode == 200) {
        final fontsFound =
            List<String>.from(response.data["fonts_found"] ?? []);
        debugPrint("✅ Fonts phát hiện: $fontsFound");

        if (fontsFound.isEmpty) {
          _showSnack("Không phát hiện được font nào trong file!");
          return;
        }

        setState(() {
          detectedFonts = fontsFound;
          fontMapping = {for (var f in fontsFound) f: selectedFont};
        });

        // 🧠 Logic xử lý kết quả
        if (fontsFound.length == 1) {
          final font = fontsFound.first;
          if (font == selectedFont) {
            _showSnack("File đã dùng font $selectedFont, không cần đổi.");
          } else {
            final ok = await _showChoiceDialog(
              "Phát hiện font $font.\nBạn có muốn đổi toàn bộ sang $selectedFont không?",
              "Convert luôn",
            );
            if (ok == true) await convertNormal(fileUrl);
          }
        } else {
          final choice = await _showOptionDialog();
          if (choice == "normal") {
            await convertNormal(fileUrl);
          } else if (choice == "mapping") {
            // ignore: use_build_context_synchronously
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (_) => FontMappingScreen(
                  filePath: fileUrl,
                  detectedFonts: fontsFound,
                  availableFonts: fonts,
                ),
              ),
            );
          }
        }
      } else {
        _showSnack("⚠️ Detect fonts thất bại: ${response.data}");
      }
    } catch (e, st) {
      debugPrint("❌ Lỗi detect fonts: $e\n$st");
      _showSnack("Lỗi phát hiện fonts: $e");
    } finally {
      setState(() => loading = false);
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
  // ignore: unused_element
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

  Future<void> convertNormal(String s3Url) async {
    setState(() => loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Chuyển toàn bộ font phát hiện sang 1 font
      final Map<String, String> mapping = {
        for (var f in detectedFonts) f: selectedFont,
      };

      final form = FormData.fromMap({
        'file_url': s3Url,
        'mapping': jsonEncode(mapping),
        'user_id': user?.uid,
      });

      final r = await dio.post('/convert-font-mapping', data: form);
      final url = r.data['result_url'];

      if (url != null) {
        setState(() => resultUrl = url);
        _showSnack(
            "✅ Đã chuyển đổi toàn bộ sang $selectedFont. File tải về: $url");
        await _loadFilePreviewFromUrl(url);
      } else {
        _showSnack("Không nhận được URL kết quả!");
      }
    } catch (e) {
      _showSnack("Lỗi convert: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> convertWithMapping(String s3Url) async {
    setState(() => loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final form = FormData.fromMap({
        'file_url': s3Url,
        'mapping': jsonEncode(fontMapping),
        'user_id': user?.uid,
      });

      final r = await dio.post('/convert-font-mapping', data: form);
      final url = r.data['result_url'];

      if (url != null) {
        setState(() => resultUrl = url);
        _showSnack("✅ Chuyển đổi mapping thành công! File: $url");

        // 🟢 Hiển thị preview nội dung sau khi chuyển đổi
        await _loadFilePreviewFromUrl(url);
      } else {
        _showSnack("Không nhận được URL kết quả!");
      }
    } catch (e) {
      _showSnack("Lỗi convert mapping: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadFilePreviewFromUrl(String fileUrl) async {
    try {
      // 🟢 Gửi request đến backend để tạo preview từ URL
      final r = await dio.post('/preview',
          data: FormData.fromMap({
            'file_url': fileUrl,
          }));

      final content = (r.data['preview'] ?? '').toString();

      setState(() {
        previewText = content.isNotEmpty
            ? content
            : "Không có nội dung hiển thị sau khi convert.";
      });
    } catch (e) {
      debugPrint("❌ Lỗi khi tải preview sau khi convert: $e");
    }
  }

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

  Future<void> _pickFromStorage() async {
    // 1. ✅ PHỤC HỒI DÒNG NÀY ĐỂ ĐỊNH NGHĨA 'res'
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'txt'],
    );

    // Bây giờ 'res' đã được định nghĩa và code chạy bình thường
    if (res == null) return;
    final path = res.files.single.path!;

    // 💡 Tạm thời chỉ lưu path để hiển thị tên
    setState(() {
      pickedFilePath = path;
      // 🟢 Reset các state cũ
      s3FileUrl = null;
      detectedFonts = [];
      resultUrl = null;
    });

    // 👉 Upload file này lên S3
    final s3Url = await _uploadToS3(path);
    if (s3Url == null) {
      _showSnack("Lỗi upload lên S3");
      return;
    }

    // 🌟 LƯU S3 URL VÀO STATE
    setState(() {
      // 2. ✅ BỎ 'this.' ĐỂ SỬA LỖI LINT
      s3FileUrl = s3Url;
    });

    // 🟢 Hiển thị preview từ S3 (tối ưu)
    await _loadFilePreviewFromUrl(s3Url);

    debugPrint("🔍 Đang detect fonts cho $s3Url...");
    // ✅ Gọi detect fonts bằng URL
    await detectFontsOnServer(s3Url);
  }

  /// 👉 Hàm upload file lên S3
  Future<String?> _uploadToS3(String path) async {
    try {
      final fileName = path.split('/').last;

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename: fileName),
      });

      debugPrint("📤 Đang gửi file $fileName lên /upload-to-s3...");
      final response = await dio.post(
        "/upload-to-s3",
        data: formData,
        // options: Options(contentType: "multipart/form-data"),
      );

      // ✅ Backend trả về "url"
      final uploadedUrl = response.data["url"];
      if (uploadedUrl == null ||
          uploadedUrl is! String ||
          !uploadedUrl.startsWith("http")) {
        debugPrint("⚠️ Upload không thành công: ${response.data}");
        return null;
      }

      debugPrint("✅ Upload thành công lên S3: $uploadedUrl");
      return uploadedUrl;
    } catch (e, st) {
      debugPrint("❌ Lỗi upload S3: $e\n$st");
      _showSnack("Lỗi upload lên S3: $e");
      return null;
    }
  }

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
      String? localPathToUpload; // Biến tạm để lưu đường dẫn

      // Nếu có path local (Android/iOS)
      if (path != null) {
        localPathToUpload = path;
      }
      // Nếu chỉ có bytes (thường là Google Drive trên Web hoặc iOS)
      else if (res.files.single.bytes != null) {
        final bytes = res.files.single.bytes!;
        final tempDir = await getTemporaryDirectory();
        final tempFile = File("${tempDir.path}/$name");
        await tempFile.writeAsBytes(bytes);
        localPathToUpload = tempFile.path;
      } else {
        _showSnack("❌ Không thể lấy file từ Google Drive");
        return;
      }

      // 💡 CẬP NHẬT STATE SAU KHI CÓ PATH
      setState(() {
        pickedFilePath = localPathToUpload;
        // 🟢 Reset các state cũ
        s3FileUrl = null;
        detectedFonts = [];
        resultUrl = null;
      });

      // 🔹 Upload lên S3 trước
      final s3Url = await _uploadToS3(localPathToUpload);
      if (s3Url == null) {
        _showSnack("Lỗi upload lên S3");
        return;
      }

      // 🌟 LƯU S3 URL VÀO STATE (đã bỏ 'this.')
      setState(() {
        s3FileUrl = s3Url;
      });

      // 🟢 Lấy preview từ S3 URL
      await _loadFilePreviewFromUrl(s3Url);

      // ✅ Gọi detect fonts bằng URL
      await detectFontsOnServer(s3Url);
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

  // ignore: unused_element
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
        // ⚙️ Nếu backend có API /preview để đọc nội dung 5 dòng đầu
        final file =
            await MultipartFile.fromFile(path, filename: path.split('/').last);
        final form = FormData.fromMap({'file': file});
        final r = await dio.post('/preview', data: form);
        content = (r.data['preview'] ?? '').toString();
      } else if (ext == "pdf") {
        // ⚙️ Nếu backend có API /preview-pdf thì dùng API này
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

  // Future<void> downloadFile() async {
  //   if (resultUrl == null) {
  //     _showSnack("Không có file nào để tải xuống.");
  //     return;
  //   }
  //   _showSnack("Đang tải xuống file từ: $resultUrl");
  // }
  Future<void> downloadFile() async {
    if (resultUrl == null) {
      _showSnack("Không có file nào để tải xuống.");
      return;
    }

    final uri = Uri.parse(resultUrl!);

    try {
      if (await canLaunchUrl(uri)) {
        // Mở trình duyệt để tải file
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack("Không thể mở URL: $resultUrl");
      }
    } catch (e) {
      _showSnack("Lỗi tải file: $e");
    }
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

  // @override
  // Widget build(BuildContext context) {
  //   final fontFamily = _mapFamily(selectedFont);
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     appBar: AppBar(title: const Text("Chuyển đổi Font chữ tự động")),
  //     body: SafeArea(
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           children: [
  //             // Upload file
  //             GestureDetector(
  //               onTap: pickFile,
  //               child: Container(
  //                 height: 140,
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(18),
  //                   boxShadow: const [
  //                     BoxShadow(color: Colors.black26, blurRadius: 8)
  //                   ],
  //                 ),
  //                 child: const Center(
  //                   child: Column(mainAxisSize: MainAxisSize.min, children: [
  //                     Icon(Icons.cloud_upload_outlined, size: 36),
  //                     SizedBox(height: 6),
  //                     Text("UPLOAD FILE")
  //                   ]),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 16),

  //             // Chọn font mới
  //             Row(children: [
  //               const Text("Font chữ mới:"),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: DropdownButtonFormField<String>(
  //                   value: selectedFont,
  //                   items: fonts
  //                       .map((f) => DropdownMenuItem(value: f, child: Text(f)))
  //                       .toList(),
  //                   onChanged: (v) => setState(() => selectedFont = v!),
  //                   decoration: InputDecoration(
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(8))),
  //                 ),
  //               ),
  //             ]),

  //             const SizedBox(height: 24),

  //             // Preview
  //             const Text("Preview",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 8),
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                   border: Border.all(width: 2),
  //                   borderRadius: BorderRadius.circular(12)),
  //               child: Text(previewText,
  //                   style: TextStyle(fontFamily: fontFamily, fontSize: 22)),
  //             ),
  //             const SizedBox(height: 12),

  //             if (pickedFilePath != null)
  //               Text("File: ${pickedFilePath!.split('/').last}"),
  //             if (resultUrl != null) SelectableText("Kết quả: $resultUrl"),
  //             if (loading)
  //               const Padding(
  //                   padding: EdgeInsets.only(top: 12),
  //                   child: CircularProgressIndicator()),

  //             const SizedBox(height: 24),

  //             if (pickedFilePath != null) ...[
  //               // 👈 Dùng pickedFilePath để *hiển thị* nút
  //               ElevatedButton.icon(
  //                 // ⚠️ SỬA Ở ĐÂY: Dùng s3FileUrl
  //                 onPressed: s3FileUrl != null
  //                     ? () => convertNormal(s3FileUrl!)
  //                     : null, // 👈 Vô hiệu hóa nút nếu s3Url chưa sẵn sàng
  //                 icon: const Icon(Icons.format_size),
  //                 label: Text("Convert tất cả sang $selectedFont"),
  //               ),
  //               const SizedBox(height: 16),
  //             ],

  //             // 🔹 Mapping UI
  //             if (detectedFonts.isNotEmpty) ...[
  //               // ... (code mapping UI của bạn) ...
  //               ElevatedButton.icon(
  //                 // ⚠️ SỬA Ở ĐÂY: Dùng s3FileUrl
  //                 onPressed: s3FileUrl != null
  //                     ? () => convertWithMapping(s3FileUrl!)
  //                     : null, // 👈 Vô hiệu hóa nút nếu s3Url chưa sẵn sàng
  //                 icon: const Icon(Icons.auto_fix_high),
  //                 label: const Text("Convert theo Mapping"),
  //               ),
  //             ],

  //             const SizedBox(height: 24),

  //             // Khung kết quả
  //             const Text("Kết quả chuyển đổi",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 8),
  //             Container(
  //               height: 140,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(18),
  //                 border: Border.all(color: Colors.grey.shade300, width: 1),
  //                 boxShadow: const [
  //                   BoxShadow(color: Colors.black12, blurRadius: 4)
  //                 ],
  //               ),
  //               child: Center(
  //                 child: loading
  //                     ? const CircularProgressIndicator()
  //                     : Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Icon(
  //                             resultUrl != null
  //                                 ? Icons.check_circle
  //                                 : Icons.description_outlined,
  //                             size: 36,
  //                             color:
  //                                 resultUrl != null ? Colors.blue : Colors.grey,
  //                           ),
  //                           const SizedBox(height: 6),
  //                           Text(
  //                             resultUrl != null
  //                                 ? "Đã chuyển đổi thành công (${resultUrl!.split('/').last})"
  //                                 : "File đã chuyển đổi sẽ xuất hiện ở đây",
  //                             textAlign: TextAlign.center,
  //                           )
  //                         ],
  //                       ),
  //               ),
  //             ),
  //             const SizedBox(height: 32),

  //             // Nút download
  //             InkWell(
  //               onTap: downloadFile,
  //               borderRadius: BorderRadius.circular(50),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(15),
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: resultUrl != null
  //                           ? Colors.blue
  //                           : Colors.grey.shade400,
  //                     ),
  //                     child: const Icon(Icons.download,
  //                         color: Colors.white, size: 30),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   const Text('Tải về', style: TextStyle(color: Colors.blue)),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final fontFamily = _mapFamily(selectedFont);

    // ✅ BỌC BẰNG WILLPOPSCOPE
    return WillPopScope(
      onWillPop: () async {
        // ✅ DÙNG BIẾN 'loading' CỦA MÀN HÌNH NÀY
        if (loading) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Không thể thoát",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text(
                  "Đang trong quá trình chuyển đổi. Vui lòng chờ hoàn tất trước khi quay lại."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          );
          return false; // 👈 Ngăn không cho thoát
        }
        return true; // 👈 Cho phép thoát
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text("Chuyển đổi Font chữ tự động")),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Upload file
                GestureDetector(
                  // ✅ Vô hiệu hóa nút upload khi đang loading
                  onTap: loading ? null : pickFile,
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
                          .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      // ✅ Vô hiệu hóa dropdown khi đang loading
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

                // Preview
                const Text("Preview",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                if (pickedFilePath != null) ...[
                  // 👈 Dùng pickedFilePath để *hiển thị* nút
                  ElevatedButton.icon(
                    // ✅ Vô hiệu hóa nút khi đang loading HOẶC chưa có s3Url
                    onPressed: s3FileUrl != null && !loading
                        ? () => convertNormal(s3FileUrl!)
                        : null,
                    icon: const Icon(Icons.format_size),
                    label: Text("Convert tất cả sang $selectedFont"),
                  ),
                  const SizedBox(height: 16),
                ],

                // 🔹 Mapping UI
                if (detectedFonts.isNotEmpty) ...[
                  // ... (code mapping UI của bạn) ...
                  ElevatedButton.icon(
                    // ✅ Vô hiệu hóa nút khi đang loading HOẶC chưa có s3Url
                    onPressed: s3FileUrl != null && !loading
                        ? () => convertWithMapping(s3FileUrl!)
                        : null,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text("Convert theo Mapping"),
                  ),
                ],

                const SizedBox(height: 24),

                // Khung kết quả
                const Text("Kết quả chuyển đổi",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                color: resultUrl != null
                                    ? Colors.blue
                                    : Colors.grey,
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
                  // ✅ Vô hiệu hóa nút khi đang loading
                  onTap: loading ? null : downloadFile,
                  borderRadius: BorderRadius.circular(50),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: resultUrl != null && !loading
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                        child: const Icon(Icons.download,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 4),
                      const Text('Tải về',
                          style: TextStyle(color: Colors.blue)),
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
