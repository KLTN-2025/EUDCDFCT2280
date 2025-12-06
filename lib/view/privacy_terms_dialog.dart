import 'dart:io'; // Để kiểm tra ngôn ngữ máy
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyTermsDialog extends StatefulWidget {
  final VoidCallback onAgreed;

  const PrivacyTermsDialog({super.key, required this.onAgreed});

  @override
  State<PrivacyTermsDialog> createState() => _PrivacyTermsDialogState();
}

class _PrivacyTermsDialogState extends State<PrivacyTermsDialog> {
  bool isAgreed = false;
  final ScrollController _scrollController = ScrollController();

  // Biến chứa nội dung hiển thị cuối cùng
  String displayContent = "";
  String title = "";
  String agreeText = "";
  String btnText = "";
  String linkText = ""; // Thêm biến này để đổi ngôn ngữ nút link

  // --- NỘI DUNG TIẾNG ANH (Mặc định) ---
  final String policyEN = """
PRIVACY POLICY & TERMS OF SERVICE

1. Data Collection
We collect your email and name via Google Firebase Authentication solely for the purpose of managing your user account and conversion history.

2. File Usage
Documents (PDF, DOCX, TXT) and images uploaded by you are temporarily processed on our secure servers to perform the conversion or translation requested. We do not claim ownership of your content.

3. Third-Party Services
We use trusted services:
- Google Firebase: Authentication & Database.
- Google Cloud Storage / AWS S3: Secure file storage.
- Google Translate API: Translation features.

4. Permissions
We may request access to Storage (to save files) and Camera. You can revoke these permissions at any time.

5. Privacy Commitment
We do NOT sell your personal data to third parties. You have full control to delete your history and files within the App settings.
""";

  // --- NỘI DUNG TIẾNG VIỆT ---
  final String policyVI = """
CHÍNH SÁCH QUYỀN RIÊNG TƯ & ĐIỀU KHOẢN DỊCH VỤ

1. Thu thập dữ liệu
Chúng tôi thu thập email và tên của bạn thông qua Google Firebase Authentication chỉ nhằm mục đích quản lý tài khoản người dùng và lịch sử chuyển đổi.

2. Sử dụng tệp tin
Các tài liệu (PDF, DOCX, TXT) và hình ảnh do bạn tải lên được xử lý tạm thời trên máy chủ bảo mật của chúng tôi để thực hiện chuyển đổi hoặc dịch thuật theo yêu cầu. Chúng tôi không tuyên bố quyền sở hữu nội dung của bạn.

3. Dịch vụ bên thứ ba
Chúng tôi sử dụng các dịch vụ đáng tin cậy:
- Google Firebase: Xác thực và cơ sở dữ liệu.
- Google Cloud Storage / AWS S3: Lưu trữ file an toàn.
- Google Translate API: Tính năng dịch thuật.

4. Quyền truy cập thiết bị
Chúng tôi có thể yêu cầu quyền truy cập Bộ nhớ (để tải file) và Camera. Bạn có thể thu hồi các quyền này bất cứ lúc nào.

5. Cam kết bảo mật
Chúng tôi KHÔNG bán dữ liệu cá nhân của bạn cho bên thứ ba. Bạn có toàn quyền xóa lịch sử chuyển đổi và các tệp liên quan ngay trong cài đặt Ứng dụng.
""";

  @override
  void initState() {
    super.initState();
    _detectLanguage();
  }

  void _detectLanguage() {
    // Mặc định là Tiếng Anh (Fall-back safe)
    bool isVietnamese = false;

    try {
      // CÁCH 1: Dùng WidgetsBinding (Chuẩn nhất của Flutter)
      final locale = ui.PlatformDispatcher.instance.locale;
      if (locale.languageCode == 'vi') {
        isVietnamese = true;
      }
    } catch (e) {
      // Nếu Cách 1 lỗi (cực hiếm), thử Cách 2: Dùng Platform.localeName
      try {
        if (Platform.localeName.toLowerCase().contains('vi')) {
          isVietnamese = true;
        }
      } catch (e2) {
        debugPrint("⚠️ Không detect được ngôn ngữ: $e2");
      }
    }

    // Cập nhật giao diện dựa trên kết quả
    if (isVietnamese) {
      setState(() {
        displayContent = policyVI;
        title = "Điều khoản & Chính sách";
        agreeText =
            "Tôi đã đọc và đồng ý với các Điều khoản & Chính sách nêu trên.";
        btnText = "Tiếp tục";
        linkText = "Xem đầy đủ trên Web";
      });
    } else {
      // Mặc định Tiếng Anh
      setState(() {
        displayContent = policyEN;
        title = "Terms & Privacy Policy";
        agreeText =
            "I have read and agree to the Terms & Privacy Policy above.";
        btnText = "Continue";
        linkText = "View Full Policy on Web";
      });
    }
  }

  void _openFullPolicy() {
    launchUrl(Uri.parse('https://sites.google.com/view/ecolive-policies'),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Chặn nút Back
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayContent,
                          style: const TextStyle(
                              fontSize: 15, height: 1.6, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton.icon(
                            onPressed: _openFullPolicy,
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: Text(linkText,
                                style: const TextStyle(fontSize: 14)),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              // Phần nút bấm cố định ở dưới
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            activeColor: Colors.blue,
                            value: isAgreed,
                            onChanged: (val) {
                              setState(() {
                                isAgreed = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAgreed = !isAgreed;
                              });
                            },
                            child: Text(
                              agreeText,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isAgreed
                            ? () {
                                widget.onAgreed();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.grey.shade300,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          btnText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
