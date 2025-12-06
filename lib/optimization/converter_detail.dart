import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'dart:async';

// Danh sách ngôn ngữ hỗ trợ (Key là hiển thị, Value là mã gửi lên server)
// ignore: constant_identifier_names, non_constant_identifier_names
Map<String, String> SUPPORTED_LANGUAGES = {
  tr(LocaleData.english): 'en',
  tr(LocaleData.french): 'fr',
  tr(LocaleData.german): 'de',
  tr(LocaleData.spanish): 'es',
  tr(LocaleData.portuguese): 'pt',
  tr(LocaleData.russian): 'ru',
  tr(LocaleData.italian): 'it',
  tr(LocaleData.vietnamese): 'vi',
  tr(LocaleData.korean): 'ko',
  tr(LocaleData.chinese): 'zh-CN',
  tr(LocaleData.japanese): 'ja',
};

class SegmentTranslationScreen extends StatefulWidget {
  final List<dynamic> chunks;
  final String? originalFilePath;
  final Map<String, dynamic>? initialResponse;
  final String userId;
  final String targetLang;
  final String backendBaseUrl;
  final String wsUrl;

  const SegmentTranslationScreen({
    super.key,
    required this.chunks,
    this.originalFilePath,
    this.initialResponse,
    required this.userId,
    required this.targetLang,
    required this.backendBaseUrl,
    required this.wsUrl,
  });

  @override
  State<SegmentTranslationScreen> createState() =>
      _SegmentTranslationScreenState();
}

class _SegmentTranslationScreenState extends State<SegmentTranslationScreen> {
  late List<Map<String, dynamic>> segments;
  final Map<int, TextEditingController> controllers = {};
  final Map<int, bool> isLoading = {};
  WebSocketChannel? channel;
  final Map<int, Timer?> _debounceTimers = {};

  // State giao diện Word
  int? _expandedIndex;
  String _currentLangCode = 'vi'; // Giá trị mặc định an toàn

