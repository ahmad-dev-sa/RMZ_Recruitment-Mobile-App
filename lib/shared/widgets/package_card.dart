import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';

class PackageSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String? priceSuffix; // defaults to tax_included
  final bool isSelected;
  final int maxWorkers;
  final List<String> nationalities;
  final String duration;
  final String workerSalary;
  final VoidCallback onTap;

  const PackageSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.priceSuffix,
    required this.isSelected,
    this.maxWorkers = 1,
    this.nationalities = const [],
    this.duration = '',
    this.workerSalary = '',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Right side gray placeholder block (First child in RTL is on the Right)
              Container(
                width: 90.w,
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              
              // Left content (Details, Title, Radio, Price)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Row: Title, Subtitle, and Radio Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          
                          // Radio button mimicking circle
                          Container(
                            width: 22.w,
                            height: 22.w,
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
                                width: isSelected ? 6.w : 1.5.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12.h),

                      // Additional details like workers, nationalities, duration, salary
                      if (duration.isNotEmpty || workerSalary.isNotEmpty) ...[
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 8.h,
                          children: [
                            _buildDetailItem(context, isDark, Icons.people_outline, '${'packages_step.max_workers'.tr()}: $maxWorkers'),
                            _buildDetailItem(context, isDark, Icons.public, '${'packages_step.nationalities'.tr()}: ${nationalities.isEmpty ? 'packages_step.all_nationalities'.tr() : nationalities.join(", ")}'),
                            if (duration.isNotEmpty)
                              _buildDetailItem(context, isDark, Icons.timer_outlined, '${'packages_step.duration'.tr()}: $duration'),
                            if (workerSalary.isNotEmpty)
                              _buildDetailItem(context, isDark, Icons.payments_outlined, '${'packages_step.worker_salary'.tr()}: $workerSalary'),
                          ],
                        ),
                        SizedBox(height: 12.h),
                      ],                      
                      // Bottom Row: Price and Suffix
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              priceSuffix ?? 'tax_included'.tr(),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: AppColors.primary, width: 1.w),
                              ),
                              child: Text(
                                price,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, bool isDark, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              fontSize: 10.sp,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
