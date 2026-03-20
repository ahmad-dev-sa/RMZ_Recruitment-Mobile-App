import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';
import '../../domain/entities/booking_package.dart';

class BookingPackagesStep extends ConsumerWidget {
  final int categoryId;
  final int serviceId;

  const BookingPackagesStep({
    super.key,
    required this.categoryId,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);
    final packagesAsync = ref.watch(availablePackagesProvider(
      PackageFilter(categoryId: categoryId, serviceId: serviceId),
    ));
    final locale = context.locale.languageCode;

    return Column(
      children: [
        Expanded(
          child: packagesAsync.when(
            data: (packages) {
              if (packages.isEmpty) {
                return const Center(child: Text('لا توجد باقات متاحة'));
              }
              
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                itemCount: packages.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final package = packages[index];
                  final isSelected = state.selectedPackage?.id == package.id;
                  final name = locale == 'ar' ? package.nameAr : package.nameEn;
                  
                  return GestureDetector(
                    onTap: () {
                      ref.read(bookingProvider.notifier).selectPackage(package);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          width: isSelected ? 2.w : 1.w,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Radio button icon
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                ),
                                SizedBox(width: 12.w),
                                // Text Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: AppColors.textPrimaryLight,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'راتب العامل / ـة من ${package.monthlySalary} ريال / شهري',
                                        style: TextStyle(
                                          color: AppColors.textSecondaryLight,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Image placeholder Box (matching design)
                                Container(
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Bottom Price Tag
                          Positioned(
                            bottom: -15.h,
                            left: 30.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: isSelected ? 2.w : 1.w),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'شامل الضريبة',
                                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${package.price} رس',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const Center(child: Text('حدث خطأ في جلب الباقات')),
          ),
        ),
        
        // Error Message
        if (state.errorMessage != null && state.currentStep == 0)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: AppColors.error, fontSize: 12.sp),
            ),
          ),
        
        // Continue Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if (state.selectedPackage != null) {
                  ref.read(bookingProvider.notifier).nextStep();
                } else {
                  // Trigger error state
                   ref.read(bookingProvider.notifier).submitOrder(); // which will just set error message since step 1 fails
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                'استمرار',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
