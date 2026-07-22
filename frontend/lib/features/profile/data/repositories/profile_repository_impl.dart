import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProfileModel> getProfile() {
    return _remoteDataSource.fetchProfile();
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) {
    return _remoteDataSource.updateProfile(profile);
  }
}
