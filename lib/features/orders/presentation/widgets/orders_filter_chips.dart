import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../providers/orders_provider.dart';

class OrdersFilterChips extends ConsumerWidget {
  const OrdersFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(ordersFilterProvider);
    final notifier = ref.read(ordersFilterProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categoriesAsync = ref.watch(categoriesProvider);
    final locale = context.locale.languageCode;

    return SizedBox(
      height: 40.h,
      child: categoriesAsync.when(
        data: (categories) {
          final List<Map<String, dynamic>> filters = [
            {'id': 'all', 'label': 'orders.all'.tr(), 'iconUrl': null},
          ];

          for (var cat in categories) {
             filters.add({
                'id': cat.id.toString(),
                'label': locale == 'ar' ? cat.nameAr : cat.nameEn,
                'iconUrl': cat.iconUrl,
             });
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = selectedFilter == filter['id'];
              final String? iconUrl = filter['iconUrl'] as String?;

              return GestureDetector(
                onTap: () {
                  notifier.state = filter['id'] as String;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.headerDarkBlue 
                        : (isDark ? AppColors.surfaceDark : Colors.white),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected ? AppColors.headerDarkBlue : AppColors.primary,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filter['label'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      if (iconUrl != null && iconUrl.isNotEmpty) ...[
                        SizedBox(width: 6.w),
                        Image.network(
                          iconUrl,
                          width: 16.w,
                          height: 16.h,
                          fit: BoxFit.contain,
                          color: isSelected ? Colors.white : AppColors.primary, // Tint the icon correctly
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.category_outlined, size: 16.sp, color: isSelected ? Colors.white : AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const SizedBox(), // Return empty keeping height 40.h
        error: (err, stack) => const SizedBox(),
      ),
    );
  }
}
