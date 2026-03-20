import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onClose;

  const SuccessDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'auth.forgot_password.success_title'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.secondary,
                fontSize: 20.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            
            // Message
            Text(
              'auth.forgot_password.success_message'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Close Button
            SizedBox(
              width: 150.w, // Specific width according to design
              height: 48.h,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error, // Red colored button for closing
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'auth.forgot_password.close'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  State<ForgotPasswordBottomSheet> createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _handleSend() {
    // TODO: Connect with Django API
    // 1. Validate ID input
    // 2. Call API to send reset password SMS to registered number
    // 3. On success, show Success Dialog
    
    // Simulating success flow:
    Navigator.of(context).pop(); // Close bottom sheet
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        onClose: () {
          Navigator.of(context).pop(); // Close dialog
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 32.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary, // Cyan background from the design
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'auth.forgot_password.title'.tr(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          // ID Field inside the sheet
          // Create a dark themed or inverted color text field specific to this component's design
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center, // As per design
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: 'auth.forgot_password.id_number'.tr(),
                hintStyle: TextStyle(
                  color: AppColors.textSecondaryLight.withOpacity(0.5),
                  fontSize: 14.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                border: InputBorder.none,
              ),
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Description
          Text(
            'auth.forgot_password.description'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              height: 1.5,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 32.h),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _handleSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary, // Dark blue button
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'auth.forgot_password.submit'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
