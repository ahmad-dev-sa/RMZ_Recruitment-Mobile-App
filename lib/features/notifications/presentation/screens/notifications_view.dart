import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/notification_provider.dart';
import '../../domain/entities/notification_entity.dart';
import '../widgets/notification_card.dart';
import '../../../orders/presentation/screens/recruitment_order_details_view.dart';
import '../../../orders/presentation/screens/daily_hourly_order_details_view.dart';
import '../../../orders/presentation/screens/rental_order_details_view.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  Future<void> _onRefresh() async {
    await ref.read(notificationProvider.notifier).fetchNotifications();
  }

  void _handleNotificationTap(NotificationEntity notification) {
    if (notification.isNew || !notification.isRead) {
      ref.read(notificationProvider.notifier).markAsRead(notification.id);
    }
    
    if (notification.notificationType == 'order' && notification.data.containsKey('order_id')) {
      final orderId = notification.data['order_id'].toString();
      final orderType = notification.data['order_type']?.toString();
      
      if (orderId.isNotEmpty) {
        if (orderType == 'daily' || orderType == 'hourly') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyHourlyOrderDetailsView(orderId: orderId),
            ),
          );
        } else if (orderType == 'rental' || orderType == 'resident' || orderType == 'monthly' || orderType == 'yearly') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentalOrderDetailsView(orderId: orderId),
            ),
          );
        } else {
          // Default to Recruitment
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecruitmentOrderDetailsView(orderId: orderId),
            ),
          );
        }
      }
    } else {
      // General feedback or detailed view placeholder if no specific action
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
        builder: (context) => Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              Text(notification.message, style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 24.h),
            ],
          ),
        )
      );
    }
  }

  void _handleNotificationDelete(NotificationEntity notification) {
    ref.read(notificationProvider.notifier).deleteNotification(notification.id);
  }

  Widget _buildSection(String title, List<NotificationEntity> items, bool isDark) {
    if (items.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverMainAxisGroup(
       slivers: [
         SliverToBoxAdapter(
           child: Padding(
             padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 24.h, bottom: 8.h),
             child: Text(
               title,
               style: TextStyle(
                 fontSize: 16.sp,
                 fontWeight: FontWeight.bold,
                 color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
               ),
             ),
           ),
         ),
         SliverList(
           delegate: SliverChildBuilderDelegate(
             (context, index) {
                final notification = items[index];
                return Column(
                  children: [
                    NotificationCard(
                      notification: notification,
                      onTap: () => _handleNotificationTap(notification),
                      onDelete: () => _handleNotificationDelete(notification),
                    ),
                    if (index < items.length - 1)
                       Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  ],
                );
             },
             childCount: items.length,
           ),
         ),
       ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final isEmpty = notificationState.unread.isEmpty && 
                    notificationState.today.isEmpty && 
                    notificationState.thisWeek.isEmpty && 
                    notificationState.older.isEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
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
                Text(
                  '${'الإشعارات'} ${notificationState.unreadCount > 0 ? "(${notificationState.unreadCount})" : ""}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                notificationState.unreadCount > 0
                    ? GestureDetector(
                        onTap: () {
                          ref.read(notificationProvider.notifier).markAllAsRead();
                        },
                        child: Text(
                          "تحديد الكل كمقروء",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SizedBox(width: 34.w), // Balance for centering
              ],
            ),
          ),
          
          Expanded(
            child: notificationState.isLoading && isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : isEmpty
                    ? RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                            Icon(Icons.notifications_off_outlined, size: 64.sp, color: Colors.grey),
                            SizedBox(height: 16.h),
                            Center(
                              child: Text(
                                "لا توجد إشعارات جديدة",
                                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            _buildSection("عناصر غير مقروءة", notificationState.unread, isDark),
                            _buildSection("اليوم", notificationState.today, isDark),
                            _buildSection("هذا الأسبوع", notificationState.thisWeek, isDark),
                            _buildSection("الأقدم", notificationState.older, isDark),
                            SliverPadding(padding: EdgeInsets.only(bottom: 40.h)),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
