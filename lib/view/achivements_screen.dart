import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// ignore: use_key_in_widget_constructors
class AchievementsScreen extends StatelessWidget {
  final String achievementTitle = "Completed Flutter Course! 🎉";
  final String achievementDescription =
      "I just completed my Flutter Development Course. Excited to build amazing apps! 🚀";
  final String achievementImage =
      "https://example.com/achievement_image.png"; // Replace with actual image URL

  void _shareAchievement(BuildContext context) {
    final String shareText =
        "$achievementTitle\n\n$achievementDescription\n\nCheck out my achievement!";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_const_constructors
          Icon(Icons.emoji_events, size: 80, color: Colors.orange),
          // ignore: prefer_const_constructors
          SizedBox(height: 10),
          Text(
            achievementTitle,
            // ignore: prefer_const_constructors
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          SizedBox(height: 5),
          Text(
            achievementDescription,
            textAlign: TextAlign.center,
            // ignore: prefer_const_constructors
            style: TextStyle(fontSize: 16),
          ),
          // ignore: prefer_const_constructors
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _shareAchievement(context),
            // ignore: prefer_const_constructors
            icon: Icon(Icons.share),
            // ignore: prefer_const_constructors
            label: Text("Share Achievement"),
          ),
        ],
      ),
    );
  }
}
