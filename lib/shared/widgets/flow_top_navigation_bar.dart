import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class FlowTopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;
  final Color? backgroundColor;
  final Color? textColor;

  const FlowTopNavigationBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onClosePressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? (isDark ? AppColors.backgroundDark : AppColors.backgroundLight);
    final fgColor = textColor ?? (isDark ? AppColors.textPrimaryLight : AppColors.textPrimaryDark);

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: fgColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: InkWell(
          onTap: onBackPressed ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded, // Right arrow for back in RTL
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: InkWell(
            onTap: onClosePressed ?? () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
