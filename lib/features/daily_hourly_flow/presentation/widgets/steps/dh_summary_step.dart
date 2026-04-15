import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../providers/daily_hourly_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../settings/presentation/providers/site_settings_provider.dart';

class DHSummaryStep extends ConsumerWidget {
  const DHSummaryStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(dailyHourlyProvider);
    final notifier = ref.read(dailyHourlyProvider.notifier);

    final dateStr = state.selectedDate != null ? DateFormat('yyyy-MM-dd').format(state.selectedDate!) : "";

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Title
                Row(
                  children: [
                    Container(width: 4.w, height: 24.h, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      'daily_hourly.order_summary'.tr(),
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                
                // Order Info Label
                Text(
                  'daily_hourly.order_info'.tr(),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                SizedBox(height: 12.h),
                
                // Address Row
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('daily_hourly.address'.tr(), style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp)),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          state.selectedAddress ?? 'daily_hourly.not_specified'.tr(), 
                          textAlign: TextAlign.end,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20.h),
                // Divider with dashes
                Row(
                  children: List.generate(30, (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      height: 1.h,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  )),
                ),
                SizedBox(height: 20.h),

                // Package Details Label
                Text(
                  'daily_hourly.package_details'.tr(),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                SizedBox(height: 12.h),

                // Details List
                _buildDetailRow('daily_hourly.service'.tr(), 'daily_hourly.service_hourly'.tr(), isDark),
                _buildDetailRow('daily_hourly.package_type'.tr(), 'daily_hourly.housemaid'.tr(), isDark),
                _buildDetailRow('daily_hourly.package'.tr(), state.selectedPackageName ?? 'daily_hourly.not_specified'.tr(), isDark),
                _buildDetailRow('daily_hourly.period'.tr(), state.selectedPeriod == DayTimePeriod.morning ? 'daily_hourly.morning'.tr() : 'daily_hourly.evening'.tr(), isDark),
                _buildDetailRow('daily_hourly.visits_count'.tr(), '${state.selectedVisitCount}', isDark),
                _buildDetailRow('daily_hourly.date'.tr(), dateStr, isDark),
                _buildDetailRow('daily_hourly.total_price_label'.tr(), '${state.packagePrice.toStringAsFixed(2)} ${'daily_hourly.sar'.tr()}', isDark),
                
                SizedBox(height: 16.h),

                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: state.termsAccepted,
                      onChanged: (val) => notifier.toggleTerms(val ?? false),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'daily_hourly.terms_agree'.tr().split('الشروط')[0],
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'daily_hourly.terms_link'.tr(),
                              style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                _showTermsBottomSheet(context, isDark);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Orange Alert
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded, color: Colors.orange, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text('daily_hourly.alert_warn'.tr(), style: TextStyle(color: Colors.orange, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'daily_hourly.alert_female_required'.tr(),
                          style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.black87, fontSize: 12.sp),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        
        // Footer with Continuous Button
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: 'daily_hourly.continue_btn'.tr(),
              onPressed: state.termsAccepted ? () => notifier.nextStep() : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp)),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final isAr = context.locale.languageCode == 'ar';
            final settingsAsync = ref.watch(siteSettingsProvider);

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'daily_hourly.terms_link'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: settingsAsync.when(
                      data: (settings) {
                        final termsAr = settings['terms_ar'] ?? '<p>لا توجد شروط وأحكام (Ar).</p>';
                        final termsEn = settings['terms_en'] ?? '<p>No Terms and Conditions found (En).</p>';
                        final termsContent = isAr ? termsAr : termsEn;
                        return SingleChildScrollView(
                          child: Html(
                            data: termsContent,
                            style: {
                              "body": Style(
                                fontSize: FontSize(14.sp),
                                color: isDark ? Colors.white : Colors.black87,
                                margin: Margins.zero,
                              ),
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          isAr ? 'حدث خطأ في تحميل الشروط والأحكام.' : 'Error loading terms and conditions.',
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: isAr ? 'إغلاق' : 'Close',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
