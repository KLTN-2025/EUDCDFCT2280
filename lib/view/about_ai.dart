import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAIScreen extends StatelessWidget {
  const AboutAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About This Powered"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              // ignore: prefer_const_constructors
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    // ignore: prefer_const_constructors
                    AssetImage('assets/geminiai.png'), // Add your logo
              ),
              const SizedBox(height: 10),

              // App Name
              Text(
                "Python",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              // Version
              Text("Version 1.0.0",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 15),

              // Developer Info
              Text(
                "Powered by Python",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // App Description
              Text(
                tr(LocaleData.enginedescription),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),

              // Back Button
              // ElevatedButton.icon(
              //   onPressed: () => Navigator.pop(context),
              //   icon: const Icon(Icons.arrow_back),
              //   label: const Text("Back"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
