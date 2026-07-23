import 'dart:convert';
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

  Map<String, dynamic> _parseData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    throw Exception('Invalid response format received from server.');
  }

  Future<ProfileModel> fetchProfile() async {
    try {
      final response = await _dio.get('/api/profiles/me/');
      return ProfileModel.fromJson(_parseData(response.data));
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Failed to fetch profile.'));
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await _dio.put('/api/profiles/me/', data: profile.toJson());
      return ProfileModel.fromJson(_parseData(response.data));
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e.response?.data, 'Failed to update profile.'));
    }
  }
}

