import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ServiceModel>> getServices({int? categoryId});
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final DioClient _dioClient;

  ServiceRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.categories);
      List<dynamic> rawList = [];
      
      if (response.data['data'] != null) {
        if (response.data['data'] is Map && response.data['data'].containsKey('results')) {
          rawList = response.data['data']['results'];
        } else if (response.data['data'] is List) {
          rawList = response.data['data'];
        }
      }

      return rawList.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<ServiceModel>> getServices({int? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      final response = await _dioClient.dio.get(
        ApiConstants.services,
        queryParameters: queryParams,
      );

      List<dynamic> rawList = [];
      if (response.data['data'] != null) {
        if (response.data['data'] is Map && response.data['data'].containsKey('results')) {
          rawList = response.data['data']['results'];
        } else if (response.data['data'] is List) {
          rawList = response.data['data'];
        }
      }

      return rawList.map((json) => ServiceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}
