import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../address/presentation/providers/address_provider.dart';

import '../../providers/branches_provider.dart';
import '../../providers/rental_provider.dart';

class BookingInfoStepView extends ConsumerStatefulWidget {
  const BookingInfoStepView({super.key});

  @override
  ConsumerState<BookingInfoStepView> createState() => _BookingInfoStepViewState();
}

class _BookingInfoStepViewState extends ConsumerState<BookingInfoStepView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);
    final isAr = context.locale.languageCode == 'ar';
    
    final addressState = ref.watch(addressProvider);
    final branchesAsync = ref.watch(branchesProvider);

    // Auto-select user address
    if (state.deliveryMethod == 1 && !addressState.isLoading && addressState.addresses.isNotEmpty && state.addressId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final primary = addressState.primaryAddress ?? addressState.addresses.first;
          final int addressId = int.tryParse(primary.id.toString()) ?? 0;
          notifier.setAddress(addressId, "${primary.city}، ${primary.region}، ${primary.street}");
        } catch (_) {}
      });
    }

    // Auto-select branch
    if (state.deliveryMethod == 0 && branchesAsync.value != null && branchesAsync.value!.isNotEmpty && state.addressId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final primary = branchesAsync.value!.first;
          notifier.setAddress(primary.id, primary.addressAr ?? primary.nameAr);
        } catch (_) {}
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delivery_method'.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Switch between branch and delivery
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.setDeliveryMethod(0),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: state.deliveryMethod == 0 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: state.deliveryMethod == 0 ? AppColors.primary : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'branch_pickup'.tr(),
                              style: TextStyle(
                                color: state.deliveryMethod == 0 ? Colors.white : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => notifier.setDeliveryMethod(1),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: state.deliveryMethod == 1 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: state.deliveryMethod == 1 ? AppColors.primary : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'home_delivery'.tr(),
                              style: TextStyle(
                                color: state.deliveryMethod == 1 ? Colors.white : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                if (state.deliveryMethod == 1) ...[
                  // Deliver to home section
                  Text(
                    'delivery_address'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  if (addressState.isLoading)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  else if (addressState.addresses.isEmpty)
                    GestureDetector(
                      onTap: () {
                        context.pushNamed('manage-addresses');
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_location_alt_outlined, color: AppColors.primary, size: 24.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'addresses.add_new_address'.tr(),
                              style: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.primary),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'booking_info_step.home'.tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  state.address ?? '',
                                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.pushNamed('manage-addresses');
                            },
                            child: Text('change'.tr(), style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                ],

                if (state.deliveryMethod == 0) ...[
                  Text(
                    'branch_info'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  branchesAsync.when(
                    data: (branches) {
                      if (branches.isEmpty) {
                         return Center(
                           child: Padding(
                             padding: EdgeInsets.all(16.w),
                             child: Text("لا توجد فروع متاحة", style: TextStyle(color: Colors.grey)),
                           )
                         );
                      }
                      final branch = branches.first;
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.store, color: AppColors.primary),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAr ? branch.nameAr : branch.nameEn,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    state.address ?? '',
                                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => Center(child: Padding(padding: EdgeInsets.all(16.w), child: CircularProgressIndicator())),
                    error: (error, _) => Center(child: Text("Error loading branches", style: TextStyle(color: Colors.red))),
                  ),
                ],
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
              onPressed: state.addressId != null ? () => notifier.nextStep() : () {},
            ),
          ),
        ),
      ],
    );
  }
}
