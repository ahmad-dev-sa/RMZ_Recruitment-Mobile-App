import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../booking/domain/entities/booking_package.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import 'recruitment_state.dart';

// Create a provider for ApiClient (can be moved to a core provider file if needed)
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookingRepositoryImpl(apiClient: apiClient);
});

final recruitmentProvider = StateNotifierProvider.autoDispose<RecruitmentNotifier, RecruitmentState>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return RecruitmentNotifier(repository);
});

class RecruitmentNotifier extends StateNotifier<RecruitmentState> {
  final BookingRepository _repository;

  RecruitmentNotifier(this._repository) : super(const RecruitmentState());

  void setStep(int step) {
    if (step >= 0 && step <= 2) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void selectPackage(int packageId, BookingPackage package) {
    state = state.copyWith(
      packageId: packageId,
      selectedPackage: package,
    );
  }

  void updateBookingInfo({
    int? addressId,
    String? address,
    String? religion,
    int? familyMembersCount,
    String? details,
    bool? hasVisa,
    String? visaNumber,
    String? preferredNationality,
    int? ageFrom,
    int? ageTo,
    int? experienceYears,
    bool? hasChildren,
    bool? hasElderly,
    bool? hasSpecialNeeds,
  }) {
    state = state.copyWith(
      addressId: addressId ?? state.addressId,
      address: address ?? state.address,
      religion: religion ?? state.religion,
      familyMembersCount: familyMembersCount ?? state.familyMembersCount,
      details: details ?? state.details,
      hasVisa: hasVisa ?? state.hasVisa,
      visaNumber: visaNumber ?? state.visaNumber,
      preferredNationality: preferredNationality ?? state.preferredNationality,
      ageFrom: ageFrom ?? state.ageFrom,
      ageTo: ageTo ?? state.ageTo,
      experienceYears: experienceYears ?? state.experienceYears,
      hasChildren: hasChildren ?? state.hasChildren,
      hasElderly: hasElderly ?? state.hasElderly,
      hasSpecialNeeds: hasSpecialNeeds ?? state.hasSpecialNeeds,
    );
  }

  Future<bool> submitOrder() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Map Arabic UI string to Religion Enum
      String religionEnum = 'any';
      if (state.religion == 'مسلم') religionEnum = 'muslim';
      if (state.religion == 'غير مسلم') religionEnum = 'non_muslim';

      final orderData = {
        'order_type': 'recruitment',
        'service_id': state.selectedPackage?.serviceId,
        'package_id': state.packageId,
        'recruitment_case': {
          'religion_preference': religionEnum,
          'family_members_count': state.familyMembersCount,
          'special_requirements': state.details,
          'has_visa': state.hasVisa,
          'visa_number': state.hasVisa ? state.visaNumber : '',
          'nationality_preference': state.preferredNationality,
          'age_min': state.ageFrom,
          'age_max': state.ageTo,
          'experience_years': state.experienceYears,
          'has_children': state.hasChildren,
          'has_elderly': state.hasElderly,
          'has_disabled': state.hasSpecialNeeds,
          if (state.addressId != null) 'customer_address': state.addressId,
        }
      };

      final orderEntity = await _repository.createRecruitmentOrder(orderData);
      
      state = state.copyWith(
        isLoading: false,
        submittedOrder: orderEntity,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'حدث خطأ أثناء إرسال الطلب، يرجى المحاولة لاحقاً',
      );
      return false;
    }
  }

  void reset() {
    state = const RecruitmentState();
  }
}
