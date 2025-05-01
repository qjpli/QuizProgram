import 'dart:convert';

class QuizFields {
  static const String id = 'id';
  static const String quizCategoryId = 'quiz_category_id';
  static const String createdBy = 'created_by';
  static const String name = 'name';
  static const String description = 'description';
  static const String difficulty = 'difficulty';
  static const String totalTakers = 'total_takers';
  static const String isAvailable = 'is_available';
  static const String maxTimePerQuestion = 'max_time_per_question';
  static const String randomizeQuestion = 'randomize_question';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class QuizModel {
  final String id;
  final String quizCategoryId;
  final String createdBy;
  final String name;
  final String description;
  final String difficulty;
  final int totalTakers;
  final bool isAvailable;
  final int maxTimePerQuestion;
  final bool randomizeQuestion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuizModel({
    required this.id,
    required this.quizCategoryId,
    required this.createdBy,
    required this.name,
    required this.description,
    required this.difficulty,
    this.totalTakers = 0,
    required this.isAvailable,
    required this.maxTimePerQuestion,
    required this.randomizeQuestion,
    this.createdAt,
    this.updatedAt,
  });

  QuizModel copyWith({
    String? id,
    String? quizCategoryId,
    String? createdBy,
    String? name,
    String? description,
    String? difficulty,
    int? totalTakers,
    bool? isAvailable,
    int? maxTimePerQuestion,
    bool? randomizeQuestion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      quizCategoryId: quizCategoryId ?? this.quizCategoryId,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      totalTakers: totalTakers ?? this.totalTakers,
      isAvailable: isAvailable ?? this.isAvailable,
      maxTimePerQuestion: maxTimePerQuestion ?? this.maxTimePerQuestion,
      randomizeQuestion: randomizeQuestion ?? this.randomizeQuestion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map[QuizFields.id] ?? '',
      quizCategoryId: map[QuizFields.quizCategoryId] ?? '',
      createdBy: map[QuizFields.createdBy] ?? '',
      name: map[QuizFields.name] ?? '',
      description: map[QuizFields.description] ?? '',
      difficulty: map[QuizFields.difficulty] ?? '',
      totalTakers: map[QuizFields.totalTakers] ?? 0,
      isAvailable: map[QuizFields.isAvailable] == 1 ? true : false,
      maxTimePerQuestion: map[QuizFields.maxTimePerQuestion] ?? 0,
      randomizeQuestion: map[QuizFields.randomizeQuestion] == 1 ? true : false,
      createdAt: map[QuizFields.createdAt] != null
          ? DateTime.tryParse(map[QuizFields.createdAt])
          : null,
      updatedAt: map[QuizFields.updatedAt] != null
          ? DateTime.tryParse(map[QuizFields.updatedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    QuizFields.id: id,
    QuizFields.quizCategoryId: quizCategoryId,
    QuizFields.createdBy: createdBy,
    QuizFields.name: name,
    QuizFields.description: description,
    QuizFields.difficulty: difficulty,
    QuizFields.totalTakers: totalTakers,
    QuizFields.isAvailable: isAvailable == true ? 1 : 0,
    QuizFields.maxTimePerQuestion: maxTimePerQuestion,
    QuizFields.randomizeQuestion: randomizeQuestion == true ? 1 : 0,
    QuizFields.createdAt: createdAt?.toIso8601String(),
    QuizFields.updatedAt: updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());

  factory QuizModel.fromJson(String source) =>
      QuizModel.fromMap(json.decode(source));
}
