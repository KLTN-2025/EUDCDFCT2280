import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

// Class lưu trữ thông tin Style của từng đoạn text
class StyleRange {
  int start;
  int end;
  String font;

  StyleRange({required this.start, required this.end, required this.font});
}

// Custom Controller để hiển thị nhiều Font trong 1 TextField
class RichFontEditorController extends TextEditingController {
  // Danh sách các vùng style, xếp theo thứ tự tăng dần, không chồng chéo
  List<StyleRange> styleRanges = [];
  String defaultFont;

  String _lastKnownText = "";

  RichFontEditorController({String text = '', required this.defaultFont})
      : super(text: text) {
    _lastKnownText = text;
    // Mặc định toàn bộ văn bản dùng font gốc
    if (text.isNotEmpty) {
      styleRanges
          .add(StyleRange(start: 0, end: text.length, font: defaultFont));
    }
  }

  // 🟢 LOGIC 1: Tự động cập nhật vị trí Style khi văn bản thay đổi
  @override
  set value(TextEditingValue newValue) {
    if (newValue.text == _lastKnownText) {
      // Nếu chỉ di chuyển con trỏ mà không đổi text thì không làm gì
      super.value = newValue;
      return;
    }

    // 1. Tính toán sự thay đổi
    final int newLen = newValue.text.length;
    final int oldLen = _lastKnownText.length;
    final int delta = newLen - oldLen; // Dương nếu thêm, Âm nếu xóa

    // 2. Tìm vị trí bắt đầu thay đổi (Diff Index)
    int diffIndex = 0;
    final int minLen = newLen < oldLen ? newLen : oldLen;
    while (diffIndex < minLen &&
        newValue.text[diffIndex] == _lastKnownText[diffIndex]) {
      diffIndex++;
    }

    // 3. Cập nhật các StyleRange
    List<StyleRange> updatedRanges = [];

    for (var range in styleRanges) {
      // Trường hợp A: Vùng style nằm hoàn toàn TRƯỚC vị trí sửa -> Giữ nguyên
      if (range.end <= diffIndex) {
        updatedRanges.add(range);
      }
      // Trường hợp B: Vùng style nằm hoàn toàn SAU vị trí sửa -> Dịch chuyển
      else if (range.start >= diffIndex) {
        // Nếu là xóa (delta < 0) và vùng này bị xóa mất một phần đầu
        // Ta cần đảm bảo start không bị lùi quá diffIndex (nơi bắt đầu xóa)
        int newStart = range.start + delta;
        int newEnd = range.end + delta;

        // Giới hạn biên an toàn
        if (newStart < diffIndex) newStart = diffIndex;

        updatedRanges
            .add(StyleRange(start: newStart, end: newEnd, font: range.font));
      }
      // Trường hợp C: Vùng style BAO TRÙM vị trí sửa -> Mở rộng hoặc thu hẹp
      else {
        // Người dùng đang gõ vào GIỮA một vùng style -> Vùng đó tự nở ra
        int newEnd = range.end + delta;
        updatedRanges
            .add(StyleRange(start: range.start, end: newEnd, font: range.font));
      }
    }

    // 4. Dọn dẹp các vùng không hợp lệ (start >= end) do bị xóa hết
    updatedRanges.removeWhere((r) => r.start >= r.end);

    // Cập nhật lại dữ liệu
    styleRanges = updatedRanges;
    _lastKnownText = newValue.text;

    super.value = newValue;
  }

