import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../providers/recruitment_provider.dart';
import '../../../../settings/presentation/providers/site_settings_provider.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';

class SummaryStepView extends ConsumerStatefulWidget {
  final int serviceId;

  const SummaryStepView({super.key, required this.serviceId});

  @override
  ConsumerState<SummaryStepView> createState() => _SummaryStepViewState();
}

class _SummaryStepViewState extends ConsumerState<SummaryStepView> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recruitmentProvider);
    final notifier = ref.read(recruitmentProvider.notifier);
    final package = state.selectedPackage;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainTitle('summary_step.order_summary'.tr()),
                SizedBox(height: 16.h),
                
                // Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.primary, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('summary_step.order_information'.tr(), style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      SizedBox(height: 16.h),
                      _buildInfoRow('summary_step.address'.tr(), state.address ?? 'summary_step.not_specified'.tr()),
                      _buildInfoRow('summary_step.religion'.tr(), state.religion == 'مسلم' ? 'booking_info_step.muslim'.tr() : (state.religion == 'غير مسلم' ? 'booking_info_step.non_muslim'.tr() : 'booking_info_step.any'.tr())),
                      _buildInfoRow('summary_step.family_members_count'.tr(), state.familyMembersCount.toString()),
                      if (state.hasVisa)
                        _buildInfoRow('summary_step.visa_number'.tr(), state.visaNumber ?? 'summary_step.not_specified'.tr()),
                      
                      SizedBox(height: 16.h),
                      // Dashed Divider
                      Row(
                        children: List.generate(
                          30,
                          (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0 ? Colors.transparent : AppColors.primary.withAlpha(150),
                              height: 1.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      Text('summary_step.package_details'.tr(), style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      SizedBox(height: 16.h),
                      _buildInfoRow('summary_step.service'.tr(), context.locale.languageCode == 'ar' ? (package?.nameAr ?? 'summary_step.not_specified'.tr()) : (package?.nameEn ?? 'summary_step.not_specified'.tr())),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Cost Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.primary, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('summary_step.cost'.tr(), style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      SizedBox(height: 16.h),
                      // _buildInfoRow('سعر الباقة غير شامل الضريبة', '4782.61 ر.س', isCurrency: true),
                      _buildInfoRow('summary_step.worker_salary'.tr(), '${package?.monthlySalary ?? '0'} ${'summary_step.sar'.tr()} / ${'summary_step.month'.tr()}', isCurrency: true),
                      // _buildInfoRow('قيمة الضريبة المضافة', '717.3915 ر.س', isCurrency: true),
                      _buildInfoRow('summary_step.total_price'.tr(), '${package?.price ?? '0'} ${'summary_step.sar'.tr()}', isCurrency: true, isBold: true),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Terms Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'summary_step.i_agree_to_terms_and_conditions'.tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        _showTermsBottomSheet(context, ref);
                      },
                      child: Text(
                        'summary_step.terms_and_conditions'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: _agreedToTerms ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: _agreedToTerms 
                            ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
        
        // Footer Button
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: state.isLoading ? 'summary_step.processing'.tr() : 'continue'.tr(),
              onPressed: (_agreedToTerms && !state.isLoading)
                  ? () async {
                      final success = await notifier.submitOrder();
                      if (success && context.mounted) {
                        context.pushNamed(
                          'recruitment-success',
                          extra: ref.read(recruitmentProvider).submittedOrder,
                        );
                      } else if (!success && state.errorMessage != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
                        );
                      }
                    } 
                  : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          color: AppColors.primary,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isCurrency = false, bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(isDark ? 30 : 10),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 11.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              _buildMainTitle('summary_step.terms_and_conditions'.tr()),
              SizedBox(height: 16.h),
               Expanded(
                child: SingleChildScrollView(
                  child: Consumer(
                    builder: (context, consumerRef, _) {
                      final settingsAsync = consumerRef.watch(siteSettingsProvider);
                      final locale = context.locale.languageCode;
                      
                      return settingsAsync.when(
                        data: (settings) {
                          final termsText = locale == 'ar' 
                              ? settings['terms_ar'] as String? ?? 'لم يتم إضافة الشروط والأحكام بعد.' 
                              : settings['terms_en'] as String? ?? 'Terms and conditions have not been added yet.';
                          
                          return Html(
                            data: termsText,
                            style: {
                              "body": Style(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                                fontSize: FontSize(14.sp),
                                lineHeight: LineHeight(1.8),
                                padding: HtmlPaddings.zero,
                                margin: Margins.zero,
                              ),
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Html(
                          data: 'summary_step.terms_details'.tr(),
                          style: {
                            "body": Style(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontSize: FontSize(14.sp),
                              lineHeight: LineHeight(1.8),
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              PrimaryButton(
                text: 'summary_step.i_agree_to_terms_and_conditions'.tr(),
                onPressed: () {
                  setState(() => _agreedToTerms = true);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
            ],
          ),
        );
      },
    );
  }
}
