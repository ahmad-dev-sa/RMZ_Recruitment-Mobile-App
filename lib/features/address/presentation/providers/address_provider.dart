import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../data/models/address_model.dart';
import 'address_state.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AddressRepositoryImpl(apiClient: apiClient);
});

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  final repository = ref.read(addressRepositoryProvider);
  return AddressNotifier(repository)..fetchAddresses();
});

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressRepository _repository;

  AddressNotifier(this._repository) : super(const AddressState());

  Future<void> fetchAddresses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final addresses = await _repository.getAddresses();
      
      // Enforce single primary address locally
      bool foundPrimary = false;
      final List<AddressEntity> cleanedAddresses = [];
      for (var a in addresses) {
        if (a.isPrimary) {
          if (!foundPrimary) {
            foundPrimary = true;
            cleanedAddresses.add(a);
          } else {
            cleanedAddresses.add(AddressModel(
              id: a.id,
              fullName: a.fullName,
              addressName: a.addressName,
              phone: a.phone,
              city: a.city,
              region: a.region,
              street: a.street,
              postalCode: a.postalCode,
              details: a.details,
              isPrimary: false,
            ));
          }
        } else {
          cleanedAddresses.add(a);
        }
      }
      
      state = state.copyWith(isLoading: false, addresses: cleanedAddresses);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> addAddress(Map<String, dynamic> data) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final newAddress = await _repository.addAddress(data);
      
      if (newAddress.isPrimary || data['is_primary'] == true || data['is_default'] == true) {
        try {
          // Force backend to unset others
          await _repository.setPrimaryAddress(newAddress.id);
        } catch (_) {}
      }
      
      state = state.copyWith(isSaving: false);
      await fetchAddresses(); // Re-fetch to get consistent state
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'فشل في حفظ العنوان');
      return false;
    }
  }

  Future<bool> updateAddress(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      await _repository.updateAddress(id, data);
      
      if (data['is_primary'] == true || data['is_default'] == true) {
        try {
          await _repository.setPrimaryAddress(id);
        } catch (_) {}
      }
      
      state = state.copyWith(isSaving: false);
      await fetchAddresses(); // Re-fetch to get consistent state
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'فشل في تحديث العنوان');
      return false;
    }
  }

  Future<void> deleteAddress(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.deleteAddress(id);
      await fetchAddresses();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل في حذف العنوان');
    }
  }

  Future<void> setPrimary(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.setPrimaryAddress(id);
      await fetchAddresses();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل تعيين العنوان كأفتراضي');
    }
  }
}
