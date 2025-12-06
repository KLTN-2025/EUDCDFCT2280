import 'package:flutter/material.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/localization/translator.dart';
import 'package:lottie/lottie.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/font.json',
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
          frameRate: const FrameRate(30),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 20,
        ),
        Text(
          tr(LocaleData.title2),
          // ignore: prefer_const_constructors
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 10,
        ),
        Container(
          // ignore: prefer_const_constructors
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            tr(LocaleData.body2),
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 15,
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
