import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/routing/workflow_router.dart';
import '../../../services/presentation/providers/service_provider.dart';

class ServicesGrid extends ConsumerWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

    if (selectedCategoryId == null) {
      return const SizedBox.shrink();
    }

    final servicesAsyncValue = ref.watch(servicesProvider(selectedCategoryId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.workers_by_details'.tr(), // Or dynamic category name if preferred
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'home.workers_by_details_desc'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        servicesAsyncValue.when(
          data: (services) {
            if (services.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Center(
                  child: Text(
                    'home.no_services'.tr(),
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                  ),
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.85,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final locale = context.locale.languageCode;
                final name = locale == 'ar' ? service.nameAr : service.nameEn;

                return GestureDetector(
                  onTap: () {
                    WorkflowRouter.startWorkflow(context, service: service);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Service Image Box
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withAlpha(20) : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: service.imageUrl != null && service.imageUrl!.isNotEmpty
                                ? Image.network(
                                    service.imageUrl!,
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.contain, // Allows transparent PNGs to sit nicely
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.home_repair_service_outlined, color: AppColors.primary, size: 28.sp);
                                    },
                                  )
                                : Icon(Icons.home_repair_service_outlined, color: AppColors.primary, size: 28.sp),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Service Title
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, stackTrace) => Center(child: Text('home.error_fetching_services'.tr())),
        ),
      ],
    );
  }
}
