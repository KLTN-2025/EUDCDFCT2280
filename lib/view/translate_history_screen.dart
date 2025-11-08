import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';

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

  // ignore: unused_element
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

        return StatefulBuilder(builder: (context, setState) {
          Future<void> startDownload() async {
            setState(() {
              downloading = true;
              downloadProgress = 0.1;
            });

            try {
              final dir = await getExternalStorageDirectory();
              final folderPath = '${dir!.path}/TranslatedFiles';
              await Directory(folderPath).create(recursive: true);

              final safeName =
                  filename.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
              final savePath = '$folderPath/$safeName';

              final dio = Dio();
              await dio.download(
                fileUrl,
                savePath,
                onReceiveProgress: (rec, total) {
                  if (total != -1) {
                    setState(() {
                      downloadProgress = rec / total;
                    });
                  }
                },
              );

              setState(() {
                downloadProgress = 1.0;
                completed = true;
                downloading = false;
              });

              // ✅ Hiện snackbar + tự mở file
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Đã tải $filename')),
                );

                await OpenFilex.open(savePath);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            } catch (e) {
              setState(() {
                downloading = false;
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('⚠️ Lỗi khi tải file: $e')),
                );
              }
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
                        'Tải file dịch',
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
                        const Center(child: Text('⏳ Đang tải...')),
                      ] else if (completed) ...[
                        const Center(child: Text('✅ Hoàn tất tải xuống')),
                      ],
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text(
                            'Tải file này',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            backgroundColor: Colors.blue[600],
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
                        padding: const EdgeInsets.all(12),
                        itemCount: _historyList.length,
                        itemBuilder: (context, index) {
                          final item = _historyList[index];
                          final filename =
                              item['original_filename'] ?? 'Không có tên';
                          final timestamp = _formatTimestamp(item['timestamp']);
                          final source =
                              item['source_lang']?.toUpperCase() ?? 'AUTO';
                          final target =
                              item['target_lang']?.toUpperCase() ?? 'UNKNOWN';

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFF6F4FF), // Màu nền pastel nhẹ
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
                                "Dịch: $source → $target",
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
                              trailing: const Icon(Icons.download,
                                  size: 18, color: Colors.blueAccent),
                              onTap: () async {
                                try {
                                  // 🔹 1. Lấy URL tải file
                                  final fileUrl = (item['result_url'] ??
                                      item['fileUrl'] ??
                                      item['outputUrl']) as String?;
                                  if (fileUrl == null || fileUrl.isEmpty) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '⚠️ Không có đường dẫn file để tải.')),
                                      );
                                    }
                                    return;
                                  }

                                  // 🔹 2. Lấy tên file (ưu tiên từ backend, nếu không thì lấy từ URL)
                                  final uri = Uri.parse(fileUrl);
                                  String fileNameFromUrl =
                                      uri.pathSegments.isNotEmpty
                                          ? uri.pathSegments.last
                                          : 'output_unknown';
                                  final fileName =
                                      (item['fileName'] as String?) ??
                                          fileNameFromUrl;
                                  final safeName = fileName.replaceAll(
                                      RegExp(r'[\\/:*?"<>|]'), '_');

                                  // 🔹 3. Xin quyền lưu file
                                  final status = await Permission
                                      .manageExternalStorage
                                      .request();
                                  if (!status.isGranted) {
                                    if (mounted) {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                '⚠️ Không có quyền lưu hoặc mở file ngoài.')),
                                      );
                                    }
                                    return;
                                  }

                                  // 🔹 4. Tạo thư mục lưu
                                  final downloadsDir = Directory(
                                      '/storage/emulated/0/Download/Ecolive_Translated');
                                  await downloadsDir.create(recursive: true);
                                  final savePath =
                                      '${downloadsDir.path}/$safeName';

                                  // 🔹 5. Hiển thị hộp thoại tải
                                  double progress = 0.0;
                                  final cancelToken = CancelToken();

                                  if (!mounted) return;
                                  showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) {
                                      return StatefulBuilder(
                                          builder: (ctx, setState) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          title: const Text('Đang tải file...'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              LinearProgressIndicator(
                                                  value: progress),
                                              const SizedBox(height: 10),
                                              Text(
                                                  '${(progress * 100).toStringAsFixed(0)}%'),
                                              const SizedBox(height: 10),
                                              TextButton(
                                                onPressed: () {
                                                  cancelToken.cancel();
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('Hủy'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );

                                  // 🔹 6. Bắt đầu tải file
                                  await Dio().download(
                                    fileUrl,
                                    savePath,
                                    cancelToken: cancelToken,
                                    onReceiveProgress: (received, total) {
                                      if (total != -1) {
                                        progress = received / total;
                                        (context as Element).markNeedsBuild();
                                      }
                                    },
                                  );

                                  if (context.mounted)
                                    // ignore: curly_braces_in_flow_control_structures
                                    Navigator.of(context).pop();

                                  // 🔹 7. Thông báo hoàn tất
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '✅ Đã tải xong $safeName vào thư mục Download/Ecolive_Translated')),
                                    );
                                  }

                                  // 🔹 8. Chờ hệ thống ghi file rồi mở
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  await OpenFilex.open(savePath);
                                } catch (e) {
                                  if (context.mounted)
                                    // ignore: curly_braces_in_flow_control_structures
                                    Navigator.of(context).pop();
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '⚠️ Lỗi khi tải hoặc mở file: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ));
  }
}
