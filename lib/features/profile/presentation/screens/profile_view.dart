import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_view.dart';
import '../../../address/presentation/screens/manage_addresses_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../orders/presentation/screens/my_orders_view.dart';
import '../../../orders/presentation/screens/my_invoices_view.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              children: [
                const Expanded(child: SizedBox()),
                Text(
                  'حسابي'.tr(), // Future: 'profile.my_account'
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.logout, color: Colors.white, size: 24.sp),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('تسجيل الخروج', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            content: Text('هل تريد فعلا تسجيل الخروج؟', style: TextStyle(fontSize: 14.sp)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('تراجع'.tr()),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await ref.read(authProvider.notifier).logout();
                                  if (context.mounted) {
                                    context.goNamed('login');
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text('موافق'.tr(), style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              children: [
                ProfileMenuItem(
                  label: 'معلوماتي'.tr(),
                  icon: Icons.person_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileView()),
                    );
                  },
                ),
                ProfileMenuItem(
                  label: 'عناويني'.tr(),
                  icon: Icons.location_on_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageAddressesView()),
                    );
                  },
                ),
                ProfileMenuItem(
                  label: 'الاشعارات'.tr(),
                  icon: Icons.notifications_none_outlined,
                  onTap: () {
                    context.pushNamed('notifications');
                  },
                ),
                ProfileMenuItem(
                  label: 'طلباتي'.tr(),
                  icon: Icons.shopping_bag_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyOrdersView()),
                    );
                  },
                ),
                
                ProfileMenuItem(
                  label: 'فواتيري'.tr(),
                  icon: Icons.receipt_long_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyInvoicesView()),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                ProfileMenuItem(
                  label: 'الغاء الحساب'.tr(),
                  icon: Icons.person_off_outlined,
                  iconColor: Colors.red.shade400,
                  onTap: () {
                    // Open Delete Account Confirmation Dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('تأكيد الإلغاء', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        content: Text('هل أنت متأكد من رغبتك في إلغاء الحساب بشكل نهائي؟', style: TextStyle(fontSize: 14.sp)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('تراجع')),
                          ElevatedButton(
                            onPressed: () async { 
                              Navigator.pop(context);
                              try {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('جاري إلغاء الحساب...')),
                                );
                                await ref.read(authProvider.notifier).deactivateAccount();
                                if (context.mounted) {
                                  context.goNamed('login');
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('فشل في إلغاء الحساب الرجاء المحاولة لاحقا')),
                                  );
                                }
                              }
                            }, 
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('تأكيد الإلغاء', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 80.h), // Padding for Bottom Nav Bar spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}
