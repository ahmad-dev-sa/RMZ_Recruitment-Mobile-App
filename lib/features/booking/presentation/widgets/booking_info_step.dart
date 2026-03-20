import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/booking_provider.dart';

class BookingInfoStep extends ConsumerStatefulWidget {
  const BookingInfoStep({super.key});

  @override
  ConsumerState<BookingInfoStep> createState() => _BookingInfoStepState();
}

class _BookingInfoStepState extends ConsumerState<BookingInfoStep> {
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current state if any
    final state = ref.read(bookingProvider);
    _detailsController.text = state.details;
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _updateState() {
    ref.read(bookingProvider.notifier).updateInfo(
      details: _detailsController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('العنوان'),
          SizedBox(height: 8.h),
          _buildAddressCard(),
          
          SizedBox(height: 24.h),
          _buildSectionTitle('الديانة'),
          SizedBox(height: 8.h),
          _buildReligionSelector(state.religion),
          
          SizedBox(height: 24.h),
          _buildSectionTitle('عدد أفراد الأسرة'),
          SizedBox(height: 8.h),
          _buildCounter(state.familyMembers),
          
          SizedBox(height: 24.h),
          _buildSectionTitle('تفصيل'),
          SizedBox(height: 8.h),
          _buildDetailsTextField(),
          
          SizedBox(height: 24.h),
          _buildVisaToggle(state.hasVisa),
          
          SizedBox(height: 48.h), // Spacing before the button
          
          // Continue Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                _updateState();
                ref.read(bookingProvider.notifier).nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                'استمرار',
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4.w, height: 16.h, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                'عنوان رئيسي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text('تغيير العنوان', style: TextStyle(color: Colors.white, fontSize: 10.sp)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14.sp),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'الرياض حي النرجس طريق عثمان بن عفان\n33833، الرمز البريدي 119876',
            style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12.sp, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReligionSelector(String currentReligion) {
    final List<String> options = ['مسلم', 'غير مسلم', 'لا يهم'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        final isSelected = currentReligion == option;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(bookingProvider.notifier).updateInfo(religion: option);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.5),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCounter(int count) {
    return Row(
      children: [
        // Plus button
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              ref.read(bookingProvider.notifier).updateInfo(familyMembers: count + 1);
            },
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8), // RTL adjusted visually
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
        // Count display
        Expanded(
          flex: 2,
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.symmetric(
                horizontal: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        ),
        // Minus button
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (count > 0) {
                ref.read(bookingProvider.notifier).updateInfo(familyMembers: count - 1);
              }
            },
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTextField() {
    return TextField(
      controller: _detailsController,
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onChanged: (val) {
        // Will update state on continue, or real-time if needed
      },
    );
  }

  Widget _buildVisaToggle(bool hasVisa) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('هل لديك فيزا؟'),
        
        // Custom Styled Toggle Switch to match design
        GestureDetector(
          onTap: () {
            ref.read(bookingProvider.notifier).updateInfo(hasVisa: !hasVisa);
          },
          child: Container(
            width: 70.w,
            height: 35.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: hasVisa ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!hasVisa)
                   Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text('لا', style: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ),
                  
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                
                 if (hasVisa)
                   Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text('نعم', style: TextStyle(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
