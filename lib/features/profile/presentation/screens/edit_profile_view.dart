import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/auth/presentation/providers/auth_state.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  // Controllers for account details
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Controllers for password
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      _nameController.text = [user.firstName, user.lastName].where((e) => e != null && e!.isNotEmpty).join(' ');
      _phoneController.text = user.phoneNumber ?? '';
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final notifier = ref.read(authProvider.notifier);
        
        final names = _nameController.text.trim().split(' ');
        final firstName = names.isNotEmpty ? names.first : null;
        final lastName = names.length > 1 ? names.sublist(1).join(' ') : null;

        await notifier.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );

        final newPassword = _passwordController.text;
        final confirmPassword = _confirmPasswordController.text;
        if (newPassword.isNotEmpty && newPassword == confirmPassword) {
          await notifier.changePassword(newPassword, confirmPassword);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم حفظ المعلومات بنجاح'.tr()), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
               backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(top: 60.h, bottom: 24.h, left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: AppColors.headerDarkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18.sp),
                  ),
                ),
                Text(
                  'تعديل معلوماتي'.tr(),
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
          
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(24.w),
                children: [
                  _buildSectionTitle('معلومات الحساب'.tr(), isDark),
                  SizedBox(height: 16.h),
                  _buildCustomTextField(
                    controller: _nameController,
                    hint: 'الاسم الكامل'.tr(),
                    suffixIcon: Icons.person_outline,
                    isDark: isDark,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'هذا الحقل مطلوب'.tr();
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildCustomTextField(
                    controller: _phoneController,
                    hint: 'رقم الهاتف'.tr(),
                    suffixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  _buildCustomTextField(
                    controller: _emailController,
                    hint: 'البريد الالكتروني'.tr(),
                    suffixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    isDark: isDark,
                  ),

                  SizedBox(height: 32.h),

                  _buildSectionTitle('كلمة المرور'.tr(), isDark),
                  SizedBox(height: 16.h),
                  _buildCustomTextField(
                    controller: _passwordController,
                    hint: 'كلمة المرور'.tr(),
                    suffixIcon: Icons.lock_outline,
                    isDark: isDark,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildCustomTextField(
                    controller: _confirmPasswordController,
                    hint: 'تأكيد كلمة المرور'.tr(),
                    suffixIcon: Icons.lock_outline,
                    isDark: isDark,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (val) {
                      if (_passwordController.text.isNotEmpty && val != _passwordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 48.h),
                  
                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                          ),
                          child: Text(
                            'الغاء'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.headerDarkBlue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.headerDarkBlue,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                          child: _isLoading
                            ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                'حفظ'.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey.shade300 : AppColors.headerDarkBlue,
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hint,
    required IconData suffixIcon,
    required bool isDark,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimaryLight, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        // Switch suffix and prefix visually because UI shows icon on the right, but in RTL layout, suffix goes to the left.
        // Wait, the design shows icon on the LEFT side of the input field in RTL?
        // No, the design shows Icons (like User, Phone) on the RIGHT side. In RTL, trailing is LEFT. 
        // Let's use suffixIcon anyway, Flutter RTL handles it, or use prefixIcon based on design.
        // Left side in RTL = suffix. Right side in RTL = prefix.
        // Actually the design shows the text right-aligned and the icon on the far left. 
        // Wait, in image 2: 'الاسم الكامل' is on the right, icon is on the left.
        // Wait, in RTL, suffix is on the left. Prefix is on the right.
        // I will use suffixIcon for the left side icon in RTL, prefixIcon for the lock visibility (which is on the far right in image 2).
        // Let's look at Image 2: 
        // "الاسم الكامل" (hint) on the right. User Icon on the left.
        // But for password: "كلمة المرور" on the right. Lock Icon on the left, AND an Eye Icon on the far right.
        // Wait, looking closely at Image 2:
        // Input: [ Eye Icon on Left | "كلمة المرور" on right | Lock Icon on Right ]
        // Actually, user icon, phone icon, mail icon, lock icon are on the RIGHT.
        // Eye icon is on the LEFT.
        // Let's re-examine image 2:
        // Right side: Lock Icon. Left side: Eye Icon.
        prefixIcon: Icon(suffixIcon, color: isDark ? Colors.grey.shade500 : AppColors.headerDarkBlue, size: 20.sp),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
      validator: validator,
    );
  }
}
