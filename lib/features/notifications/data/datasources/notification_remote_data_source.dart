import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({bool? isRead});
  Future<NotificationModel> markAsRead(String id);
  Future<bool> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<NotificationModel>> getNotifications({bool? isRead}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (isRead != null) {
        queryParams['is_read'] = isRead;
      }

      final response = await _dioClient.dio.get(
        ApiConstants.notifications,
        queryParameters: queryParams,
      );

      // Backend wraps data in ApiResponse.success(data=response.data)
      // which results in {"success": true, "data": {"count": X, "results": [...]}} 
      // or {"success": true, "data": [...]} if no pagination is active.
      
      List<dynamic> rawList = [];
      if (response.data['data'] != null) {
        if (response.data['data'] is Map && response.data['data'].containsKey('results')) {
          rawList = response.data['data']['results'];
        } else if (response.data['data'] is List) {
           rawList = response.data['data'];
        }
      }

      return rawList.map((json) => NotificationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NotificationModel> markAsRead(String id) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.notifications}$id/mark-read/',
      );
      
      // Backend returns ApiResponse.success(data=serializer.data)
      final data = response.data['data'] ?? {};
      return NotificationModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> markAllAsRead() async {
     try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.notifications}mark-all-read/',
      );
      
      return response.data['success'] == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('message')) {
        return Exception(data['message']);
      }
    }
    return Exception('حدث خطأ في جلب الإشعارات');
  }
}
