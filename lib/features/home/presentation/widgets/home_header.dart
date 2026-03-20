import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/widgets/notification_dropdown.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the user object from Auth state
    final authState = ref.watch(authProvider);
    String fullName = 'الضيف';
    
    if (authState is AuthAuthenticated && authState.user.firstName != null) {
      fullName = authState.user.firstName!;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 30.h, left: 24.w, right: 24.w),
      decoration: const BoxDecoration(
        color: AppColors.headerDarkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Notification Bell with Badge
          GestureDetector(
            onTap: () {
              // Show notification dropdown
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Dismiss',
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const NotificationDropdownWidget();
                },
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                // Badge
                Consumer(
                  builder: (context, ref, child) {
                    final notifState = ref.watch(notificationProvider);
                    if (notifState.unreadCount > 0) {
                      return Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            notifState.unreadCount > 9 ? '+9' : '${notifState.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          
          // Right side: Greeting and Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'home.welcome'.tr(namedArgs: {'name': fullName}),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الرياض، حي النرجس', // Static for now based on design
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
