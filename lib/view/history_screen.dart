import 'dart:convert';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
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
        SnackBar(content: Text(tr(LocaleData.downloading_image))),
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
              content: Text(tr(LocaleData.file_hasbeensaved)),
              action: SnackBarAction(
                label: tr(LocaleData.file_open),
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
              // ignore: prefer_interpolation_to_compose_strings
              content: Text(tr(LocaleData.cannot_open_file) +
                  ' (${response.statusCode})')),
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
        SnackBar(content: Text(tr(LocaleData.no_image_to_download))),
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
      SnackBar(content: Text(tr(LocaleData.download_all_image))),
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
        // ignore: prefer_interpolation_to_compose_strings
        content: Text(tr(LocaleData.file_saved) +
            ' $successCount / ${images.length} ' +
            tr(LocaleData.image_to_gallery)),
        action: SnackBarAction(
          label: tr(LocaleData.open_gallery),
          onPressed: () => OpenFilex.open("storage/emulated/0/Pictures"),
        ),
      ),
    );
  }

  Future<void> _deleteHistoryItem(String historyId) async {
    // Hiển thị dialog loading
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho đóng
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final url = Uri.parse(
          '${widget.apiBaseUrl}/delete-image-history?user_id=${widget.userId}&history_id=$historyId');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.hasbeendeleted1image))),
        );

        setState(() {
          _historyList.removeWhere((item) => item['id'] == historyId);
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Lỗi xóa: ${response.body}')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Lỗi: $e")),
      );
    } finally {
      // Đóng dialog loading
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _clearAllHistory() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final url = Uri.parse(
          '${widget.apiBaseUrl}/clear-image-history?user_id=${widget.userId}');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.hasbeendeleted))),
        );

        setState(() => _historyList.clear());
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Lỗi xóa tất cả: ${response.body}')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Lỗi: $e")),
      );
    } finally {
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.historyconvertedfiletoimage)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(tr(LocaleData.deletewholehistory)),
                  content: Text(tr(LocaleData.deletewholehistory2)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(tr(LocaleData.cancel))),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(tr(LocaleData.deletebtt))),
                  ],
                ),
              );
              if (confirm == true) {
                await _clearAllHistory();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text(tr(LocaleData.cannot_loading)))
              : _historyList.isEmpty
                  ? Center(child: Text(tr(LocaleData.nohistory)))
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
                            // 🟢 🟢 🟢 PHẦN SỬA LỖI: Bọc ảnh trong Container cứng & thêm errorBuilder
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: firstImage != null
                                    ? Image.network(
                                        firstImage.startsWith('http')
                                            ? firstImage
                                            : '${widget.apiBaseUrl}$firstImage',
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            // ignore: curly_braces_in_flow_control_structures
                                            return child;
                                          return const Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2));
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Icon(Icons.broken_image,
                                                  color: Colors.red, size: 24));
                                        },
                                      )
                                    : const Center(
                                        child: Icon(Icons.image_not_supported,
                                            color: Colors.grey)),
                              ),
                            ),
                            // 🟢 🟢 🟢 KẾT THÚC PHẦN SỬA
                            title: Text(
                              tr(LocaleData.convertedfiletoimage),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Nút xem preview ảnh
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye,
                                      color: Colors.blue),
                                  onPressed: () => _showImagePreview(
                                      context, filename, images),
                                ),

                                // Nút xoá lịch sử
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            Text(tr(LocaleData.deleteconfirm)),
                                        content:
                                            Text(tr(LocaleData.deleteconfirm2)),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text(tr(LocaleData.cancel)),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child:
                                                Text(tr(LocaleData.deletebtt)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await _deleteHistoryItem(item['id']);
                                    }
                                  },
                                ),
                              ],
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
                          "${tr(LocaleData.imagefrom)}$filename",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        if (isDownloading)
                          Column(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 10),
                              Text(tr(LocaleData.downloading_image)),
                            ],
                          ),
                        if (images.isEmpty)
                          Text(tr(LocaleData.no_image_saved))
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
                                            SnackBar(
                                              content: Text(tr(LocaleData
                                                  .downloading_image)),
                                              duration:
                                                  const Duration(seconds: 1),
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
                                            SnackBar(
                                              content: Text(tr(
                                                  LocaleData.download_already)),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.download,
                                            size: 16),
                                        label: Text(
                                            tr(LocaleData.downloadthisimage)),
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
                                SnackBar(
                                  content:
                                      Text(tr(LocaleData.download_all_image)),
                                  duration: const Duration(seconds: 1),
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
                                SnackBar(
                                  content: Text(tr(
                                      LocaleData.download_already_all_image)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon:
                                const Icon(Icons.download_for_offline_rounded),
                            label: Text(tr(LocaleData.downloadthisallimage)),
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
                            label: Text(tr(LocaleData.open_gallery)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: Text(tr(LocaleData.close)),
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
