import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../marketing/presentation/providers/marketing_provider.dart';

class LatestPackagesSlider extends ConsumerWidget {
  const LatestPackagesSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsyncValue = ref.watch(homeBannersProvider);

    return bannersAsyncValue.when(
      data: (banners) {
        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'home.latest_packages'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed('offers');
                    },
                    child: Row(
                      children: [
                        Text(
                          'home.view_more'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _BannerSliderWidget(banners: banners),
          ],
        );
      },
      loading: () => SizedBox(
        height: 160.h,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (error, stack) => SizedBox(
        height: 160.h,
        child: Center(
          child: Text(
            'home.error_fetching_offers'.tr(),
            style: TextStyle(color: AppColors.error, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}

class _BannerSliderWidget extends StatefulWidget {
  final List<dynamic> banners;
  const _BannerSliderWidget({Key? key, required this.banners}) : super(key: key);

  @override
  State<_BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<_BannerSliderWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          int nextIndex = _currentIndex + 1;
          if (nextIndex >= widget.banners.length) {
            nextIndex = 0;
          }
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index]; // BannerEntity
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    banner.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.shade400,
                          size: 40.sp,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index 
                  ? AppColors.primary 
                  : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
