import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPageInfo> _pages = const [
    OnboardingPageInfo(
      imagePath: 'assets/images/onboarding_1.png',
      titleTranslationKey: 'onboarding.page1.title',
      descriptionTranslationKey: 'onboarding.page1.description',
    ),
    OnboardingPageInfo(
      imagePath: 'assets/images/onboarding_2.png',
      titleTranslationKey: 'onboarding.page2.title',
      descriptionTranslationKey: 'onboarding.page2.description',
    ),
    OnboardingPageInfo(
      imagePath: 'assets/images/onboarding_3.png',
      titleTranslationKey: 'onboarding.page3.title',
      descriptionTranslationKey: 'onboarding.page3.description',
    ),
  ];

  Future<void> _completeOnboarding() async {
    await _navigateToAuth('login');
  }

  Future<void> _navigateToAuth(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (mounted) {
      context.goNamed(routeName);
    }
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = 'ThemeData'; // Normally we use context theme, but to keep colors forced based on design sometimes

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar Area (Skip + Back Button)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button OR Empty Space
                  _currentIndex > 0
                      ? InkWell(
                          onTap: _previousPage,
                          borderRadius: BorderRadius.circular(50.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : SizedBox(width: 40.w), // Placeholder
                  
                  // Skip Button
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.cyanLight,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'skip'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 60.w), // Placeholder
                ],
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(info: _pages[index]);
                },
              ),
            ),
            
            // Bottom Action Area
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 40.h),
              child: _currentIndex == _pages.length - 1
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _navigateToAuth('login'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.secondary),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'login'.tr(),
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: PrimaryButton(
                            text: 'register'.tr(),
                            onPressed: () => _navigateToAuth('register'),
                          ),
                        ),
                      ],
                    )
                  : PrimaryButton(
                      text: 'continue'.tr(),
                      onPressed: _nextPage,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
