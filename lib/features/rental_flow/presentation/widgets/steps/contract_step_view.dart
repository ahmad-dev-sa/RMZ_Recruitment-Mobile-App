import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';

import '../../providers/rental_provider.dart';
import '../../screens/signature_view.dart';
import 'contract_preview_sheet.dart';

class ContractStepView extends ConsumerStatefulWidget {
  const ContractStepView({super.key});

  @override
  ConsumerState<ContractStepView> createState() => _ContractStepViewState();
}

class _ContractStepViewState extends ConsumerState<ContractStepView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('contract'.tr()),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ContractPreviewSheet(),
                    );
                  },
                  icon: Icon(Icons.description, color: Theme.of(context).primaryColor),
                  label: Text(
                    'view_contract'.tr(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          _buildSectionTitle('personal_info'.tr()),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    state.dob ?? 'تاريخ الميلاد',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      notifier.setDob("${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");
                    }
                  },
                  child: Text('edit'.tr()),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),
          
          _buildSectionTitle('sign_contract'.tr()),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'signature'.tr(),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final signature = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignatureView(),
                          ),
                        );
                        if (signature != null) {
                          notifier.setSignature(signature);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                      label: Text(
                        state.signatureBytes == null 
                          ? 'add_signature'.tr()
                          : 'update_signature'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (state.signatureBytes != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    height: 150.h,
                    width: double.infinity,
                    color: isDark ? Colors.white12 : Colors.grey.shade100,
                    child: Image.memory(state.signatureBytes!),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 24.h),
          
          _buildSectionTitle('order_summary'.tr()),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'order_info'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                _buildSummaryRow('delivery_address'.tr(), state.address ?? 'الرياض'),
                _buildSummaryRow(
                  'delivery_method'.tr(), 
                  state.deliveryMethod == 0 ? 'branch_pickup'.tr() : 'home_delivery'.tr(),
                ),
                Divider(height: 32.h),
                Text(
                  'package_type'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                _buildSummaryRow('duration'.tr(), '${state.selectedPackage?.durationValue ?? 1} ${(state.selectedPackage?.durationUnit ?? 'month').tr()}'),
                _buildSummaryRow('service'.tr(), state.selectedPackage?.nameAr ?? 'مدبرة منزل'),
                _buildSummaryRow('nationality'.tr(), state.selectedWorker?.nationalityAr ?? 'أفريقيا'),
              ],
            ),
          ),
          
          SizedBox(height: 40.h),
          
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
              text: state.isLoading ? 'جاري الإنشاء...' : 'continue'.tr(),
              onPressed: (state.signatureBytes != null && !state.isLoading) ? () => notifier.createOrder() : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
