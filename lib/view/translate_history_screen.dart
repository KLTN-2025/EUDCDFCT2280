import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:file_saver/file_saver.dart'; // 🟢 Giữ FileSaver

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

  // --- CÁC HÀM XÓA & LẤY DỮ LIỆU ---

  Future<void> _deleteSingleHistory(String historyId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final baseUrl = widget.apiBaseUrl.startsWith('http')
          ? widget.apiBaseUrl
          : 'https://${widget.apiBaseUrl}';

      final url = Uri.parse(
        '$baseUrl/delete-translate-history?user_id=${widget.userId}&history_id=$historyId',
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          _historyList.removeWhere((item) => item['id'] == historyId);
        });
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr(LocaleData.hasbeendeleted1file))),
          );
        }
      } else {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Không thể xóa mục này")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${tr(LocaleData.language_error)} $e")),
        );
      }
    } finally {
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
      final baseUrl = widget.apiBaseUrl.startsWith('http')
          ? widget.apiBaseUrl
          : 'https://${widget.apiBaseUrl}';

      final url = Uri.parse(
        '$baseUrl/clear-translate-history?user_id=${widget.userId}',
      );

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() => _historyList.clear());
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr(LocaleData.hasbeendeleted))),
          );
        }
      } else {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ Không thể xóa tất cả")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Lỗi: $e")),
        );
      }
    } finally {
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    }
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

  // 🟢 1. HÀM MỚI: TẢI VÀ MỞ FILE NGAY LẬP TỨC (Dùng cho nút Icon)
  Future<void> _downloadAndOpenFile(String fileUrl, String filename) async {
    if (fileUrl.isEmpty) return;

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${tr(LocaleData.downloading)} $filename..."),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }

      // Tải về RAM
      var response = await Dio().get(
        fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Xử lý tên file + Timestamp để tránh trùng
      String extension = "docx";
      String nameWithoutExt = filename;
      if (filename.contains(".")) {
        List<String> parts = filename.split(".");
        extension = parts.last;
        parts.removeLast();
        nameWithoutExt = parts.join(".");
      }
      String finalName =
          "${nameWithoutExt}_${DateTime.now().millisecondsSinceEpoch}";

      // Lưu file
      String resultPath = await FileSaver.instance.saveFile(
        name: finalName,
        bytes: response.data,
        ext: extension,
        mimeType: MimeType.other,
      );

      // Mở file ngay lập tức
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(LocaleData.downloadcompleted)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // 🔥 Tự động bật Word lên
        await OpenFilex.open(resultPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // 🟢 2. UI BOTTOM SHEET CŨ (Dùng cho sự kiện Tap vào dòng)
  void _showTranslatePreview(
      BuildContext context, String fileUrl, String filename) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        double downloadProgress = 0.0;
        bool downloading = false;
        bool completed = false;

        return StatefulBuilder(builder: (context, setStateSheet) {
          Future<void> startDownload() async {
            setStateSheet(() {
              downloading = true;
              downloadProgress = 0.0;
            });

            try {
              var response = await Dio().get(
                fileUrl,
                options: Options(responseType: ResponseType.bytes),
                onReceiveProgress: (rec, total) {
                  if (total != -1) {
                    setStateSheet(() {
                      downloadProgress = rec / total;
                    });
                  }
                },
              );

              String extension = "docx";
              String nameWithoutExt = filename;
              if (filename.contains(".")) {
                List<String> parts = filename.split(".");
                extension = parts.last;
                parts.removeLast();
                nameWithoutExt = parts.join(".");
              }
              String finalName =
                  "${nameWithoutExt}_${DateTime.now().millisecondsSinceEpoch}";

              String resultPath = await FileSaver.instance.saveFile(
                name: finalName,
                bytes: response.data,
                ext: extension,
                mimeType: MimeType.other,
              );

              setStateSheet(() {
                downloadProgress = 1.0;
                completed = true;
                downloading = false;
              });

              if (context.mounted) {
                await OpenFilex.open(resultPath);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            } catch (e) {
              setStateSheet(() => downloading = false);
            }
          }

          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (_, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        tr(LocaleData.download_file_trans),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      if (downloading) ...[
                        LinearProgressIndicator(
                          value: downloadProgress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        Center(
                            child: Text(
                                "${(downloadProgress * 100).toStringAsFixed(0)}%")),
                      ] else if (completed) ...[
                        Center(
                            child: Text(tr(LocaleData.download_already),
                                style: const TextStyle(color: Colors.green))),
                      ],
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: Text(
                            tr(LocaleData.download_this_file),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: downloading ? null : startDownload,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.historyconvertedfilelanguage)),
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
                      padding: const EdgeInsets.all(12),
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        final item = _historyList[index];
                        final filename =
                            item['original_filename'] ?? 'output.docx';
                        final timestamp = _formatTimestamp(item['timestamp']);
                        final source =
                            item['source_lang']?.toUpperCase() ?? 'AUTO';
                        final target =
                            item['target_lang']?.toUpperCase() ?? 'UNKNOWN';

                        final fileUrl = (item['result_url'] ??
                            item['fileUrl'] ??
                            item['outputUrl']) as String?;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F4FF),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            leading: const Icon(
                              Icons.description_rounded,
                              color: Colors.blue,
                              size: 42,
                            ),
                            title: Text(
                              "${tr(LocaleData.historyconvertedfiletolanguagetranslated)}$source → $target",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  filename,
                                  style: const TextStyle(
                                      fontSize: 13.5, color: Colors.black87),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      timestamp,
                                      style: const TextStyle(
                                          fontSize: 12.5, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // 🟢 CẬP NHẬT: Trailing chứa cả Delete và Download
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                              child:
                                                  Text(tr(LocaleData.cancel))),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text(
                                                  tr(LocaleData.deletebtt))),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await _deleteSingleHistory(item['id']);
                                    }
                                  },
                                ),
                                // 🔥 Nút Download: Gọi hàm tải & mở ngay (Bỏ qua Bottom Sheet)
                                IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Colors.blueAccent),
                                  onPressed: () {
                                    if (fileUrl != null && fileUrl.isNotEmpty) {
                                      _downloadAndOpenFile(fileUrl, filename);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("⚠️ File không tồn tại")),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            // Sự kiện Tap vào item: Vẫn hiện Preview Bottom Sheet (để xem kỹ hơn)
                            onTap: () {
                              if (fileUrl != null && fileUrl.isNotEmpty) {
                                _showTranslatePreview(
                                    context, fileUrl, filename);
                              }
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
