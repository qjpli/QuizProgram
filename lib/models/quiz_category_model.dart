import 'dart:convert';

class QuizCategoryFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String isAvailable = 'is_available';
  static const String svgIcon = 'svg_icon';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class QuizCategoryModel {
  final String id;
  final String name;
  final bool isAvailable;
  final String svgIcon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuizCategoryModel({
    required this.id,
    required this.name,
    required this.isAvailable,
    required this.svgIcon,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizCategoryModel.fromMap(Map<String, dynamic> map) {
    return QuizCategoryModel(
      id: map[QuizCategoryFields.id] ?? '',
      name: map[QuizCategoryFields.name] ?? '',
      isAvailable: map[QuizCategoryFields.isAvailable] == 1 ? true : false,
      svgIcon: map[QuizCategoryFields.svgIcon] ?? '',
      createdAt: map[QuizCategoryFields.createdAt] != null
          ? DateTime.tryParse(map[QuizCategoryFields.createdAt])
          : null,
      updatedAt: map[QuizCategoryFields.updatedAt] != null
          ? DateTime.tryParse(map[QuizCategoryFields.updatedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    QuizCategoryFields.id: id,
    QuizCategoryFields.name: name,
    QuizCategoryFields.isAvailable: isAvailable ? 1 : 0, // Convert bool to int
    QuizCategoryFields.svgIcon: svgIcon,
    QuizCategoryFields.createdAt: createdAt?.toIso8601String(),
    QuizCategoryFields.updatedAt: updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());

  factory QuizCategoryModel.fromJson(String source) =>
      QuizCategoryModel.fromMap(json.decode(source));
}
