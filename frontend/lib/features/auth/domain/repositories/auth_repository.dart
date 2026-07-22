import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<void> register({
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}


