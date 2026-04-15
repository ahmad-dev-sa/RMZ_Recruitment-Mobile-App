import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../shared/widgets/package_card.dart';
import '../../providers/daily_hourly_provider.dart';
import '../../../../recruitment_flow/presentation/providers/packages_provider.dart';

class DHPackagesStep extends ConsumerWidget {
  final int serviceId;
  const DHPackagesStep({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final state = ref.watch(dailyHourlyProvider);
    final notifier = ref.read(dailyHourlyProvider.notifier);
    
    // Fetch real packages from backend
    final packagesAsync = ref.watch(servicePackagesProvider(serviceId));

    return Column(
      children: [
        SizedBox(height: 20.h),
        // Segmented Control for Morning / Evening (Mock UI for Period selection)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                _buildSegmentButton(
                  title: 'daily_hourly.morning'.tr(),
                  isSelected: state.selectedPeriod == DayTimePeriod.morning,
                  onTap: () => notifier.setPeriod(DayTimePeriod.morning),
                ),
                _buildSegmentButton(
                  title: 'daily_hourly.evening'.tr(),
                  isSelected: state.selectedPeriod == DayTimePeriod.evening,
                  onTap: () => notifier.setPeriod(DayTimePeriod.evening),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        
        Expanded(
          child: packagesAsync.when(
            data: (allPackages) {
              final targetShift = state.selectedPeriod == DayTimePeriod.morning ? 'morning' : 'evening';
              final packages = allPackages.where((pkg) => pkg.shiftType == targetShift).toList();

              if (packages.isEmpty) {
                return Center(child: Text('packages_step.no_packages_available'.tr()));
              }
              
              return Column(
                children: [
                  // Title Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.selectedPeriod == DayTimePeriod.morning 
                                ? 'daily_hourly.morning_packages'.tr()
                                : 'daily_hourly.evening_packages'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'daily_hourly.package_count_label'.tr(),
                              style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 24.w,
                              height: 24.w,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text('${packages.length}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final pkg = packages[index];
                        // Convert package fields
                        final pkgName = isAr ? pkg.nameAr : pkg.nameEn;
                        final pkgDesc = isAr ? pkg.descriptionAr : pkg.descriptionEn;
                        final isSelected = state.selectedPackageId == pkg.id;

                        // Parse price
                        final parsedPrice = double.tryParse(pkg.price) ?? 0.0;
                        final displayPrice = parsedPrice == parsedPrice.roundToDouble() 
                            ? parsedPrice.toInt().toString() 
                            : parsedPrice.toStringAsFixed(2);

                        // Format visits arabic
                        String visitsText = '${pkg.visitCount} Visits';
                        if (isAr) {
                          if (pkg.visitCount == 1) {
                            visitsText = 'زيارة واحدة';
                          } else if (pkg.visitCount == 2) {
                            visitsText = 'زيارتان';
                          } else if (pkg.visitCount >= 3 && pkg.visitCount <= 10) {
                            visitsText = '${pkg.visitCount} زيارات';
                          } else {
                            visitsText = '${pkg.visitCount} زيارة';
                          }
                        }

                        // Translate duration unit if possible using available keys (e.g., 'day', 'month', 'hour')
                        final unitTrans = ['day', 'month', 'hour'].contains(pkg.durationUnit) 
                            ? pkg.durationUnit.tr() 
                            : pkg.durationUnit;

                        return PackageSelectionCard(
                          title: pkgName,
                          subtitle: pkgDesc,
                          price: '$displayPrice ${"daily_hourly.sar".tr()}',
                          isSelected: isSelected,
                          // Pass standard package values
                          duration: '${pkg.durationValue} $unitTrans ($visitsText)',
                          nationalities: pkg.nationalities.map((n) => isAr ? n['name_ar'] as String : n['name_en'] as String).toList(),
                          onTap: () => notifier.setPackage(
                            pkg.id, 
                            pkg.serviceId,
                            pkg.visitCount,
                            double.tryParse(pkg.price) ?? double.tryParse(pkg.totalAmount) ?? 0.0,
                            double.tryParse(pkg.taxAmount) ?? 0.0,
                            pkgName,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('packages_step.error_fetching_packages'.tr())),
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
              text: 'daily_hourly.continue_btn'.tr(),
              onPressed: state.selectedPackageId != null ? () => notifier.nextStep() : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentButton({required String title, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
             color: isSelected ? AppColors.primary : Colors.transparent,
             borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade500,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}


