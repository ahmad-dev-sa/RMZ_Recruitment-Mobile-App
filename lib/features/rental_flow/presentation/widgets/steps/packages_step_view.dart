import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../shared/widgets/package_card.dart';

import '../../providers/rental_provider.dart';
import '../../../../booking/domain/entities/booking_package.dart';
import '../../../../recruitment_flow/presentation/providers/packages_provider.dart';

class PackagesStepView extends ConsumerStatefulWidget {
  const PackagesStepView({super.key});

  @override
  ConsumerState<PackagesStepView> createState() => _PackagesStepViewState();
}

class _PackagesStepViewState extends ConsumerState<PackagesStepView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);
    final isAr = context.locale.languageCode == 'ar';

    final serviceId = state.serviceId ?? 0;
    final packagesAsync = ref.watch(servicePackagesProvider(serviceId));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_package'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                packagesAsync.when(
                  data: (packages) {
                    if (packages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Text(
                            'no_packages_for_service'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textSecondaryLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packages.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final pkg = packages[index];
                        final isSelected = state.selectedPackage?.id == pkg.id;
                        final pkgName = isAr ? pkg.nameAr : pkg.nameEn;
                        final displayPrice = pkg.price;
                        
                        return PackageSelectionCard(
                          title: pkgName,
                          subtitle: isAr ? pkg.descriptionAr : pkg.descriptionEn,
                          price: '$displayPrice ${"sar".tr()}',
                          isSelected: isSelected,
                          duration: '${pkg.durationValue} ${pkg.durationUnit.tr()}',
                          nationalities: pkg.nationalities.map((n) => isAr ? n['name_ar'] as String : n['name_en'] as String).toList(),
                          onTap: () {
                            notifier.selectPackage(pkg);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'packages_step.error_fetching_packages'.tr(),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Footer with Continuous Button
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: 'continue'.tr(),
              onPressed: state.selectedPackage != null ? () => notifier.nextStep() : () {},
            ),
          ),
        ),
      ],
    );
  }
}
