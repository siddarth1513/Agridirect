import 'package:dio/dio.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  String _extractErrorMessage(dynamic data, String fallback) {
    if (data is Map && data.containsKey('detail')) {
      return data['detail'].toString();
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return fallback;
  }

  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await _dio.get('/api/profiles/me/');
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Failed to fetch profile.'));
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await _dio.put('/api/profiles/me/', data: profile.toJson());
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Failed to update profile.'));
    }
  }
}

