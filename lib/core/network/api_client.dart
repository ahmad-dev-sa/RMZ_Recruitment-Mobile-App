import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String baseUrl = 'https://rmz-test.anafannan.cloud/api/v1/'; // TODO: Replace with actual Django API URL

  final Dio _dio;

  ApiClient() : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TODO: Fetch token from flutter_secure_storage and attach here
          // final token = await secureStorage.read(key: 'token');
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }

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
          }
          
          // TODO: Handle 401 Unauthorized (Refresh Token Logic)

          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
