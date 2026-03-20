import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/service_provider.dart';

class ServicesListView extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const ServicesListView({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsyncValue = ref.watch(servicesProvider(categoryId));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
          onPressed: () => context.pop(),
        ),
      ),
      body: servicesAsyncValue.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد خدمات متاحة حالياً في هذا القسم',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(24.w),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final locale = context.locale.languageCode;
              final name = locale == 'ar' ? service.nameAr : service.nameEn;
              final description = locale == 'ar' ? service.descriptionAr : service.descriptionEn;
              
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Service Image
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        image: service.imageUrl != null && service.imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(service.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: service.imageUrl == null || service.imageUrl!.isEmpty
                          ? Icon(Icons.cleaning_services, color: Colors.grey[400])
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    // Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondaryLight,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'يبدأ من ${service.price} ر.س',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stackTrace) => Center(child: Text('حدث خطأ في جلب الخدمات')),
      ),
    );
  }
}
