import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../booking/domain/entities/order_entity.dart';

enum DayTimePeriod { morning, evening }

class DailyHourlyState {
  final int currentStep;
  final DayTimePeriod selectedPeriod;
  final String? selectedPackageId; // using String for mock IDs
  final String? selectedPackageName;
  final int? selectedServiceId;
  final DateTime? selectedDate;
  final String? selectedAddress; // using String for mockup
  final bool termsAccepted;
  final String? selectedPaymentMethod;
  final String? promoCode;
  final double promoDiscount;
  final int selectedVisitCount;
  final double packagePrice;
  final double packageTax;
  final bool isSubmitting;
  final OrderEntity? createdOrder;

  DailyHourlyState({
    this.currentStep = 0,
    this.selectedPeriod = DayTimePeriod.morning,
    this.selectedPackageId,
    this.selectedPackageName,
    this.selectedServiceId,
    this.selectedDate,
    this.selectedAddress,
    this.termsAccepted = false,
    this.selectedPaymentMethod,
    this.promoCode,
    this.promoDiscount = 0.0,
    this.selectedVisitCount = 1,
    this.packagePrice = 0.0,
    this.packageTax = 0.0,
    this.isSubmitting = false,
    this.createdOrder,
  });

  DailyHourlyState copyWith({
    int? currentStep,
    DayTimePeriod? selectedPeriod,
    String? selectedPackageId,
    String? selectedPackageName,
    int? selectedServiceId,
    DateTime? selectedDate,
    String? selectedAddress,
    bool? termsAccepted,
    String? selectedPaymentMethod,
    String? promoCode,
    double? promoDiscount,
    int? selectedVisitCount,
    double? packagePrice,
    double? packageTax,
    bool? isSubmitting,
    OrderEntity? createdOrder,
  }) {
    return DailyHourlyState(
      currentStep: currentStep ?? this.currentStep,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      selectedPackageName: selectedPackageName ?? this.selectedPackageName,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
      selectedVisitCount: selectedVisitCount ?? this.selectedVisitCount,
      packagePrice: packagePrice ?? this.packagePrice,
      packageTax: packageTax ?? this.packageTax,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }
}

class DailyHourlyNotifier extends StateNotifier<DailyHourlyState> {
  DailyHourlyNotifier() : super(DailyHourlyState());

  void setStep(int step) {
    if (step >= 0 && step < 4) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() => setStep(state.currentStep + 1);
  void previousStep() => setStep(state.currentStep - 1);

  void setPeriod(DayTimePeriod period) => state = state.copyWith(selectedPeriod: period);
  void setPackage(String packageId, int serviceId, [int visitCount = 1, double price = 0.0, double tax = 0.0, String? packageName]) => state = state.copyWith(
    selectedPackageId: packageId, 
    selectedPackageName: packageName,
    selectedServiceId: serviceId,
    selectedVisitCount: visitCount,
    packagePrice: price,
    packageTax: tax,
  );
  void setDate(DateTime date) => state = state.copyWith(selectedDate: date);
  void setAddress(String address) => state = state.copyWith(selectedAddress: address);
  void toggleTerms(bool value) => state = state.copyWith(termsAccepted: value);
  void setPaymentMethod(String method) => state = state.copyWith(selectedPaymentMethod: method);
  void setPromoCode(String code) => state = state.copyWith(promoCode: code);
  void setPromoDiscount(double discount) => state = state.copyWith(promoDiscount: discount);
  void setSubmitting(bool value) => state = state.copyWith(isSubmitting: value);
  void setCreatedOrder(OrderEntity order) => state = state.copyWith(createdOrder: order);
  
  bool canProceed() {
    switch(state.currentStep) {
      case 0:
        return state.selectedPackageId != null;
      case 1:
        return state.selectedDate != null && state.selectedAddress != null;
      case 2:
        return state.termsAccepted;
      case 3:
        return state.selectedPaymentMethod != null;
      default:
        return false;
    }
  }
}

final dailyHourlyProvider = StateNotifierProvider<DailyHourlyNotifier, DailyHourlyState>((ref) {
  return DailyHourlyNotifier();
});
