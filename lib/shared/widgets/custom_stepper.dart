import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep; // 0-indexed
  final List<String> steps;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index % 2 == 0) {
            // Node (Circle + Text)
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;
            
            return Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isActive ? AppColors.primary : AppColors.headerDarkBlue,
                      border: Border.all(
                        color: isCompleted || isActive ? AppColors.primary : Colors.grey.shade500,
                        width: isActive ? 6.w : 2.w,
                      ),
                    ),
                    child: isCompleted 
                        ? Icon(Icons.check, color: Colors.white, size: 16.sp) 
                        : null,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    steps[stepIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCompleted || isActive ? Colors.white : Colors.grey.shade500,
                      fontSize: 11.sp,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Connecting Line
            final lineIndex = index ~/ 2;
            final isLineCompleted = lineIndex < currentStep;
            
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 13.h), // align vertically with the center of the 28.w circle
                height: 2.h,
                color: isLineCompleted ? AppColors.primary : Colors.grey.shade600,
              ),
            );
          }
        }),
      ),
    );
  }
}
