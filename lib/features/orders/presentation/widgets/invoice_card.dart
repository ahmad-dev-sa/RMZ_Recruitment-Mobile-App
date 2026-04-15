import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/domain/entities/order_entity.dart';

class InvoiceCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onDownloadPdf;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.order,
    required this.onDownloadPdf,
    required this.onTap,
  });

  String _formatDateStr(String dateStr, BuildContext context) {
    if (dateStr.isEmpty) return 'غير محدد';
    try {
      final DateTime parsed = DateTime.parse(dateStr).toLocal();
      final localeCode = context.locale.languageCode;
      final String date = DateFormat('dd MMM yyyy', localeCode).format(parsed);
      return date;
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Generate a mock invoice number from the order number if API doesn't provide one natively
    final String invoiceNumber = 'INV-${order.orderNumber.replaceAll('ORD-', '')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
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
            // Header: Invoice Number & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20.sp),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الفاتورة',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          invoiceNumber,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'مدفوع',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            SizedBox(height: 16.h),
            
            // Order details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب رقم: ${order.orderNumber}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'التاريخ: ${_formatDateStr(order.createdAt, context)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإجمالي',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${order.totalPrice} ريال',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20.h),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: OutlinedButton.icon(
                onPressed: onDownloadPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                label: const Text('تحميل الفاتورة PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
