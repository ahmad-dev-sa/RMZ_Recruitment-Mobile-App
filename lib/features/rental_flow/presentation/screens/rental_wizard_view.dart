import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/widgets/custom_stepper.dart';
import '../../../../shared/widgets/flow_top_navigation_bar.dart';
import '../providers/rental_provider.dart';
import '../widgets/steps/packages_step_view.dart';
import '../widgets/steps/booking_info_step_view.dart';
import '../widgets/steps/workers_step_view.dart';
import '../widgets/steps/contract_step_view.dart';
import '../widgets/steps/payment_step_view.dart';
import '../../../../core/constants/app_colors.dart';

class RentalWizardView extends ConsumerStatefulWidget {
  final int? categoryId; // Optional, might be passed from routing
  final int? serviceId;
  
  const RentalWizardView({
    super.key,
    this.categoryId,
    this.serviceId,
  });

  @override
  ConsumerState<RentalWizardView> createState() => _RentalWizardViewState();
}

class _RentalWizardViewState extends ConsumerState<RentalWizardView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Set serviceId to state if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.serviceId != null && widget.serviceId != 0) {
        ref.read(rentalProvider.notifier).setServiceId(widget.serviceId!);
      }
    });
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
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);

    // Sync PageController with State if it changes externally
    ref.listen<int>(rentalProvider.select((s) => s.currentStep), (prev, next) {
      if (prev != next) {
        _onStepChange(next);
      }
    });

    final List<String> steps = [
      'packages'.tr(),
      'booking_info'.tr(),
      'the_worker'.tr(),
      'the_contract'.tr(),
      'payment'.tr(),
    ];
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: FlowTopNavigationBar(
        title: 'resident_worker_rental'.tr(),
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
              children: const [
                PackagesStepView(),
                BookingInfoStepView(),
                WorkersStepView(),
                ContractStepView(),
                PaymentStepView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
