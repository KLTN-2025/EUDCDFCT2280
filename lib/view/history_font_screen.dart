import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FontHistoryScreen extends StatefulWidget {
  final String userId;
  final String apiBaseUrl;

  const FontHistoryScreen(
      {super.key, required this.userId, required this.apiBaseUrl});

  @override
  State<FontHistoryScreen> createState() => _FontHistoryScreenState();
}

class _FontHistoryScreenState extends State<FontHistoryScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, dynamic>> _historyList = [];

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
          Uri.parse('$baseUrl/get-font-history?user_id=${widget.userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _historyList = List<Map<String, dynamic>>.from(data['history'] ?? []);
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

  Future<void> _deleteHistoryItem(String historyId) async {
    // Hiển thị dialog loading
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho đóng
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final url = Uri.parse(
          '${widget.apiBaseUrl}/delete-font-history?user_id=${widget.userId}&history_id=$historyId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.hasbeendeleted1file))),
        );
        _fetchHistory(); // Reload danh sách
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Xóa thất bại: ${response.body}')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Lỗi: $e')),
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
          '${widget.apiBaseUrl}/clear-font-history?user_id=${widget.userId}');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.hasbeendeleted))),
        );
        _fetchHistory();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Xóa toàn bộ thất bại: ${response.body}')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Lỗi: $e')),
      );
    } finally {
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.pop(context);
    }
  }

  String _formatTimestamp(String ts) {
    try {
      // 1. Parse chuỗi thời gian từ Server (đang là UTC)
      final dtUtc = DateTime.parse(ts);

      // 2. Chuyển đổi sang múi giờ của thiết bị (Local Time - GMT+7)
      final dtLocal = dtUtc.toLocal();

      // 3. Format cho đẹp (thêm số 0 vào trước phút nếu < 10)
      String minute = dtLocal.minute.toString().padLeft(2, '0');
      String hour = dtLocal.hour.toString().padLeft(2, '0');
      String day = dtLocal.day.toString().padLeft(2, '0');
      String month = dtLocal.month.toString().padLeft(2, '0');

      return "$hour:$minute - $day/$month/${dtLocal.year}";
    } catch (_) {
      return ts;
    }
  }

  // 🟢 HÀM MỚI: Tải và mở lại file từ lịch sử
  // ignore: unused_element
  Future<void> _downloadAndOpenOldFile(
      String? url, String? originalName) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ File này không có link tải!")),
      );
      return;
    }

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
          ],
        ),
      ),
    );

    try {
      // 1. Tạo đường dẫn file tạm
      final tempDir = await getTemporaryDirectory();
      // Lấy đuôi file (docx/pdf) từ URL hoặc tên gốc
      String extension = "docx";
      if (originalName != null && originalName.contains(".")) {
        extension = originalName.split('.').last;
      }

      // Tạo tên file ngẫu nhiên để tránh cache cũ
      final fileName =
          "history_${DateTime.now().millisecondsSinceEpoch}.$extension";
      final savePath = "${tempDir.path}/$fileName";

      // 2. Tải về bằng Dio
      await Dio().download(url, savePath);

      // 3. Tắt loading
      if (mounted) Navigator.pop(context);

      // 4. Mở file
      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Không thể mở file: ${result.message}")),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Tắt loading nếu lỗi
      // ignore: avoid_print
      print("Download error: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.font_history_screen)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              // ... (Giữ nguyên logic xóa all) ...
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
              if (confirm == true) await _clearAllHistory();
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
                  ? Center(child: Text(tr(LocaleData.historystatus)))
                  : ListView.builder(
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        final item = _historyList[index];
                        final filename =
                            item['original_filename'] ?? 'Không có tên';
                        final timestamp =
                            _formatTimestamp(item['timestamp'] ?? '');
                        final resultUrl = item['result_url']; // Lấy link tải

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            // 🟢 SỰ KIỆN: Bấm vào item -> Tải & Mở
                            onTap: () =>
                                _downloadAndOpenOldFile(resultUrl, filename),
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: const Icon(Icons.description,
                                  size: 40, color: Colors.blueAccent),
                              title: Text(filename,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("⏱ $timestamp",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  if (item['target_font'] != null)
                                    Text("Font: ${item['target_font']}",
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 12)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Nút tải về nhỏ (để user biết là bấm được)
                                  IconButton(
                                    icon: const Icon(Icons.download_rounded,
                                        color: Colors.blue),
                                    onPressed: () => _downloadAndOpenOldFile(
                                        resultUrl, filename),
                                  ),
                                  // Nút xóa
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      // ... (Logic xóa giữ nguyên) ...
                                      final confirm = await showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title:
                                              Text(tr(LocaleData.font_delete)),
                                          content: Text(
                                              tr(LocaleData.font_delete_sure)),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: Text(
                                                    tr(LocaleData.cancel))),
                                            TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: Text(
                                                    tr(LocaleData.deletebtt))),
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
                          ),
                        );
                      },
                    ),
    );
  }
}
