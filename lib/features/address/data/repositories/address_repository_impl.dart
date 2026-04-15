import '../../../../core/network/api_client.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../models/address_model.dart';
import 'package:dio/dio.dart';

class AddressRepositoryImpl implements AddressRepository {
  final ApiClient apiClient;

  AddressRepositoryImpl({required this.apiClient});

  @override
  Future<List<AddressEntity>> getAddresses() async {
    try {
      final response = await apiClient.dio.get('addresses/');
      
      // Handle both paginated and non-paginated DRF responses
      final data = response.data;
      final List results = (data is Map && data.containsKey('results')) 
          ? data['results'] 
          : data as List;
          
      return results.map((e) => AddressModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch addresses: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch addresses');
    }
  }

  @override
  Future<AddressEntity> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await apiClient.dio.post('addresses/', data: addressData);
      return AddressModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to add address: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to add address');
    }
  }

  @override
  Future<AddressEntity> updateAddress(String id, Map<String, dynamic> addressData) async {
    try {
      final response = await apiClient.dio.patch('addresses/$id/', data: addressData);
      return AddressModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update address: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update address');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await apiClient.dio.delete('addresses/$id/');
    } on DioException catch (e) {
      throw Exception('Failed to delete address: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete address');
    }
  }

  @override
  Future<AddressEntity> setPrimaryAddress(String id) async {
    try {
      final response = await apiClient.dio.post('addresses/$id/make-default/');
      return AddressModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to set primary address: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to set primary address');
    }
  }
}
