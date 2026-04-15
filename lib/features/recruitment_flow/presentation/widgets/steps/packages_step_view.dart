import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/recruitment_provider.dart';
import '../../providers/packages_provider.dart';
import '../../../../../shared/widgets/package_card.dart';
import '../../../../../core/widgets/primary_button.dart';

class PackagesStepView extends ConsumerWidget {
  final int serviceId;
  final String serviceName;

  const PackagesStepView({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recruitmentProvider);
    final notifier = ref.read(recruitmentProvider.notifier);
    final packagesAsync = ref.watch(servicePackagesProvider(serviceId));
    final locale = context.locale.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: packagesAsync.when(
            data: (packages) {
              if (packages.isEmpty) {
                return Center(child: Text('packages_step.no_packages_available'.tr()));
              }
              
              return Column(
                children: [
                  // Header with Service Name and Package Count Badge
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Service Name (Right side in RTL)
                        Text(
                          serviceName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            // Fallback to black if primary dark is not heavily used in constants
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                        
                        // Badge (Left side in RTL)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'packages_step.packages_label'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C7C7), // Cyan to match design
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '${packages.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        final isSelected = state.packageId.toString() == package.id;
                        final name = locale == 'ar' ? package.nameAr : package.nameEn;
                        final desc = locale == 'ar' ? package.descriptionAr : package.descriptionEn;
                        final subtitle = desc.isNotEmpty ? desc : '${'packages_step.worker_salary_from'.tr()} ${package.monthlySalary} ${'summary_step.sar'.tr()} / ${'summary_step.month'.tr()}';

                        final packageNationalities = package.nationalities
                            .map((n) => locale == 'ar' ? n['name_ar'] as String : n['name_en'] as String)
                            .toList();

                        final durationText = '${package.durationValue} ${'packages_step.${package.durationUnit}'.tr()}';

                        return PackageSelectionCard(
                          title: name,
                          subtitle: subtitle,
                          price: '${package.totalAmount} ${'summary_step.sar'.tr()}', // Use totalAmount instead of price if needed, or maybe just `package.price` if it was total
                          isSelected: isSelected,
                          maxWorkers: package.maxWorkers,
                          nationalities: packageNationalities,
                          duration: durationText,
                          workerSalary: '${package.monthlySalary} ${'summary_step.sar'.tr()}',
                          onTap: () {
                            notifier.selectPackage(int.parse(package.id), package);
                          },
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
                color: Colors.black.withAlpha(10),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: 'continue'.tr(),
              onPressed: state.isStepOneComplete ? () => notifier.nextStep() : () {},
              // Ignore tap if not complete. Can also fade button using opacity if desired.
            ),
          ),
        ),
      ],
    );
  }
}
