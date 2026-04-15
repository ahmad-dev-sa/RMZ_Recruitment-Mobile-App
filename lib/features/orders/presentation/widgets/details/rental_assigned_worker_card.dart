import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import 'candidate_cv_fullscreen_view.dart';

class RentalAssignedWorkerCard extends StatelessWidget {
  final OrderDetailsEntity order;

  const RentalAssignedWorkerCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final worker = order.selectedCandidate;

    if (worker == null) {
      return const SizedBox.shrink();
    }

    // Determine age and experience
    final age = worker.workerDetails?.age ?? '-';
    // Summing experiences or taking the first one? Often the total experience is displayed. We'll simply construct a string or show count.
    final List<ExperienceEntity> expList = worker.workerDetails?.cv?.experiences ?? [];
    String expString = expList.isEmpty ? 'orders.no_experience'.tr() : '${expList.length} ${"orders.years_of_experience".tr()}';
    // Fallback if there's no localization for years_of_experience yet
    if (expList.isNotEmpty) {
      // Just check if we can parse the duration
      int totalYears = 0;
      for (var exp in expList) {
        if (exp.duration.contains(RegExp(r'[0-9]'))) {
          // simple extract numbers, if not possible just use duration string
          final match = RegExp(r'\d+').firstMatch(exp.duration);
          if (match != null) {
            totalYears += int.tryParse(match.group(0) ?? '0') ?? 0;
          }
        }
      }
      if (totalYears > 0) {
        expString = '$totalYears ${isAr ? "سنوات" : "years"}';
      } else {
        expString = expList.first.duration;
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAr ? 'العامل المعين' : 'Assigned Worker',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: worker.imageUrl != null ? NetworkImage(worker.imageUrl!) : null,
                child: worker.imageUrl == null
                    ? Icon(Icons.person, size: 30.sp, color: Colors.grey.shade500)
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        _buildInfoChip(isAr ? 'الجنسية: ' : 'Nationality: ', worker.getLocalizedNationality(isAr) ?? '-', isDark),
                        _buildInfoChip(isAr ? 'العمر: ' : 'Age: ', age.toString(), isDark),
                        _buildInfoChip(isAr ? 'الخبرة: ' : 'Experience: ', expString, isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CandidateCvFullscreenView(candidate: worker),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              icon: Icon(Icons.article_outlined, color: Colors.white, size: 20.sp),
              label: Text(
                isAr ? 'الذهاب الى السيرة الذاتية للعاملة' : 'View Worker CV',
                style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
            TextSpan(text: value, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 11.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
