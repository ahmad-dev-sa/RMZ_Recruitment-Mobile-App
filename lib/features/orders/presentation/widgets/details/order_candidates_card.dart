import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/order_details_provider.dart';
import 'candidate_cv_fullscreen_view.dart';
import 'candidate_videos_view.dart';
import '../../../../../core/services/pdf_helper.dart';
import '../../../../settings/presentation/providers/site_settings_provider.dart';

class OrderCandidatesCard extends ConsumerWidget {
  final OrderDetailsEntity order;

  const OrderCandidatesCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final hasCandidates = order.candidates.isNotEmpty;
    final actionState = ref.watch(orderDetailsActionProvider);
    final settingsAsync = ref.watch(siteSettingsProvider);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.selectedCandidate != null 
                  ? 'orders.hired_candidate'.tr() 
                  : 'orders.candidates_process'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              if (order.selectedCandidate == null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${order.candidates.length}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          if (order.selectedCandidate != null)
            // Hired Candidate View
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: isDark ? Colors.green.shade800 : Colors.green.shade300),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    backgroundImage: order.selectedCandidate!.imageUrl != null ? NetworkImage(order.selectedCandidate!.imageUrl!) : null,
                    child: order.selectedCandidate!.imageUrl == null
                        ? Icon(Icons.person, size: 30.sp, color: Colors.grey.shade500)
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              'orders.hired_candidate'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.green.shade400 : Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          order.selectedCandidate!.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (order.selectedCandidate!.getLocalizedNationality(isAr).isNotEmpty || order.selectedCandidate!.getLocalizedProfession(isAr).isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            [
                              if (order.selectedCandidate!.getLocalizedProfession(isAr).isNotEmpty) order.selectedCandidate!.getLocalizedProfession(isAr),
                              if (order.selectedCandidate!.getLocalizedNationality(isAr).isNotEmpty) order.selectedCandidate!.getLocalizedNationality(isAr),
                            ].join(' • '),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (!hasCandidates)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'orders.no_candidates_yet'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            // In case we have candidates, we show them in a horizontal list or grid.
            // Simplified horizontal list for future scaling
            // In case we have candidates, we show them in a horizontal list
            SizedBox(
              height: 360.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.candidates.length,
                separatorBuilder: (context, index) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  final cand = order.candidates[index];
                  return Container(
                    width: 200.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 36.r,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: cand.imageUrl != null ? NetworkImage(cand.imageUrl!) : null,
                          child: cand.imageUrl == null
                              ? Icon(Icons.person, size: 36.sp, color: Colors.grey.shade500)
                              : null,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          cand.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (cand.getLocalizedNationality(isAr).isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            cand.getLocalizedNationality(isAr),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          height: 32.h,
                          child: ElevatedButton(
                            onPressed: actionState.isLoading ? null : () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                                  title: Text('orders.hire_confirmation_title'.tr(), style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                  content: Text('orders.hire_confirmation_message'.tr(), style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.grey.shade800, fontSize: 14.sp)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text('orders.cancel'.tr(), style: TextStyle(color: Colors.grey)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                      child: Text('orders.yes_hire'.tr(), style: const TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await ref.read(orderDetailsActionProvider.notifier).hireCandidate(order.id, cand.id);
                                if (!context.mounted) return;
                                final currentState = ref.read(orderDetailsActionProvider);
                                if (currentState.hasError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(currentState.error.toString()), backgroundColor: AppColors.error),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: const Text("تم إرسال طلب التوظيف بنجاح!"), backgroundColor: Colors.green),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'orders.hire_candidate'.tr(),
                              style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (cand.workerDetails?.cv != null) ...[
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.description_outlined,
                                  label: 'orders.cv'.tr(),
                                  color: Colors.blue.shade600,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CandidateCvFullscreenView(candidate: cand),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _buildActionButton(
                                  icon: Icons.play_circle_outline,
                                  label: 'orders.videos'.tr(),
                                  color: Colors.purple.shade600,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => CandidateVideosView(candidate: cand),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: double.infinity,
                            child: _buildActionButton(
                              icon: Icons.download_rounded,
                              label: 'orders.save_pdf'.tr(),
                              color: Colors.green.shade600,
                              onTap: () async {
                                String? logoUrl;
                                String? companyName;
                                settingsAsync.whenData((data) {
                                  if (data.isNotEmpty) {
                                    logoUrl = data['logo'];
                                    companyName = isAr ? data['site_name_ar'] : data['site_name_en'];
                                  }
                                });
                                
                                await PdfHelper.generateAndPrintCandidateCV(
                                  candidate: cand,
                                  isAr: isAr,
                                  logoUrl: logoUrl,
                                  companyName: companyName,
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 4.h),
            Text(label, style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1),
          ],
        ),
      ),
    );
  }
}
