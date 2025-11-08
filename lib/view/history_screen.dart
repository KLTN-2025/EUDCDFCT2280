import 'dart:convert';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class HistoryScreen extends StatefulWidget {
  final String userId;
  final String apiBaseUrl;

  const HistoryScreen({
    Key? key,
    required this.userId,
    required this.apiBaseUrl,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _historyList = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final baseUrl = widget.apiBaseUrl.startsWith('http')
          ? widget.apiBaseUrl
          : 'https://${widget.apiBaseUrl}';
      final url = Uri.parse('$baseUrl/get-history?user_id=${widget.userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _historyList = data['history'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Fetch error: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _formatTimestamp(String? isoTime) {
    if (isoTime == null) return "Không rõ thời gian";
    try {
      final dt = DateTime.parse(isoTime).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return "Không rõ thời gian";
    }
  }

  /// 🖼 Tải 1 ảnh & mở ảnh đó sau khi lưu
  Future<void> _downloadSingleImage(
      BuildContext context, String imageUrl) async {
    try {
      if (Platform.isAndroid) {
        final p = await Permission.photos.request();
        if (!p.isGranted) {
          final p2 = await Permission.storage.request();
          if (!p2.isGranted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('⚠️ Cần quyền truy cập để lưu ảnh')),
            );
            return;
          }
        }
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⏳ Đang tải ảnh...')),
      );

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await Directory.systemTemp.createTemp('ecolive_images');
        final fileName = imageUrl.split('/').last.split('?').first;
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);

        final success = await GallerySaver.saveImage(file.path,
            albumName: "Converted Images");
        if (success == true) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Ảnh đã lưu vào thư viện!'),
              action: SnackBarAction(
                label: 'Mở ảnh',
                onPressed: () {
                  OpenFilex.open(file.path);
                },
              ),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ Lưu ảnh thất bại')),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ Không thể tải ảnh (${response.statusCode})')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Lỗi tải ảnh: $e')),
      );
    }
  }

  /// 📦 Tải tất cả ảnh trong 1 mục
  Future<void> _downloadAllImages(
      BuildContext context, List<String> images) async {
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có ảnh nào để tải')),
      );
      return;
    }

    if (Platform.isAndroid) {
      final p = await Permission.photos.request();
      if (!p.isGranted) {
        final p2 = await Permission.storage.request();
        if (!p2.isGranted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ Cần quyền để lưu ảnh')),
          );
          return;
        }
      }
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏳ Đang tải tất cả ảnh...')),
    );

    int successCount = 0;
    for (final rawUrl in images) {
      final imageUrl =
          rawUrl.startsWith('http') ? rawUrl : '${widget.apiBaseUrl}$rawUrl';
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final tempDir =
              await Directory.systemTemp.createTemp('ecolive_images');
          final fileName = imageUrl.split('/').last.split('?').first;
          final file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(bytes);
          final saved = await GallerySaver.saveImage(file.path,
              albumName: "Converted Images");
          if (saved == true) successCount++;
        }
      } catch (_) {}
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('✅ Đã lưu $successCount / ${images.length} ảnh vào thư viện!'),
        action: SnackBarAction(
          label: 'Mở thư viện',
          onPressed: () => OpenFilex.open("storage/emulated/0/Pictures"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử chuyển đổi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text("Không thể tải lịch sử."))
              : _historyList.isEmpty
                  ? const Center(child: Text("Chưa có lịch sử nào."))
                  : ListView.builder(
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        final item = _historyList[index];
                        final filename =
                            item['original_filename'] ?? 'Không có tên';
                        final timestamp = _formatTimestamp(item['timestamp']);
                        final images =
                            List<String>.from(item['image_urls'] ?? []);
                        final firstImage =
                            images.isNotEmpty ? images.first : null;

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: firstImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      firstImage.startsWith('http')
                                          ? firstImage
                                          : '${widget.apiBaseUrl}$firstImage',
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported,
                                    size: 45, color: Colors.grey),
                            title: const Text(
                              "Chuyển đổi file → ảnh",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("📄 $filename"),
                                Text("⏱ $timestamp",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  size: 18, color: Colors.blue),
                              onPressed: () =>
                                  _showImagePreview(context, filename, images),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  /// 🔍 Hiển thị danh sách ảnh + nút tải + mở ảnh
  void _showImagePreview(
    BuildContext rootContext,
    String filename,
    List<String> images,
  ) {
    showModalBottomSheet(
      context: rootContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isDownloading = false;
        bool isDownloaded = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: FractionallySizedBox(
                heightFactor: 0.6, // 👈 Chiều cao 60% màn hình, nằm giữa
                widthFactor: 0.95,
                child: Material(
                  color: Colors.white,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ảnh từ file: $filename",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        if (isDownloading)
                          const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text("⏳ Đang tải ảnh..."),
                            ],
                          ),
                        if (images.isEmpty)
                          const Text("Không có ảnh được lưu.")
                        else
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, i) {
                                final imgUrl = images[i];
                                return Container(
                                  width: 220,
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: GestureDetector(
                                            onTap: () {
                                              // 🔍 Zoom in ảnh
                                              showDialog(
                                                context: context,
                                                builder: (_) => Dialog(
                                                  backgroundColor: Colors.black,
                                                  child: InteractiveViewer(
                                                    minScale: 0.8,
                                                    maxScale: 5,
                                                    child: Image.network(
                                                      imgUrl,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.network(
                                              imgUrl,
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              errorBuilder:
                                                  (context, error, _) =>
                                                      const Icon(
                                                Icons.broken_image,
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "🔄 Đang tải ảnh này..."),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );

                                          setState(() => isDownloading = true);
                                          await _downloadSingleImage(
                                              rootContext, imgUrl);
                                          setState(() {
                                            isDownloading = false;
                                            isDownloaded = true;
                                          });

                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("✅ Ảnh đã được tải!"),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.download,
                                            size: 16),
                                        label: const Text("Tải ảnh này"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (!isDownloaded)
                          ElevatedButton.icon(
                            onPressed: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("🔄 Đang tải tất cả ảnh..."),
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              setState(() => isDownloading = true);
                              await _downloadAllImages(rootContext, images);
                              setState(() {
                                isDownloading = false;
                                isDownloaded = true;
                              });

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("✅ Tải xong tất cả ảnh!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon:
                                const Icon(Icons.download_for_offline_rounded),
                            label: const Text("Tải tất cả ảnh"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () async {
                              // 🚀 Mở ứng dụng thư viện mặc định
                              const intent = AndroidIntent(
                                action: 'android.intent.action.MAIN',
                                category: 'android.intent.category.APP_GALLERY',
                                flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                              );
                              await intent.launch();
                            }, 
                            icon: const Icon(Icons.photo_library_rounded),
                            label: const Text("📸 Mở thư viện"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: const Text("Đóng"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
