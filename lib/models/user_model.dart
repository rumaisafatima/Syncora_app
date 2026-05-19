// lib/models/user_model.dart

import '../enums/app_enums.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final Gender gender;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final firstChar = firstName.isNotEmpty ? firstName[0] : '';
    final lastChar = lastName.isNotEmpty ? lastName[0] : '';
    if (firstChar.isEmpty && lastChar.isEmpty) return '?';
    return '$firstChar$lastChar'.toUpperCase();
  }

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'gender': gender.name,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final rawFullName = map['fullName'] as String? ?? '';
    final parts = rawFullName.trim().split(' ').where((w) => w.isNotEmpty).toList();
    final fallbackFirst = parts.isNotEmpty ? parts.first : '';
    final fallbackLast = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return UserModel(
      firstName: map['firstName'] as String? ?? fallbackFirst,
      lastName: map['lastName'] as String? ?? fallbackLast,
      email: map['email'] as String? ?? '',
      gender: Gender.values.firstWhere(
        (g) => g.name == map['gender'],
        orElse: () => Gender.preferNotToSay,
      ),
    );
  }
}
