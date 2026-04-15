import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';

class CandidateVideosView extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateVideosView({super.key, required this.candidate});

  Future<void> _launchVideoUrl(BuildContext context, String urlStr) async {
    final Uri url = Uri.parse(urlStr);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('orders.video_launch_error'.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final videos = candidate.workerDetails?.cv?.videos ?? [];

    return Container(
      padding: EdgeInsets.only(top: 16.h, left: 24.w, right: 24.w, bottom: 40.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 48.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          Text(
            'orders.cv_videos_title'.tr(args: [candidate.name]),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          
          if (videos.isEmpty)
             Padding(
               padding: EdgeInsets.symmetric(vertical: 40.h),
               child: Text(
                 'orders.no_videos'.tr(),
                 style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
               ),
             )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: videos.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return InkWell(
                    onTap: () => _launchVideoUrl(context, video.url),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                             padding: EdgeInsets.all(12.w),
                             decoration: BoxDecoration(
                               color: Colors.red.shade50,
                               shape: BoxShape.circle,
                             ),
                             child: Icon(Icons.play_arrow_rounded, color: Colors.red.shade600, size: 24.sp),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video.title.isNotEmpty ? video.title : 'orders.video_interview'.tr(),
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'orders.click_to_play'.tr(),
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.open_in_new_rounded, size: 16.sp, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
