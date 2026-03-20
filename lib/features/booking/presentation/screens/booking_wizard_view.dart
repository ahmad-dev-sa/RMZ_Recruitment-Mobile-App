import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_packages_step.dart';
import '../widgets/booking_info_step.dart';
import '../widgets/booking_summary_step.dart';

class BookingWizardView extends ConsumerStatefulWidget {
  final int categoryId;
  final int serviceId;
  final String serviceName;
  const BookingWizardView({
    super.key,
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  ConsumerState<BookingWizardView> createState() => _BookingWizardViewState();
}

class _BookingWizardViewState extends ConsumerState<BookingWizardView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepChange(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    
    // Listen to step changes from provider to sync PageController
    ref.listen<BookingState>(bookingProvider, (previous, next) {
      if (previous?.currentStep != next.currentStep && _pageController.hasClients) {
        if (_pageController.page?.round() != next.currentStep) {
          _onStepChange(next.currentStep);
        }
      }
      
      if (next.isSuccess) {
         context.pushReplacementNamed('booking-success');
      }
    });

    final List<Widget> steps = [
      BookingPackagesStep(
        categoryId: widget.categoryId,
        serviceId: widget.serviceId,
      ),
      const BookingInfoStep(),
      const BookingSummaryStep(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.h),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF172535), // Dark blue from design
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Header (Title, Close, Back)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close Button
                      GestureDetector(
                        onTap: () {
                          ref.read(bookingProvider.notifier).reset();
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed('home');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, color: AppColors.primary, size: 20.sp),
                        ),
                      ),
                      
                      // Title
                      Text(
                        widget.serviceName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Back Button
                      GestureDetector(
                        onTap: () {
                          if (bookingState.currentStep > 0) {
                            ref.read(bookingProvider.notifier).previousStep();
                          } else {
                            ref.read(bookingProvider.notifier).reset();
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.goNamed('home');
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Stepper
                _buildStepper(bookingState.currentStep),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
        children: steps,
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    const List<String> stepTitles = ['باقات', 'معلومات الحجز', 'الملخص'];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: List.generate(stepTitles.length * 2 - 1, (index) {
              if (index.isEven) {
                // Circle
                final stepIndex = index ~/ 2;
                final isCompletedOrCurrent = stepIndex <= currentStep;
                
                return Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: isCompletedOrCurrent ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 3.w,
                    ),
                  ),
                );
              } else {
                // Line
                final stepIndex = index ~/ 2;
                final isCompletedOrCurrent = stepIndex < currentStep;
                
                return Expanded(
                  child: Container(
                    height: 3.h,
                    color: isCompletedOrCurrent ? AppColors.primary : AppColors.primary.withOpacity(0.3),
                  ),
                );
              }
            }),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stepTitles.map((title) {
              return Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
