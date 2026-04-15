import '../../../booking/domain/entities/booking_package.dart';
import '../../../booking/domain/entities/order_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruitment_state.freezed.dart';

@freezed
class RecruitmentState with _$RecruitmentState {
  const factory RecruitmentState({
    @Default(0) int currentStep,
    int? packageId,
    BookingPackage? selectedPackage,
    // Step 2 Info
    int? addressId,
    String? address,
    @Default('لا يهم') String religion,
    // Additional Worker Preferences
    String? preferredNationality,
    int? ageFrom,
    int? ageTo,
    int? experienceYears,
    // Family Conditions
    @Default(false) bool hasChildren,
    @Default(false) bool hasElderly,
    @Default(false) bool hasSpecialNeeds,
    // Existing fields
    @Default(0) int familyMembersCount,
    String? details,
    @Default(false) bool hasVisa,
    String? visaNumber,
    // order API state
    @Default(false) bool isLoading,
    String? errorMessage,
    OrderEntity? submittedOrder,
  }) = _RecruitmentState;

  const RecruitmentState._();

  bool get isStepOneComplete => packageId != null;
  bool get isStepTwoComplete => address?.isNotEmpty == true;
}
