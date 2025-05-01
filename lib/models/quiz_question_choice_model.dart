import 'dart:convert';

class QuizQuestionChoiceFields {
  static const String id = 'id';
  static const String quizQuestionId = 'quiz_question_id';
  static const String value = 'value';
  static const String isCorrect = 'is_correct';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class QuizQuestionChoiceModel {
  final String id;
  final String quizQuestionId;
  final String value;
  final bool isCorrect;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuizQuestionChoiceModel({
    required this.id,
    required this.quizQuestionId,
    required this.value,
    required this.isCorrect,
    this.createdAt,
    this.updatedAt,
  });

  QuizQuestionChoiceModel copyWith({
    String? id,
    String? quizQuestionId,
    String? value,
    bool? isCorrect,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizQuestionChoiceModel(
      id: id ?? this.id,
      quizQuestionId: quizQuestionId ?? this.quizQuestionId,
      value: value ?? this.value,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory QuizQuestionChoiceModel.fromMap(Map<String, dynamic> map) {
    return QuizQuestionChoiceModel(
      id: map[QuizQuestionChoiceFields.id] ?? '',
      quizQuestionId: map[QuizQuestionChoiceFields.quizQuestionId] ?? '',
      value: map[QuizQuestionChoiceFields.value] ?? '',
      isCorrect: map[QuizQuestionChoiceFields.isCorrect] == '1' ? true : false,
      createdAt: map[QuizQuestionChoiceFields.createdAt] != null
          ? DateTime.tryParse(map[QuizQuestionChoiceFields.createdAt])
          : null,
      updatedAt: map[QuizQuestionChoiceFields.updatedAt] != null
          ? DateTime.tryParse(map[QuizQuestionChoiceFields.updatedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    QuizQuestionChoiceFields.id: id,
    QuizQuestionChoiceFields.quizQuestionId: quizQuestionId,
    QuizQuestionChoiceFields.value: value,
    QuizQuestionChoiceFields.isCorrect: isCorrect == true ? 1 : 0,
    QuizQuestionChoiceFields.createdAt: createdAt?.toIso8601String(),
    QuizQuestionChoiceFields.updatedAt: updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());

  factory QuizQuestionChoiceModel.fromJson(String source) =>
      QuizQuestionChoiceModel.fromMap(json.decode(source));
}