  // Hàm quan trọng nhất: Áp dụng Font mới cho vùng đang chọn
  void applyFontToSelection(TextSelection selection, String newFont) {
    if (!selection.isValid || selection.isCollapsed) return;

    int start = selection.start;
    int end = selection.end;

    // 1. Xóa các range cũ nằm trong vùng chọn để tránh chồng chéo
    styleRanges.removeWhere((r) => r.start >= start && r.end <= end);

    // 2. Xử lý cắt các range bị giao nhau (ở đầu hoặc đuôi)
    List<StyleRange> newRanges = [];
    for (var r in styleRanges) {
      // Trường hợp range cũ bao trùm vùng chọn: [ --- {selection} --- ]
      // Cắt làm 2 range con ở 2 đầu, ở giữa để trống cho range mới
      if (r.start < start && r.end > end) {
        newRanges.add(StyleRange(start: r.start, end: start, font: r.font));
        newRanges.add(StyleRange(start: end, end: r.end, font: r.font));
      }
      // Giao đầu: [ -- { -- ] }
      else if (r.start < start && r.end > start) {
        r.end = start;
        newRanges.add(r);
      }
      // Giao đuôi: { [ -- } -- ]
      else if (r.start < end && r.end > end) {
        r.start = end;
        newRanges.add(r);
      } else {
        newRanges.add(r);
      }
    }

    styleRanges = newRanges;

    // 3. Thêm range mới vào
    styleRanges.add(StyleRange(start: start, end: end, font: newFont));

    // 4. Sắp xếp lại
    styleRanges.sort((a, b) => a.start.compareTo(b.start));

    notifyListeners(); // Cập nhật giao diện
  }

  // Override hàm buildTextSpan để hiển thị màu sắc/font
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> children = [];
    String currentText = text;
    int cursor = 0;

    // Font dự phòng để tránh lỗi ô vuông
    final List<String> fallbacks = ['Arial', 'Roboto', 'sans-serif'];

    for (var range in styleRanges) {
      // 1. Phần text chưa có style (dùng default)
      if (range.start > cursor) {
        // Kẹp biên an toàn
        int safeEnd =
            range.start > currentText.length ? currentText.length : range.start;
        if (cursor < safeEnd) {
          children.add(TextSpan(
            text: currentText.substring(cursor, safeEnd),
            style: style?.copyWith(
              fontFamily: defaultFont,
              fontFamilyFallback: fallbacks, // Fix ô vuông
            ),
          ));
        }
      }

      // 2. Phần text có style riêng
      int safeRangeEnd =
          range.end > currentText.length ? currentText.length : range.end;
      int safeRangeStart = range.start < 0 ? 0 : range.start;

      if (safeRangeStart < safeRangeEnd) {
        children.add(TextSpan(
          text: currentText.substring(safeRangeStart, safeRangeEnd),
          style: style?.copyWith(
            fontFamily: range.font,
            fontFamilyFallback: fallbacks, // Fix ô vuông
            // backgroundColor: Colors.transparent, // Không tô màu nền nữa
          ),
        ));
      }
      cursor = safeRangeEnd;
    }

    // 3. Phần đuôi còn lại
    if (cursor < currentText.length) {
      children.add(TextSpan(
        text: currentText.substring(cursor),
        style: style?.copyWith(
          fontFamily: defaultFont,
          fontFamilyFallback: fallbacks,
        ),
      ));
    }

    return TextSpan(style: style, children: children);
  }
}

class FontPartialScreen extends StatefulWidget {
  final List<Map<String, dynamic>> paragraphs;
  final String originalFilePath;
  final String userId;
  final String backendBaseUrl;
  final String selectedFont;

  const FontPartialScreen({
    Key? key,
    required this.paragraphs,
    required this.originalFilePath,
    required this.userId,
    required this.backendBaseUrl,
    required this.selectedFont,
  }) : super(key: key);

  @override
  State<FontPartialScreen> createState() => _FontPartialScreenState();
}

class _FontPartialScreenState extends State<FontPartialScreen> {
  late RichFontEditorController _controller;
  bool _isExporting = false;
  final Dio _dio = Dio();

  // Biến lưu font đang chọn trên Dropdown
  late String _dropdownFont;

  final List<String> _availableFonts = [
    "Times New Roman",
    "Calibri",
    "Arial",
    "Serif",
    "Sans-serif",
    "Script",
  ];

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

    // 1. Chuẩn bị biến để xây dựng lại văn bản và Style
    StringBuffer fullTextBuffer = StringBuffer();
    List<StyleRange> initialRanges = [];
    int currentIndex = 0;

