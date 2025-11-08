//SECOND SITUATION

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AIConverter {
  /// Pick a file (PDF or DOCX)
  static Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  /// Extract text from PDF (Dummy implementation for now)
  static Future<String> extractTextFromPDF(File file) async {
    return "This is a sample extracted text from the PDF file. It contains extra spaces and unnecessary words.";
  }

  /// Extract text from DOCX (Dummy implementation for now)
  static Future<String> extractTextFromDocx(File file) async {
    return "This is a sample extracted text from the DOCX file. It also has unnecessary spaces and words.";
  }

  /// Optimize text & calculate savings
  static Map<String, dynamic> optimizeText(String text) {
    int originalWordCount = text.split(RegExp(r"\s+")).length;
    String optimizedText = text.replaceAll(RegExp(r"\s+"), " ").trim();
    int optimizedWordCount = optimizedText.split(" ").length;

    int wordsSaved = originalWordCount - optimizedWordCount;
    double percentageSaved = (wordsSaved / originalWordCount) * 100;

    return {
      "text": optimizedText,
      "wordsSaved": wordsSaved,
      "percentageSaved": percentageSaved
    };
  }

  /// Generate optimized PDF
  static Future<File> createOptimizedPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              text,
              // ignore: prefer_const_constructors
              style: pw.TextStyle(
                fontSize: 10, // Small font size to save ink
              ),
            ),
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/optimized_document.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Share the optimized PDF
  static Future<void> shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)],
        text: "Download your optimized document!");
  }
}
