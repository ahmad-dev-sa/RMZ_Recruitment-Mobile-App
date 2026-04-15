import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsItemCard extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const SettingsItemCard({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon on the Start (Right in RTL)
            leadingIcon,
            SizedBox(width: 16.w),
            
            // Text in the middle
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ),
            
            // Trailing on the End (Left in RTL). 
            // In RTL, Icons.arrow_back_ios translates to a right-pointing arrow, 
            // but the mock shows a left-pointing arrow `<`.
            // Because RTL flips the arrow_forward_ios to left-pointing, we should just use forward_ios!
            if (trailingWidget != null) 
              trailingWidget!
            else 
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.sp,
                color: isDark ? Colors.grey.shade500 : AppColors.textPrimaryLight.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