    // 2. Duyệt qua danh sách paragraphs từ API /detect-fonts trả về
    for (var p in widget.paragraphs) {
      String text = p['text'].toString();

      // Xử lý trường hợp backend trả về "(Empty)"
      if (text == "(Empty)") text = "";

      // --- LOGIC LẤY FONT GỐC ---
      // Lấy font detect được từ server. Nếu không có hoặc "Unknown" thì về Arial.
      List<dynamic> pFonts = p['fonts'] ?? [];
      String originalFont = "Arial";

      if (pFonts.isNotEmpty) {
        String detected = pFonts.first.toString();
        if (detected != "Unknown") {
          originalFont = detected;
        }
      }
      // ---------------------------

      // Nếu đoạn văn có nội dung, tạo Range cho nó
      if (text.isNotEmpty) {
        fullTextBuffer.write(text);

        // 🔥 QUAN TRỌNG: Tạo vùng style giữ font gốc cho đoạn này
        initialRanges.add(StyleRange(
          start: currentIndex,
          end: currentIndex + text.length,
          font: originalFont,
        ));

        currentIndex += text.length;
      }

      // Thêm xuống dòng để ngăn cách các đoạn (giống logic split trong export)
      fullTextBuffer.write("\n");
      // Tăng index cho ký tự \n này (thường \n sẽ ăn theo font của đoạn trước hoặc default)
      currentIndex += 1;
    }

    String fullString = fullTextBuffer.toString();
    // Lưu ý: Không .trim() ở đây nếu muốn giữ chính xác cấu trúc dòng

    // 3. Khởi tạo Controller
    // defaultFont ở đây chỉ là dự phòng, styleRanges bên dưới mới quyết định hiển thị
    _controller =
        RichFontEditorController(text: fullString, defaultFont: "Arial");

    // 🔥 GÁN ĐÈ StyleRanges:
    // Đây là bước quyết định để UI hiển thị đúng font gốc từng đoạn
    _controller.styleRanges = initialRanges;

    // 4. Cập nhật Dropdown nội bộ (Dropdown B)
    // Lấy font của đoạn đầu tiên làm giá trị hiển thị ban đầu
    if (initialRanges.isNotEmpty) {
      _dropdownFont = initialRanges.first.font;
    } else {
      _dropdownFont = "Arial";
    }

