import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_request_models.dart';
import 'auth_state.dart';

// 1. Providers for dependencies
final secureStorageProvider = Provider<SecureStorageHelper>((ref) {
  return SecureStorageHelper();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return DioClient(storage);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(remoteDataSource, storage);
});

// 2. StateNotifier to manage AuthState
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final isAuth = await _repository.isAuthenticated();
      if (isAuth) {
        // Fetch user data
        final user = await _repository.getUserProfile();
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      // Token might be expired or network error
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login(String idNumber, String password) async {
    state = const AuthLoading();
    try {
      final request = LoginRequest(idNumber: idNumber, password: password);
      final user = await _repository.login(request);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register({
    required String idNumber,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AuthLoading();
    try {
      final request = RegisterRequest(
        idNumber: idNumber,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      final user = await _repository.register(request);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
  }) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;

    state = const AuthLoading();
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (email != null) data['email'] = email;

      final updatedUser = await _repository.updateProfile(data);
      state = AuthAuthenticated(updatedUser);
    } catch (e) {
      // Revert back on error
      state = currentState;
      throw e;
    }
  }

  Future<void> changePassword(String newPassword, String confirmPassword) async {
    try {
      await _repository.changePassword(newPassword, confirmPassword);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deactivateAccount() async {
    state = const AuthLoading();
    try {
      await _repository.deactivateAccount();
      state = const AuthUnauthenticated();
    } catch (e) {
      // Revert back or throw
      state = const AuthUnauthenticated(); // or leave it unauthenticated anyway since it failed, but probably best to fetch profile again or just throw
      throw e;
    }
  }
}

// 3. Main Auth Provider for the UI
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
