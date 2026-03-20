import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/booking_package.dart';

class BookingState {
  final int currentStep;
  final BookingPackage? selectedPackage;
  
  // Info Step Data
  final String address;
  final String religion;
  final int familyMembers;
  final String details;
  final bool hasVisa;
  
  // Submission
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  const BookingState({
    this.currentStep = 0,
    this.selectedPackage,
    this.address = '',
    this.religion = 'مسلم', // default
    this.familyMembers = 0,
    this.details = '',
    this.hasVisa = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  BookingState copyWith({
    int? currentStep,
    BookingPackage? selectedPackage,
    String? address,
    String? religion,
    int? familyMembers,
    String? details,
    bool? hasVisa,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      address: address ?? this.address,
      religion: religion ?? this.religion,
      familyMembers: familyMembers ?? this.familyMembers,
      details: details ?? this.details,
      hasVisa: hasVisa ?? this.hasVisa,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage, // To clear, pass empty string or handle explicitly
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState());

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

  void selectPackage(BookingPackage package) {
    state = state.copyWith(selectedPackage: package, errorMessage: null);
  }

  void updateInfo({
    String? address,
    String? religion,
    int? familyMembers,
    String? details,
    bool? hasVisa,
  }) {
    state = state.copyWith(
      address: address,
      religion: religion,
      familyMembers: familyMembers,
      details: details,
      hasVisa: hasVisa,
    );
  }

  Future<void> submitOrder() async {
    // Basic validation
    if (state.selectedPackage == null) {
      state = state.copyWith(errorMessage: 'الرجاء اختيار باقة');
      return;
    }
    
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'حدث خطأ أثناء إرسال الطلب. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  void reset() {
    state = const BookingState();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

class PackageFilter {
  final int categoryId;
  final int serviceId;

  const PackageFilter({required this.categoryId, required this.serviceId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageFilter &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          serviceId == other.serviceId;

  @override
  int get hashCode => categoryId.hashCode ^ serviceId.hashCode;
}

// A generic provider for fetching packages based on category and service
final availablePackagesProvider = FutureProvider.family<List<BookingPackage>, PackageFilter>((ref, filter) async {
  await Future.delayed(const Duration(milliseconds: 800));
  
  // Here we simulate fetching filtered data based on category and service.
  // In a real scenario, we would inject a repository and call an API: `repository.getPackages(filter.categoryId, filter.serviceId)`
  
  if (filter.categoryId == 1) { // Assuming 1 represents Recruitment (استقدام)
    return [
      const BookingPackage(id: '1', nameAr: 'استقدام عاملة منزلية من تنزانيا', nameEn: 'Maid from Tanzania', price: '6300', monthlySalary: '900 - 1200'),
      const BookingPackage(id: '2', nameAr: 'استقدام عاملة منزلية من كينيا', nameEn: 'Maid from Kenya', price: '6500', monthlySalary: '1000 - 1300'),
      const BookingPackage(id: '3', nameAr: 'استقدام عاملة منزلية من أوغندا', nameEn: 'Maid from Uganda', price: '6000', monthlySalary: '900 - 1100'),
      const BookingPackage(id: '4', nameAr: 'استقدام عاملة منزلية من الفلبين', nameEn: 'Maid from Philippines', price: '15000', monthlySalary: '1500 - 1800'),
    ];
  } else {
    // If not Recruitment, show some dummy packages for Hourly or other categories
    return [
      const BookingPackage(id: '5', nameAr: 'باقة زيارة واحدة', nameEn: 'One Visit Package', price: '200', monthlySalary: '0'),
      const BookingPackage(id: '6', nameAr: 'باقة 4 زيارات', nameEn: '4 Visits Package', price: '750', monthlySalary: '0'),
    ];
  }
});
