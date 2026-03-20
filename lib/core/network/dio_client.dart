import 'package:dio/dio.dart';
import '../../features/auth/presentation/providers/auth_provider.dart'; // We will use this to trigger logout
import 'api_constants.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage_helper.dart';

class DioClient {
  late final Dio _dio;

  DioClient(SecureStorageHelper storageHelper) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
    _dio.interceptors.add(AuthInterceptor(_dio, storageHelper));
  }

  Dio get dio => _dio;
}
