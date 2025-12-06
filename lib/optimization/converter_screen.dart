import 'dart:io';
import 'package:flutter/material.dart';
import 'ai_converter.dart';

// ignore: use_key_in_widget_constructors
class ConverterScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String extractedText = "No file selected";
  int wordsSaved = 0;
  double percentageSaved = 0.0;
  File? optimizedFile;

  Future<void> convertFile() async {
    File? file = await AIConverter.pickFile();
    if (file == null) return;

    String text = file.path.endsWith(".pdf")
        ? await AIConverter.extractTextFromPDF(file)
        : await AIConverter.extractTextFromDocx(file);

    var optimizedData = AIConverter.optimizeText(text);
    File pdfFile = await AIConverter.createOptimizedPDF(optimizedData["text"]);

    setState(() {
      extractedText = optimizedData["text"];
      wordsSaved = optimizedData["wordsSaved"];
      percentageSaved = optimizedData["percentageSaved"];
      optimizedFile = pdfFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
      appBar: AppBar(title: Text("Eco-Friendly Text Optimizer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Words Saved: $wordsSaved (${percentageSaved.toStringAsFixed(2)}%)",
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // ignore: prefer_const_constructors
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(extractedText, textAlign: TextAlign.center),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertFile,
              // ignore: prefer_const_constructors
              child: Text("Select & Optimize File"),
            ),
            if (optimizedFile != null) ...[
              ElevatedButton(
                onPressed: () => AIConverter.shareFile(optimizedFile!),
                // ignore: prefer_const_constructors
                child: Text("Share Optimized PDF"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
