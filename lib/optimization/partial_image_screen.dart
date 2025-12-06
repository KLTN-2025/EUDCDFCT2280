import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:http/http.dart' as http;
import 'package:ecolive/view/history_screen.dart';

class PartialExportScreen extends StatefulWidget {
  final List<String> imageUrls;
  final String originalFileName;
  final String apiBaseUrl;

  const PartialExportScreen({
    Key? key,
    required this.imageUrls,
    required this.originalFileName,
    required this.apiBaseUrl,
  }) : super(key: key);

  @override
  State<PartialExportScreen> createState() => _PartialExportScreenState();
}

class _PartialExportScreenState extends State<PartialExportScreen> {
  // 🟢 Key: Index của ảnh, Value: Loại file (PNG, JPG...)
  // Nếu index tồn tại trong Map nghĩa là ảnh đó ĐƯỢC CHỌN.
  final Map<int, String> _selectedItems = {};

  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Mặc định chọn tất cả là JPG lúc đầu
    for (int i = 0; i < widget.imageUrls.length; i++) {
      _selectedItems[i] = 'JPG';
    }
  }

  // Chọn / Bỏ chọn ảnh
  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.containsKey(index)) {
        _selectedItems.remove(index);
      } else {
        // Mặc định khi chọn lại là JPG
        _selectedItems[index] = 'JPG';
      }
    });
  }

  // Chọn tất cả / Bỏ chọn tất cả
  void _toggleSelectAll() {
    setState(() {
      if (_selectedItems.length == widget.imageUrls.length) {
        _selectedItems.clear();
      } else {
        for (int i = 0; i < widget.imageUrls.length; i++) {
          _selectedItems[i] = 'JPG';
        }
      }
    });
  }

  // 🟢 Hàm đổi định dạng cho 1 ảnh cụ thể
  void _changeFormat(int index, String? newFormat) {
    if (newFormat == null) return;
    setState(() {
      _selectedItems[index] = newFormat;
    });
  }

  Future<void> _exportSelectedImages() async {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(LocaleData.image_please_choose))),
      );
      return;
    }

    setState(() => _isExporting = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous_user";

      // 🟢 Chuẩn bị dữ liệu danh sách items (URL + Loại ảnh)
      List<Map<String, String>> itemsToSend = [];

      // Duyệt qua Map để lấy các ảnh đã chọn
      // Lưu ý: Cần sort theo index để thứ tự ảnh không bị lộn xộn
      var sortedKeys = _selectedItems.keys.toList()..sort();

      for (var index in sortedKeys) {
        itemsToSend.add({
          "url": widget.imageUrls[index],
          "image_type":
              _selectedItems[index]!, // Lấy định dạng riêng của ảnh đó
        });
      }

      final uri = Uri.parse("${widget.apiBaseUrl}/save-selected-images");

      // JSON Body mới gửi list items
      final body = jsonEncode({
        "user_id": userId,
        "original_filename": widget.originalFileName,
        "items": itemsToSend,
      });

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(LocaleData.image_exported_success))),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryScreen(
              userId: userId,
              apiBaseUrl: widget.apiBaseUrl,
            ),
          ),
          (route) => route.isFirst,
        );
      } else {
        throw Exception("Lỗi server: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Lỗi xuất ảnh: $e")),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.image_adjust_sepe)),
        actions: [
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _selectedItems.length == widget.imageUrls.length
                  ? tr(LocaleData.image_cancel)
                  : tr(LocaleData.image_all),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Grid Ảnh
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7, // 🟢 Tăng chiều cao ô để chứa Dropdown
              ),
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                final url = widget.imageUrls[index];
                final isSelected = _selectedItems.containsKey(index);
                final currentFormat = _selectedItems[index] ?? 'JPG';

                return GestureDetector(
                  onTap: () => _toggleSelection(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 3)
                          : Border.all(color: Colors.grey[300]!),
                      color: Colors.white,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 6)
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Phần Ảnh
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(9)),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (ctx, child, loading) {
                                      if (loading == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2));
                                    },
                                    errorBuilder: (ctx, err, _) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              // Checkbox tròn
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                    size: 28,
                                  ),
                                ),
                              ),
                              // Số trang
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      tr(LocaleData.image_page) +
                                          " ${index + 1}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🟢 Phần Dropdown chọn định dạng (Chỉ hiện khi được chọn)
                        if (isSelected)
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(9)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr(LocaleData.image_type),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                DropdownButton<String>(
                                  value: currentFormat,
                                  dropdownColor: Colors.blue[700],
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white, size: 20),
                                  underline:
                                      const SizedBox(), // Xóa gạch chân mặc định
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  items: ['JPG', 'PNG', 'JPEG', 'WEBP']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) => _changeFormat(index, val),
                                ),
                              ],
                            ),
                          )
                        else
                          // Placeholder khi không chọn
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(9)),
                            ),
                            child: Text(tr(LocaleData.image_tap_to_choose),
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Nút Export ở dưới cùng
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))
            ]),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isExporting ? null : _exportSelectedImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isExporting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: Colors.white),
                            const SizedBox(width: 10),
                            Text(tr(LocaleData.file_processing))
                          ],
                        )
                      : Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          tr(LocaleData.image_exported) +
                              " ${_selectedItems.length} " +
                              tr(LocaleData.image_to_history),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
