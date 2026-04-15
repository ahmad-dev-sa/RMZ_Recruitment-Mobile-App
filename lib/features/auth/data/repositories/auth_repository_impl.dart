import '../../../../core/storage/secure_storage_helper.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_request_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageHelper _storageHelper;

  AuthRepositoryImpl(this._remoteDataSource, this._storageHelper);

  @override
  Future<UserEntity> login(LoginRequest request) async {
    final responseData = await _remoteDataSource.login(request);
    
    // Save tokens if present in response
    if (responseData.containsKey('access')) {
      await _storageHelper.saveAccessToken(responseData['access']);
    }
    if (responseData.containsKey('refresh')) {
      await _storageHelper.saveRefreshToken(responseData['refresh']);
    }

    // Either Django returns user object in login response, or we fetch it.
    // If your API returns the user in login payload:
    // return UserModel.fromJson(responseData['user']);
    // Otherwise fallback to fetching the profile manually right after login:
    return await _remoteDataSource.getUserProfile();
  }

  @override
  Future<UserEntity> register(RegisterRequest request) async {
    final responseData = await _remoteDataSource.register(request);
    
    // Assuming backend returns token automatically upon Register
    // If not, we might need to route user to login. Usually it returns tokens:
    if (responseData.containsKey('access')) {
      await _storageHelper.saveAccessToken(responseData['access']);
    }
    if (responseData.containsKey('refresh')) {
      await _storageHelper.saveRefreshToken(responseData['refresh']);
    }

    return await _remoteDataSource.getUserProfile();
  }

  @override
  Future<UserEntity> getUserProfile() async {
    return await _remoteDataSource.getUserProfile();
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> data) async {
    return await _remoteDataSource.updateProfile(data);
  }

  @override
  Future<void> changePassword(String newPassword, String confirmPassword) async {
    return await _remoteDataSource.changePassword(newPassword, confirmPassword);
  }

  @override
  Future<void> deactivateAccount() async {
    await _remoteDataSource.deactivateAccount();
    await logout();
  }

  @override
  Future<void> logout() async {
    await _storageHelper.clearAuthData();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storageHelper.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
