import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../booking/data/models/order_details_model.dart';
import 'rental_state.dart';
import '../../../booking/domain/entities/booking_package.dart';
import '../../../booking/domain/entities/order_details_entity.dart';

final rentalProvider = StateNotifierProvider<RentalNotifier, RentalState>((ref) {
  return RentalNotifier();
});

class RentalNotifier extends StateNotifier<RentalState> {
  RentalNotifier() : super(const RentalState());

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void setServiceId(int id) {
    state = state.copyWith(serviceId: id);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
  
  void setStep(int step) {
    if (step >= 0 && step <= 4) {
      state = state.copyWith(currentStep: step);
    }
  }

  void selectPackage(BookingPackage package) {
    state = state.copyWith(selectedPackage: package);
    nextStep();
  }

  void setDeliveryMethod(int method) {
    if (state.deliveryMethod != method) {
      state = state.copyWith(
        deliveryMethod: method,
        addressId: null,
        address: null,
      );
    }
  }

  void setAddress(int id, String address) {
    state = state.copyWith(addressId: id, address: address);
  }

  void selectWorker(CandidateEntity worker) {
    state = state.copyWith(selectedWorker: worker);
    nextStep();
  }

  void setSignature(Uint8List bytes) {
    state = state.copyWith(signatureBytes: bytes);
  }
  
  void removeSignature() {
    state = state.copyWith(signatureBytes: null);
  }

  void setDob(String dob) {
    state = state.copyWith(dob: dob);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void applyDiscountCode(String code) {
    state = state.copyWith(discountCode: code);
  }

  void setPromoDiscount(double discount) {
    state = state.copyWith(promoDiscount: discount);
  }

  Future<void> createOrder() async {
    if (state.createdOrder != null) {
      if (state.currentStep < 4) {
        nextStep();
      }
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final apiClient = ApiClient();
      
      int durationMonths = 1;
      if (state.selectedPackage != null) {
        if (state.selectedPackage!.durationUnit == 'month') {
          durationMonths = state.selectedPackage!.durationValue;
        } else if (state.selectedPackage!.durationUnit == 'year') {
          durationMonths = state.selectedPackage!.durationValue * 12;
        }
      }

      // Prepare rental details
      final Map<String, dynamic> rentalDetails = {
        'duration_months': durationMonths,
        'accommodation_provided': true,
        'delivery_method': state.deliveryMethod == 0 ? 'branch_pickup' : 'home_delivery',
      };
      
      if (state.deliveryMethod == 0) {
        // hardcoded branch for now, or you could fetch it if available
        rentalDetails['receipt_branch_id'] = 1;
      } else if (state.addressId != null) {
        rentalDetails['customer_address_id'] = state.addressId;
      }

      if (state.selectedWorker != null) {
        rentalDetails['workers'] = [state.selectedWorker!.id];
      }

      // Convert signature
      String? base64Signature;
      if (state.signatureBytes != null) {
        base64Signature = 'data:image/png;base64,' + base64Encode(state.signatureBytes!);
      }

      final payload = {
        'order_type': 'rental',
        'service_id': state.serviceId,
        if (state.selectedPackage != null) 'package_id': state.selectedPackage!.id,
        'rental_details': rentalDetails,
        if (base64Signature != null) 'base64_signature': base64Signature,
      };

      final response = await apiClient.dio.post('orders/', data: payload);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final orderData = response.data['data'];
        final createdOrder = OrderDetailsModel.fromJson(orderData);
        
        state = state.copyWith(
          isLoading: false,
          createdOrder: createdOrder,
        );
        // Move to payment step
        nextStep();
      } else {
        throw Exception(response.data['message'] ?? 'فشل إنشاء الطلب');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> submitPayment() async {
    if (state.createdOrder == null) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final apiClient = ApiClient();
      
      // Submit payment intent
      final double originalTotal = double.tryParse(state.createdOrder!.totalPrice) ?? 0.0;
      double finalTotal = originalTotal - state.promoDiscount;
      if (finalTotal < 0) finalTotal = 0;

      final payload = {
        'order': state.createdOrder!.id,
        'method': state.paymentMethod,
        'amount': finalTotal,
      };
      
      // For now we don't strictly require the backend /payments endpoints to exist for testing.
      // But if they do:
      // await apiClient.dio.post('payments/intents/', data: payload);
      
      // Simulate backend delay
      await Future.delayed(const Duration(seconds: 2));
      
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
  
  void reset() {
    state = const RentalState();
  }
}
