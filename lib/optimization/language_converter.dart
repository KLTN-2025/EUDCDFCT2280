import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecolive/view/language_tutorial_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:ecolive/optimization/converter_detail.dart';
import 'package:ecolive/view/translate_history_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart'; // Giữ cái này
import 'package:open_filex/open_filex.dart'; // Giữ cái này

class LanguageConverterScreen extends StatefulWidget {
  const LanguageConverterScreen({super.key});

  @override
  State<LanguageConverterScreen> createState() =>
      _LanguageConverterScreenState();
}

class _LanguageConverterScreenState extends State<LanguageConverterScreen> {
  String? _uploadedFileName;
  String _selectedLanguage = 'Korean';
  String _outputStatusText = tr(LocaleData.contentfileconverted);
  String? _downloadUrl;
  bool _isLoading = false;

  final String backendBaseUrl =
      "https://ecolive-font-converter-docker.onrender.com";
  final userId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous_user";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeLangConvert') ?? true;

    if (isFirstTime) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      _showFullTutorial();
      await prefs.setBool('isFirstTimeLangConvert', false);
    }
  }

  void _showFullTutorial() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return LanguageTutorialOverlay(
          onClose: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
      );
      if (result == null) return;

      File file = File(result.files.single.path!);
      setState(() {
        _uploadedFileName = result.files.single.name;
        _outputStatusText = tr(LocaleData.language);
        _isLoading = true;
        _downloadUrl = null;
      });

      String? mode = await _showTranslateModeDialog();
      if (mode == null) return;

      if (mode == "chunk") {
        await _translateByChunks(file);
        return;
      }

      var detectReq = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/detect-language'),
      );
      detectReq.files.add(await http.MultipartFile.fromPath('file', file.path));

      var detectResp = await detectReq.send();
      var detectBody = await detectResp.stream.bytesToString();

      if (detectResp.statusCode != 200) {
        setState(() {
          _outputStatusText =
              "❌ Lỗi khi phát hiện ngôn ngữ (${detectResp.statusCode})";
          _isLoading = false;
        });
        return;
      }

      var detectData = json.decode(detectBody);
      String detectedLang = detectData['detected_lang'] ?? "unknown";

      setState(() {
        // Đã sửa lỗi String Interpolation (dùng $ thay vì +)
        _outputStatusText =
            "${tr(LocaleData.language_detected)} ${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()}\n${tr(LocaleData.language_translating)}";
      });

      var translateReq = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/translate-doc'),
      );
      translateReq.files
          .add(await http.MultipartFile.fromPath('file', file.path));

      String targetLang = _selectedLanguage.toLowerCase();
      if (targetLang.contains('simplified')) {
        targetLang = 'chinese';
      } else if (targetLang.contains('traditional')) {
        targetLang = 'chinese_traditional';
      }

      translateReq.fields['target_lang'] = targetLang;
      translateReq.fields['user_id'] = userId;

      var transResp = await translateReq.send();
      var transBody = await transResp.stream.bytesToString();

      if (transResp.statusCode == 200) {
        var jsonResponse = json.decode(transBody);

        _downloadUrl = jsonResponse['download_url'] ??
            jsonResponse['result_url'] ??
            jsonResponse['resultUrl'] ??
            jsonResponse['url'];

        setState(() {});

        if (jsonResponse['status'] == 'success' && _downloadUrl != null) {
          setState(() {
            _outputStatusText =
                "${tr(LocaleData.language_translated_success)} (${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()})";
          });
        } else {
          setState(() {
            _outputStatusText = tr(LocaleData.language_detect_error);
          });
        }
      } else {
        setState(() {
          _outputStatusText =
              "${tr(LocaleData.language_detect_error)} (${transResp.statusCode})\nTừ ${detectedLang.toUpperCase()} → ${_selectedLanguage.toUpperCase()}";
        });
      }
    } catch (e) {
      setState(() {
        _outputStatusText = "${tr(LocaleData.language_error)} $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _showTranslateModeDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(tr(LocaleData.language_choose_method)),
          content: Text(
            tr(LocaleData.language_ask),
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "full"),
              child: Text(tr(LocaleData.language_trans_all)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, "chunk"),
              child: Text(tr(LocaleData.language_trans_chunk)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _translateByChunks(File file) async {
    try {
      setState(() {
        _isLoading = true;
        _outputStatusText = tr(LocaleData.language_appear);
      });

      var detectReq = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/detect-language'),
      );
      detectReq.files.add(await http.MultipartFile.fromPath('file', file.path));

      var detectResp = await detectReq.send();
      String detectedLangCode = 'vi';

      if (detectResp.statusCode == 200) {
        final detectResponse = await http.Response.fromStream(detectResp);
        var detectData = json.decode(utf8.decode(detectResponse.bodyBytes));
        detectedLangCode = detectData['detected_lang'] ?? 'vi';
        if (detectedLangCode == 'unknown') detectedLangCode = 'en';
      }

      setState(() {
        _outputStatusText = tr(LocaleData.language_seperate);
      });

      var req = http.MultipartRequest(
        'POST',
        Uri.parse('$backendBaseUrl/translate-doc-chunks'),
      );

      req.files.add(await http.MultipartFile.fromPath('file', file.path));
      req.fields['target_lang'] = detectedLangCode;
      req.fields['user_id'] = userId;

      var resp = await req.send();
      final response = await http.Response.fromStream(resp);

      if (response.statusCode == 200) {
        var jsonData = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          _outputStatusText = tr(LocaleData.language_trans_already);
        });

        if (!mounted) return;

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SegmentTranslationScreen(
                chunks: jsonData["chunks"] ?? [],
                originalFilePath: file.path,
                userId: userId,
                targetLang: detectedLangCode,
                backendBaseUrl: backendBaseUrl,
                wsUrl: "$backendBaseUrl/ws-segment",
              ),
            ));
      } else {
        setState(() {
          _outputStatusText =
              "${tr(LocaleData.language_error_seperate)} (${resp.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        _outputStatusText = "${tr(LocaleData.language_error)} $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Đã xóa hàm _getMimeType thừa thãi

  Future<void> _downloadFile() async {
    if (_downloadUrl == null) return;

    try {
      setState(() => _isLoading = true);

      // 1. Tải file về RAM
      var response = await Dio().get(
        _downloadUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      // 2. Chuẩn bị tên file
      String fileName = _uploadedFileName != null
          ? "${_uploadedFileName!.split('.').first}_translated"
          : 'translated_file';

      String extension = 'docx';
      if (_downloadUrl!.endsWith('.pdf')) extension = 'pdf';

      // 3. Lưu file
      String resultPath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: response.data,
        ext: extension,
        mimeType: MimeType.other, // Dùng other để tránh lỗi
      );

      setState(() => _isLoading = false);

      // 4. Thông báo và Mở file
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(LocaleData.language_download_successed)),
            backgroundColor: Colors.green[700],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: tr(LocaleData.file_open),
              textColor: Colors.white,
              onPressed: () {
                OpenFilex.open(resultPath);
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showFullText() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(LocaleData.language_convert)),
        content: SingleChildScrollView(
          child: Text(
            _outputStatusText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr(LocaleData.close)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... Phần build UI giữ nguyên ...
    // Để tiết kiệm không gian, tôi không paste lại phần UI vì nó không thay đổi.
    // Bạn giữ nguyên phần build bên dưới nhé!
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(tr(LocaleData.all_convert_no)),
              content: Text(tr(LocaleData.all_convert_no2)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(tr(LocaleData.ok)),
                ),
              ],
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(LocaleData.convertlanguage)),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: tr(LocaleData.font_instruction),
              onPressed: () {
                _showFullTutorial();
              },
            ),
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: tr(LocaleData.language_history),
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("⚠️ Bạn cần đăng nhập để xem lịch sử!")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TranslateHistoryScreen(
                      userId: user.uid,
                      apiBaseUrl:
                          "https://ecolive-font-converter-docker.onrender.com",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickAndUploadFile,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload,
                                  size: 50, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(tr(LocaleData.uploadfile),
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
              ),
              if (_uploadedFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "${tr(LocaleData.language_file_chose)}$_uploadedFileName",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              if (!_isLoading) ...[
                Text(tr(LocaleData.newlanguage),
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: [
                    tr(LocaleData.english),
                    tr(LocaleData.french),
                    tr(LocaleData.german),
                    tr(LocaleData.spanish),
                    tr(LocaleData.portuguese),
                    tr(LocaleData.russian),
                    tr(LocaleData.italian),
                    tr(LocaleData.vietnamese),
                    tr(LocaleData.korean),
                    tr(LocaleData.chinese),
                    tr(LocaleData.japanese),
                  ]
                      .map((lang) =>
                          DropdownMenuItem(value: lang, child: Text(lang)))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                ),
              ] else ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 2),
                    const SizedBox(width: 12),
                    Text(tr(LocaleData.language_processing),
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 30),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showFullText,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _outputStatusText,
                      style: const TextStyle(color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  InkWell(
                    onTap: _downloadUrl != null ? _downloadFile : null,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _downloadUrl != null
                            ? Colors.blue[600]
                            : Colors.grey,
                      ),
                      child: const Icon(Icons.download,
                          color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(tr(LocaleData.downloadbtt),
                      style: const TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
