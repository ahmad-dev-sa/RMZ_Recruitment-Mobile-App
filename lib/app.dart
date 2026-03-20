import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class RMZApp extends ConsumerWidget {
  const RMZApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine current theme mode from a future ThemeProvider
    // For now we default to ThemeMode.system
    final ThemeMode currentThemeMode = ThemeMode.system;

    return ScreenUtilInit(
      designSize: const Size(390, 844), // Base design size (e.g iPhone 13/14)
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'RMZ Recruitment',
          debugShowCheckedModeBanner: false,
          
          // Localization Setup
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // Theme Setup
          themeMode: currentThemeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // Routing Setup
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
