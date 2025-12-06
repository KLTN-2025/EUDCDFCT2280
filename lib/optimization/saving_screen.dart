import 'package:flutter/material.dart';

class SavingsScreen extends StatelessWidget {
  final double inkSaved;
  final int pagesSaved;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  SavingsScreen({required this.inkSaved, required this.pagesSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // ignore: prefer_const_constructors
          AppBar(title: Text("Savings Report"), backgroundColor: Colors.green),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: prefer_const_constructors
            Text("🎉 Optimization Complete!",
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            // ignore: prefer_const_constructors
            SizedBox(height: 20),
            Text("🖨 Ink Saved: $inkSaved%",
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 18, color: Colors.green)),
            Text("📄 Pages Saved: $pagesSaved",
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 18, color: Colors.green)),
            // ignore: prefer_const_constructors
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              // ignore: prefer_const_constructors
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
