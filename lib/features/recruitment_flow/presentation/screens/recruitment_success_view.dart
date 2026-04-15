import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/pdf_helper.dart';
import '../../../booking/domain/entities/order_entity.dart';
import '../../../settings/presentation/providers/site_settings_provider.dart';

class RecruitmentSuccessView extends ConsumerWidget {
  final dynamic order; // Can be OrderEntity or OrderModel

  const RecruitmentSuccessView({super.key, this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(siteSettingsProvider);
    final settings = settingsAsyncValue.valueOrNull ?? {};
    // Parse the order details
    String packageName = 'success_step.default_package_name'.tr();
    String totalPrice = '0 ${'summary_step.sar'.tr()}';
    String orderNumber = '#---';
    String status = 'success_step.default_status'.tr();

    if (order is OrderEntity) {
      final o = order as OrderEntity;
      packageName = o.packageName;
      final priceStr = o.totalPrice.isNotEmpty ? o.totalPrice : '0';
      totalPrice = '$priceStr ${'summary_step.sar'.tr()}';
      orderNumber = o.orderNumber;
      status = o.status;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 24.w, right: 24.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue, // Better constant header color for both modes
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
            ),
            alignment: Alignment.centerRight, // Fixed to the right consistently
            child: Text(
              'success_step.order_confirmed'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Success Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white, // Softer inner card dark color
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, color: Colors.white, size: 40.sp),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'success_step.order_created_successfully'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Info Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Aligns to the right in RTL,
                          children: [
                            Text(
                              'success_step.order_information'.tr(),
                              style: TextStyle(
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildInfoRow('success_step.package'.tr(), packageName, isDark),
                        _buildInfoRow('success_step.total_price'.tr(), totalPrice, isDark, subValue: 'شامل الضريبة المضافة'),
                        _buildInfoRow('success_step.order_number'.tr(), orderNumber, isDark),
                        _buildInfoRow('success_step.order_status'.tr(), status, isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Footer
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary, width: 1.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          final dateStr = DateFormat('yyyy/MM/dd', context.locale.languageCode).format(DateTime.now());
                          
                          // Safely get settings mapping localized values if possible
                          final isArabic = context.locale.languageCode == 'ar';
                          final logoUrl = settings['logo'] as String?;
                          final companyName = isArabic 
                              ? settings['site_name_ar'] as String? ?? 'رمز للاستقدام'
                              : settings['site_name_en'] as String? ?? 'RMZ Recruitment';
                          
                          final phone = settings['contact_phone'] as String?;
                          final email = settings['contact_email'] as String?;
                          final address = isArabic
                              ? settings['address_ar'] as String?
                              : settings['address_en'] as String?;

                          PdfHelper.generateAndPrintOrderPdf(
                            orderNumber: orderNumber,
                            packageName: packageName,
                            totalPrice: totalPrice,
                            status: status,
                            date: dateStr,
                            isAr: isArabic,
                            logoUrl: logoUrl,
                            companyName: companyName,
                            phone: phone,
                            email: email,
                            address: address,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.picture_as_pdf, size: 18.sp),
                            SizedBox(width: 8.w),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'success_step.save_as_pdf'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),  
                        onPressed: () {
                          // Navigate back to home
                          context.go('/home');
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'success_step.return_to_home'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {String? subValue}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Always right in RTL
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                if (subValue != null) ...[
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      subValue,
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        fontSize: 9.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
