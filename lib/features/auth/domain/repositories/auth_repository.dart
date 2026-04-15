import '../entities/user_entity.dart';
import '../../data/models/auth_request_models.dart';

abstract class AuthRepository {
  Future<UserEntity> login(LoginRequest request);
  Future<UserEntity> register(RegisterRequest request);
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String newPassword, String confirmPassword);
  Future<void> deactivateAccount();
  Future<void> logout();
  Future<bool> isAuthenticated();
}
