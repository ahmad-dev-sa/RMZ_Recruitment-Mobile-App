import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/order_details_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';

class OrderReviewCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const OrderReviewCard({super.key, required this.order});

  @override
  ConsumerState<OrderReviewCard> createState() => _OrderReviewCardState();
}

class _OrderReviewCardState extends ConsumerState<OrderReviewCard> {
  int _selectedRating = 0;
  int _workerRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitted = false;
  bool _isLoading = false;

  void _submitReview() async {
    if (_selectedRating == 0 || _workerRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تقييم الخدمة والعاملة أولاً')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(orderDetailsActionProvider.notifier).submitOrderReview(
        widget.order.id, 
        _selectedRating, 
        _workerRating, 
        _commentController.text.trim()
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال تقييمك بنجاح. شكراً لك!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final review = widget.order.review;
    final bool hasExistingReview = review != null || _isSubmitted;

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
      child: hasExistingReview 
          ? _buildSuccessOrExistingView(isDark, review) 
          : _buildReviewForm(isDark),
    );
  }

  Widget _buildSuccessOrExistingView(bool isDark, [OrderReviewEntity? review]) {
    final int serviceR = review?.rating ?? _selectedRating;
    final int workerR = review?.workerRating ?? _workerRating;
    final String commentText = review?.comment ?? _commentController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 36.sp),
        ),
        SizedBox(height: 12.h),
        Text(
          'تم التقييم بنجاح',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 24.h),
        
        Text(
          'تقييم العاملة',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Icon(
                index < workerR ? Icons.star_rounded : Icons.star_outline_rounded,
                color: index < workerR ? Colors.amber : Colors.grey.shade400,
                size: 24.sp,
              ),
            );
          }),
        ),
        
        SizedBox(height: 16.h),
        
        Text(
          'تقييم الخدمة',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Icon(
                index < serviceR ? Icons.star_rounded : Icons.star_outline_rounded,
                color: index < serviceR ? Colors.amber : Colors.grey.shade400,
                size: 24.sp,
              ),
            );
          }),
        ),
        
        if (commentText.isNotEmpty) ...[
           SizedBox(height: 16.h),
           Container(
             width: double.infinity,
             padding: EdgeInsets.all(12.w),
             decoration: BoxDecoration(
               color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
               borderRadius: BorderRadius.circular(8.r)
             ),
             child: Text(commentText, style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700), textAlign: TextAlign.center),
           )
        ]
      ],
    );
  }

  Widget _buildReviewForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.star_outline_rounded, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              'تقييم الخدمة', // 'Service Review'
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'كيف كانت تجربتك معنا؟ نرجو منك تقييم الخدمة لمساعدتنا على التطور.',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey, height: 1.5),
        ),
        
        SizedBox(height: 24.h),
        
        // Worker Rating row
        Text(
          'تقييم العاملة',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _workerRating = starIndex;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  starIndex <= _workerRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= _workerRating ? Colors.amber : Colors.grey.shade400,
                  size: 40.sp,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 16.h),
        // Service Rating row
        Text(
          'تقييم الخدمة',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRating = starIndex;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  starIndex <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: starIndex <= _selectedRating ? Colors.amber : Colors.grey.shade400,
                  size: 40.sp,
                ),
              ),
            );
          }),
        ),
        
        SizedBox(height: 24.h),

        // Text Field
        TextField(
          controller: _commentController,
          maxLines: 3,
          style: TextStyle(fontSize: 13.sp, color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'أضف تعليقاً (اختياري)...',
            hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            child: _isLoading
                ? SizedBox(width: 24.w, height: 24.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    'إرسال التقييم',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

}
