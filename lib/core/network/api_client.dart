import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_helper.dart';
import 'auth_interceptor.dart';

class ApiClient {
  static const String baseUrl = 'https://rmz-test.anafannan.cloud/api/v1/'; // TODO: Replace with actual Django API URL

  final Dio _dio;

  ApiClient() : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    final secureStorage = SecureStorageHelper();
    _dio.interceptors.add(AuthInterceptor(_dio, secureStorage));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Auth interceptor handles tokens now

          // Add Language Header for Django i18n
          // options.headers['Accept-Language'] = 'ar'; // Dynamic based on context

          if (kDebugMode) {
             print('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
             print('<-- ${response.statusCode} ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
             print('<-- Error ${e.message}');
             if (e.response != null) {
               print('<-- Response Data: ${e.response?.data}');
             }
          }
          
          // Auth interceptor handles 401 now

          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
