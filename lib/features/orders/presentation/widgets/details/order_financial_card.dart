import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';

class OrderFinancialCard extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderFinancialCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String _translateStatus(String status) {
      if (status.isEmpty) return status;
      final lowerStatus = status.toLowerCase();
      
      if (lowerStatus == 'pending') return 'orders.status_pending'.tr();
      if (lowerStatus == 'active' || lowerStatus == 'جاري') return 'orders.status_active'.tr();
      if (lowerStatus == 'processing' || lowerStatus == 'in_progress' || lowerStatus.contains('تجهيز')) return 'orders.status_processing'.tr();
      if (lowerStatus == 'completed' || lowerStatus == 'done') return 'orders.status_completed'.tr();
      if (lowerStatus == 'cancelled' || lowerStatus == 'canceled') return 'orders.status_cancelled'.tr();
      if (lowerStatus == 'ended' || lowerStatus == 'منتهي') return 'orders.status_ended'.tr();
      
      return status;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String lowerRawStatus = order.status.toLowerCase();
    
    final bool isGreen = lowerRawStatus.contains('completed') || lowerRawStatus.contains('done') || lowerRawStatus.contains('مكتمل') || lowerRawStatus.contains('active') || lowerRawStatus.contains('نشط') || lowerRawStatus.contains('جاري');
    final bool isOrange = lowerRawStatus.contains('review') || lowerRawStatus.contains('مراجعة') || lowerRawStatus.contains('processing') || lowerRawStatus.contains('تجهيز') || lowerRawStatus.contains('in_progress');
    final bool isRed = lowerRawStatus.contains('cancel') || lowerRawStatus.contains('ملغي') || lowerRawStatus.contains('closed') || lowerRawStatus.contains('مغلق') || lowerRawStatus.contains('end') || lowerRawStatus.contains('منتهي');

    Color statusTextColor;
    Color statusBgColor;

    if (isGreen) {
      statusTextColor = Colors.green;
      statusBgColor = Colors.green.withAlpha(25);
    } else if (isOrange) {
      statusTextColor = Colors.orange.shade700;
      statusBgColor = Colors.orange.withAlpha(25);
    } else if (isRed) {
      statusTextColor = Colors.red;
      statusBgColor = Colors.red.withAlpha(25);
    } else {
      statusTextColor = Colors.amber.shade700;
      statusBgColor = Colors.amber.withAlpha(25);
    }

    final isDiscountStr = order.discount?.trim() ?? '0';
    final hasDiscount = isDiscountStr.isNotEmpty && isDiscountStr != '0' && isDiscountStr != '0.0' && isDiscountStr != '0.00';

    return Container(
      padding: EdgeInsets.all(16.w),
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
          // Header: Order Number & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contract / Order Number
             Row(
               children: [
                 Text(
                   'orders.order_number'.tr(),
                   style: TextStyle(
                     fontSize: 12.sp,
                     fontWeight: FontWeight.bold,
                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                   ),
                 ),
                 SizedBox(width: 8.w),
                 Text(
                   order.orderNumber,
                   style: TextStyle(
                     fontSize: 13.sp,
                     fontWeight: FontWeight.bold,
                     color: isDark ? Colors.white : AppColors.textPrimaryLight,
                   ),
                 ),
               ],
             ),
              
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _translateStatus(order.status),
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          SizedBox(height: 16.h),

          Text(
            'الباقة',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            order.packageName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          
          SizedBox(height: 32.h), // Spacing logic matching layout padding in design

          // Financial Breakdown container
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                _buildAmountRow('orders.recruitment_price'.tr(), order.recruitmentPrice, false, context),
                SizedBox(height: 12.h),
                _buildAmountRow('orders.service_fee'.tr(), order.serviceFee, false, context),
                SizedBox(height: 12.h),
                if (hasDiscount) ...[
                  _buildAmountRow('orders.discount'.tr(), order.discount!, false, context, isDiscount: true),
                  SizedBox(height: 12.h),
                ],
                _buildAmountRow('orders.tax_amount'.tr(), order.taxAmount, false, context),
                SizedBox(height: 12.h),
                Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, height: 1),
                SizedBox(height: 12.h),
                _buildAmountRow('orders.grand_total'.tr(), order.totalPrice, true, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, String value, bool isTotal, BuildContext context, {bool isDiscount = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color valueColor;
    if (isTotal) {
      valueColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    } else if (isDiscount) {
      valueColor = Colors.red;
    } else {
      valueColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal 
                ? (isDark ? Colors.white : AppColors.textPrimaryLight)
                : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
          ),
        ),
        Row(
          children: [
            Text(
              isDiscount ? '-$value' : value,
              style: TextStyle(
                fontSize: isTotal ? 14.sp : 12.sp,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'orders.sar'.tr(),
              style: TextStyle(
                fontSize: isTotal ? 12.sp : 10.sp,
                color: isTotal 
                    ? (isDark ? Colors.grey.shade300 : Colors.grey.shade600)
                    : (isDark ? Colors.grey.shade500 : Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
