import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/order_details_provider.dart';

class OrderVisaCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const OrderVisaCard({super.key, required this.order});

  @override
  ConsumerState<OrderVisaCard> createState() => _OrderVisaCardState();
}

class _OrderVisaCardState extends ConsumerState<OrderVisaCard> {
  late TextEditingController _visaNumberController;
  late TextEditingController _expiryDateController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _visaNumberController = TextEditingController(text: widget.order.visaNumber ?? '');
    _expiryDateController = TextEditingController(text: widget.order.visaExpiryDate ?? '');
    
    // If we already have a visa number, start in read-only mode
    if (widget.order.visaNumber != null && widget.order.visaNumber!.isNotEmpty) {
      _isEditing = false;
    } else {
      _isEditing = true;
    }
  }

  @override
  void didUpdateWidget(OrderVisaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.order.visaNumber != oldWidget.order.visaNumber) {
      if (_visaNumberController.text != widget.order.visaNumber) {
        _visaNumberController.text = widget.order.visaNumber ?? '';
      }
    }
    if (widget.order.visaExpiryDate != oldWidget.order.visaExpiryDate) {
      if (_expiryDateController.text != widget.order.visaExpiryDate) {
        _expiryDateController.text = widget.order.visaExpiryDate ?? '';
      }
    }
  }

  @override
  void dispose() {
    _visaNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onSave() async {
    final visaNum = _visaNumberController.text.trim();
    final expiry = _expiryDateController.text.trim();
    if (visaNum.isNotEmpty && expiry.isNotEmpty) {
      await ref.read(orderDetailsActionProvider.notifier).updateVisaInfo(widget.order.id, visaNum, expiry);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('orders.required_field'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionState = ref.watch(orderDetailsActionProvider);

    // Listen to action state to show success or error
    ref.listen<AsyncValue<void>>(
      orderDetailsActionProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (!state.isLoading && !state.hasError) {
          // On success, hide the edit form
          setState(() {
            _isEditing = false;
          });
        }
      },
    );

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                'orders.employment_status'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              if (widget.order.visaStatus != null && widget.order.visaStatus!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    widget.order.visaStatus!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else 
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: !_isEditing && widget.order.visaNumber != null && widget.order.visaNumber!.isNotEmpty
                      ? Colors.green.withOpacity(0.15)
                      : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    !_isEditing && widget.order.visaNumber != null && widget.order.visaNumber!.isNotEmpty
                      ? 'orders.visa_updated'.tr()
                      : 'orders.visa_pending'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: !_isEditing && widget.order.visaNumber != null && widget.order.visaNumber!.isNotEmpty
                        ? isDark ? Colors.green.shade400 : Colors.green.shade700
                        : isDark ? Colors.orange.shade400 : Colors.orange.shade700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          
          if (!_isEditing) ...[
            // READ-ONLY VIEW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'orders.visa_info'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade300 : AppColors.textPrimaryLight,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        'orders.edit_visa_info'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.description_outlined, color: AppColors.primary, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'orders.visa_number'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.order.visaNumber ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'orders.expiry_date'.tr(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.order.visaExpiryDate ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                        ),
                      ),
                      _buildRemainingDays(widget.order.visaExpiryDate, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // EDIT FORM VIEW
            Text(
              'orders.visa_info'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade300 : AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Visa Number Input
            Text(
              'orders.visa_number'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: _visaNumberController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.w),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Expiry Date Input
            Text(
              'orders.expiry_date'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _expiryDateController,
                  style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1.w),
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Save & Cancel Buttons
            Row(
              children: [
                if (widget.order.visaNumber != null && widget.order.visaNumber!.isNotEmpty) ...[
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: actionState.isLoading ? null : () {
                          setState(() {
                            // Reset text to previous values
                            _visaNumberController.text = widget.order.visaNumber ?? '';
                            _expiryDateController.text = widget.order.visaExpiryDate ?? '';
                            _isEditing = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: isDark ? Colors.grey.shade600 : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: Icon(Icons.close, color: isDark ? Colors.white : Colors.black, size: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: actionState.isLoading ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: actionState.isLoading 
                          ? SizedBox(width: 24.w, height: 24.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'orders.save_visa_info'.tr(),
                              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: actionState.isLoading ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: actionState.isLoading 
                          ? SizedBox(width: 24.w, height: 24.w, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              'orders.save_visa_info'.tr(),
                              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRemainingDays(String? dateStr, bool isDark) {
    if (dateStr == null || dateStr.isEmpty) return const SizedBox.shrink();

    try {
      final expiryStr = dateStr.replaceAll('/', '-'); 
      final expiry = DateTime.parse(expiryStr);
      final today = DateTime.now();
      
      final expiryDateOnly = DateTime(expiry.year, expiry.month, expiry.day);
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      
      final difference = expiryDateOnly.difference(todayDateOnly).inDays;

      if (difference < 0) {
        return Container(
          margin: EdgeInsets.only(top: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'orders.visa_expired'.tr(namedArgs: {'days': difference.abs().toString()}),
            style: TextStyle(fontSize: 10.sp, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      } else if (difference == 0) {
        return Container(
          margin: EdgeInsets.only(top: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'orders.visa_expires_today'.tr(),
            style: TextStyle(fontSize: 10.sp, color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(top: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'orders.visa_remaining_days'.tr(namedArgs: {'days': difference.toString()}),
            style: TextStyle(fontSize: 10.sp, color: isDark ? Colors.green.shade400 : Colors.green.shade700, fontWeight: FontWeight.bold),
          ),
        );
      }
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
