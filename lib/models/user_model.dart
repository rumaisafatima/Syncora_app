// lib/models/user_model.dart

import '../enums/app_enums.dart';

class UserModel {
  final String fullName;
  final String email;
  final Gender gender;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.gender,
  });

  String get firstName => fullName.trim().split(' ').first;

  String get initials {
    final parts = fullName.trim().split(' ').where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'email': email,
        'gender': gender.name,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        fullName: map['fullName'] as String,
        email: map['email'] as String,
        gender: Gender.values.firstWhere(
          (g) => g.name == map['gender'],
          orElse: () => Gender.preferNotToSay,
        ),
      );
}
