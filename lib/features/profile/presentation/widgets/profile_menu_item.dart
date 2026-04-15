import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool hasArrow;
  final Color? iconColor;

  const ProfileMenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.hasArrow = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24.sp,
                  color: iconColor ?? (isDark ? Colors.grey.shade300 : AppColors.headerDarkBlue),
                ),
                SizedBox(width: 16.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.headerDarkBlue,
                  ),
                ),
              ],
            ),
            if (hasArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
