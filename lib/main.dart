import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/localization/locale_helper.dart';
import 'package:doctor_hunt/core/router/app_router.dart';
import 'package:doctor_hunt/core/themes/app_theme.dart';
import 'package:doctor_hunt/core/utils/app_logger.dart';
import 'package:doctor_hunt/generated/i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      publishableKey: SupabaseConstants.supabaseAnonKey,
    );
  } catch (e) {
    AppLogger.warning('Supabase initialization warning: $e');
  }
  await setupLocator();
  await LocaleHelper.initializeLocale();
  runApp(TranslationProvider(child: const DoctorHuntApp()));
}

class DoctorHuntApp extends StatelessWidget {
  const DoctorHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Doctor Hunt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocale.values.map((e) => e.flutterLocale),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
