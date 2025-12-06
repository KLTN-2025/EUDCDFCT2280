import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  final _loc = FlutterLocalization.instance;

  Locale _current = const Locale('en');

  Locale get currentLocale => _current;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> changeLanguage(Locale locale) async {
    _current = locale;
    _loc.translate(locale.languageCode);

    // lưu
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', locale.languageCode);

    notifyListeners(); // 🔥 BẮT BUỘC để toàn app rebuild
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('lang') ?? 'en';
    _current = Locale(code);
    _loc.translate(code);
    notifyListeners();
  }
}
