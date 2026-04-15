import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/address_provider.dart';

class AddressFormBottomSheet extends ConsumerStatefulWidget {
  final AddressEntity? addressToEdit;

  const AddressFormBottomSheet({super.key, this.addressToEdit});

  @override
  ConsumerState<AddressFormBottomSheet> createState() => _AddressFormBottomSheetState();
}

class _AddressFormBottomSheetState extends ConsumerState<AddressFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _addressNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _regionController;
  late final TextEditingController _streetController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _detailsController;

  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.addressToEdit;
    _fullNameController = TextEditingController(text: addr?.fullName ?? '');
    _addressNameController = TextEditingController(text: addr?.addressName ?? 'المنزل');
    _phoneController = TextEditingController(text: addr?.phone ?? '');
    _cityController = TextEditingController(text: addr?.city ?? '');
    _regionController = TextEditingController(text: addr?.region ?? '');
    _streetController = TextEditingController(text: addr?.street ?? '');
    _postalCodeController = TextEditingController(text: addr?.postalCode ?? '');
    _detailsController = TextEditingController(text: addr?.details ?? '');
    _isPrimary = addr?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'full_name': _fullNameController.text,
        'address_name': _addressNameController.text,
        'phone': _phoneController.text,
        'city': _cityController.text,
        'region': _regionController.text,
        'district': _regionController.text,
        'street': _streetController.text,
        'postal_code': _postalCodeController.text,
        'details': _detailsController.text,
        'notes': _detailsController.text,
        'is_primary': _isPrimary,
        'is_default': _isPrimary,
      };

      final notifier = ref.read(addressProvider.notifier);
      bool success;
      
      if (widget.addressToEdit == null) {
        success = await notifier.addAddress(data);
      } else {
        success = await notifier.updateAddress(widget.addressToEdit!.id, data);
      }

      if (success && mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.addressToEdit == null ? 'addresses.add_success'.tr() : 'addresses.update_success'.tr()),
          ),
        );
      } else if (!success && mounted) {
        final error = ref.read(addressProvider).errorMessage ?? 'حدث خطأ غير متوقع';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.h,
        bottom: bottomInset > 0 ? bottomInset + 24.h : 24.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      widget.addressToEdit == null ? 'addresses.add_new_address'.tr() : 'addresses.update'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildInputField('addresses.full_name'.tr(), _fullNameController, isDark),
                    _buildInputField('addresses.address_name'.tr(), _addressNameController, isDark),
                    _buildInputField('addresses.phone'.tr(), _phoneController, isDark, isNumber: true),
                    _buildInputField('addresses.city'.tr(), _cityController, isDark),
                    _buildInputField('addresses.region'.tr(), _regionController, isDark),
                    _buildInputField('addresses.street'.tr(), _streetController, isDark),
                    _buildInputField('addresses.postal_code'.tr(), _postalCodeController, isDark, isNumber: true),
                    _buildInputField('addresses.details'.tr(), _detailsController, isDark, maxLines: 3, isRequired: false),
                    
                    SizedBox(height: 16.h),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'addresses.is_primary'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _isPrimary = !_isPrimary),
                          child: Container(
                            width: 50.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: AppColors.headerDarkBlue,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 200),
                                  left: _isPrimary ? 4.w : 22.w,
                                  right: _isPrimary ? 22.w : 4.w,
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: _isPrimary ? 26.w : null,
                                  right: _isPrimary ? null : 26.w,
                                  child: Text(
                                    _isPrimary ? 'addresses.yes'.tr() : 'addresses.no'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            ),
                            child: Text(
                              'addresses.cancel'.tr(),
                              style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            text: state.isSaving ? 'addresses.saving'.tr() : (widget.addressToEdit == null ? 'addresses.save'.tr() : 'addresses.update'.tr()),
                            onPressed: state.isSaving ? () {} : _submit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String hint,
    TextEditingController controller,
    bool isDark, {
    bool isNumber = false,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        textAlign: TextAlign.right,
        style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400, fontSize: 13.sp),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'addresses.required_field'.tr();
          }
          return null;
        },
      ),
    );
  }
}
