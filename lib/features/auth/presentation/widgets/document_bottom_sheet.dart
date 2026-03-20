import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

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
      height: MediaQuery.of(context).size.height * 0.7, // Occupy roughly 70% of screen height
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary, // Cyan background matching the design
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Stack(
        children: [
          // Content Area
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 60.h, // Space for the close button and title
                  bottom: 24.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
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
                      
                      // Content text
                      Text(
                        content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                          height: 1.8,
                          fontSize: 15.sp,
                        ),
                        textAlign: TextAlign.justify, // Added justify for structured reading
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
