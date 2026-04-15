import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';

class CandidateCvFullscreenView extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateCvFullscreenView({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final workerDetails = candidate.workerDetails;
    final cv = workerDetails?.cv;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          _buildCustomHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildHeader(isDark, isAr),
                   SizedBox(height: 24.h),
                   if (workerDetails != null) _buildBasicInfo(workerDetails, isDark),
                   if (cv != null && cv.skills.isNotEmpty) ...[
                     SizedBox(height: 24.h),
                     _buildSectionTitle('orders.cv_skills'.tr(), Icons.star_border_rounded, isDark),
                     SizedBox(height: 12.h),
                     _buildSkills(cv.skills, isDark, isAr),
                   ],
                   if (cv != null && cv.languages.isNotEmpty) ...[
                     SizedBox(height: 24.h),
                     _buildSectionTitle('orders.cv_languages'.tr(), Icons.language_rounded, isDark),
                     SizedBox(height: 12.h),
                     _buildLanguages(cv.languages, isDark, isAr),
                   ],
                   if (cv != null && cv.experiences.isNotEmpty) ...[
                     SizedBox(height: 24.h),
                     _buildSectionTitle('orders.cv_experience'.tr(), Icons.work_outline_rounded, isDark),
                     SizedBox(height: 12.h),
                     _buildExperiences(cv.experiences, isDark, isAr),
                   ],
                   SizedBox(height: 40.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
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
              Navigator.pop(context);
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
            'orders.cv_title'.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 34.w), // Balance for centering
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, bool isAr) {
    return Row(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: candidate.imageUrl == null
                ? Icon(Icons.person, size: 40.sp, color: Colors.grey.shade400)
                : Image.network(
                    candidate.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 40.sp, color: Colors.grey.shade400);
                    },
                  ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                candidate.name,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              if (candidate.getLocalizedProfession(isAr).isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  candidate.getLocalizedProfession(isAr),
                  style: TextStyle(fontSize: 14.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
              if (candidate.getLocalizedNationality(isAr).isNotEmpty) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey.shade500),
                    SizedBox(width: 4.w),
                    Text(
                      candidate.getLocalizedNationality(isAr),
                      style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo(WorkerDetailsEntity details, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        alignment: WrapAlignment.spaceAround,
        children: [
          if (details.age != null) _buildInfoItem('orders.cv_age'.tr(), details.age!, Icons.cake_outlined, isDark),
          if (details.religion != null) _buildInfoItem('orders.cv_religion'.tr(), details.religion!, Icons.mosque_outlined, isDark),
          if (details.maritalStatus != null) _buildInfoItem('orders.cv_marital'.tr(), details.maritalStatus!, Icons.family_restroom_outlined, isDark),
          if (details.childrenCount != null) _buildInfoItem('orders.cv_children'.tr(), details.childrenCount.toString(), Icons.child_care_outlined, isDark),
          if (details.height != null) _buildInfoItem('orders.cv_height'.tr(), "\${details.height} cm", Icons.height_outlined, isDark),
          if (details.weight != null) _buildInfoItem('orders.cv_weight'.tr(), "\${details.weight} kg", Icons.monitor_weight_outlined, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, bool isDark) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 10.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
      ],
    );
  }

  Widget _buildSkills(List<SkillEntity> skills, bool isDark, bool isAr) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: skills.map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (skill.iconUrl != null) ...[
                Image.network(
                  skill.iconUrl!, 
                  width: 16.w, 
                  height: 16.w, 
                  color: AppColors.primary,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.check_circle_outline, size: 16.w, color: AppColors.primary);
                  },
                ),
                SizedBox(width: 6.w),
              ] else ...[
                 Icon(Icons.check_circle_outline, size: 16.w, color: AppColors.primary),
                 SizedBox(width: 6.w),
              ],
              Flexible(
                child: Text(
                  skill.getLocalizedName(isAr),
                  style: TextStyle(color: AppColors.primary, fontSize: 13.sp, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguages(List<LanguageEntity> languages, bool isDark, bool isAr) {
    return Column(
      children: languages.map((lang) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.getLocalizedName(isAr),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
              ),
              Container(
                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                 decoration: BoxDecoration(
                   color: Colors.blue.shade50,
                   borderRadius: BorderRadius.circular(12.r)
                 ),
                 child: Text(
                    lang.level,
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12.sp, fontWeight: FontWeight.bold),
                 ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExperiences(List<ExperienceEntity> experiences, bool isDark, bool isAr) {
    return Column(
      children: experiences.map((exp) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                 padding: EdgeInsets.all(8.w),
                 decoration: BoxDecoration(
                   color: Colors.orange.shade50,
                   shape: BoxShape.circle,
                 ),
                 child: Icon(Icons.work_history_rounded, color: Colors.orange.shade400, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.getLocalizedTitle(isAr).isNotEmpty ? exp.getLocalizedTitle(isAr) : 'orders.exp_worker'.tr(),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, size: 14.sp, color: Colors.grey.shade500),
                        SizedBox(width: 4.w),
                        Text(
                          exp.getLocalizedCountry(isAr).isNotEmpty ? exp.getLocalizedCountry(isAr) : 'orders.unknown_country'.tr(),
                          style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        ),
                        SizedBox(width: 12.w),
                        Icon(Icons.access_time_rounded, size: 14.sp, color: Colors.grey.shade500),
                        SizedBox(width: 4.w),
                        Text(
                          exp.duration,
                          style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
