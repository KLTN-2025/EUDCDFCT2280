import 'package:flutter/material.dart';
import 'package:ecolive/loading/loading.dart';
import 'package:ecolive/localization/locales.dart';
import 'package:ecolive/view/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme_provider.dart';
import 'package:ecolive/localization/translator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Loading(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final currentLang = langProvider.currentLocale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(LocaleData.settings),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: ListView(
        children: [
          // ── Theme switch ──────────────────────────
          ListTile(
            leading: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny),
            title: Text(tr(LocaleData.light_darkmode)),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (val) async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 2));
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                themeProvider.toggleTheme();
              },
            ),
          ),

          // ── Language dropdown ─────────────────────
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(tr(LocaleData.language)),
            trailing: DropdownButton<String>(
              value: currentLang,
              onChanged: (code) async {
                if (code == null) return;
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                await context
                    .read<LanguageProvider>()
                    .changeLanguage(Locale(code));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              items: LOCALES
                  .map((l) => DropdownMenuItem(
                        value: l.languageCode,
                        child: Text(l.languageCode.toUpperCase()),
                      ))
                  .toList(),
            ),
          ),

          const Divider(), // Đường kẻ ngăn cách cho đẹp

          // MỤC MỚI: Xem lại Chính sách
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(tr(LocaleData.privacy_term)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Mở lại màn hình Dialog nhưng ẩn nút đồng ý (chỉ để đọc)
              // Hoặc mở thẳng Web Google Sites
              launchUrl(
                  Uri.parse('https://sites.google.com/view/ecolive-policies'),
                  mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
