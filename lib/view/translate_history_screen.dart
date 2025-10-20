import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateHistoryScreen extends StatefulWidget {
  final String userId;
  final String apiBaseUrl;

  const TranslateHistoryScreen({
    Key? key,
    required this.userId,
    required this.apiBaseUrl,
  }) : super(key: key);

  @override
  State<TranslateHistoryScreen> createState() => _TranslateHistoryScreenState();
}

class _TranslateHistoryScreenState extends State<TranslateHistoryScreen> {
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
      final url =
          Uri.parse('$baseUrl/get-translate-history?user_id=${widget.userId}');
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
      print('⚠️ Fetch translate history error: $e');
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

  Future<File?> _downloadTranslatedFile(String url, String filename) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Cần quyền lưu file')),
        );
        return null;
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⏳ Đang tải file...')),
      );

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getExternalStorageDirectory();
        final file = File('${directory!.path}/$filename');
        await file.writeAsBytes(bytes);
        return file;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Không thể tải file (${response.statusCode})'),
          ),
        );
        return null;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Lỗi tải file: $e')),
      );
      return null;
    }
  }

  Future<int> _downloadAllTranslatedFilesInList(
    void Function(void Function()) setStateDialog,
  ) async {
    if (_historyList.isEmpty) return 0;

    final perm = await Permission.storage.request();
    if (!perm.isGranted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Cần quyền lưu file')),
      );
      return 0;
    }

    // thông báo bắt đầu
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏳ Đang tải tất cả file...')),
    );

    final dir = await getExternalStorageDirectory();
    final folderPath = '${dir!.path}/TranslatedFiles';
    final folder = Directory(folderPath);
    if (!await folder.exists()) await folder.create(recursive: true);

    int success = 0;
    for (int i = 0; i < _historyList.length; i++) {
      final item = _historyList[i];
      final url = item['result_url'];
      final filename = item['original_filename'] ??
          'translated_${DateTime.now().millisecondsSinceEpoch}.docx';

      // cập nhật tiến trình dialog (nếu có)
      setStateDialog(() {});

      if (url == null) continue;

      try {
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode == 200) {
          final file = File('$folderPath/$filename');
          await file.writeAsBytes(resp.bodyBytes);
          success++;
        }
      } catch (_) {
        // bỏ qua lỗi 1 file, tiếp tục các file khác
      }
    }

    return success;
  }

  void _showTranslatePreview(
    BuildContext rootContext,
    Map<String, dynamic> item,
  ) {
    final filename = item['original_filename'] ?? 'Không có tên';
    final source = item['source_lang'] ?? 'auto';
    final target = item['target_lang'] ?? 'unknown';
    final fileUrl = item['result_url'];
    final time = _formatTimestamp(item['timestamp']);

    showModalBottomSheet(
      context: rootContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool isDownloading = false;
        bool isDownloaded = false;
        bool isDownloadingAll = false;
        File? downloadedFile;

        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: FractionallySizedBox(
                heightFactor: 0.55,
                widthFactor: 0.95,
                child: Material(
                  color: Colors.white,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Bản dịch: ${source.toUpperCase()} → ${target.toUpperCase()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text("📄 $filename"),
                        Text("⏱ $time",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 16),

                        // nút tải file hiện tại
                        if (isDownloading)
                          const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text("⏳ Đang tải file..."),
                            ],
                          )
                        else if (isDownloaded && downloadedFile != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              OpenFilex.open(downloadedFile!.path);
                            },
                            icon: const Icon(Icons.open_in_new_rounded),
                            label: const Text("📂 Mở file"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: fileUrl != null
                                ? () async {
                                    setState(() => isDownloading = true);
                                    final file = await _downloadTranslatedFile(
                                        fileUrl, filename);
                                    setState(() {
                                      isDownloading = false;
                                      if (file != null) {
                                        isDownloaded = true;
                                        downloadedFile = file;
                                      }
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.download_rounded),
                            label: const Text("Tải file dịch"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),

                        const SizedBox(height: 12),

                        // NÚT: Tải tất cả file trong lịch sử (ở trong dialog)
                        if (isDownloadingAll)
                          const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text("⏳ Đang tải tất cả file..."),
                            ],
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () async {
                              // bắt đầu tải tất cả
                              setState(() {
                                isDownloadingAll = true;
                              });

                              final success =
                                  await _downloadAllTranslatedFilesInList(
                                      setState);

                              setState(() {
                                isDownloadingAll = false;
                              });

                              // thông báo kết quả
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('✅ Đã tải $success file')),
                              );
                            },
                            icon:
                                const Icon(Icons.download_for_offline_rounded),
                            label: const Text("Tải tất cả file trong lịch sử"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),

                        const Spacer(),

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử dịch file"),
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
                  ? const Center(child: Text("Chưa có lịch sử dịch nào."))
                  : ListView.builder(
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        final item = _historyList[index];
                        final filename =
                            item['original_filename'] ?? 'Không có tên';
                        final timestamp = _formatTimestamp(item['timestamp']);
                        final source = item['source_lang'] ?? 'auto';
                        final target = item['target_lang'] ?? 'unknown';

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            // leading: const Icon(Icons.description_rounded,
                            //     color: Colors.blue, size: 45),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item['thumbnail_url'] != null
                                  ? Image.network(
                                      item['thumbnail_url'],
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  size: 45, color: Colors.grey),
                                    )
                                  : const Icon(Icons.description_rounded,
                                      color: Colors.blue, size: 45),
                            ),

                            title: Text(
                              "Dịch: ${source.toUpperCase()} → ${target.toUpperCase()}",
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
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  size: 18, color: Colors.blue),
                              onPressed: () =>
                                  _showTranslatePreview(context, item),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
