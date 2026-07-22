import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/storage/secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await _remoteDataSource.login(email: email, password: password);
    final access = response['access'] as String;
    final refresh = response['refresh'] as String;

    await _secureStorage.saveTokens(access: access, refresh: refresh);
    
    // Fetch user profile info, then save role
    final user = await _remoteDataSource.fetchProfile();
    await _secureStorage.saveUserRole(user.role);
    return user;
  }



  @override
  Future<void> register({
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
  }) async {
    await _remoteDataSource.register(
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      role: role,
    );
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final access = await _secureStorage.getAccessToken();
    if (access == null) return null;
    try {
      return await _remoteDataSource.fetchProfile();
    } catch (_) {
      return null;
    }
  }
}
