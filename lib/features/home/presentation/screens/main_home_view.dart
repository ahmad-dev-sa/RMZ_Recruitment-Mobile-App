import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'home_tab_view.dart';
import '../../../offers/presentation/screens/offers_view.dart';
import '../../../../features/settings/presentation/screens/settings_view.dart';
import '../../../orders/presentation/screens/my_orders_view.dart';
import '../../../../features/profile/presentation/screens/profile_view.dart';

class MainHomeView extends StatefulWidget {
  const MainHomeView({super.key});

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _pages = [
    const HomeTabView(),
    const MyOrdersView(),
    const OffersView(),
    const ProfileView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'label': 'nav.home'.tr()},
      {'icon': Icons.list_alt_outlined, 'label': 'nav.orders'.tr()},
      {'icon': Icons.percent_outlined, 'label': 'nav.offers'.tr()},
      {'icon': Icons.person_outline, 'label': 'nav.profile'.tr()},
      {'icon': Icons.settings_outlined, 'label': 'nav.settings'.tr()},
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: List.generate(_pages.length, (index) {
          final isActive = _currentIndex == index;
          final isPrevious = _previousIndex == index;
          final isParticipating = isActive || isPrevious;

          double dx = 0;
          if (index < _currentIndex) {
            dx = -1.0;
          } else if (index > _currentIndex) {
            dx = 1.0;
          } else {
            dx = 0.0;
          }

          final isRtl = context.locale.languageCode == 'ar';
          if (isRtl) dx = -dx;

          return IgnorePointer(
            ignoring: !isActive,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              offset: Offset(dx, 0),
              child: Opacity(
                opacity: isParticipating ? 1.0 : 0.0,
                child: _pages[index],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(navItems.length, (index) {
                final isSelected = _currentIndex == index;
                final item = navItems[index];

                return GestureDetector(
                  onTap: () {
                    if (_currentIndex != index) {
                      setState(() {
                        _previousIndex = _currentIndex;
                        _currentIndex = index;
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuint,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16.w : 8.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected ? Colors.white : AppColors.primary.withOpacity(0.8),
                          size: 24.sp,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuint,
                          alignment: Alignment.center,
                          child: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 8.w),
                                    Text(
                                      item['label'] as String,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
