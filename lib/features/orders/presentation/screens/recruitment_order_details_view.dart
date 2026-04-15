import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/order_details_provider.dart';
import '../widgets/details/order_financial_card.dart';
import '../widgets/details/order_visa_card.dart';
import '../widgets/details/order_candidates_card.dart';
import '../widgets/details/order_documents_card.dart';
import '../widgets/details/order_contract_card.dart';

class RecruitmentOrderDetailsView extends ConsumerWidget {
  final String orderId;

  const RecruitmentOrderDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderAsync = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed('home');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18.sp),
                  ),
                ),
                Text(
                  'orders.order_details'.tr(), // Or 'orders.my_orders' based on screenshot
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 34.w), // Balance for centering
              ],
            ),
          ),
          
          Expanded(
            child: orderAsync.when(
              data: (orderDetails) {
                return ListView(
                  padding: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w, bottom: 100.h),
                  children: [
                    OrderFinancialCard(order: orderDetails),
                    SizedBox(height: 20.h),
                    OrderVisaCard(order: orderDetails),
                    SizedBox(height: 20.h),
                    OrderCandidatesCard(order: orderDetails),
                    SizedBox(height: 20.h),
                    OrderContractCard(order: orderDetails),
                    SizedBox(height: 20.h),
                    OrderDocumentsCard(order: orderDetails),
                  ],
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16.h),
                    Text(
                      'orders.loading'.tr(),
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14.sp),
                    )
                  ],
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    '${'orders.error_fetching'.tr()}: $err',
                    style: TextStyle(color: AppColors.error, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
