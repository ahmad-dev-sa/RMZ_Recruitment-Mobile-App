import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../booking/domain/entities/booking_package.dart';
import '../../../booking/domain/entities/order_details_entity.dart'; // For CandidateEntity

part 'rental_state.freezed.dart';

@freezed
class RentalState with _$RentalState {
  const factory RentalState({
    @Default(0) int currentStep,
    int? serviceId,
    BookingPackage? selectedPackage,
    // Step 2 Info (Booking Details)
    @Default(0) int deliveryMethod, // 0 for Branch, 1 for Delivery
    int? addressId,
    String? address,
    // Step 3 Info (Worker)
    CandidateEntity? selectedWorker,
    // Step 4 Info (Contract/Signature)
    Uint8List? signatureBytes,
    String? dob,
    // Step 5 Info (Payment)
    @Default('visa') String paymentMethod,
    String? discountCode,
    @Default(0.0) double promoDiscount,
    
    OrderDetailsEntity? createdOrder,

    // API state
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isSuccess,
  }) = _RentalState;

  const RentalState._();
}
