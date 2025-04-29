import 'dart:convert';

class UserFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String createdAt = 'created_at';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt, // Optional
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[UserFields.id] as String? ?? '',
      name: map[UserFields.name] as String? ?? '',
      email: map[UserFields.email] as String? ?? '',
      createdAt: map[UserFields.createdAt] != null
          ? DateTime.tryParse(map[UserFields.createdAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserFields.id: id,
      UserFields.name: name,
      UserFields.email: email,
      UserFields.createdAt: createdAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
