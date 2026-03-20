import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/document_bottom_sheet.dart';

import '../widgets/document_bottom_sheet.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  @override
  void dispose() {
    _idController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_termsAccepted || !_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء الموافقة على الشروط والأحكام وسياسة الخصوصية')),
      );
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتي المرور غير متطابقتين')),
      );
      return;
    }

    ref.read(authProvider.notifier).register(
      idNumber: _idController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: AppColors.error),
        );
      } else if (next is AuthAuthenticated) {
        // Navigate to dashboard or home
        if (context.mounted) {
           context.goNamed('home');
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('تم تسجيل الحساب بنجاح!')),
           );
        }
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              
              // Title
              Text(
                'auth.register.title'.tr(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              
              // Subtitle
              Text(
                'auth.register.subtitle'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 40.h),
              
              // ID Field
              CustomTextField(
                controller: _idController,
                hintText: 'auth.register.id_number'.tr(),
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.credit_card_outlined),
              ),
              SizedBox(height: 16.h),
              
              // First Name Field
              CustomTextField(
                controller: _firstNameController,
                hintText: 'auth.register.first_name'.tr(),
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              SizedBox(height: 16.h),
              
              // Last Name Field
              CustomTextField(
                controller: _lastNameController,
                hintText: 'auth.register.last_name'.tr(),
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              SizedBox(height: 16.h),
              
              // Phone Field
              CustomTextField(
                controller: _phoneController,
                hintText: 'auth.register.phone_number'.tr(),
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              SizedBox(height: 16.h),
              
              // Email Field
              CustomTextField(
                controller: _emailController,
                hintText: 'auth.register.email'.tr(),
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              SizedBox(height: 16.h),
              
              // Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: 'auth.register.password'.tr(),
                obscureText: !_isPasswordVisible,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Icon(
                  _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onSuffixIconTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 16.h),
              
              // Confirm Password Field
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'auth.register.confirm_password'.tr(),
                obscureText: !_isConfirmPasswordVisible,
                isPassword: true,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onSuffixIconTap: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 24.h),
              
              // Terms & Conditions Checkbox
              Row(
                children: [
                  SizedBox(
                    height: 24.w,
                    width: 24.w,
                    child: Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'auth.register.agree_to'.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 14.sp,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DocumentBottomSheet(
                                title: 'documents.terms_and_conditions.title'.tr(),
                                content: 'documents.terms_and_conditions.content'.tr(),
                              ),
                            );
                          },
                          child: Text(
                            'auth.register.terms'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              
              // Privacy Policy Checkbox
              Row(
                children: [
                  SizedBox(
                    height: 24.w,
                    width: 24.w,
                    child: Checkbox(
                      value: _privacyAccepted,
                      onChanged: (value) {
                        setState(() {
                          _privacyAccepted = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          'auth.register.view'.tr(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 14.sp,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DocumentBottomSheet(
                                title: 'documents.privacy_policy.title'.tr(),
                                content: 'documents.privacy_policy.content'.tr(),
                              ),
                            );
                          },
                          child: Text(
                            'auth.register.privacy_policy'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              
              // Register Button
              isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    text: 'auth.register.submit'.tr(),
                    onPressed: _handleRegister,
                  ),
              
              SizedBox(height: 24.h),
              
              // Login Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.register.already_have_account'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextButton(
                    onPressed: () {
                      context.goNamed('login');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'auth.register.login_here'.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
