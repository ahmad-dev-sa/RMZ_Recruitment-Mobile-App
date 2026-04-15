import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/address_provider.dart';

import '../widgets/address_form_bottom_sheet.dart';

class ManageAddressesView extends ConsumerStatefulWidget {
  const ManageAddressesView({super.key});

  @override
  ConsumerState<ManageAddressesView> createState() => _ManageAddressesViewState();
}

class _ManageAddressesViewState extends ConsumerState<ManageAddressesView> {

  void _showAddressSheet({AddressEntity? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: AddressFormBottomSheet(addressToEdit: address),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 16.w, right: 16.w),
            color: AppColors.headerDarkBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 18.sp),
                  ),
                ),
                Text(
                  'addresses.title'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 34.w), // Balance for centering
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saved Addresses List
                  Text(
                    'addresses.title'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.addresses.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.h),
                        child: Text(
                          'addresses.no_addresses'.tr(),
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    )
                  else
                    ...(() {
                      final sorted = List<AddressEntity>.from(state.addresses);
                      sorted.sort((a, b) => a.isPrimary ? -1 : (b.isPrimary ? 1 : 0));
                      return sorted.map((address) => _buildAddressCard(address, isDark));
                    })(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddressSheet(),
        icon: Icon(Icons.add, color: Colors.white, size: 20.sp),
        label: Text(
          'addresses.add_new_address'.tr(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressEntity address, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (address.isPrimary)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.primary, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'addresses.primary_address'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    ref.read(addressProvider.notifier).setPrimary(address.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle_outlined, color: Colors.grey.shade500, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'addresses.set_as_primary'.tr(),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  address.fullName, // Used to be 'اسم الموقع'
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left, // Left aligned since it's the second element in RTL or LTR
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address.fullAddressFormatted,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp, height: 1.5),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  address.addressName, // 'المنزل'
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showAddressSheet(address: address),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, color: AppColors.primary, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'addresses.edit'.tr(),
                            style: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
                          title: Text(
                            'addresses.confirm_delete_title'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          content: Text(
                            'addresses.confirm_delete_msg'.tr(),
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text('addresses.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ref.read(addressProvider.notifier).deleteAddress(address.id);
                              },
                              child: Text('addresses.delete'.tr(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(150),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.white, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            'addresses.delete'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
