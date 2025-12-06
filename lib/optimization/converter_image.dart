import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart'; // Thêm thư viện này
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/optimization/full_screen_image.dart';
import 'package:ecolive/view/history_screen.dart';
import 'package:ecolive/optimization/partial_image_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecolive/view/image_tutorial_overlay.dart';

class FileConverterImageScreen extends StatefulWidget {
  const FileConverterImageScreen({super.key});

  @override
  State<FileConverterImageScreen> createState() =>
      _FileConverterImageScreenState();
}

class _FileConverterImageScreenState extends State<FileConverterImageScreen> {
  String? _uploadedFileName;
  String _selectedImageType = 'PNG';
  String _outputStatusText = tr(LocaleData.noresult);
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  // 🟢 HÀM KIỂM TRA QUYỀN (GIỐNG MÀN HÌNH LỊCH SỬ)
  Future<bool> _checkPermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;

    // Android 13+ (SDK 33): Không cần quyền Storage/Photos để lưu ảnh vào Gallery qua thư viện GallerySaver
    if (androidInfo.version.sdkInt >= 33) {
      return true;
    }

    // Android 12 trở xuống: Xin quyền Storage
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Cần quyền bộ nhớ để lưu ảnh!")),
      );
    }
    return false;
  }

  Future<void> _checkAndShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeFileImage') ?? true;

    if (isFirstTime) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      _showImageTutorial();
      await prefs.setBool('isFirstTimeFileImage', false);
    }
  }

  void _showImageTutorial() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return ImageTutorialOverlay(
          onClose: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  Future<void> _pickFileAndConvert() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);

    bool? isPartialMode = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(tr(LocaleData.file_choose_method)),
        content: Text(tr(LocaleData.file_ask)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(tr(LocaleData.file_all)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(tr(LocaleData.file_seperate)),
          ),
        ],
      ),
    );

    if (isPartialMode == null) return;

    setState(() {
      _uploadedFileName = result.files.single.name;
      _isLoading = true;
      _outputStatusText = tr(LocaleData.file_processing);
      _imageUrls.clear();
    });

    try {
      const serverUrl = "https://ecolive-font-converter-docker.onrender.com";
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous_user";

      var uri = Uri.parse("$serverUrl/convert-to-image");
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
      request.fields['image_type'] = _selectedImageType;
      request.fields['user_id'] = userId;
      request.fields['save_history'] = isPartialMode ? "false" : "true";

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        List<dynamic> rawUrls = data['files'] ?? data['image_urls'] ?? [];
        List<String> urls = rawUrls.map((e) => e.toString()).toList();

        urls = urls.map((u) {
          if (!u.startsWith("http")) return "$serverUrl$u";
          return u;
        }).toList();

        setState(() {
          _imageUrls = urls;
          _isLoading = false;
        });

        if (isPartialMode) {
          setState(() => _outputStatusText = tr(LocaleData.file_process_temp));

          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartialExportScreen(
                imageUrls: urls,
                originalFileName: _uploadedFileName!,
                apiBaseUrl: serverUrl,
              ),
            ),
          );
        } else {
          setState(() {
            _outputStatusText =
                "${tr(LocaleData.file_converted_success)} (${_imageUrls.length})";
          });
        }
      } else {
        setState(() {
          _outputStatusText =
              "${tr(LocaleData.file_converted_error)} (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _outputStatusText = "${tr(LocaleData.language_error)} $e";
        _isLoading = false;
      });
    }
  }

  // Tải 1 ảnh
  Future<void> _downloadFile(String url) async {
    // Kiểm tra quyền trước
    if (!await _checkPermission()) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final tempPath = '${tempDir.path}/$fileName';

      // Tải về temp
      await Dio().download(url, tempPath);

      // Lưu vào Gallery
      final success = await GallerySaver.saveImage(
        tempPath,
        albumName: "Ecolive Images",
      );

      // Xóa file temp để tiết kiệm bộ nhớ
      if (File(tempPath).existsSync()) {
        await File(tempPath).delete();
      }

      if (success == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.file_hasbeensaved))),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Lỗi khi lưu ảnh!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Lỗi tải ảnh: $e")),
        );
      }
    }
  }

  // 🟢 TẢI TẤT CẢ (ĐÃ FIX CRASH)
  // 🟢 TẢI TẤT CẢ (ĐÃ FIX LOGIC VÀ WARNING)
  Future<void> _downloadAllImages() async {
    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Chưa có ảnh nào để tải!")),
      );
      return;
    }

    // Kiểm tra quyền
    if (!await _checkPermission()) return;

    // Biến để cập nhật UI trong Dialog
    // Chúng ta dùng ValueNotifier để truyền số lượng ảnh đang tải vào Dialog mà không cần setState phức tạp
    ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);

    // Hiện Dialog Loading
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr(LocaleData.file_download)),
          content: ValueListenableBuilder<int>(
            valueListenable: progressNotifier,
            builder: (context, current, child) {
              return SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      "${tr(LocaleData.file_downloading)} $current / ${_imageUrls.length} ${tr(LocaleData.file_image)}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    // 🟢 LOGIC TẢI TUẦN TỰ (Chạy ngầm bên dưới Dialog)
    final dio = Dio();
    final tempDir = await getTemporaryDirectory();
    int successCount = 0;

    for (int i = 0; i < _imageUrls.length; i++) {
      if (!mounted) break;

      // Cập nhật số thứ tự ảnh đang tải để Dialog hiển thị
      progressNotifier.value = i + 1;

      final url = _imageUrls[i];
      final fileName =
          "ecolive_${DateTime.now().millisecondsSinceEpoch}_$i.jpg";
      final tempPath = '${tempDir.path}/$fileName';

      try {
        // 1. Tải về
        await dio.download(url, tempPath);

        // 2. Lưu Gallery
        final saved = await GallerySaver.saveImage(
          tempPath,
          albumName: "Ecolive Images",
        );

        if (saved == true) {
          successCount++;
          // 3. Xóa file temp
          final f = File(tempPath);
          if (await f.exists()) {
            await f.delete();
          }
        }
      } catch (e) {
        debugPrint("Lỗi tải ảnh $i: $e");
      }

      // Nghỉ xả hơi để tránh OOM
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Tắt Dialog
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();

      // Hiện thông báo kết quả
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "${tr(LocaleData.image_downloaded)} $successCount/${_imageUrls.length} ${tr(LocaleData.image)}!"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(tr(LocaleData.file_cannot_out),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: Text(tr(LocaleData.file_cannot_out2)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(tr(LocaleData.ok),
                      style: const TextStyle(color: Colors.blue)),
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
          title: Text(tr(LocaleData.filetoimage)),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _showImageTutorial,
            ),
            IconButton(
              icon: const Icon(Icons.history),
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
                      apiBaseUrl:
                          "https://ecolive-font-converter-docker.onrender.com",
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
                      Text(tr(LocaleData.uploadfile),
                          style: const TextStyle(color: Colors.grey)),
                      if (_uploadedFileName != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          "${tr(LocaleData.file_image_hasbeenchose)} $_uploadedFileName",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(tr(LocaleData.sortofimage),
                  style: const TextStyle(fontSize: 16)),
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
                onChanged: _isLoading
                    ? null
                    : (val) => setState(() => _selectedImageType = val!),
              ),
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
                                      label: Text(tr(LocaleData.downloadall)),
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
                                          label:
                                              Text(tr(LocaleData.downloadbtt)),
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
