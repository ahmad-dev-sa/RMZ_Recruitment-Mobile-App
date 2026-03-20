import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/banner_model.dart';

abstract class MarketingRemoteDataSource {
  Future<List<BannerModel>> getBanners({String? location});
}

class MarketingRemoteDataSourceImpl implements MarketingRemoteDataSource {
  final DioClient _dioClient;

  MarketingRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<BannerModel>> getBanners({String? location}) async {
    try {
      final queryParams = location != null ? {'location': location} : null;
      final response = await _dioClient.dio.get(
        ApiConstants.banners,
        queryParameters: queryParams,
      );

      // We expect the DRF backend to return a list of banners in 'results' for paginated, or directly as a List.
      // E.g., if there's no pagination, it returns `List`.
      List<dynamic> dataList;
      if (response.data is Map) {
        // Handle custom response wrapper {"success": true, "data": [...]}
        if (response.data['data'] != null && response.data['data'] is List) {
           dataList = response.data['data'] as List<dynamic>;
        } 
        // Handle DRF standard pagination {"results": [...]}
        else if (response.data['results'] != null) {
           dataList = response.data['results'] as List<dynamic>;
        } else {
           throw Exception('Unexpected response format: no data or results array found');
        }
      } else if (response.data is List) {
        dataList = response.data as List<dynamic>;
      } else {
        throw Exception('Unexpected response format');
      }

      return dataList.map((json) => BannerModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load banners: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
