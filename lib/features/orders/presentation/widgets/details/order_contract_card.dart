import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/order_details_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class OrderContractCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const OrderContractCard({super.key, required this.order});

  @override
  ConsumerState<OrderContractCard> createState() => _OrderContractCardState();
}

class _OrderContractCardState extends ConsumerState<OrderContractCard> {
  Future<void> _uploadContract() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        
        final int fileSizeInBytes = await file.length();
        if (fileSizeInBytes > 3 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('orders.file_size_error'.tr()),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        await ref.read(orderDetailsActionProvider.notifier).uploadContract(widget.order.id, file);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('orders.contract_uploaded_success'.tr())),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('orders.error_action'.tr())),
        );
      }
    }
  }

  Future<void> _handleContractAction(String actionType, String titleKey, String messageKey) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titleKey.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          content: Text(messageKey.tr(), style: TextStyle(fontSize: 14.sp)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('orders.cancel'.tr(), style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('orders.confirm'.tr(), style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final notifier = ref.read(orderDetailsActionProvider.notifier);
        if (actionType == 'renew') {
          await notifier.renewContract(widget.order.id);
        } else if (actionType == 'cancel') {
          await notifier.cancelContract(widget.order.id);
        } else if (actionType == 'refund') {
          await notifier.refundContract(widget.order.id);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('orders.action_success'.tr())),
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

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionState = ref.watch(orderDetailsActionProvider);
    final contract = widget.order.contract;
    final worker = widget.order.selectedCandidate;

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
            'orders.contract_section'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          
          if (worker != null) ...[
            SizedBox(height: 16.h),
            _buildWorkerInfo(worker, isDark),
          ],
          
          SizedBox(height: 20.h),
          
          if (contract == null || (contract.printPdf == null && contract.signedPdf == null)) ...[
             _buildPendingContractState(isDark),
          ] else if (contract.signedPdf != null) ...[
             _buildSignedContractState(contract, isDark),
          ] else if (contract.printPdf != null) ...[
             _buildActionableContractState(contract, actionState, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkerInfo(CandidateEntity worker, bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: (worker.imageUrl != null && worker.imageUrl!.isNotEmpty) 
                ? NetworkImage(worker.imageUrl!) 
                : null,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: (worker.imageUrl == null || worker.imageUrl!.isEmpty)
                ? Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                SizedBox(height: 2.h),
                Text(
                  '\${worker.profession ?? ''} - \${worker.nationality ?? ''}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingContractState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.description_outlined, size: 32.sp, color: Colors.orange.shade400),
          SizedBox(height: 8.h),
          Text(
            'orders.contract_preparing'.tr(),
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.orange.shade700),
          ),
          SizedBox(height: 4.h),
          Text(
            'orders.contract_preparing_desc'.tr(),
            style: TextStyle(fontSize: 10.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSignedContractState(ContractEntity contract, bool isDark) {
    final DateTime? startDate = _parseDate(contract.startDate);
    final DateTime? endDate = _parseDate(contract.endDate);
    final bool isExpired = endDate != null && DateTime.now().isAfter(endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : (isExpired ? Colors.red.shade50 : Colors.green.shade50),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isDark ? Colors.grey.shade800 : (isExpired ? Colors.red.shade200 : Colors.green.shade200)),
          ),
          child: Column(
            children: [
              Icon(
                isExpired ? Icons.warning_amber_rounded : Icons.check_circle_outline, 
                size: 32.sp, 
                color: isExpired ? Colors.red.shade500 : Colors.green.shade600
              ),
              SizedBox(height: 8.h),
              Text(
                isExpired ? 'orders.contract_expired'.tr() : 'orders.contract_active'.tr(),
                style: TextStyle(
                  fontSize: 14.sp, 
                  fontWeight: FontWeight.bold, 
                  color: isExpired ? Colors.red.shade700 : Colors.green.shade700
                ),
              ),
              if (startDate != null && endDate != null) ...[
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDateColumn('orders.start_date'.tr(), DateFormat('yyyy-MM-dd').format(startDate), isExpired, isDark),
                    Container(height: 30.h, width: 1, color: isExpired ? Colors.red.shade200 : Colors.green.shade200),
                    _buildDateColumn('orders.end_date'.tr(), DateFormat('yyyy-MM-dd').format(endDate), isExpired, isDark),
                  ],
                ),
              ],
            ],
          ),
        ),
        
        SizedBox(height: 24.h),
        Text(
          'orders.manage_contract'.tr(),
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
        ),
        SizedBox(height: 12.h),
        
        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.autorenew_rounded,
                label: 'orders.renew'.tr(),
                color: Colors.blue.shade600,
                onTap: () => _handleContractAction('renew', 'orders.renew_title', 'orders.renew_desc'),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildActionButton(
                icon: Icons.cancel_outlined,
                label: 'orders.cancel_contract'.tr(),
                color: Colors.orange.shade600,
                onTap: () => _handleContractAction('cancel', 'orders.cancel_title', 'orders.cancel_desc'),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildActionButton(
                icon: Icons.money_off_csred_rounded,
                label: 'orders.refund'.tr(),
                color: Colors.red.shade600,
                onTap: () => _handleContractAction('refund', 'orders.refund_title', 'orders.refund_desc'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateColumn(String title, String date, bool isExpired, bool isDark) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 10.sp, color: isExpired ? Colors.red.shade400 : Colors.green.shade600)),
        SizedBox(height: 4.h),
        Text(date, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: isExpired ? Colors.red.shade700 : Colors.green.shade800)),
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
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 6.h),
            Text(label, style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActionableContractState(ContractEntity contract, AsyncValue<void> actionState, bool isDark) {
    return Column(
      children: [
        // Download Row
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
               Icon(Icons.picture_as_pdf_rounded, color: Colors.red.shade400, size: 24.sp),
               SizedBox(width: 12.w),
               Expanded(
                 child: Text(
                   'orders.contract_document'.tr(),
                   style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                 ),
               ),
               IconButton(
                 onPressed: () {
                    // Logic to open URL contract.printPdf!
                 },
                 icon: Icon(Icons.download_rounded, color: AppColors.primary, size: 24.sp),
               ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Upload Action
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: actionState.isLoading ? null : _uploadContract,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            icon: actionState.isLoading 
                ? SizedBox(width: 16.sp, height: 16.sp, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Icon(Icons.upload_file, color: Colors.white, size: 18.sp),
            label: Text(
              actionState.isLoading ? 'orders.uploading_file'.tr() : 'orders.upload_signed_contract'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
