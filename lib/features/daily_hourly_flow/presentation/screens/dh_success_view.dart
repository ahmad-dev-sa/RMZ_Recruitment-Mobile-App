import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_stepper.dart';
import '../providers/daily_hourly_provider.dart';
import '../../../../../core/services/pdf_helper.dart';
import '../../../settings/presentation/providers/site_settings_provider.dart';
class DhSuccessView extends ConsumerWidget {
  const DhSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(dailyHourlyProvider);
    final order = state.createdOrder;
    final siteSettingsAsync = ref.watch(siteSettingsProvider);

    final stepsKeys = [
      'daily_hourly.step_packages'.tr(),
      'daily_hourly.step_booking_info'.tr(),
      'daily_hourly.step_summary'.tr(),
      'daily_hourly.step_payment'.tr(),
    ];

    String packageTitle = order?.packageName ?? 'daily_hourly.title'.tr();
    String totalPrice = '${order?.totalPrice ?? state.packagePrice} ${'daily_hourly.sar'.tr()}';
    String orderNumber = '#${order?.orderNumber ?? ''}';
    String orderStatus = _translateStatus(order?.status ?? 'pending');
    String paymentStatus = order?.paymentStatus != null ? _translateStatus(order!.paymentStatus!) : 'daily_hourly.paid'.tr();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(top: 60.h, bottom: 0.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
                        child: Icon(Icons.close_rounded, color: AppColors.primary, size: 24.sp),
                      ),
                    ),
                    Text(
                      'daily_hourly.title'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 32.w),
                  ],
                ),
                SizedBox(height: 10.h),
                CustomStepper(currentStep: 4, steps: stepsKeys), 
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                       color: isDark ? Colors.grey.shade900 : Colors.white,
                       borderRadius: BorderRadius.circular(16.r),
                       border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Icon(Icons.check_rounded, color: Colors.white, size: 40.sp),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'daily_hourly.payment_success'.tr(),
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryDark),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                       color: isDark ? Colors.grey.shade900 : Colors.white,
                       borderRadius: BorderRadius.circular(16.r),
                       border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'daily_hourly.order_info'.tr(),
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryDark),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        
                        _buildRow('daily_hourly.package'.tr(), packageTitle, isDark),
                        SizedBox(height: 8.h),
                        _buildRow('daily_hourly.total_price_label'.tr(), totalPrice, isDark),
                        SizedBox(height: 8.h),
                        if (order?.orderNumber != null) ...[
                          _buildRow('daily_hourly.order_number'.tr(), orderNumber, isDark),
                          SizedBox(height: 8.h),
                        ],
                        _buildRow('daily_hourly.order_status'.tr(), orderStatus, isDark),
                        SizedBox(height: 8.h),
                        _buildRow('daily_hourly.payment_status'.tr(), paymentStatus, isDark),
                        
                        SizedBox(height: 24.h),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              if (order != null) {
                                String? logoUrl;
                                String? companyName;
                                String? phone;
                                String? email;
                                String? address;
                                if (siteSettingsAsync is AsyncData) {
                                  final data = siteSettingsAsync.value;
                                  if (data != null) {
                                    logoUrl = data['logo_url'] ?? data['logo'];
                                    companyName = data['site_name'] ?? data['title_ar'];
                                    phone = data['phone'] ?? data['contact_phone'];
                                    email = data['email'] ?? data['contact_email'];
                                    address = data['address'] ?? data['address_ar'];
                                  }
                                }
                                PdfHelper.generateAndPrintOrderPdf(
                                  orderNumber: order.orderNumber,
                                  packageName: packageTitle,
                                  totalPrice: totalPrice,
                                  status: orderStatus,
                                  date: order.createdAt,
                                  isAr: context.locale.languageCode == 'ar',
                                  logoUrl: logoUrl,
                                  companyName: companyName,
                                  phone: phone,
                                  email: email,
                                  address: address,
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20.r)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('daily_hourly.download_invoice'.tr(), style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8.w),
                                  Icon(Icons.receipt_long_rounded, color: Colors.white, size: 16.sp),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
               color: isDark ? Colors.grey.shade900 : Colors.white,
               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                   context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.headerDarkBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text('daily_hourly.go_home'.tr(), style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
         color: isDark ? Colors.grey.shade800 : AppColors.backgroundLight,
         borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.w600)),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value, 
              style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pending': return 'orders.status_pending'.tr();
      case 'confirmed': return 'orders.status_confirmed'.tr();
      case 'in_progress': return 'orders.status_in_progress'.tr();
      case 'completed': return 'orders.status_completed'.tr();
      case 'cancelled': return 'orders.status_cancelled'.tr();
      case 'paid': return 'daily_hourly.paid'.tr();
      case 'unpaid': return 'daily_hourly.unpaid'.tr();
      case 'failed': return 'daily_hourly.payment_failed'.tr();
      default: return status;
    }
  }
}
