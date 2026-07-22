import '../../../auth/data/models/user_model.dart';

class ProfileModel {
  final int id;
  final UserModel user;
  final String farmName; // Only for farmers
  final String farmAddress; // Only for farmers
  final String deliveryAddress; // Only for buyers
  final double? latitude;
  final double? longitude;
  final double rating;
  final List<String> images;

  ProfileModel({
    required this.id,
    required this.user,
    this.farmName = '',
    this.farmAddress = '',
    this.deliveryAddress = '',
    this.latitude,
    this.longitude,
    required this.rating,
    this.images = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(userMap);
    
    final imagesList = json['images'] as List?;
    final imagesUrls = imagesList != null 
      ? imagesList.map((img) => img['image'] as String).toList()
      : <String>[];

    return ProfileModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      user: user,
      farmName: json['farm_name'] ?? '',
      farmAddress: json['farm_address'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 5.0,
      images: imagesUrls,
    );
  }

  Map<String, dynamic> toJson() {
    if (user.role == 'FARMER') {
      return {
        'farm_name': farmName,
        'farm_address': farmAddress,
        'latitude': latitude,
        'longitude': longitude,
      };
    } else {
      return {
        'delivery_address': deliveryAddress,
        'latitude': latitude,
        'longitude': longitude,
      };
    }
  }
}
