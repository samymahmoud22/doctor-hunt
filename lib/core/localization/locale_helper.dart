import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_hunt/core/themes/app_colors.dart';
import 'package:doctor_hunt/core/themes/app_text_styles.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

class LocaleHelper {
  LocaleHelper._();

  static const String prefKey = 'selected_language_code';

  /// Initialize the locale on app startup from SharedPreferences
  static Future<AppLocale> initializeLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(prefKey);
      if (savedCode != null && savedCode.isNotEmpty) {
        return await LocaleSettings.setLocaleRaw(savedCode);
      }
    } catch (_) {}
    return await LocaleSettings.useDeviceLocale();
  }

  /// Set the locale across the entire app and persist it in SharedPreferences
  static Future<AppLocale> setLocale(AppLocale locale) async {
    final result = await LocaleSettings.setLocale(locale);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKey, locale.languageCode);
    } catch (_) {}
    return result;
  }

  /// Toggle between English and Arabic
  static Future<AppLocale> toggleLocale() async {
    final next = LocaleSettings.currentLocale == AppLocale.ar ? AppLocale.en : AppLocale.ar;
    return await setLocale(next);
  }

  /// Display a modal bottom sheet allowing the user to pick English or Arabic
  static Future<void> showLanguageSelectionBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppColors.white,
      builder: (ctx) {
        final currentLocale = LocaleSettings.currentLocale;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t.profile.language,
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 16),
                _LanguageOptionTile(
                  key: const Key('language_option_en'),
                  title: 'English',
                  subtitle: 'English (US)',
                  isSelected: currentLocale == AppLocale.en,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    if (currentLocale != AppLocale.en) {
                      await setLocale(AppLocale.en);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _LanguageOptionTile(
                  key: const Key('language_option_ar'),
                  title: 'العربية',
                  subtitle: 'Arabic',
                  isSelected: currentLocale == AppLocale.ar,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    if (currentLocale != AppLocale.ar) {
                      await setLocale(AppLocale.ar);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isSelected ? AppColors.primaryDark : AppColors.textMain,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.subtext,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                color: AppColors.subtext,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