    // Đảm bảo font này có trong danh sách Dropdown để không bị lỗi UI
    if (!_availableFonts.contains(_dropdownFont)) {
      _availableFonts.insert(0, _dropdownFont);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Xử lý đổi font khi user chọn Dropdown
  void _onFontChanged(String newFont) {
    setState(() {
      _dropdownFont = newFont;
    });

    // Áp dụng ngay cho vùng đang bôi đen (selection)
    if (_controller.selection.isValid && !_controller.selection.isCollapsed) {
      _controller.applyFontToSelection(_controller.selection, newFont);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(LocaleData.font_bold_word))),
      );
    }
  }

  Future<void> _exportDocument(String format) async {
    setState(() => _isExporting = true);
    try {
      // 1. Cập nhật nội dung mới nhất từ TextField vào biến
      String fullText = _controller.text;
      List<Map<String, dynamic>> segmentsPayload = [];
      int cursor = 0;

      // --- Logic cắt text (Giữ nguyên logic cũ của bạn) ---
      void addSegment(String text, String font) {
        if (text.isEmpty) return;
        List<String> lines = text.split('\n');
        for (int i = 0; i < lines.length; i++) {
          String line = lines[i];
          bool isNewPara = (i > 0);
          if (line.isEmpty && lines.length > 1 && i < lines.length - 1) {
            segmentsPayload
                .add({"text": "", "font": font, "is_new_paragraph": true});
            continue;
          }
          if (line.isNotEmpty) {
            segmentsPayload.add(
                {"text": line, "font": font, "is_new_paragraph": isNewPara});
          }
        }
      }

      for (var range in _controller.styleRanges) {
        if (range.start > cursor) {
          addSegment(
              fullText.substring(cursor, range.start), _controller.defaultFont);
        }
        int end = range.end > fullText.length ? fullText.length : range.end;
        addSegment(fullText.substring(range.start, end), range.font);
        cursor = end;
      }
      if (cursor < fullText.length) {
        addSegment(fullText.substring(cursor), _controller.defaultFont);
      }
      // -----------------------------------------------------

      // 🔍 DEBUG: In ra để xem Flutter đang gửi cái gì
      debugPrint("📦 Payload gửi đi: ${jsonEncode(segmentsPayload)}");

      // Lấy tên file gốc từ đường dẫn
      String fileName = widget.originalFilePath.split('/').last;

      // 2. Gửi Request lên Server
      final formData = FormData.fromMap({
        'segments_data': jsonEncode(segmentsPayload),
        'user_id': widget.userId,
        'output_format': format,
        'original_filename': fileName,
      });

      final response = await _dio.post(
        "${widget.backendBaseUrl}/export-font-doc-mixed",
        data: formData,
        options: Options(
            responseType: ResponseType.json,
            sendTimeout: const Duration(seconds: 120),
            receiveTimeout: const Duration(seconds: 120),
            validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200) {
        String downloadUrl = response.data['result_url'];
        debugPrint("🔗 Link nhận được từ Server: $downloadUrl");

        if (downloadUrl.isNotEmpty) {
          // 🟢 BẮT ĐẦU QUY TRÌNH TẢI VÀ MỞ FILE (Code mới)

          try {
            // a. Tạo đường dẫn lưu file tạm
            final dir = await getTemporaryDirectory();
            final fileName =
                "converted_file_${DateTime.now().millisecondsSinceEpoch}.$format";
            final savePath = "${dir.path}/$fileName";

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr(LocaleData.file_downloading))),
              );
            }

            // b. Tải file về
            await _dio.download(downloadUrl, savePath);

            // c. Mở file bằng OpenFilex
            final result = await OpenFilex.open(savePath);

            if (result.type != ResultType.done) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      // ignore: prefer_interpolation_to_compose_strings
                      content: Text(tr(LocaleData.font_cannot_open) +
                          " ${result.message}")),
                );
              }
            }
          } catch (downloadError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    // ignore: prefer_interpolation_to_compose_strings
                    content: Text(tr(LocaleData.font_download_error) +
                        " $downloadError")),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      "Lỗi: ${response.data['message'] ?? 'Không có link tải'}")),
            );
          }
        }
      } else {
        throw Exception(
            "Lỗi server (${response.statusCode}): ${response.data}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_interpolation_to_compose_strings
          SnackBar(content: Text(tr(LocaleData.font_error_export) + " $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.font_edit)),
        actions: [
          // Dropdown chọn Font
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _dropdownFont,
              icon: const Icon(Icons.font_download, color: Colors.white),
              dropdownColor: Colors.blue,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (val) {
                if (val != null) _onFontChanged(val);
              },
              items: _availableFonts
                  .map((f) => DropdownMenuItem(
                      value: f,
                      child: Text(f,
                          style:
                              TextStyle(color: Colors.black, fontFamily: f))))
                  .toList(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.yellow.shade100,
            child: Text(
              tr(LocaleData.font_tip),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
          ),

          // Vùng soạn thảo chính (1 TextField duy nhất)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ],
                  border: Border.all(color: Colors.grey.shade300)),
              child: TextField(
                controller: _controller,
                maxLines: null, // Cho phép nhiều dòng vô hạn
                expands: true, // Mở rộng hết khung
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black,
                  fontFamilyFallback: ['Arial', 'Roboto', 'sans-serif'],
                ),
                textAlignVertical: TextAlignVertical.top, // Gõ từ trên xuống
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: tr(LocaleData.font_content),
                ),
              ),
            ),
          ),

          // Footer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _isExporting ? null : () => _exportDocument("docx"),
                      icon: const Icon(Icons.save),
                      label: Text(tr(LocaleData.font_export_DOCX)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showComingSoonDialog,
                      // _isExporting ? null : () => _exportDocument("pdf"),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: Text(tr(LocaleData.font_export_PDF)),
                      style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.red,
                          // foregroundColor: Colors.white,
                          // 👇 Màu nền khi bị vô hiệu hóa (Xám)
                          disabledBackgroundColor: Colors.grey.shade300,

                          // 👇 Màu chữ/icon khi bị vô hiệu hóa (Xám đậm hơn chút)
                          disabledForegroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
