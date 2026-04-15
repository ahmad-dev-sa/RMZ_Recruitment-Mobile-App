import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/pdf_helper.dart';
import '../../../../features/settings/presentation/providers/site_settings_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/invoice_card.dart';
import 'recruitment_order_details_view.dart';
import 'daily_hourly_order_details_view.dart';
import 'rental_order_details_view.dart';

class MyInvoicesView extends ConsumerWidget {
  const MyInvoicesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 16.w, right: 20.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (Navigator.canPop(context))
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18.sp),
                      ),
                    ),
                  ),
                Text(
                  'فواتيري'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
                    SizedBox(height: 16.h),
                    Text('حدث خطأ في تحميل الفواتير', style: TextStyle(color: Colors.grey, fontSize: 16.sp)),
                  ],
                ),
              ),
              data: (orders) {
                // Filter only paid orders or completed orders that act as invoices
                final paidOrders = orders.where((o) => 
                  o.paymentStatus?.toLowerCase() == 'paid' || 
                  o.paymentStatus == 'مدفوع' ||
                  o.status.toLowerCase() == 'completed' ||
                  o.status == 'مكتمل' ||
                  o.status.toLowerCase() == 'done'
                ).toList();

                if (paidOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64.sp, color: Colors.grey.shade400),
                        SizedBox(height: 16.h),
                        Text(
                          "لا توجد فواتير مدفوعة",
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    // ignore: unused_result
                    ref.refresh(ordersProvider);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    itemCount: paidOrders.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final order = paidOrders[index];
                      return InvoiceCard(
                        order: order,
                        onDownloadPdf: () async {
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
                            status: order.paymentStatus ?? order.status,
                            date: order.createdAt,
                            isAr: context.locale.languageCode == 'ar',
                            logoUrl: logoUrl,
                            companyName: companyName,
                          );
                        },
                        onTap: () {
                          // Navigate to corresponding details view
                          if (order.orderType == 'daily' || order.orderType == 'hourly') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => DailyHourlyOrderDetailsView(orderId: order.id),
                            ));
                          } else if (order.orderType == 'rental' || order.orderType == 'resident' || order.orderType == 'monthly' || order.orderType == 'yearly') {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => RentalOrderDetailsView(orderId: order.id),
                            ));
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => RecruitmentOrderDetailsView(orderId: order.id),
                            ));
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
