import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight, // Adjusts visual based on RTL setup
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        color: AppColors.error,
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28.sp),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notification.isNew ? (isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05)) : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: _getColorForLevel(notification.level).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(notification.notificationType),
                  color: _getColorForLevel(notification.level),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              
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
                              fontSize: 15.sp,
                              fontWeight: notification.isNew ? FontWeight.bold : FontWeight.normal,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Unread indicator dot
                        if (notification.isNew)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                            fontWeight: notification.isNew ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
