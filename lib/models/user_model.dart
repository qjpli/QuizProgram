import 'dart:convert';

class UserFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String username = 'username';
  static const String password = 'password';
  static const String createdAt = 'created_at';
}

class UserModel {
  final String id;
  final String name;
  final String username;
  final String password;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[UserFields.id] as String? ?? '',
      name: map[UserFields.name] as String? ?? '',
      username: map[UserFields.username] as String? ?? '',
      password: map[UserFields.password] as String? ?? '',
      createdAt: map[UserFields.createdAt] != null
          ? DateTime.tryParse(map[UserFields.createdAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserFields.id: id,
      UserFields.name: name,
      UserFields.username: username,
      UserFields.password: password,
      UserFields.createdAt: createdAt?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
