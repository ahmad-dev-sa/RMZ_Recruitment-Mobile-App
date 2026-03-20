import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';

class BookingSuccessView extends ConsumerWidget {
  const BookingSuccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(bookingProvider);
    final locale = context.locale.languageCode;
    
    // Safety check, though ideally this view is only reached on success
    final packageName = state.selectedPackage != null 
        ? (locale == 'ar' ? state.selectedPackage!.nameAr : state.selectedPackage!.nameEn) 
        : 'باقة غير محددة';
        
    final price = state.selectedPackage?.price ?? '0.0';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF172535), // Dark blue from design
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40.w), // Spacer
                Text(
                  'الطلب مؤكد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 40.w), // Spacer
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            // Success Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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
                    'تم انشاء الطلب',
                    style: TextStyle(
                      color: const Color(0xFF172535),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'بنجاح',
                    style: TextStyle(
                      color: const Color(0xFF172535),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Order Summary Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات الطلب',
                    style: TextStyle(
                      color: const Color(0xFF172535),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildSummaryRow('الباقة', packageName),
                  SizedBox(height: 12.h),
                  _buildSummaryRow('إجمالي السعر', '$price رس'),
                  SizedBox(height: 12.h),
                  _buildSummaryRow('رقم الطلب', '#985654841656589'), // Dummy order number
                  SizedBox(height: 12.h),
                  _buildSummaryRow('حالة الطلب', 'جاري العمل'),
                ],
              ),
            ),
            
            SizedBox(height: 48.h),
            
            // Return to Home
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(bookingProvider.notifier).reset();
                  context.goNamed('home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF172535),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'الرجوع للرئيسية',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // Matches design light background for rows
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
