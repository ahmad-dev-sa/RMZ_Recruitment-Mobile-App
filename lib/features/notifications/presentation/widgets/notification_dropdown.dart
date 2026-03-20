import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_provider.dart';

class NotificationDropdownWidget extends ConsumerStatefulWidget {
  const NotificationDropdownWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationDropdownWidget> createState() => _NotificationDropdownWidgetState();
}

class _NotificationDropdownWidgetState extends ConsumerState<NotificationDropdownWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.payment_outlined;
      case 'promo':
        return Icons.local_offer_outlined;
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'system':
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForLevel(String level) {
    switch (level) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'danger':
        return AppColors.error;
      case 'info':
      default:
        return AppColors.secondary;
    }
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);

    return Stack(
      children: [
        // Transparent barrier to close dropdown when tapped outside
        GestureDetector(
          onTap: _closeDropdown,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        
        // The dropdown content
        Positioned(
          top: 100.h, // adjust based on HomeHeader height
          left: 24.w,
          right: 24.w,
          child: Material(
            color: Colors.transparent,
            child: SizeTransition(
              sizeFactor: _animation,
              axisAlignment: 1.0, 
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "الإشعارات", // Notifications
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          if (notificationState.unreadCount > 0)
                            GestureDetector(
                              onTap: () {
                                ref.read(notificationProvider.notifier).markAllAsRead();
                                _closeDropdown();
                              },
                              child: Text(
                                "تحديد الكل كمقروء", // Mark all as read
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    
                    // List
                    Flexible(
                      child: notificationState.isLoading
                          ? Padding(
                              padding: EdgeInsets.all(24.h),
                              child: const CircularProgressIndicator(color: AppColors.primary),
                            )
                          : notificationState.notifications.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(32.h),
                                  child: Column(
                                    children: [
                                      Icon(Icons.notifications_off_outlined, size: 48.sp, color: Colors.grey),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "لا توجد إشعارات جديدة",
                                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: notificationState.notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notificationState.notifications[index];
                                    
                                    return InkWell(
                                      onTap: () {
                                        if (!notification.isRead) {
                                          ref.read(notificationProvider.notifier).markAsRead(notification.id);
                                        }
                                        // Optional: Handle navigation based on notification.notificationType
                                        // _closeDropdown();
                                      },
                                      child: Container(
                                        color: notification.isRead ? Colors.transparent : Colors.blue.withOpacity(0.05),
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Icon
                                            Container(
                                              padding: EdgeInsets.all(8.w),
                                              decoration: BoxDecoration(
                                                color: _getColorForLevel(notification.level).withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _getIconForType(notification.notificationType),
                                                color: _getColorForLevel(notification.level),
                                                size: 20.sp,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            
                                            // Content
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          notification.title,
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                                            color: AppColors.textPrimaryLight,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        _formatDate(notification.createdAt),
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    notification.message,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: AppColors.textSecondaryLight,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours > 0) return 'منذ ${difference.inHours} ساعة';
      if (difference.inMinutes > 0) return 'منذ ${difference.inMinutes} دقيقة';
      return 'الآن';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('yyyy/MM/dd').format(date);
    }
  }
}
