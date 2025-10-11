import 'package:flutter/material.dart';

class LanguageConverterScreen extends StatefulWidget {
  const LanguageConverterScreen({super.key});

  @override
  State<LanguageConverterScreen> createState() =>
      _LanguageConverterScreenState();
}

class _LanguageConverterScreenState extends State<LanguageConverterScreen> {
  // Biến để lưu trữ tên file đã tải lên
  // ignore: unused_field
  String? _uploadedFileName;

  // Biến để lưu trữ ngôn ngữ mới đã chọn
  String _selectedLanguage = 'Korean';

  // Biến để hiển thị trạng thái của file đã chuyển đổi
  // ignore: prefer_final_fields
  String _outputStatusText = 'Nội dung file đã chuyển đổi nằm ở đây';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LANGUAGE TO LANGUAGE'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vùng Upload File
            GestureDetector(
              onTap: () {
                // TODO: Triển khai chức năng chọn file ở đây
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('UPLOAD FILE', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Phần chọn Ngôn ngữ mới
            const Text('Ngôn ngữ mới', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: <String>[
                'Korean',
                'Chinese',
                'Japanese',
                'English',
                'French'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Phần Output
            const Text('Output', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  _outputStatusText,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Nút Tải về
            Column(
              children: [
                InkWell(
                  onTap: () {
                    // TODO: Triển khai chức năng tải file về ở đây
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[600],
                    ),
                    child: const Icon(Icons.download,
                        color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Tải về', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
