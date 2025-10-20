import 'dart:io';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio/dio.dart'; // Dùng để tải file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_change_md/optimization/full_screen_image.dart';
import 'package:font_change_md/view/history_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver_plus/gallery_saver.dart'; // Mới
import 'package:open_filex/open_filex.dart'; // Để mở file
import 'package:path_provider/path_provider.dart'; // Để lấy temp dir
import 'package:permission_handler/permission_handler.dart';

class FileConverterImageScreen extends StatefulWidget {
  const FileConverterImageScreen({super.key});

  @override
  State<FileConverterImageScreen> createState() =>
      _FileConverterImageScreenState();
}

class _FileConverterImageScreenState extends State<FileConverterImageScreen> {
  String? _uploadedFileName;
  String _selectedImageType = 'PNG';
  String _outputStatusText = "Chưa có tệp kết quả.";
  List<String> _imageUrls = [];
  bool _isLoading = false;

  Future<void> _pickFileAndConvert() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    setState(() {
      _uploadedFileName = result.files.single.name;
      _isLoading = true;
      _outputStatusText = '⏳ Đang xử lý...';
      _imageUrls.clear();
    });

    try {
      // 🟢 Lấy IP động từ backend
      const serverUrl = "https://ecolive-font-converter.onrender.com";
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous_user";

      var uri = Uri.parse("$serverUrl/convert-to-image");
      // var request = http.MultipartRequest("POST", uri)
      //   ..files.add(await http.MultipartFile.fromPath("file", file.path))
      //   ..fields['image_type'] = _selectedImageType;
      //   ..fields['user_id'] = userId; // 🟢 THÊM DÒNG NÀY
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
      request.fields['image_type'] = _selectedImageType;
      request.fields['user_id'] = userId;

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);

        // ⚙️ Nếu backend trả "files" hoặc "image_urls"
        List<dynamic> rawUrls =
            data['files'] ?? data['image_urls'] ?? []; // 👈 thêm fallback
        List<String> urls = rawUrls.map((e) => e.toString()).toList();

        // Nếu link không có http thì nối serverUrl
        urls = urls.map((u) {
          if (!u.startsWith("http")) return "$serverUrl$u";
          return u;
        }).toList();

