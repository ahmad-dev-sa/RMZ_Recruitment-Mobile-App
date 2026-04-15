import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/pdf_helper.dart';
import '../../../../features/settings/presentation/providers/site_settings_provider.dart';
import '../../../booking/domain/entities/order_details_entity.dart';
import '../widgets/details/order_financial_card.dart';

class InvoiceViewScreen extends ConsumerWidget {
  final OrderDetailsEntity order;

  const InvoiceViewScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('عرض الفاتورة'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                  Icon(Icons.receipt_long, size: 64.sp, color: AppColors.primary),
                  SizedBox(height: 16.h),
                  Text(
                    'فاتورة طلب رقم ${order.orderNumber}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'تاريخ الاصدار: ${order.createdAt}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            OrderFinancialCard(order: order),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () async {
                String? logoUrl;
                String? companyName;
                try {
                  final Map<String, dynamic> settings = await ref.read(siteSettingsProvider.future);
                  logoUrl = settings['logo_url'] as String? ?? settings['logo'] as String?;
                  companyName = settings['site_name'] as String? ?? settings['title_ar'] as String?;
                  if (context.mounted && context.locale.languageCode != 'ar') {
                    companyName = settings['site_name_en'] as String? ?? settings['title_en'] as String? ?? companyName;
                  }
                } catch (_) {}

                if (!context.mounted) return;
                await PdfHelper.generateAndPrintOrderPdf(
                  orderNumber: order.orderNumber,
                  packageName: order.packageName,
                  totalPrice: '${order.totalPrice} ريال',
                  status: 'مدفوع', // Invoices viewed here are typically paid
                  date: order.createdAt,
                  isAr: context.locale.languageCode == 'ar',
                  logoUrl: logoUrl,
                  companyName: companyName,
                );
              },
              icon: const Icon(Icons.print, color: Colors.white),
              label: Text('حفظ كملف PDF', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
