import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../booking/domain/entities/order_details_entity.dart';
import '../../providers/order_details_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDocumentsCard extends ConsumerStatefulWidget {
  final OrderDetailsEntity order;

  const OrderDocumentsCard({super.key, required this.order});

  @override
  ConsumerState<OrderDocumentsCard> createState() => _OrderDocumentsCardState();
}

class _OrderDocumentsCardState extends ConsumerState<OrderDocumentsCard> {
  Future<void> _uploadDocument() async {
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

        final String? title = await showDialog<String>(
          context: context,
          builder: (context) {
            String tempTitle = '';
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              title: Text('orders.document_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              content: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'orders.enter_document_title'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onChanged: (value) => tempTitle = value,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text('orders.cancel'.tr(), style: TextStyle(color: Colors.grey.shade600)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(tempTitle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('orders.upload'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );

        if (title != null) {
          await ref.read(orderDetailsActionProvider.notifier).uploadDocument(widget.order.id, file, title);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('orders.file_type_error'.tr())),
        );
      }
    }
  }

  Future<void> _confirmDelete(String documentId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('orders.delete_document_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          content: Text('orders.delete_document_message'.tr(), style: TextStyle(fontSize: 14.sp)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('orders.cancel'.tr(), style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('orders.delete'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ref.read(orderDetailsActionProvider.notifier).deleteDocument(widget.order.id, documentId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('orders.document_deleted_success'.tr())),
          );
        }
      } catch (e) {
        // Error is handled by provider listen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDocuments = widget.order.documents.isNotEmpty;
    final actionState = ref.watch(orderDetailsActionProvider);

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
          // It successfully finished an action
          // We can check if it just uploaded
          // but since state matches any action in the provider we just refresh silently
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
                'orders.documents'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              ElevatedButton.icon(
                onPressed: actionState.isLoading ? null : _uploadDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Teal
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                icon: actionState.isLoading 
                  ? SizedBox(width: 14.sp, height: 14.sp, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(Icons.upload_file, size: 16.sp, color: Colors.white),
                label: Text(
                  actionState.isLoading ? 'orders.uploading_file'.tr() : 'orders.upload_files'.tr(),
                  style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          
          SizedBox(height: 24.h),
          
          if (!hasDocuments)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'orders.no_documents_yet'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.order.documents.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, height: 1),
              ),
              itemBuilder: (context, index) {
                final doc = widget.order.documents[index];
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red.shade400, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            doc.uploadedAt,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!actionState.isLoading)
                      IconButton(
                        onPressed: () => _confirmDelete(doc.id),
                        icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20.sp),
                      ),
                    IconButton(
                        onPressed: () async {
                          final uri = Uri.parse(doc.fileUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: Icon(Icons.remove_red_eye_rounded, color: AppColors.primary, size: 20.sp),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
