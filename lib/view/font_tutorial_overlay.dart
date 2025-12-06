import 'dart:ui'; // Cần cho hiệu ứng Blur
import 'package:flutter/material.dart';
import 'package:ecolive/Widget/common_tutorial_video.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';

class FontTutorialOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const FontTutorialOverlay({super.key, required this.onClose});

  @override
  State<FontTutorialOverlay> createState() => _FontTutorialOverlayState();
}

class _FontTutorialOverlayState extends State<FontTutorialOverlay> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Trong suốt để thấy nền sau
      body: Stack(
        children: [
          // 1. LỚP BLUR NỀN
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(0.85), // Màu tối đè lên
              ),
            ),
          ),

          // 2. NỘI DUNG CHÍNH
          SafeArea(
            child: Column(
              children: [
                // --- HEADER ---
                const SizedBox(height: 20),
                Text(
                  tr(LocaleData.language_tutorial_detail),
                  style: const TextStyle(
                    color: Colors.yellow, // Text vàng
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr(LocaleData.font_select),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Divider(color: Colors.white24, indent: 40, endIndent: 40),

                // --- PAGE VIEW (2 TAB) ---
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildTab1_FullFont(), // Tab 1: Toàn bộ
                      _buildTab2_PartialFont(), // Tab 2: Từng đoạn
                    ],
                  ),
                ),

                // --- NÚT ĐÓNG ---
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                    onPressed: widget.onClose,
                    child: Text(tr(LocaleData.close),
                        style: const TextStyle(
                            color: Colors.white54,
                            decoration: TextDecoration.underline)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🟢 TAB 1: CHUYỂN ĐỔI TOÀN BỘ
  // -------------------------------------------------------
  // ignore: non_constant_identifier_names
  Widget _buildTab1_FullFont() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Video intro
          // _buildVideoPlaceholder("Video giới thiệu chung"),
          // const SizedBox(height: 20),
          // Title gạch chân trắng
          _buildUnderlinedTitle(tr(LocaleData.file_all)),
          const SizedBox(height: 5),
          Text(tr(LocaleData.language_tutorial_detail),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),
          // Bước 1
          _buildStepText(tr(LocaleData.font_step)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_all.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 20),
          // Bước 2
          _buildStepText(tr(LocaleData.font_step2)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_all2.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 30),

          // Nút chuyển Tab
          GestureDetector(
            onTap: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: Column(
              children: [
                Text(tr(LocaleData.language_swip),
                    style: const TextStyle(color: Colors.yellow, fontSize: 14)),
                const SizedBox(height: 5),
                const Icon(Icons.arrow_circle_right_outlined,
                    color: Colors.yellow, size: 40),
                Text(tr(LocaleData.language_trans_chunk),
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🟢 TAB 2: CHUYỂN ĐỔI TỪNG ĐOẠN
  // -------------------------------------------------------
  // ignore: non_constant_identifier_names
  Widget _buildTab2_PartialFont() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildUnderlinedTitle(tr(LocaleData.seperate)),
          const SizedBox(height: 5),
          Text(tr(LocaleData.language_tutorial_detail),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),
          // Bước 1
          _buildStepText(tr(LocaleData.font_step3)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_chunk.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 15),
          // Bước 2
          _buildStepText(tr(LocaleData.font_step4)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_chunk2.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 15),
          // Bước 3
          _buildStepText(tr(LocaleData.font_step5)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_chunk3.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 15),
          // Bước 4
          _buildStepText(tr(LocaleData.font_step6)),
          const CommonTutorialVideo(
            assetPath:
                'assets/videos/video_font_chunk4.mp4', // Video bạn đã đổi tên
          ),

          const SizedBox(height: 40),
          // Nút Hoàn thành
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            onPressed: widget.onClose,
            child: Text(tr(LocaleData.understand),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildUnderlinedTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStepText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
      ),
    );
  }
}