  // Hàm hiển thị thông báo tính năng đang phát triển
  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.orange),
            const SizedBox(width: 10),
            Text(tr(LocaleData.notify)),
          ],
        ),
        content: Text(tr(LocaleData.update_pdf)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr(LocaleData.close),
                style: const TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 🟢 FIX LỖI DROPDOWN Ở ĐÂY
    _initializeLanguage();

    // Parse chunks an toàn
    List<Map<String, dynamic>> parseChunks(List<dynamic> list) {
      return list.map((e) {
        return Map<String, dynamic>.from(e as Map);
      }).toList();
    }

    if (widget.chunks.isEmpty && widget.initialResponse != null) {
      final resp = widget.initialResponse!;
      if (resp.containsKey('chunks') && resp['chunks'] is List) {
        segments = parseChunks(resp['chunks']);
      } else {
        segments = [];
      }
    } else {
      segments = parseChunks(widget.chunks);
    }

    for (int i = 0; i < segments.length; i++) {
      controllers[i] =
          TextEditingController(text: segments[i]['translated'] ?? "");
      isLoading[i] = false;
      segments[i]['diff'] = segments[i]['diff'] ?? [];
    }

    if (widget.wsUrl.isNotEmpty && widget.userId.isNotEmpty) {
      _connectWebSocket();
    }
  }

  // 🟢 Hàm chuẩn hóa ngôn ngữ đầu vào
  void _initializeLanguage() {
    String inputLang = widget.targetLang.toLowerCase().trim();

    // Bản đồ ánh xạ các tên gọi khác nhau về mã chuẩn
    Map<String, String> mapping = {
      'korean': 'ko',
      'ko': 'ko',
      'vietnamese': 'vi',
      'vi': 'vi',
      'english': 'en',
      'en': 'en',
      'japanese': 'ja',
      'ja': 'ja',
      'chinese': 'zh-CN',
      'zh': 'zh-CN',
      'cn': 'zh-CN',
      'french': 'fr',
      'fr': 'fr',
    };

    // Thử tìm mã chuẩn
    String? normalized = mapping[inputLang];

    // Kiểm tra xem mã đã chuẩn hóa có nằm trong danh sách hỗ trợ của Dropdown không
    if (normalized != null && SUPPORTED_LANGUAGES.containsValue(normalized)) {
      _currentLangCode = normalized;
    } else {
      // Nếu không tìm thấy hoặc mã lạ, fallback về 'vi' hoặc 'en' để tránh crash
      // Kiểm tra xem input có tình cờ đúng là value trong SUPPORTED_LANGUAGES không
      if (SUPPORTED_LANGUAGES.containsValue(inputLang)) {
        _currentLangCode = inputLang;
      } else {
        _currentLangCode = 'vi'; // Fallback an toàn nhất
        // ignore: avoid_print
        print(
            "⚠️ Warning: Unknown language '$inputLang', falling back to 'vi'");
      }
    }
  }

  void _connectWebSocket() {
    try {
      final uri = Uri.parse("${widget.wsUrl}?user_id=${widget.userId}");
      channel = WebSocketChannel.connect(uri);
      channel?.stream.listen((message) {
        try {
          final data = json.decode(message);
          if (data['type'] == 'diff_update') {
            final int index = data['index'] is int ? data['index'] : -1;
            if (index >= 0 && index < segments.length) {
              if (!mounted) return;
              setState(() {
                segments[index]['diff'] = data['diff'] ?? [];
                // Chỉ update diff, không update text để tránh conflict khi user đang gõ
              });
            }
          }
        } catch (e) {
          // ignore: avoid_print
          print("WS Error: $e");
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print("WS Connect Error: $e");
    }
  }

  Future<void> _retranslateSegment(int index) async {
    setState(() => isLoading[index] = true);
    try {
      final uri = Uri.parse("${widget.backendBaseUrl}/retranslate-segment");
      final response = await http.post(
        uri,
        body: {
          'user_id': widget.userId,
          'target_lang': _currentLangCode, // Sử dụng mã đã chuẩn hóa
          'text': segments[index]['original'] ?? "",
          'original_translation': controllers[index]?.text ?? "",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['status'] == 'success') {
          final translated = data['translated'] ?? "";
          final diff = data['diff'] ?? [];

          if (mounted) {
            setState(() {
              controllers[index]?.text = translated;
              segments[index]['translated'] = translated;
              segments[index]['diff'] = diff;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    } finally {
      if (mounted) setState(() => isLoading[index] = false);
    }
  }

  List<TextSpan> _buildDiffSpans(int index) {
    final List<dynamic> diff = segments[index]['diff'] ?? [];
    final tokenRegex = RegExp(r"(\w+|[^\w\s]+)", unicode: true);
    final textValue = controllers[index]?.text ?? "";
    final tokens =
        tokenRegex.allMatches(textValue).map((m) => m.group(0)!).toList();

    List<TextSpan> children = [];
    for (var token in tokens) {
      Map? matchDiff = diff.firstWhere(
        (d) =>
            d is Map && (d['word'] == token || d['word'].toString() == token),
        orElse: () => null,
      ) as Map?;

      if (matchDiff != null && matchDiff['type'] != 'equal') {
        Color bgColor = Colors.transparent;
        Color textColor = Colors.black;
        TextDecoration decoration = TextDecoration.none;

        switch (matchDiff['type']) {
          case 'added':
            bgColor = const Color(0xFFE8F5E9); // Xanh lá nhạt
            textColor = Colors.green[900]!;
            break;
          case 'removed':
            textColor = Colors.red;
            decoration = TextDecoration.lineThrough;
            break;
          case 'replaced':
            textColor = Colors.blue[800]!;
            bgColor = Colors.blue[50]!;
            break;
        }
        children.add(TextSpan(
            text: "$token ",
            style: TextStyle(
                backgroundColor: bgColor,
                color: textColor,
                decoration: decoration,
                fontSize: 16,
                height: 1.5)));
      } else {
        children.add(TextSpan(
            text: "$token ",
            style: const TextStyle(
                color: Colors.black87, fontSize: 16, height: 1.5)));
      }
    }
    return children;
  }

  // --- Export Handlers ---
  // void _exportTXT() async {
  //   try {
  //     String content = segments.map((s) => s['translated'] ?? "").join("\n\n");
  //     Directory dir = await getApplicationDocumentsDirectory();
  //     String path =
  //         "${dir.path}/translated_${DateTime.now().millisecondsSinceEpoch}.txt";
  //     await File(path).writeAsString(content);
  //     await OpenFilex.open(path);
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("Lỗi Export TXT: $e")));
  //     }
  //   }
  // }

  void _exportDOCX() async {
    try {
      // 1. LẤY DỮ LIỆU MỚI NHẤT TỪ Ô NHẬP LIỆU (CONTROLLERS)
      // Thay vì lấy từ biến 'segments' (dữ liệu cũ)
      List<String> currentEditedSegments = [];
      for (int i = 0; i < segments.length; i++) {
        // Ưu tiên lấy text đang hiển thị trên màn hình
        String text = controllers[i]?.text ?? segments[i]['translated'] ?? "";
        currentEditedSegments.add(text);
      }

      // 2. Chuẩn bị FormData
      Map<String, dynamic> formDataMap = {
        'user_id': widget.userId,
        'target_lang': _currentLangCode,
        // Gửi danh sách string đơn giản để Python dễ xử lý
        'segments': json.encode(currentEditedSegments),
      };

      // 3. QUAN TRỌNG: Gửi file gốc lên server để làm mẫu (Template)
      if (widget.originalFilePath != null) {
        File originalFile = File(widget.originalFilePath!);
        if (await originalFile.exists()) {
          formDataMap['file'] =
              await MultipartFile.fromFile(widget.originalFilePath!);
        } else {
          // ignore: avoid_print
          print("⚠️ Không tìm thấy file gốc tại: ${widget.originalFilePath}");
        }
      }

      final formData = FormData.fromMap(formDataMap);

      // 4. Gửi Request
      final response = await Dio().post(
        "${widget.backendBaseUrl}/export-docx",
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      // 5. Lưu và mở file
      if (response.statusCode == 200 && response.data != null) {
        Directory dir = await getApplicationDocumentsDirectory();
        String fileName =
            "translated_edited_${DateTime.now().millisecondsSinceEpoch}.docx";
        String path = "${dir.path}/$fileName";

        File(path).writeAsBytesSync(response.data);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
              // ignore: prefer_interpolation_to_compose_strings
              tr(LocaleData.language_hasbeen_exported) + " $fileName")));
        }
        await OpenFilex.open(path);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Export Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Lỗi Export DOCX: $e")));
      }
    }
  }

  // void _exportPDF() async {
  //   try {
  //     // 1. Lấy dữ liệu (Giống hệt DOCX)
  //     List<String> currentEditedSegments = [];
  //     for (int i = 0; i < segments.length; i++) {
  //       String text = controllers[i]?.text ?? segments[i]['translated'] ?? "";
  //       currentEditedSegments.add(text);
  //     }

  //     // 2. Chuẩn bị FormData
  //     Map<String, dynamic> formDataMap = {
  //       'user_id': widget.userId,
  //       'target_lang': _currentLangCode,
  //       'segments': json.encode(currentEditedSegments),
  //     };

  //     // Gửi file gốc
  //     if (widget.originalFilePath != null) {
  //       File originalFile = File(widget.originalFilePath!);
  //       if (await originalFile.exists()) {
  //         formDataMap['file'] =
  //             await MultipartFile.fromFile(widget.originalFilePath!);
  //       }
  //     }

  //     final formData = FormData.fromMap(formDataMap);

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(tr(LocaleData.language_being_exportPDF))));
  //     }

  //     // 3. Gọi Endpoint /export-pdf
  //     final response = await Dio().post(
  //       "${widget.backendBaseUrl}/export-pdf",
  //       data: formData,
  //       options: Options(responseType: ResponseType.bytes),
  //     );

  //     // 4. Lưu file PDF
  //     if (response.statusCode == 200 && response.data != null) {
  //       Directory dir = await getApplicationDocumentsDirectory();
  //       String fileName =
  //           "translated_${DateTime.now().millisecondsSinceEpoch}.pdf";
  //       String path = "${dir.path}/$fileName";

  //       File(path).writeAsBytesSync(response.data);

  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             // ignore: prefer_interpolation_to_compose_strings
  //             content: Text(tr(LocaleData.language_PDF) + " $fileName")));
  //       }
  //       await OpenFilex.open(path);
  //     }
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print("Export PDF Error: $e");
  //     if (mounted) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("Lỗi Export PDF: $e")));
  //     }
  //   }
  // }

  @override
  void dispose() {
    // ignore: curly_braces_in_flow_control_structures
    for (var c in controllers.values) c.dispose();
    channel?.sink.close();
    // ignore: curly_braces_in_flow_control_structures
    for (var t in _debounceTimers.values) t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: Text(tr(LocaleData.language_doc),
            style: const TextStyle(color: Colors.black87, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentLangCode, // ✅ Đảm bảo giá trị này luôn hợp lệ
                icon: const Icon(Icons.language, color: Colors.blue),
                dropdownColor: Colors.white,
                items: SUPPORTED_LANGUAGES.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child:
                        Text(entry.key, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentLangCode = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.save_alt),
            color: Colors.white,
            itemBuilder: (context) => [
              // const PopupMenuItem(value: 'txt', child: Text("Xuất TXT")),
              PopupMenuItem(
                  value: 'docx', child: Text(tr(LocaleData.font_export_DOCX))),
              PopupMenuItem(
                  value: 'pdf', child: Text(tr(LocaleData.font_export_PDF))),
            ],
            onSelected: (val) {
              // if (val == 'txt') _exportTXT();
              if (val == 'docx') _exportDOCX();
              if (val == 'pdf') {
                // _exportPDF();
                _showComingSoonDialog();
              }
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            itemCount: segments.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final bool isExpanded = _expandedIndex == index;

              // 🟢 CHẾ ĐỘ ĐỌC (READ MODE)
              if (!isExpanded) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _expandedIndex = index;
                    });
                  },
                  hoverColor: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(height: 1.5),
                        children: _buildDiffSpans(index),
                      ),
                    ),
                  ),
                );
              }

              // 🟢 CHẾ ĐỘ SỬA (EDIT MODE)
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue.shade200, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nguyên gốc
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.format_quote,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              segments[index]['original'] ?? "",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Ô nhập liệu
                    TextField(
                      controller: controllers[index],
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: tr(LocaleData.language_typing),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (text) {
                        _debounceTimers[index]?.cancel();
                        _debounceTimers[index] =
                            Timer(const Duration(milliseconds: 500), () {
                          channel?.sink.add(json.encode({
                            "type": "edit_update",
                            "index": index,
                            "text": text,
                            "previous_translation":
                                segments[index]['translated'] ?? "",
                            "target_lang": _currentLangCode,
                          }));
                        });
                      },
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    // 🟢 FIX: Dùng Wrap thay vì Row để tự động xuống dòng nếu màn hình nhỏ
                    Wrap(
                      alignment: WrapAlignment.end, // Căn phải
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.0, // Khoảng cách ngang giữa các nút
                      runSpacing: 8.0, // Khoảng cách dọc nếu xuống dòng
                      children: [
                        // Nút Dịch lại
                        TextButton.icon(
                          icon: isLoading[index]!
                              ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.translate, size: 16),
                          label: Text(tr(LocaleData.language_translate_again)),
                          onPressed: isLoading[index]!
                              ? null
                              : () => _retranslateSegment(index),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8)),
                        ),

                        // Nút Xong
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _expandedIndex = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(tr(LocaleData.language_done)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
