import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../orders/presentation/providers/orders_provider.dart';
import '../../providers/daily_hourly_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class DHPaymentStep extends ConsumerWidget {
  const DHPaymentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(dailyHourlyProvider);
    final notifier = ref.read(dailyHourlyProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
             padding: EdgeInsets.all(20.w),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Payment Method Title
                 Row(
                   children: [
                     Container(width: 4.w, height: 24.h, color: AppColors.primary),
                     SizedBox(width: 8.w),
                     Text(
                       'daily_hourly.payment_method'.tr(),
                       style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                     ),
                   ],
                 ),
                 SizedBox(height: 16.h),
                 
                 // Payment Options
                 Container(
                   decoration: BoxDecoration(
                     color: isDark ? Colors.grey.shade900 : Colors.white,
                     borderRadius: BorderRadius.circular(16.r),
                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                   ),
                   child: Column(
                     children: [
                       _buildPaymentRadio('daily_hourly.credit_card'.tr(), 'credit', Icons.credit_card_outlined, state, notifier, isDark),
                       Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                       _buildPaymentRadio('daily_hourly.cash_delivery'.tr(), 'cash', Icons.local_shipping_outlined, state, notifier, isDark),
                       Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                       _buildPaymentRadio('STC Pay', 'stc', null, state, notifier, isDark, imageAsset: null), // STC Pay logo mock
                       Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                       _buildPaymentRadio('daily_hourly.sadad'.tr(), 'sadad', null, state, notifier, isDark, imageAsset: null),
                       Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                       _buildPaymentRadio('Tamara Pay', 'tamara', null, state, notifier, isDark, subtitle: 'daily_hourly.tamara_desc'.tr()),
                     ],
                   ),
                 ),
                 
                 SizedBox(height: 16.h),
                 Center(
                   child: Text('daily_hourly.pay_apple_pay'.tr(), style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp)),
                 ),
                 SizedBox(height: 8.h),
                 
                 // Apple Pay Button
                 GestureDetector(
                   onTap: () => notifier.setPaymentMethod('apple_pay'),
                   child: Container(
                     width: double.infinity,
                     height: 50.h,
                     decoration: BoxDecoration(
                       color: isDark ? Colors.white : Colors.black,
                       borderRadius: BorderRadius.circular(8.r),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('daily_hourly.apple_pay'.tr(), style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                         SizedBox(width: 8.w),
                         Icon(Icons.apple, color: isDark ? Colors.black : Colors.white, size: 24.sp),
                       ],
                     ),
                   ),
                 ),
                 
                 SizedBox(height: 24.h),
                 
                 // Promo Code Title
                 Align(
                   alignment: AlignmentDirectional.centerStart,
                   child: Text('daily_hourly.have_promo'.tr(), style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                 ),
                 SizedBox(height: 8.h),
                 
                 // Promo Code Input
                 Row(
                   children: [
                     Expanded(
                       child: Container(
                         height: 50.h,
                         decoration: BoxDecoration(
                           color: isDark ? Colors.grey.shade900 : Colors.white,
                           borderRadius: BorderRadius.circular(12.r),
                           border: Border.all(color: AppColors.primary),
                         ),
                         child: Row(
                           children: [
                             SizedBox(width: 16.w),
                             Icon(Icons.discount_outlined, color: AppColors.primary, size: 20.sp),
                             SizedBox(width: 8.w),
                             Expanded(
                               child: TextField(
                                 decoration: InputDecoration(
                                   border: InputBorder.none,
                                   hintText: 'daily_hourly.enter_promo'.tr(),
                                   hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
                                 ),
                                 style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14.sp),
                                 onChanged: (val) => notifier.setPromoCode(val),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                     SizedBox(width: 12.w),
                     InkWell(
                       onTap: () => _verifyCode(context, ref, notifier, state),
                       child: Container(
                         height: 50.h,
                         padding: EdgeInsets.symmetric(horizontal: 24.w),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12.r)),
                         child: Text('daily_hourly.send'.tr(), style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                       ),
                     ),
                   ],
                 ),
                 
                 SizedBox(height: 32.h),
                 
                 // Final Totals
                 Builder(
                   builder: (context) {
                     // Calculate discount purely for UI demonstration or based on promo
                     final double discount = state.promoDiscount;
                     final double grandTotal = state.packagePrice - discount;

                     return Container(
                       padding: EdgeInsets.all(16.w),
                       decoration: BoxDecoration(
                         color: isDark ? Colors.grey.shade900 : Colors.white,
                         borderRadius: BorderRadius.circular(16.r),
                       ),
                       child: Column(
                         children: [
                           Row(
                             children: [
                               Text(
                                 'daily_hourly.payment_details'.tr(),
                                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                               ),
                             ],
                           ),
                           SizedBox(height: 16.h),
                           _buildTotalRow('daily_hourly.total_price_label'.tr(), state.packagePrice.toStringAsFixed(2)),
                           SizedBox(height: 12.h),
                           _buildTotalRow('daily_hourly.discount_amount'.tr(), discount.toStringAsFixed(2)),
                           SizedBox(height: 12.h),
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                             decoration: BoxDecoration(
                               color: AppColors.primary,
                               borderRadius: BorderRadius.circular(20.r),
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text('daily_hourly.grand_total'.tr(), style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                                 Text("${grandTotal > 0 ? grandTotal.toStringAsFixed(2) : '0.00'} ${'daily_hourly.sar'.tr()}", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                               ],
                             ),
                           ),
                         ],
                       ),
                     );
                   }
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
              text: 'daily_hourly.continue_btn'.tr(), // "Push to success" action
              isLoading: state.isSubmitting,
              onPressed: () async {
                if (state.selectedPaymentMethod == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      title: Text('daily_hourly.alert_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      content: Text('daily_hourly.select_payment_alert'.tr(), style: TextStyle(fontSize: 14.sp)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('daily_hourly.ok'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                
                notifier.setSubmitting(true);
                final bookingRepo = ref.read(bookingRepositoryProvider);
                try {
                  final orderData = {
                    'order_type': 'daily',
                    'package_id': state.selectedPackageId,
                    'service_id': state.selectedServiceId,
                    'daily_booking': {
                      'start_time': state.selectedPeriod == DayTimePeriod.morning ? '08:00:00' : '16:00:00',
                      'booking_date': state.selectedDate?.toIso8601String().split('T').first,
                      'city': state.selectedAddress != null && state.selectedAddress!.contains('،') 
                                ? state.selectedAddress!.split('،').first.trim() 
                                : 'الرياض', // Extract city from the registered address format
                      'address': state.selectedAddress ?? 'العنوان غير محدد',
                    },
                    'payment_method': state.selectedPaymentMethod,
                    if (state.promoCode != null && state.promoCode!.isNotEmpty && state.promoDiscount > 0)
                      'promo_code': state.promoCode,
                  };
                  
                  final order = await bookingRepo.createRecruitmentOrder(orderData);
                  
                  notifier.setCreatedOrder(order);
                  notifier.setSubmitting(false);
                  if (context.mounted) {
                    GoRouter.of(context).pushNamed('workflow-dh-success');
                  }
                } catch (e) {
                  notifier.setSubmitting(false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('daily_hourly.payment_failed'.tr()),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRadio(String title, String value, IconData? icon, DailyHourlyState state, DailyHourlyNotifier notifier, bool isDark, {String? subtitle, String? imageAsset}) {
    final isSelected = state.selectedPaymentMethod == value;
    return InkWell(
      onTap: () => notifier.setPaymentMethod(value),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.w),
              ),
              child: isSelected 
                  ? Center(child: Container(width: 10.w, height: 10.w, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)))
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey.shade800)),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(subtitle, style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade500), maxLines: 2),
                  ]
                ],
              ),
            ),
            if (icon != null) Icon(icon, color: AppColors.primary, size: 24.sp),
            if (imageAsset != null) Image.asset(imageAsset, height: 24.h), // Mock for custom logos like STC and Mada
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String amount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp, fontWeight: FontWeight.bold)),
           Text("$amount ${'daily_hourly.sar'.tr()}", style: TextStyle(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _verifyCode(BuildContext context, WidgetRef ref, DailyHourlyNotifier notifier, DailyHourlyState state) async {
    final code = state.promoCode;
    if (code == null || code.isEmpty) {
      notifier.setPromoDiscount(0.0);
      return;
    }

    final apiClient = ref.read(apiClientProvider);
    try {
      // Call without query params just in case backend filtering is not active, and filter locally
      final response = await apiClient.dio.get('marketing/offers/');
      
      List items = [];
      if (response.data is Map) {
         if (response.data.containsKey('data')) items = response.data['data'];
         else if (response.data.containsKey('results')) items = response.data['results'];
      } else if (response.data is List) {
         items = response.data;
      }
      
      // Match the entered code
      final filteredOffers = items.where((o) => o['discount_code']?.toString().toUpperCase() == code.toUpperCase()).toList();
      
      if (filteredOffers.isNotEmpty) {
        final offer = filteredOffers.first;
        final packageId = offer['package'];
        final serviceId = offer['service'];
        
        bool valid = true;
        // Verify package constraint if defined in the offer
        if (packageId != null && packageId.toString() != state.selectedPackageId) {
          valid = false;
        }
        
        if (!valid) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عذراً، هذا الكود غير مخصص لهذه الباقة!')));
          notifier.setPromoDiscount(0.0);
          return;
        }

        double discount = 0.0;
        if (offer['discount_amount'] != null) {
          discount = double.tryParse(offer['discount_amount'].toString()) ?? 0.0;
        } else if (offer['discount_percentage'] != null) {
          final pct = double.tryParse(offer['discount_percentage'].toString()) ?? 0.0;
          discount = state.packagePrice * (pct / 100);
        }
        
        notifier.setPromoDiscount(discount);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تطبيق الخصم بنجاح!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الكود غير صحيح أو منتهي الصلاحية.'), backgroundColor: Colors.red));
        notifier.setPromoDiscount(0.0);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ في التحقق من الكود.'), backgroundColor: Colors.red));
    }
  }
}
