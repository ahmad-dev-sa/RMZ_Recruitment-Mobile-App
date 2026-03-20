import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';

class BookingSummaryStep extends ConsumerStatefulWidget {
  const BookingSummaryStep({super.key});

  @override
  ConsumerState<BookingSummaryStep> createState() => _BookingSummaryStepState();
}

class _BookingSummaryStepState extends ConsumerState<BookingSummaryStep> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);
    final locale = context.locale.languageCode;
    
    // Fallback if accessed without selection
    if (state.selectedPackage == null) {
      return const Center(child: Text('الرجاء اختيار باقة أولاً'));
    }

    final package = state.selectedPackage!;
    final packageName = locale == 'ar' ? package.nameAr : package.nameEn;
    
    // Simulate price breakdown
    final price = double.tryParse(package.price) ?? 0.0;
    final vat = price * 0.15;
    final total = price; // Assuming price string includes VAT based on design, reverse calculating base if needed.
    // In design: basic price is 4782.61, VAT is 717.3915, total 5500. Let's just hardcode a breakdown representation for now.
    final basePrice = total / 1.15;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainTitle('ملخص الطلب'),
          SizedBox(height: 16.h),
          
          // Info Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardSectionTitle('معلومات الطلب'),
                SizedBox(height: 12.h),
                _buildInfoRow('العنوان', 'النرجس، الرياض'), // Dummy address from design
                SizedBox(height: 8.h),
                _buildInfoRow('الديانة', state.religion),
                SizedBox(height: 8.h),
                _buildInfoRow('عدد أفراد الأسرة', '${state.familyMembers}'),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const DashedDivider(),
                ),
                
                _buildCardSectionTitle('تفاصيل الباقة'),
                SizedBox(height: 12.h),
                _buildInfoRow('الخدمة', packageName.contains('مدبرة') ? 'مدبرة منزلية' : 'عاملة منزلية'),
                SizedBox(height: 8.h),
                _buildInfoRow('الجنسية', packageName.split('من').last.trim()), // Dummy extraction
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Cost Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardSectionTitle('التكلفة'),
                SizedBox(height: 12.h),
                _buildCostRow('سعر الباقة غير شامل الضريبة', '${basePrice.toStringAsFixed(2)} رس'),
                SizedBox(height: 8.h),
                _buildCostRow('مرتب العامل / ـة', '${package.monthlySalary} رس / شهر'),
                SizedBox(height: 8.h),
                _buildCostRow('قيمة الضريبة المضافة', '${vat.toStringAsFixed(2)} رس'),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي السعر', style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      Text('${total.toStringAsFixed(0)} رس', style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Terms
          Row(
            children: [
              Checkbox(
                value: _agreedToTerms,
                onChanged: (val) {
                  setState(() => _agreedToTerms = val ?? false);
                },
                activeColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'أوافق على الشروط و الأحكام ',
                    style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'الشروط والأحكام',
                        style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          if (state.errorMessage != null)
             Padding(
               padding: EdgeInsets.only(top: 8.h),
               child: Text(state.errorMessage!, style: TextStyle(color: AppColors.error, fontSize: 12.sp)),
             ),
             
          SizedBox(height: 24.h),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _agreedToTerms && !state.isSubmitting
                  ? () {
                      ref.read(bookingProvider.notifier).submitOrder();
                    }
                  : null, // Disabled if not agreed or currently submitting
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'استمرار',
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
    );
  }

  Widget _buildMainTitle(String title) {
    return Row(
      children: [
        Container(width: 4.w, height: 16.h, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildCardSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF172535),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp)),
          Text(value, style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp))),
          Text(value, style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Extension to draw dashed line for divider
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0.w;
        final dashHeight = 1.0.h;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3)),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
