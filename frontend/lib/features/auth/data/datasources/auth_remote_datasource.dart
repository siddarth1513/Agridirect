import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  String _extractErrorMessage(dynamic data, String fallback) {
    if (data is Map) {
      if (data.containsKey('detail')) return data['detail'].toString();
      if (data.containsKey('non_field_errors') && data['non_field_errors'] is List && (data['non_field_errors'] as List).isNotEmpty) {
        return data['non_field_errors'][0].toString();
      }
      for (final entry in data.entries) {
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          return '${entry.key}: ${val[0]}';
        } else if (val is String && val.isNotEmpty) {
          return '${entry.key}: $val';
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return fallback;
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/api/auth/login/', data: {
        'username': email,
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Login failed. Please check your email and password.'));
    }
  }


  Future<void> register({
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
  }) async {
    try {
      await _dio.post('/api/auth/register/', data: {
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
        'role': role,
      });
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Registration failed. Please check your details.'));
    }
  }


  Future<UserModel> fetchProfile() async {
    try {
      final response = await _dio.get('/api/profiles/me/');
      // The profile API response embeds User details under 'user' key.
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Failed to fetch user profile.'));
    }
  }
}

