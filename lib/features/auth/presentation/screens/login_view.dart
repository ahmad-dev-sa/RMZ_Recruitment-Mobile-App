import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/forgot_password_bottom_sheet.dart';

import '../widgets/forgot_password_bottom_sheet.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Basic validation
    if (_idController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهوية وكلمة المرور')),
      );
      return;
    }
    
    // Call auth provider to login
    ref.read(authProvider.notifier).login(
      _idController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Auth State changes for Error/Success Navigation
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
             SnackBar(content: Text('تم تسجيل الدخول بنجاح! مرحباً ${next.user.firstName ?? ""}')),
           );
        }
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              
              // Title
              Text(
                'auth.login.title'.tr(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 16.h),
              
              // Subtitle
              Text(
                'auth.login.subtitle'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              
              // Description
              Text(
                'auth.login.description'.tr(),
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
                hintText: 'auth.login.id_number'.tr(),
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              SizedBox(height: 16.h),
              
              // Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: 'auth.login.password'.tr(),
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
              SizedBox(height: 12.h),
              
              // Forgot Password
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ForgotPasswordBottomSheet(),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'auth.login.forgot_password'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              
              // Login Button
              isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    text: 'auth.login.submit'.tr(),
                    onPressed: _handleLogin,
                  ),
              
              SizedBox(height: 40.h),
              
              // Register Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.login.dont_have_account'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextButton(
                    onPressed: () {
                      context.goNamed('register');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'auth.login.register_here'.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
