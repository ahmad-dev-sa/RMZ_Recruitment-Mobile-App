import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/orders_provider.dart';
import '../widgets/orders_filter_chips.dart';
import '../widgets/order_card.dart';
import 'recruitment_order_details_view.dart';
import 'daily_hourly_order_details_view.dart';
import 'rental_order_details_view.dart';

class MyOrdersView extends ConsumerWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Custom Header
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
                  'orders.my_orders'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Filters Component
          const OrdersFilterChips(),
          
          SizedBox(height: 24.h),
          
          // Orders List
          Expanded(
             child: ordersAsync.when(
               data: (orders) {
                 if (orders.isEmpty) {
                   return Center(
                     child: Text(
                       'orders.no_orders'.tr(),
                       style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 16.sp),
                     ),
                   );
                 }
                 
                 return ListView.separated(
                   padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 100.h), // bottom padding for nav bar
                   itemCount: orders.length,
                   separatorBuilder: (context, index) => SizedBox(height: 16.h),
                   itemBuilder: (context, index) {
                     return OrderCard(
                       order: orders[index],
                       onTap: () {
                         final order = orders[index];
                         
                         // Route based on orderType
                         if (order.orderType == 'daily' || order.orderType == 'hourly') {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => DailyHourlyOrderDetailsView(orderId: order.id),
                             ),
                           );
                         } else if (order.orderType == 'rental' || order.orderType == 'resident' || order.orderType == 'monthly' || order.orderType == 'yearly') {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => RentalOrderDetailsView(orderId: order.id),
                             ),
                           );
                         } else {
                           // Default to Recruitment
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => RecruitmentOrderDetailsView(orderId: order.id),
                             ),
                           );
                         }
                       },
                     );
                   },
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
                 )
               ),
               error: (err, stack) => Center(
                 child: Text(
                   'orders.error_fetching'.tr(),
                   style: TextStyle(color: AppColors.error, fontSize: 16.sp),
                 ),
               ),
             ),
          ),
        ],
      ),
    );
  }
}
