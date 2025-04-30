import 'dart:convert';

class QuizQuestionFields {
  static const String id = 'id';
  static const String quizId = 'quiz_id';
  static const String question = 'question';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class QuizQuestionModel {
  final String id;
  final String quizId;
  final String question;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuizQuestionModel({
    required this.id,
    required this.quizId,
    required this.question,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    return QuizQuestionModel(
      id: map[QuizQuestionFields.id] ?? '',
      quizId: map[QuizQuestionFields.quizId] ?? '',
      question: map[QuizQuestionFields.question] ?? '',
      createdAt: map[QuizQuestionFields.createdAt] != null
          ? DateTime.tryParse(map[QuizQuestionFields.createdAt])
          : null,
      updatedAt: map[QuizQuestionFields.updatedAt] != null
          ? DateTime.tryParse(map[QuizQuestionFields.updatedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    QuizQuestionFields.id: id,
    QuizQuestionFields.quizId: quizId,
    QuizQuestionFields.question: question,
    QuizQuestionFields.createdAt: createdAt?.toIso8601String(),
    QuizQuestionFields.updatedAt: updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());

  factory QuizQuestionModel.fromJson(String source) =>
      QuizQuestionModel.fromMap(json.decode(source));
}
