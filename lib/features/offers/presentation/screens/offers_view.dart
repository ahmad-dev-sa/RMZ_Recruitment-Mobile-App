import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../marketing/presentation/providers/marketing_provider.dart';

class OffersView extends ConsumerWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBannersAsync = ref.watch(allBannersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('nav.offers'.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // Because OffersView is used both in Bottom Nav and directly, 
            // goNamed('home') ensures we reset to the main dashboard.
            context.goNamed('home');
          },
        ),
      ),
      body: allBannersAsync.when(
        data: (banners) {
          if (banners.isEmpty) {
            return Center(
              child: Text(
                'لا توجد عروض حالياً',
                style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 16.sp),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: banners.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: NetworkImage(banner.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Text(
            'خطأ في تحميل العروض',
            style: TextStyle(color: AppColors.error, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
