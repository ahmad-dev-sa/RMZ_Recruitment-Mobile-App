import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

import 'package:flutter_html/flutter_html.dart';

class DocumentBottomSheet extends StatelessWidget {
  final String title;
  final String content;

  const DocumentBottomSheet({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7, 
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 60.h, 
                  bottom: 24.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                          fontSize: 28.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      Html(
                        data: content,
                        style: {
                          "body": Style(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                            fontSize: FontSize(15.sp),
                            lineHeight: LineHeight(1.8),
                            textAlign: TextAlign.justify,
                            padding: HtmlPaddings.zero,
                            margin: Margins.zero,
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: 8.h),
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Close Icon Button
          Positioned(
            top: 24.h, // Adjusted to match design
            left: 24.w, // Match padding from edge
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.close,
                  color: isDark ? AppColors.backgroundDark : AppColors.secondary, // The 'x' matches the background color inside a white box
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