        setState(() {
          _imageUrls = urls;
          _outputStatusText =
              "✅ Chuyển đổi thành công (${_imageUrls.length} ảnh)";
        });
      } else {
        setState(() {
          _outputStatusText = "❌ Lỗi khi chuyển đổi (${response.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _outputStatusText = "⚠️ Lỗi: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadFile(String url) async {
    try {
      // 🟢 Xin quyền truy cập lưu trữ
      if (Platform.isAndroid) {
        final storagePermission = await Permission.photos.request();
        if (storagePermission.isDenied) {
          await Permission.storage.request();
        }
      }

      // 🟢 Tải ảnh về file tạm
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last; // Lấy tên file từ URL
      final tempPath = '${tempDir.path}/$fileName';
      await Dio().download(url, tempPath);

      // 🟢 Lưu file tạm vào thư viện ảnh
      final success = await GallerySaver.saveImage(
        tempPath,
        albumName: "Converted Images", // Tùy chọn: Lưu vào album riêng
      );

      // 🟢 Xóa file tạm sau khi lưu thành công
      if (success == true) {
        await File(tempPath).delete();
      }

      // 🟢 Kiểm tra kết quả
      if (success == true) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("✅ Ảnh đã lưu vào thư viện!"),
            action: SnackBarAction(
              label: 'Mở',
              onPressed: () async {
                final result = await OpenFilex.open(tempPath);
                if (result.type != ResultType.done) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("⚠️ Lỗi mở ảnh: ${result.message}")),
                  );
                }
              },
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Lỗi khi lưu ảnh!")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Lỗi tải ảnh: $e")),
      );
    }
  }

  Future<void> _downloadAllImages() async {
    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Chưa có ảnh nào để tải!")),
      );
      return;
    }

    final BuildContext scaffoldContext = context;

    // ⚠️ Không setState toàn bộ UI nữa
    showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Đang tải ảnh"),
          content: StatefulBuilder(
            builder: (innerContext, setStateDialog) {
              int current = 0;
              int total = _imageUrls.length;

              Future<void> startDownload() async {
                try {
                  // 🟢 Xin quyền lưu trữ
                  if (Platform.isAndroid) {
                    final storagePermission = await Permission.photos.request();
                    if (storagePermission.isDenied) {
                      await Permission.storage.request();
                    }
                  }

                  final tempDir = await getTemporaryDirectory();
                  int successCount = 0;

                  for (int i = 0; i < total; i++) {
                    final url = _imageUrls[i];
                    final fileName = url.split('/').last;
                    final tempPath = '${tempDir.path}/$fileName';

                    try {
                      await Dio().download(url, tempPath);
                      final saved = await GallerySaver.saveImage(
                        tempPath,
                        albumName: "Converted Images",
                      );
                      if (saved == true) {
                        successCount++;
                        await File(tempPath)
                            .delete(); // 🟢 Xóa file tạm ngay sau khi lưu
                      }
                    } catch (_) {}

                    // Thêm delay để tránh overload
                    await Future.delayed(const Duration(milliseconds: 200));

                    // Cập nhật tiến trình chỉ trong dialog
                    setStateDialog(() => current = i + 1);
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.of(innerContext).pop();

                  bool openedSuccessfully = false;

                  if (Platform.isAndroid) {
                    try {
                      const intent = AndroidIntent(
                        action: 'android.intent.action.MAIN',
                        category: 'android.intent.category.APP_GALLERY',
                        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                      );
                      await intent.launch();
                      openedSuccessfully = true;
                    } catch (e) {
                      try {
                        await OpenFilex.open("/storage/emulated/0/Pictures");
                        openedSuccessfully = true;
                      } catch (_) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          SnackBar(
                              content: Text("⚠️ Không thể mở thư viện: $e")),
                        );
                      }
                    }
                  }

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        "✅ Đã tải $successCount/$total ảnh${openedSuccessfully ? ' và mở thư viện thành công' : ''}!",
                      ),
                    ),
                  );
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(innerContext).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text("⚠️ Lỗi tải ảnh: $e")),
                  );
                }
              }

              // Chạy ngay khi dialog hiển thị
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => startDownload());

              return SizedBox(
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text("Đang tải $current / $total ảnh..."),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
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
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CHUYỂN ĐỔI FILE SANG IMAGE'),
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
                    builder: (context) => HistoryScreen(
                      userId: user.uid,
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
                onTap: _pickFileAndConvert,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload,
                          size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      const Text('UPLOAD FILE',
                          style: TextStyle(color: Colors.grey)),
                      if (_uploadedFileName != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          "Đã chọn: $_uploadedFileName",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Loại ảnh', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedImageType,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: ['PNG', 'JPG', 'JPEG', 'WEBP'].map((v) {
                  return DropdownMenuItem<String>(
                    value: v,
                    child: Text(v),
                  );
                }).toList(),
                // Khi đang xử lý (_isLoading = true) thì disable Dropdown
                onChanged: _isLoading
                    ? null
                    : (val) => setState(() => _selectedImageType = val!),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _imageUrls.isNotEmpty
                          ? ListView.builder(
                              itemCount: _imageUrls.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _imageUrls.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoading
                                          ? null
                                          : _downloadAllImages,
                                      icon: const Icon(Icons.cloud_download),
                                      label: const Text("Tải tất cả ảnh"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final url = _imageUrls[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullScreenImageViewer(
                                                  imageUrls: _imageUrls,
                                                  initialIndex: index,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: url,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                url,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () => _downloadFile(url),
                                          icon: const Icon(Icons.download),
                                          label: const Text('Tải ảnh này'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                _outputStatusText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
