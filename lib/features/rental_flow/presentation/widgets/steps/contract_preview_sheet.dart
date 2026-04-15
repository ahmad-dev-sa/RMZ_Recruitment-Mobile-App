import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/contract_preview_provider.dart';
import '../../providers/rental_provider.dart';

class ContractPreviewSheet extends ConsumerStatefulWidget {
  final String? htmlContent;
  const ContractPreviewSheet({super.key, this.htmlContent});

  @override
  ConsumerState<ContractPreviewSheet> createState() => _ContractPreviewSheetState();
}

class _ContractPreviewSheetState extends ConsumerState<ContractPreviewSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.htmlContent != null && widget.htmlContent!.isNotEmpty) {
        ref.read(contractPreviewProvider.notifier).setHtmlContent(widget.htmlContent!);
      } else {
        ref.read(contractPreviewProvider.notifier).fetchPreview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contractPreviewProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'view_contract'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          Divider(height: 32.h),
          Expanded(
            child: _buildContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ContractPreviewState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.htmlContent == null || state.htmlContent!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد قالب عقد متاح حالياً',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Html(data: state.htmlContent!),
          SizedBox(height: 32.h),
          if (state.managerSignatureUrl != null && state.managerSignatureUrl!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "توقيع ممثل الشركة",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                Image.network(
                  state.managerSignatureUrl!,
                  height: 80.h,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ],
            ),
          SizedBox(height: 16.h),
          if (state.companyStampUrl != null && state.companyStampUrl!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الختم المعتمد",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                Image.network(
                  state.companyStampUrl!,
                  height: 80.h,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ],
            ),
          // Show customer signature from local state if available (meaning we are on payment step)
          Consumer(builder: (context, ref, child) {
            final rentalState = ref.watch(rentalProvider);
            if (rentalState.signatureBytes != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    "توقيع العميل",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  Image.memory(
                    rentalState.signatureBytes!,
                    height: 80.h,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
