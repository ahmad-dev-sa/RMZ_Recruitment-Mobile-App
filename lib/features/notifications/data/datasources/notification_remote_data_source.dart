import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';
import '../models/notifications_response_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications();
  Future<NotificationModel> markAsRead(String id);
  Future<bool> markAllAsRead();
  Future<bool> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<NotificationsResponseModel> getNotifications() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.notifications);
      final data = response.data['data'] ?? {};
      return NotificationsResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NotificationModel> markAsRead(String id) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.notifications}$id/read/',
      );
      
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
        '${ApiConstants.notifications}read-all/',
      );
      
      return response.data['success'] == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _dioClient.dio.delete(
        '${ApiConstants.notifications}$id/',
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
