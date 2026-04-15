import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../address/presentation/providers/address_provider.dart';
import '../../providers/recruitment_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';

class BookingInfoStepView extends ConsumerStatefulWidget {
  const BookingInfoStepView({super.key});

  @override
  ConsumerState<BookingInfoStepView> createState() => _BookingInfoStepViewState();
}

class _BookingInfoStepViewState extends ConsumerState<BookingInfoStepView> {
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _visaNumberController = TextEditingController();
  final TextEditingController _ageFromController = TextEditingController();
  final TextEditingController _ageToController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(recruitmentProvider);
    _detailsController.text = state.details ?? '';
    _visaNumberController.text = state.visaNumber ?? '';
    _ageFromController.text = state.ageFrom?.toString() ?? '';
    _ageToController.text = state.ageTo?.toString() ?? '';
    _experienceController.text = state.experienceYears?.toString() ?? '';
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _visaNumberController.dispose();
    _ageFromController.dispose();
    _ageToController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Widget _buildVisaNumberInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: TextField(
        controller: _visaNumberController,
        keyboardType: TextInputType.number,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          hintText: 'booking_info_step.enter_visa_number'.tr(),
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, fontSize: 13.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recruitmentProvider);
    final notifier = ref.read(recruitmentProvider.notifier);
    final addressState = ref.watch(addressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sync selected address if not set
    if (state.address == null && addressState.primaryAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.updateBookingInfo(address: addressState.primaryAddress!.fullAddressFormatted);
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('booking_info_step.address'.tr(), isDark),
                if (addressState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (addressState.addresses.isEmpty)
                  _buildEmptyAddressBtn(isDark)
                else
                  _buildAddressCard(
                    addressState.primaryAddress?.fullAddressFormatted ?? '', 
                    addressName: addressState.primaryAddress?.addressName ?? 'booking_info_step.home'.tr(),
                    isSelected: true,
                    isDark: isDark,
                  ),

                SizedBox(height: 24.h),
                _buildSectionTitle('booking_info_step.religion'.tr(), isDark),
                _buildReligionToggles(state.religion, notifier, isDark),

                SizedBox(height: 24.h),
                _buildSectionTitle('booking_info_step.worker_info'.tr(), isDark),
                _buildNationalitySelector(state, notifier, isDark),
                SizedBox(height: 16.h),
                _buildAgeAndExperienceInputs(isDark),

                SizedBox(height: 24.h),
                _buildSectionTitle('booking_info_step.family_info'.tr(), isDark),
                _buildFamilyCheckboxes(state, notifier, isDark),

                SizedBox(height: 24.h),
                _buildSectionTitle('booking_info_step.family_members_count'.tr(), isDark),
                _buildFamilyCounter(state.familyMembersCount, notifier, isDark),

                SizedBox(height: 24.h),
                _buildSectionTitle('booking_info_step.details'.tr(), isDark),
                _buildDetailsTextArea(isDark),

                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'booking_info_step.do_you_have_visa'.tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    _buildVisaToggle(state.hasVisa, notifier, isDark),
                  ],
                ),
                if (state.hasVisa) ...[
                  SizedBox(height: 16.h),
                  _buildSectionTitle('booking_info_step.visa_number'.tr(), isDark),
                  _buildVisaNumberInput(isDark),
                ],
                SizedBox(height: 16.h),
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
              onPressed: state.isStepTwoComplete 
                  ? () {
                      notifier.updateBookingInfo(
                        details: _detailsController.text,
                        visaNumber: state.hasVisa ? _visaNumberController.text : null,
                        ageFrom: int.tryParse(_ageFromController.text),
                        ageTo: int.tryParse(_ageToController.text),
                        experienceYears: int.tryParse(_experienceController.text),
                      );
                      notifier.nextStep();
                    } 
                  : () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(width: 4.w, height: 18.h, color: isDark ? Colors.white : Colors.black),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAddressBtn(bool isDark) {
    return GestureDetector(
      onTap: () => context.pushNamed('manage-addresses'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_outlined, color: AppColors.primary, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'booking_info_step.add_new_address'.tr(),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(String address, {required bool isSelected, String addressName = '', required bool isDark}) {
    if (addressName.isEmpty) addressName = 'booking_info_step.home'.tr();
    return GestureDetector(
      onTap: () => context.pushNamed('manage-addresses'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 2.w),
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
                Text(
                  'booking_info_step.primary_address'.tr(),
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(addressName, style: TextStyle(color: Colors.white, fontSize: 10.sp)),
                      SizedBox(width: 4.w),
                      Icon(Icons.edit_location_alt_outlined, color: Colors.white, size: 14.sp),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              address,
              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade500, fontSize: 13.sp, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReligionToggles(String currentReligion, RecruitmentNotifier notifier, bool isDark) {
    final options = ['مسلم', 'غير مسلم', 'لا يهم'];
    final labels = {
      'مسلم': 'booking_info_step.muslim'.tr(),
      'غير مسلم': 'booking_info_step.non_muslim'.tr(),
      'لا يهم': 'booking_info_step.any'.tr(),
    };
    return Row(
      children: options.map((option) {
        final isSelected = currentReligion == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => notifier.updateBookingInfo(religion: option),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.primary),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[option]!,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isDark ? Colors.white : AppColors.primary),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFamilyCounter(int count, RecruitmentNotifier notifier, bool isDark) {
    return Row(
      children: [
        // Decrease
        Expanded(
          child: GestureDetector(
            onTap: () => {if (count > 0) notifier.updateBookingInfo(familyMembersCount: count - 1)},
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(8.r)), // RTL
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ),
        ),
        // Count
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border.symmetric(horizontal: BorderSide(color: AppColors.primary, width: 1.w)),
            ),
            alignment: Alignment.center,
            child: Text(
              count.toString(),
              style: TextStyle(color: isDark ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        ),
        // Increase
        Expanded(
          child: GestureDetector(
            onTap: () => notifier.updateBookingInfo(familyMembersCount: count + 1),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8.r)), // RTL
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTextArea(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: TextField(
        controller: _detailsController,
        maxLines: 5,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
          hintText: 'booking_info_step.enter_additional_details'.tr(),
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, fontSize: 13.sp),
        ),
      ),
    );
  }

  Widget _buildVisaToggle(bool hasVisa, RecruitmentNotifier notifier, bool isDark) {
    return GestureDetector(
      onTap: () => notifier.updateBookingInfo(hasVisa: !hasVisa),
      child: Container(
        width: 60.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: hasVisa ? 4.w : 28.w, // Reversed logic for RTL inside stack if needed, basically toggle
              right: hasVisa ? 28.w : 4.w,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
            Positioned(
              left: hasVisa ? 28.w : null,
              right: hasVisa ? null : 28.w,
              child: Text(
                hasVisa ? 'booking_info_step.yes'.tr() : 'booking_info_step.no'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyCheckboxes(dynamic state, RecruitmentNotifier notifier, bool isDark) {
    return Column(
      children: [
        _buildCheckboxRow('booking_info_step.has_children'.tr(), state.hasChildren, (val) => notifier.updateBookingInfo(hasChildren: val), isDark),
        _buildCheckboxRow('booking_info_step.has_elderly'.tr(), state.hasElderly, (val) => notifier.updateBookingInfo(hasElderly: val), isDark),
        _buildCheckboxRow('booking_info_step.has_special_needs'.tr(), state.hasSpecialNeeds, (val) => notifier.updateBookingInfo(hasSpecialNeeds: val), isDark),
      ],
    );
  }

  Widget _buildCheckboxRow(String label, bool value, ValueChanged<bool?> onChanged, bool isDark) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
      ),
      child: CheckboxListTile(
        title: Text(label, style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13.sp)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    );
  }

  Widget _buildNationalitySelector(dynamic state, RecruitmentNotifier notifier, bool isDark) {
    final locale = context.locale.languageCode;
    final packageNationalities = state.selectedPackage?.nationalities ?? [];
    
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      value: 'all',
      child: Text('packages_step.all_nationalities'.tr()),
    ));
    
    for (var nat in packageNationalities) {
      final name = locale == 'ar' ? nat['name_ar'] as String : nat['name_en'] as String;
      final id = nat['id'].toString();
      items.add(DropdownMenuItem(
        value: id,
        child: Text(name),
      ));
    }

    String currentValue = state.preferredNationality ?? 'all';
    if (!items.any((item) => item.value == currentValue)) {
      currentValue = 'all';
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13.sp),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items,
          onChanged: (val) {
            notifier.updateBookingInfo(preferredNationality: val == 'all' ? null : val);
          },
        ),
      ),
    );
  }

  Widget _buildAgeAndExperienceInputs(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildNumberInput('booking_info_step.preferred_age_from'.tr(), _ageFromController, isDark),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildNumberInput('booking_info_step.preferred_age_to'.tr(), _ageToController, isDark),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildNumberInput('booking_info_step.experience_years'.tr(), _experienceController, isDark),
      ],
    );
  }

  Widget _buildNumberInput(String hint, TextEditingController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 1.w),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 13.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, fontSize: 13.sp),
        ),
      ),
    );
  }
}
