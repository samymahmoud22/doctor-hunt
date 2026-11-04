import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_hunt/core/localization/locale_helper.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleHelper Unit Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocaleSettings.setLocale(AppLocale.en);
    });

    tearDown(() async {
      await LocaleSettings.setLocale(AppLocale.en);
    });

    test('setLocale switches locale and persists to SharedPreferences', () async {
      expect(LocaleSettings.currentLocale, AppLocale.en);

      final result = await LocaleHelper.setLocale(AppLocale.ar);
      expect(result, AppLocale.ar);
      expect(LocaleSettings.currentLocale, AppLocale.ar);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(LocaleHelper.prefKey), 'ar');

      // Switch back to English
      final backResult = await LocaleHelper.setLocale(AppLocale.en);
      expect(backResult, AppLocale.en);
      expect(LocaleSettings.currentLocale, AppLocale.en);
      expect(prefs.getString(LocaleHelper.prefKey), 'en');
    });

    test('toggleLocale switches back and forth between en and ar', () async {
      await LocaleHelper.setLocale(AppLocale.en);
      expect(LocaleSettings.currentLocale, AppLocale.en);

      final firstToggle = await LocaleHelper.toggleLocale();
      expect(firstToggle, AppLocale.ar);
      expect(LocaleSettings.currentLocale, AppLocale.ar);

      final secondToggle = await LocaleHelper.toggleLocale();
      expect(secondToggle, AppLocale.en);
      expect(LocaleSettings.currentLocale, AppLocale.en);
    });

    test('initializeLocale loads saved locale from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        LocaleHelper.prefKey: 'ar',
      });

      final loaded = await LocaleHelper.initializeLocale();
      expect(loaded, AppLocale.ar);
      expect(LocaleSettings.currentLocale, AppLocale.ar);
    });

    test('initializeLocale edge case: empty or invalid code falls back safely', () async {
      SharedPreferences.setMockInitialValues({
        LocaleHelper.prefKey: '',
      });

      final loaded = await LocaleHelper.initializeLocale();
      expect(loaded, isA<AppLocale>());
    });
  });

  group('LocaleHelper Widget Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocaleSettings.setLocale(AppLocale.en);
    });

    tearDown(() async {
      await LocaleSettings.setLocale(AppLocale.en);
    });

    testWidgets('showLanguageSelectionBottomSheet opens sheet and switches language on tap', (tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => LocaleHelper.showLanguageSelectionBottomSheet(context),
                    child: const Text('Change Language'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.text('Change Language'));
      await tester.pumpAndSettle();

      // Verify both language options are rendered
      expect(find.text('English'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);

      // Tap on Arabic
      await tester.tap(find.byKey(const Key('language_option_ar')));
      await tester.pumpAndSettle();

      // Verify locale changed to Arabic
      expect(LocaleSettings.currentLocale, AppLocale.ar);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(LocaleHelper.prefKey), 'ar');
    });
  });
}

