import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/domain/entities/order_details_entity.dart';

class ContractViewScreen extends StatelessWidget {
  final OrderDetailsEntity order;

  const ContractViewScreen({super.key, required this.order});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح هذا الرابط حالياً')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contract = order.contract;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('عرض العقد'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: contract == null
          ? Center(
              child: Text(
                'لا توجد معلومات للعقد قيد اللحظة',
                style: TextStyle(fontSize: 16.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined, size: 64.sp, color: AppColors.primary),
                        SizedBox(height: 16.h),
                        Text(
                          'عقد طلب رقم ${order.orderNumber}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'حالة العقد: ${contract.status}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'من: ${contract.startDate ?? "-"}  |  إلى: ${contract.endDate ?? "-"}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  if (contract.signedPdf != null) ...[
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(context, contract.signedPdf!),
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text('تحميل العقد الموقع', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ] else if (contract.printPdf != null) ...[
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(context, contract.printPdf!),
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text('تحميل العقد بصيغة PDF', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  if (contract.htmlContent != null && contract.htmlContent!.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Text(
                      'محتوى العقد:',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      ),
                      child: Html(data: contract.htmlContent!),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
