import 'package:dio/dio.dart';
import '../storage/secure_storage_helper.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageHelper _storageHelper;
  final Dio _dio;

  AuthInterceptor(this._dio, this._storageHelper);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // If the request requires authentication, add the Bearer token
    // Exclude basic auth endpoints to avoid sending tokens unnecessarily
    final bool requiresAuth = !options.path.contains(ApiConstants.login) &&
                              !options.path.contains(ApiConstants.register) &&
                              !options.path.contains(ApiConstants.refresh);

    if (requiresAuth) {
      final token = await _storageHelper.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Attempt Token Refresh if 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final refreshToken = await _storageHelper.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Create a new Dio instance to avoid interceptor loop
          final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
          
          final response = await refreshDio.post(
            ApiConstants.refresh,
            data: {'refresh': refreshToken},
          );

          final newAccessToken = response.data['access'];
          await _storageHelper.saveAccessToken(newAccessToken);

          // Optionally handle rotation if backend rotation is on
          if (response.data['refresh'] != null) {
            await _storageHelper.saveRefreshToken(response.data['refresh']);
          }

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          
          final retryResponse = await _dio.fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh totally failed (expired maybe), should log user out
          await _storageHelper.clearAuthData();
          return handler.reject(err);
        }
      }
    }
    handler.next(err);
  }
}
