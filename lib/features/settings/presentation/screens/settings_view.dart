import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widgets/settings_item_card.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentThemeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.goNamed('home');
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18.sp),
                  ),
                ),
                Text(
                  'settings.title'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 34.w), // Balance for centering
              ],
            ),
          ),

          // Settings List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              children: [
                // About Company
                SettingsItemCard(
                  title: 'settings.about_company'.tr(),
                  leadingIcon: Container(
                    width: 32.w,
                    height: 32.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  onTap: () {},
                ),

                // Contact Us
                SettingsItemCard(
                  title: 'settings.contact_us'.tr(),
                  leadingIcon: Icon(Icons.share_outlined, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  onTap: () {},
                ),

                // Language
                SettingsItemCard(
                  title: 'settings.language'.tr(),
                  leadingIcon: Icon(Icons.language_outlined, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  trailingWidget: _buildLanguageSwitch(context, isDark),
                  onTap: () {
                    // Toggle language logic mapping
                    _toggleLanguage(context);
                  },
                ),

                // App Theme
                SettingsItemCard(
                  title: 'settings.app_theme'.tr(),
                  leadingIcon: Icon(Icons.wb_sunny_outlined, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  trailingWidget: _buildThemeSwitch(currentThemeMode, ref, isDark),
                  onTap: () {
                    final isCurrentlyDark = currentThemeMode == ThemeMode.dark || 
                        (currentThemeMode == ThemeMode.system && isDark);
                    ref.read(themeProvider.notifier).toggleTheme(!isCurrentlyDark);
                  },
                ),

                // Technical Support
                SettingsItemCard(
                  title: 'settings.technical_support'.tr(),
                  leadingIcon: Icon(Icons.headset_mic_outlined, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  onTap: () {},
                ),

                // FAQ
                SettingsItemCard(
                  title: 'settings.faq'.tr(),
                  leadingIcon: Icon(Icons.chat_bubble_outline, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  onTap: () {},
                ),

                // Terms and Conditions
                SettingsItemCard(
                  title: 'settings.terms_and_conditions'.tr(),
                  leadingIcon: Icon(Icons.article_outlined, color: isDark ? Colors.white : AppColors.textPrimaryLight),
                  onTap: () {},
                ),
                
                SizedBox(height: 100.h), // Bottom padding for navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitch(BuildContext context, bool isDark) {
    bool isArabic = context.locale.languageCode == 'ar';
    return Container(
      width: 64.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: AppColors.headerDarkBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isArabic ? null : 4.w,
            right: isArabic ? 4.w : null,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: isArabic ? 8.w : null,
            right: isArabic ? null : 8.w,
            child: Text(
              isArabic ? 'العربية' : 'Eng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLanguage(BuildContext context) {
    if (context.locale.languageCode == 'ar') {
      context.setLocale(const Locale('en'));
    } else {
      context.setLocale(const Locale('ar'));
    }
  }

  Widget _buildThemeSwitch(ThemeMode currentMode, WidgetRef ref, bool isDarkContext) {
    // Determine if we are visually dark right now
    final isDark = currentMode == ThemeMode.dark || (currentMode == ThemeMode.system && isDarkContext);
    
    return Container(
      width: 64.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: isDark ? 4.w : null, // Assuming RTL goes reversed
            right: isDark ? null : 4.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: isDark ? null : 8.w,
            right: isDark ? 8.w : null,
            child: Text(
              isDark ? 'داكن' : 'فاتح',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black54,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
