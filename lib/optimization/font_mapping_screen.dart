import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FontMappingScreen extends StatefulWidget {
  final String filePath; // Đây là S3 URL
  final List<String> detectedFonts;
  final List<String> availableFonts;

  const FontMappingScreen({
    Key? key,
    required this.filePath,
    required this.detectedFonts,
    required this.availableFonts,
  }) : super(key: key);

  @override
  State<FontMappingScreen> createState() => _FontMappingScreenState();
}

class _FontMappingScreenState extends State<FontMappingScreen> {
  // ✅ SỬA LỖI 1: Dùng đúng BaseURL của Render
  final dio = Dio(BaseOptions(
    baseUrl: 'https://ecolive-font-converter-docker.onrender.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // mapping font
  Map<String, String> fontMapping = {};
  bool loading = false;
  String? resultUrl;

  @override
  void initState() {
    super.initState();
    // Logic khởi tạo này của bạn là đúng
    for (var f in widget.detectedFonts) {
      if (widget.availableFonts.isNotEmpty) {
        fontMapping[f] = widget.availableFonts.first;
      }
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> convertWithMapping() async {
    setState(() => loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;

      // ✅ SỬA LỖI 2: Gửi 'file_url' (String), không phải 'file' (Multipart)
      final form = FormData.fromMap({
        'file_url': widget.filePath, // widget.filePath đã là S3 URL
        'mapping': jsonEncode(fontMapping),
        'user_id': user?.uid, // Gửi kèm user_id nếu backend cần
      });

      // ✅ SỬA LỖI 3: Dùng đúng tên endpoint
      final r = await dio.post('/convert-font-mapping', data: form);

      final url = r.data['result_url'];
      if (url != null) {
        setState(() => resultUrl = url);

        // ✅ SỬA LỖI 4 (UX): Thông báo thành công và quay lại
        _showSnack("✅ Chuyển đổi mapping thành công!");

        // Tự động quay về màn hình trước sau 1 giây
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _showSnack("Lỗi: Không nhận được URL kết quả!", isError: true);
      }
    } catch (e) {
      debugPrint("❌ Lỗi convert mapping: $e");
      _showSnack("Lỗi convert: $e", isError: true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chuyển từng đoạn / Mapping Font")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Chọn font mới cho từng font gốc:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: widget.detectedFonts.length,
                itemBuilder: (ctx, i) {
                  final f = widget.detectedFonts[i];
                  return Card(
                    child: ListTile(
                      title: Text(f,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: DropdownButtonFormField<String>(
                        value: fontMapping[f],
                        items: widget.availableFonts
                            .map((ff) => DropdownMenuItem(
                                  value: ff,
                                  child: Text(ff),
                                ))
                            .toList(),
                        onChanged: (v) => setState(
                            () => fontMapping[f] = v!), // Sửa: v! an toàn hơn
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else
              ElevatedButton.icon(
                onPressed: loading ? null : convertWithMapping,
                icon: const Icon(Icons.check),
                label: const Text("Xác nhận chuyển"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),

            // Không cần hiển thị resultUrl ở đây nữa vì chúng ta đã pop màn hình
            if (resultUrl != null) ...[
              const SizedBox(height: 12),
              const Text("✅ Đã chuyển xong!"),
            ]
          ],
        ),
      ),
    );
  }
}
