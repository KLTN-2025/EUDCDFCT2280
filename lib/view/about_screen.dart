import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleData.aboutapp)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            // ignore: prefer_const_constructors
            CircleAvatar(
              radius: 50,
              // ignore: prefer_const_constructors
              backgroundImage: AssetImage('assets/logo2.png'), // Add your logo
            ),
            const SizedBox(height: 10),

            // App Name
            Text(
              "Écolive",
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
              "Tuan Justin - App Developer",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // App Description
            Text(
              // "Écolive Converter helps you convert text into an eco-friendly font, reducing ink usage and minimizing the carbon footprint."
              tr(LocaleData.appdescription),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
