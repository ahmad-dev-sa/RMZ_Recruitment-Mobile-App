import '../entities/address_entity.dart';

abstract class AddressRepository {
  Future<List<AddressEntity>> getAddresses();
  Future<AddressEntity> addAddress(Map<String, dynamic> addressData);
  Future<AddressEntity> updateAddress(String id, Map<String, dynamic> addressData);
  Future<void> deleteAddress(String id);
  Future<AddressEntity> setPrimaryAddress(String id);
}
