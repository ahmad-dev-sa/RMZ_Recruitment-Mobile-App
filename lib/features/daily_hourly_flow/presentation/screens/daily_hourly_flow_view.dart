import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_stepper.dart';
import '../../../../../shared/widgets/flow_top_navigation_bar.dart';
import '../providers/daily_hourly_provider.dart';
import '../widgets/steps/dh_packages_step.dart';
import '../widgets/steps/dh_booking_info_step.dart';
import '../widgets/steps/dh_summary_step.dart';
import '../widgets/steps/dh_payment_step.dart';

class DailyHourlyFlowView extends ConsumerStatefulWidget {
  final int categoryId;
  final int serviceId;
  final String serviceName;
  const DailyHourlyFlowView({
    super.key, 
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  ConsumerState<DailyHourlyFlowView> createState() => _DailyHourlyFlowViewState();
}

class _DailyHourlyFlowViewState extends ConsumerState<DailyHourlyFlowView> {
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

  void _onStepChanged(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dailyHourlyProvider);
    final notifier = ref.read(dailyHourlyProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen to changes in step to animate page view
    ref.listen(dailyHourlyProvider.select((state) => state.currentStep), (previous, next) {
      if (previous != next && next != _pageController.page?.round()) {
        _onStepChanged(next);
      }
    });

    final stepsKeys = [
      'daily_hourly.step_packages'.tr(),
      'daily_hourly.step_booking_info'.tr(),
      'daily_hourly.step_summary'.tr(),
      'daily_hourly.step_payment'.tr(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: FlowTopNavigationBar(
        title: widget.serviceName,
        backgroundColor: AppColors.headerDarkBlue,
        textColor: Colors.white,
        onBackPressed: () {
          if (state.currentStep > 0) {
            notifier.previousStep();
          } else {
            Navigator.of(context).pop();
            ref.invalidate(dailyHourlyProvider);
          }
        },
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: CustomStepper(
              currentStep: state.currentStep,
              steps: stepsKeys,
            ),
          ),
          
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures to enforce linear flow
              children: [
                DHPackagesStep(serviceId: widget.serviceId),
                const DHBookingInfoStep(),
                const DHSummaryStep(),
                const DHPaymentStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
