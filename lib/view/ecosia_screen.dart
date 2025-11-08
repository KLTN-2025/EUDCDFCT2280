import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';

// ignore: use_key_in_widget_constructors
class EcosiaCloneScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EcosiaCloneScreenState createState() => _EcosiaCloneScreenState();
}

class _EcosiaCloneScreenState extends State<EcosiaCloneScreen> {
  int treeCount = 94829305; // Starting number
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startCounting();
  }

  void startCounting() {
    // ignore: prefer_const_constructors
    _timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        treeCount += 1; // Increase the count by 1 every 2 seconds
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/ecosia_logo.png', height: 100),
              // ignore: prefer_const_constructors
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: tr(LocaleData.ecosiasr),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // ignore: prefer_const_constructors
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(height: 20),
              Text(
                // "$treeCount",
                // ignore: unnecessary_string_interpolations
                "${treeCount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => "${match[1]},")}",
                // ignore: prefer_const_constructors
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(tr(LocaleData.ecosiaDS)),
              // ignore: prefer_const_constructors
              SizedBox(height: 30),
              // ignore: prefer_const_constructors
              Icon(
                Icons.arrow_downward,
                size: 40,
                color: Colors.blueAccent,
              ),
              // ignore: prefer_const_constructors
              Spacer(),
              Image.asset(
                'assets/landscape.png',
                height: 500,
                fit: BoxFit.cover,
              ),
            ],
          ),

          // Back Button (Positioned at Top-Left)
          Positioned(
            top: 40, // Adjust position from the top
            left: 20, // Adjust position from the left
            child: IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
          ),
        ],
      ),
    );
  }
}
