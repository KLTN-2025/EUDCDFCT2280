import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      // final url = Uri.parse(
      //     '${widget.apiBaseUrl}/get-history?user_id=${widget.userId}');
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
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image,
                                                color: Colors.grey)),
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

  void _showImagePreview(
      BuildContext context, String filename, List<String> images) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ảnh từ file: $filename",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            if (images.isEmpty)
              const Text("Không có ảnh được lưu.")
            else
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        images[i],
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text("Đóng"),
            ),
          ],
        ),
      ),
    );
  }
}
