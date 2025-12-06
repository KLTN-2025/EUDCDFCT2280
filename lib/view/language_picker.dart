import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../localization/locales.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (Locale locale) {
        localization.translate(locale as String);
        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        return LOCALES.map((mapLocale) {
          return PopupMenuItem<Locale>(
            value: mapLocale.locale,
            child: Text(
              mapLocale.locale.languageCode.toUpperCase(), // e.g. EN, FR
            ),
          );
        }).toList();
      },
    );
  }
}
