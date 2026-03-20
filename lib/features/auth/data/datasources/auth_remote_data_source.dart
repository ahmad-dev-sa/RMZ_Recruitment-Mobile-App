import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_request_models.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(LoginRequest request);
  Future<Map<String, dynamic>> register(RegisterRequest request);
  Future<UserModel> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return response.data; // Expected { "access": "...", "refresh": "...", "user": {...} }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      return response.data; // Expected access, refresh tokens
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        // Checking for common registration unique constraint violations
        if (data.containsKey('email') || data.containsKey('phone_number') || data.containsKey('id_number') || data.containsKey('first_name')) {
           return Exception('هذا البريد الإلكتروني أو رقم الجوال أو رقم الهوية مستخدم بالفعل، الرجاء اختيار بيانات أخرى.');
        }
        
        // Return first error message
        final firstValue = data.values.firstOrNull;
        if (firstValue is List && firstValue.isNotEmpty) {
           return Exception(firstValue.first.toString());
        }
        return Exception(firstValue?.toString() ?? 'Unknown server error');
      }
      return Exception('Server error: ${error.response?.statusCode}');
    } else {
      return Exception('Network or connection error. Please try again.');
    }
  }
}
