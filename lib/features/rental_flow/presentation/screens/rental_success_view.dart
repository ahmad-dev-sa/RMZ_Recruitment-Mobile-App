import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../providers/rental_provider.dart';

class RentalSuccessView extends ConsumerWidget {
  const RentalSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(rentalProvider);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Icon & Message
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF42D3B8), // Matching the success teal color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'payment_successful'.tr(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Order Summary Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'order_info'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildInfoRow('package'.tr(), state.selectedPackage?.nameAr ?? ''),
                    SizedBox(height: 16.h),
                    if (state.createdOrder != null) ...[
                      _buildInfoRow('total_price'.tr(), '${state.createdOrder!.totalPrice} ريال', highlight: false),
                      SizedBox(height: 16.h),
                      _buildInfoRow('order_number'.tr(), state.createdOrder!.orderNumber, highlight: false),
                      SizedBox(height: 16.h),
                      _buildInfoRow('order_status'.tr(), state.createdOrder!.status, highlight: false),
                      SizedBox(height: 16.h),
                    ],
                    _buildInfoRow('payment_status'.tr(), 'تم استلام طلب الدفع (عبر ${state.paymentMethod})', highlight: false),
                    
                    SizedBox(height: 24.h),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Download invoice action
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF42D3B8),
                              side: const BorderSide(color: Color(0xFF42D3B8)),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            icon: const Icon(Icons.receipt_long, size: 18),
                            label: Text('download_invoice'.tr()),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('جاري تحميل العقد...')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).primaryColor),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            icon: const Icon(Icons.description, size: 18),
                            label: const Text('تحميل العقد'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Main Home
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'go_to_home'.tr(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13.sp,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.black : Colors.black87,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
