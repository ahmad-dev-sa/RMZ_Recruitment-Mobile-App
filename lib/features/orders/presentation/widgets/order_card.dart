import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  String _formatDateStr(String dateStr, BuildContext context) {
    if (dateStr.isEmpty) return 'orders.not_specified'.tr();
    try {
      final DateTime parsed = DateTime.parse(dateStr).toLocal();
      final localeCode = context.locale.languageCode;
      // Using intl package formatting via easy_localization
      // Example output: 20 Dec 2023 - 09:23 AM
      final String date = DateFormat('dd MMM yyyy', localeCode).format(parsed);
      final String time = DateFormat('hh:mm a', localeCode).format(parsed);
      return '$date  •  $time';
    } catch (e) {
      // Fallback in case Django sends a custom format that can't be parsed directly or fails
      return dateStr;
    }
  }

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

  @override
  Widget build(BuildContext context) {
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Top Row: Contract No (Right) & Status Badge (Left)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contract Number
               Row(
                 children: [
                   Text(
                     'orders.contract_number'.tr(),
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
                       fontSize: 14.sp,
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Package Name
            Text(
              order.packageName,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            
            // Package description (subtitles sometimes shown under it in design)
            SizedBox(height: 4.h),
            Text(
              'orders.package_desc_placeholder'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Bottom Info Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Price Label mapped exactly to mockup structure
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4.w,
                    children: [
                      Text(
                        'orders.total'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        '${order.totalPrice} ${'orders.sar'.tr()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'orders.inclusive_tax'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  Divider(height: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  SizedBox(height: 12.h),
                  
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined, 
                        size: 14.sp, 
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${'orders.date'.tr()}: ${_formatDateStr(order.createdAt, context)}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
