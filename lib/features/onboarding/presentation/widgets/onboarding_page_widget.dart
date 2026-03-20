import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';

class OnboardingPageInfo {
  final String imagePath;
  final String titleTranslationKey;
  final String descriptionTranslationKey;

  const OnboardingPageInfo({
    required this.imagePath,
    required this.titleTranslationKey,
    required this.descriptionTranslationKey,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageInfo info;

  const OnboardingPageWidget({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          
          // Image Section
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: AssetImage(info.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 50.h),
          
          // Text Section
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  info.titleTranslationKey.tr(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                    fontSize: 28.sp,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  info.descriptionTranslationKey.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 15.sp,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
