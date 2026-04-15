import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../providers/rental_provider.dart';
import '../../providers/rental_state.dart';
import 'contract_preview_sheet.dart';

class PaymentStepView extends ConsumerStatefulWidget {
  const PaymentStepView({super.key});

  @override
  ConsumerState<PaymentStepView> createState() => _PaymentStepViewState();
}

class _PaymentStepViewState extends ConsumerState<PaymentStepView> {
  final TextEditingController _discountController = TextEditingController();

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'credit_card', 'titleAr': 'بطاقة ائتمانية', 'icon': Icons.credit_card},
    {'id': 'cash', 'titleAr': 'الدفع عند التوصيل', 'icon': Icons.local_shipping},
    {'id': 'stc_pay', 'titleAr': 'STC Pay', 'icon': Icons.account_balance_wallet},
    {'id': 'sadad', 'titleAr': 'الدفع عن طريق سداد', 'icon': Icons.receipt},
    {'id': 'tamara', 'titleAr': 'Tamara Pay', 'desc': 'طلب الاسترداد الخاص بمدفوعات تمارا يتم من خلال تمارا', 'icon': Icons.payment},
  ];

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentalProvider);
    final notifier = ref.read(rentalProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.createdOrder == null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const Center(child: CircularProgressIndicator()),
            )
          else ...[
            _buildSectionTitle('تفاصيل الطلب'),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('رقم الطلب', state.createdOrder!.orderNumber),
                  _buildSummaryRow('حالة الدفع', 'لم يتم الدفع'),
                  _buildSummaryRow('المبلغ الإجمالي', '${state.createdOrder!.totalPrice} ريال'),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ContractPreviewSheet(htmlContent: state.createdOrder?.contract?.htmlContent),
                        );
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('عرض النسخة المعتمدة من العقد'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
          
          _buildSectionTitle('payment_method'.tr()),
          
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                ..._paymentMethods.asMap().entries.map((entry) {
                  final method = entry.value;
                  final index = entry.key;
                  final isSelected = state.paymentMethod == method['id'];
                  
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => notifier.setPaymentMethod(method['id']),
                        leading: Radio<String>(
                          value: method['id'],
                          groupValue: state.paymentMethod,
                          onChanged: (val) => notifier.setPaymentMethod(val!),
                          activeColor: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          method['titleAr'],
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                        ),
                        subtitle: method.containsKey('desc') 
                            ? Text(method['desc'], style: TextStyle(fontSize: 10.sp, color: Colors.grey))
                            : null,
                        trailing: Icon(method['icon'], color: Theme.of(context).primaryColor),
                      ),
                      if (index < _paymentMethods.length - 1)
                        const Divider(height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          Text(
            'or_pay_with_apple_pay'.tr(),
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () => notifier.setPaymentMethod('apple_pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              icon: const Icon(Icons.apple),
              label: Text('pay_with_apple_pay'.tr()),
            ),
          ),

          SizedBox(height: 24.h),
          Text(
            'have_discount_code'.tr(),
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    hintText: 'enter_discount_code'.tr(),
                    prefixIcon: Icon(Icons.confirmation_num, color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    if (_discountController.text.isNotEmpty) {
                      notifier.applyDiscountCode(_discountController.text);
                      _verifyCode(context, ref, notifier, state, _discountController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text('send'.tr()),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),
          
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'payment_details'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                _buildSummaryRow('package_price'.tr(), '${state.createdOrder!.subTotal} ريال سعودي'),
                if (state.promoDiscount > 0)
                   _buildSummaryRow('discount'.tr(), '${state.promoDiscount} ريال سعودي'),
                _buildSummaryRow('vat'.tr(), '${state.createdOrder!.taxAmount} ريال سعودي'),
                SizedBox(height: 8.h),
                Builder(
                  builder: (context) {
                    final double originalTotal = double.tryParse(state.createdOrder!.totalPrice) ?? 0.0;
                    double finalTotal = originalTotal - state.promoDiscount;
                    if (finalTotal < 0) finalTotal = 0;
                    
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_payment'.tr(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${finalTotal.toStringAsFixed(2)} ريال سعودي',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          
          SizedBox(height: 40.h),
          
              ],
            ),
          ),
        ),
        
        // Footer with Continuous Button
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              text: 'continue'.tr(),
              isLoading: state.isLoading,
              onPressed: () async {
                await notifier.submitPayment();
                if (ref.read(rentalProvider).errorMessage == null) {
                   if (context.mounted) {
                     context.go('/workflow/rental/success');
                   }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
               label,
               style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode(BuildContext context, WidgetRef ref, RentalNotifier notifier, RentalState state, String code) async {
    if (code.isEmpty) {
      notifier.setPromoDiscount(0.0);
      return;
    }

    // Try finding ApiClient directly from provider if available, or just construct it.
    // rental_provider uses ApiClient() so we can do the same.
    final apiClient = ref.read(rentalProvider.notifier);
    try {
      final client = ApiClient();
      final response = await client.dio.get('marketing/offers/');
      
      List items = [];
      if (response.data is Map) {
         if (response.data.containsKey('data')) items = response.data['data'];
         else if (response.data.containsKey('results')) items = response.data['results'];
      } else if (response.data is List) {
         items = response.data;
      }
      
      final filteredOffers = items.where((o) => o['discount_code']?.toString().toUpperCase() == code.toUpperCase()).toList();
      
      if (filteredOffers.isNotEmpty) {
        final offer = filteredOffers.first;
        final packageId = offer['package'];
        
        bool valid = true;
        if (packageId != null && packageId.toString() != state.selectedPackage?.id.toString()) {
          valid = false;
        }
        
        if (!valid) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('عذراً، هذا الكود غير مخصص لهذه الباقة!')));
          notifier.setPromoDiscount(0.0);
          return;
        }

        double discount = 0.0;
        double packagePrice = double.tryParse(state.createdOrder?.subTotal ?? '0') ?? 0.0;
        
        if (offer['discount_amount'] != null) {
          discount = double.tryParse(offer['discount_amount'].toString()) ?? 0.0;
        } else if (offer['discount_percentage'] != null) {
          final pct = double.tryParse(offer['discount_percentage'].toString()) ?? 0.0;
          discount = packagePrice * (pct / 100);
        }
        
        notifier.setPromoDiscount(discount);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تطبيق الخصم بنجاح!'), backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الكود غير صحيح أو منتهي الصلاحية.'), backgroundColor: Colors.red));
        notifier.setPromoDiscount(0.0);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ في التحقق من الكود.'), backgroundColor: Colors.red));
    }
  }
}
