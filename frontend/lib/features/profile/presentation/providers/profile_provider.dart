import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ProfileRemoteDataSource(dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDS = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDS);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repository.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), stack);
    }
  }

  Future<void> updateProfile({
    String? farmName,
    String? farmAddress,
    String? deliveryAddress,
    double? latitude,
    double? longitude,
  }) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    state = const AsyncValue.loading();
    try {
      final updatedProfileModel = ProfileModel(
        id: currentProfile.id,
        user: currentProfile.user,
        farmName: farmName ?? currentProfile.farmName,
        farmAddress: farmAddress ?? currentProfile.farmAddress,
        deliveryAddress: deliveryAddress ?? currentProfile.deliveryAddress,
        latitude: latitude ?? currentProfile.latitude,
        longitude: longitude ?? currentProfile.longitude,
        rating: currentProfile.rating,
        images: currentProfile.images,
      );

      final updatedProfile = await _repository.updateProfile(updatedProfileModel);
      state = AsyncValue.data(updatedProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e.toString().replaceAll('Exception: ', ''), stack);
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repo);
});
