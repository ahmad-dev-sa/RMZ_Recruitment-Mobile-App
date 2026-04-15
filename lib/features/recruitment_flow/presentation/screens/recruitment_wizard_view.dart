import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/widgets/custom_stepper.dart';
import '../../../../shared/widgets/flow_top_navigation_bar.dart';
import '../providers/recruitment_provider.dart';
import '../widgets/steps/packages_step_view.dart';
import '../widgets/steps/booking_info_step_view.dart';
import '../widgets/steps/summary_step_view.dart';
import '../../../../core/constants/app_colors.dart';

class RecruitmentWizardView extends ConsumerStatefulWidget {
  final int categoryId;
  final int serviceId;
  final String serviceName;

  const RecruitmentWizardView({
    super.key,
    required this.categoryId,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  ConsumerState<RecruitmentWizardView> createState() => _RecruitmentWizardViewState();
}

class _RecruitmentWizardViewState extends ConsumerState<RecruitmentWizardView> {
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

  void _onStepChange(int newStep) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        newStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recruitmentProvider);
    final notifier = ref.read(recruitmentProvider.notifier);

    // Sync PageController with State if it changes externally
    ref.listen<int>(recruitmentProvider.select((s) => s.currentStep), (prev, next) {
      if (prev != next) {
        _onStepChange(next);
      }
    });

    final List<String> steps = [
      'packages'.tr(),
      'booking_info'.tr(),
      'summary'.tr(),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              steps: steps,
            ),
          ),
          
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe to force validation
              children: [
                PackagesStepView(
                  serviceId: widget.serviceId,
                  serviceName: widget.serviceName,
                ),
                const BookingInfoStepView(),
                SummaryStepView(serviceId: widget.serviceId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

