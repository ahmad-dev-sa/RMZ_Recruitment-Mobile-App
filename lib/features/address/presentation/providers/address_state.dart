import '../../domain/entities/address_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_state.freezed.dart';

@freezed
class AddressState with _$AddressState {
  const factory AddressState({
    @Default([]) List<AddressEntity> addresses,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _AddressState;

  const AddressState._();

  AddressEntity? get primaryAddress {
    if (addresses.isEmpty) return null;
    try {
      return addresses.firstWhere((a) => a.isPrimary);
    } catch (_) {
      return addresses.first;
    }
  }
}
