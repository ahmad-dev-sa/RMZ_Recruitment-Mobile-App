import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/order_details_provider.dart';
import '../../screens/invoice_view_screen.dart';
import '../../screens/contract_view_screen.dart';

class RentalContractCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const RentalContractCard({super.key, required this.order});

  @override
  ConsumerState<RentalContractCard> createState() => _RentalContractCardState();
}

class _RentalContractCardState extends ConsumerState<RentalContractCard> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleCustomerRequest(String requestType, String title, String hint, {bool isNumber = false}) async {
    _reasonController.clear();
    final bool isAr = context.locale.languageCode == 'ar';
    final actionState = ref.watch(orderDetailsActionProvider);

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isAr ? 'الرجاء توضيح التفاصيل' : 'Please provide details',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _reasonController,
                keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                ),
                maxLines: isNumber ? 1 : 3,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(isAr ? 'إلغاء' : 'Cancel', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(isAr ? 'إرسال' : 'Submit', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final details = _reasonController.text.trim();
      if (details.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isAr ? 'الرجاء إدخال التفاصيل المطلوبة' : 'Details are required')),
          );
        }
        return;
      }
      try {
        await ref.read(orderDetailsActionProvider.notifier).submitCustomerRequest(widget.order.id, requestType, details: details);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(isAr ? 'تم إرسال الطلب بنجاح' : 'Request submitted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  Future<void> _handleDirectRequest(String requestType, String title, String confirmMessage) async {
    final bool isAr = context.locale.languageCode == 'ar';
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          content: Text(confirmMessage, style: TextStyle(fontSize: 14.sp)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(isAr ? 'إلغاء' : 'Cancel', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(isAr ? 'تأكيد' : 'Confirm', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ref.read(orderDetailsActionProvider.notifier).submitCustomerRequest(widget.order.id, requestType, details: 'User confirmation');
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(isAr ? 'تم إرسال الطلب بنجاح' : 'Request submitted successfully')),
           );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.locale.languageCode == 'ar';
    final contract = widget.order.contract;

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
          Text(
            isAr ? 'تفاصيل العقد' : 'Contract Details',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Contract Information
          _buildInfoRow(isAr ? 'مدة العقد' : 'Duration', widget.order.packageName, isDark),
          SizedBox(height: 8.h),
          _buildInfoRow(isAr ? 'الحالة' : 'Status', _translateContractStatus(contract?.status ?? '', isAr), isDark),
          SizedBox(height: 8.h),
          _buildInfoRow(isAr ? 'بداية العقد' : 'Start Date', contract?.startDate ?? '-', isDark),
          SizedBox(height: 8.h),
          _buildInfoRow(isAr ? 'تاريخ انتهاء العقد' : 'End Date', contract?.endDate ?? '-', isDark),
          
          SizedBox(height: 20.h),
          
          // Documents buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: isAr ? 'عرض الفاتورة' : 'View Invoice',
                  color: Colors.teal.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoiceViewScreen(order: widget.order),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                 child: _buildActionButton(
                  icon: Icons.description_outlined,
                  label: isAr ? 'عرض العقد' : 'View Contract',
                  color: Colors.blue.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContractViewScreen(order: widget.order),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          SizedBox(height: 20.h),
          
          Text(
            isAr ? 'إجراءات العقد' : 'Contract Actions',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          SizedBox(height: 12.h),

          // Actions
          Wrap(
            spacing: 8.w,
            runSpacing: 12.h,
            children: [
              _buildSecondaryActionButton(
                label: isAr ? 'تمديد العقد' : 'Extend Contract',
                icon: Icons.update,
                onTap: () => _handleCustomerRequest('extend_contract', isAr ? 'تمديد العقد' : 'Extend Contract', isAr ? 'أدخل مدة التمديد بالأشهر (مثال: 3)' : 'Enter duration in months (e.g. 3)', isNumber: true),
                isDark: isDark,
              ),
              _buildSecondaryActionButton(
                label: isAr ? 'طلب تغيير عاملة' : 'Change Worker',
                icon: Icons.swap_horiz,
                onTap: () => _handleCustomerRequest('replace_worker', isAr ? 'طلب تغيير عاملة' : 'Change Worker', isAr ? 'أدخل سبب التغيير' : 'Enter reason for replacement'),
                isDark: isDark,
              ),
              _buildSecondaryActionButton(
                label: isAr ? 'طلب الغاء العقد' : 'Cancel Contract',
                icon: Icons.cancel_outlined,
                onTap: () => _handleCustomerRequest('cancel_contract', isAr ? 'تأكيد إلغاء العقد' : 'Confirm Cancellation', isAr ? 'أدخل سبب الإلغاء' : 'Enter reason for cancellation'),
                isDark: isDark,
              ),
              _buildSecondaryActionButton(
                label: isAr ? 'طلب استرداد قيمة العقد' : 'Refund',
                icon: Icons.money_off,
                onTap: () => _handleDirectRequest('refund_contract', isAr ? 'طلب استرداد' : 'Request Refund', isAr ? 'هل أنت متأكد من رغبتك في إرسال طلب استرداد قيمة العقد للإدارة؟' : 'Are you sure you want to request a refund?'),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _translateContractStatus(String status, bool isAr) {
    if (status.isEmpty) return '-';
    // Simplified translation
    final s = status.toLowerCase();
    if (s.contains('active') || s.contains('جاري')) return isAr ? 'جاري' : 'Active';
    if (s.contains('pending')) return isAr ? 'قيد الانتظار' : 'Pending';
    if (s.contains('cancel')) return isAr ? 'ملغي' : 'Cancelled';
    if (s.contains('end') || s.contains('منتهي')) return isAr ? 'منتهي' : 'Ended';
    return status;
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13.sp)),
        Text(value, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 8.h),
            Text(label, style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionButton({required String label, required IconData icon, required VoidCallback onTap, required bool isDark}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
