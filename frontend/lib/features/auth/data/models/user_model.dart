class UserModel {
  final int id;
  final String email;
  final String phoneNumber;
  final String role; // 'FARMER' or 'BUYER'

  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      email: json['email'] as String,
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
    };
  }
}
