import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import 'rental_provider.dart';

class ContractPreviewState {
  final bool isLoading;
  final String? error;
  final String? htmlContent;
  final String? managerSignatureUrl;
  final String? companyStampUrl;

  ContractPreviewState({
    this.isLoading = false,
    this.error,
    this.htmlContent,
    this.managerSignatureUrl,
    this.companyStampUrl,
  });

  ContractPreviewState copyWith({
    bool? isLoading,
    String? error,
    String? htmlContent,
    String? managerSignatureUrl,
    String? companyStampUrl,
  }) {
    return ContractPreviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      htmlContent: htmlContent ?? this.htmlContent,
      managerSignatureUrl: managerSignatureUrl ?? this.managerSignatureUrl,
      companyStampUrl: companyStampUrl ?? this.companyStampUrl,
    );
  }
}

class ContractPreviewNotifier extends StateNotifier<ContractPreviewState> {
  final Ref _ref;
  final ApiClient _apiClient = ApiClient();

  ContractPreviewNotifier(this._ref) : super(ContractPreviewState());

  void setHtmlContent(String html) {
    state = state.copyWith(htmlContent: html, isLoading: false, error: null);
  }

  Future<void> fetchPreview() async {
    final rentalState = _ref.read(rentalProvider);
    final serviceId = rentalState.serviceId;

    if (serviceId == null) {
      state = state.copyWith(error: "الخدمة غير محددة");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.dio.get(
        'contracts/template_preview/',
        queryParameters: {
          'service_id': serviceId,
          'contract_type': 'rental',
          'lang': 'ar', // Defaulting to Arabic for preview
          if (rentalState.selectedPackage != null) 'package_id': rentalState.selectedPackage!.id,
          if (rentalState.selectedWorker != null) 'worker_id': rentalState.selectedWorker!.id,
        },
      );

      final data = response.data['data'];
      
      state = state.copyWith(
        isLoading: false,
        htmlContent: data['html'],
        managerSignatureUrl: data['manager_signature'],
        companyStampUrl: data['company_stamp'],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "فشل استرداد العقد: ${e.toString()}",
      );
    }
  }
}

final contractPreviewProvider = StateNotifierProvider<ContractPreviewNotifier, ContractPreviewState>((ref) {
  return ContractPreviewNotifier(ref);
});
