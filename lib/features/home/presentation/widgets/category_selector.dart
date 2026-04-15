import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../services/presentation/providers/service_provider.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    return categoriesAsyncValue.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        // Set the first item as selected initially if none is selected
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(selectedCategoryIdProvider) == null) {
            ref.read(selectedCategoryIdProvider.notifier).state = categories.first.id;
          }
        });

        return SizedBox(
          height: 85.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategoryId == category.id;
              
              final locale = context.locale.languageCode;
              final name = locale == 'ar' ? category.nameAr : category.nameEn;

              final newText = locale == 'ar' ? category.textIsNewAr : category.textIsNewEn;
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedCategoryIdProvider.notifier).state = category.id;
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12.w, top: 10.h, bottom: 10.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF1E293B) : Colors.white),
                        borderRadius: BorderRadius.circular(40), // Pill shape
                        border: isSelected ? null : Border.all(color: isDark ? Colors.transparent : Colors.grey.shade200, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                            blurRadius: isSelected ? 8 : 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image Icon
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withAlpha(50) : (isDark ? Colors.white.withAlpha(20) : Colors.grey.shade100),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: category.iconUrl != null && category.iconUrl!.isNotEmpty
                                  ? Image.network(
                                      category.iconUrl!,
                                      width: 24.w,
                                      height: 24.h,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.category_outlined, size: 22.sp, color: isSelected ? Colors.white : AppColors.primary),
                                    )
                                  : Icon(Icons.category_outlined, size: 22.sp, color: isSelected ? Colors.white : AppColors.primary),
                            ),
                          ),
                          
                          SizedBox(width: 12.w),
                          
                          // Title Text
                          Text(
                            name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : (isDark ? Colors.white : AppColors.textPrimaryLight),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // The "New" Badge
                    if (category.isNew)
                      Positioned(
                        top: 2.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.error, // Red warning color
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            newText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 85.h,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => SizedBox(
        height: 85.h,
        child: Center(child: Text('home.error_fetching_categories'.tr())),
      ),
    );
  }
}
