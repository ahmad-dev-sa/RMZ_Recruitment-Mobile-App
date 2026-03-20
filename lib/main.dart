import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

Future<void> main() async {
  // 1. Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // 3. Run the App wrapped with Riverpod ProviderScope and EasyLocalization
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations', // <-- Asset path to translation files
        fallbackLocale: const Locale('ar'), // Default language is Arabic
        startLocale: const Locale('ar'),
        child: const RMZApp(),
      ),
    ),
  );
}
