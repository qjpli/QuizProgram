import 'dart:convert';

class QuizTakerFields {
  static const String id = 'id';
  static const String quizId = 'quiz_id';
  static const String userId = 'user_id';
  static const String displayname = 'displayname';
  static const String avatarUsed = 'avatar_used';
  static const String points = 'points';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class QuizTakerModel {
  final String id;
  final String quizId;
  final String userId;
  final String displayname;
  final String avatarUsed;
  final double points;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuizTakerModel({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.displayname,
    required this.avatarUsed,
    required this.points,
    this.createdAt,
    this.updatedAt,
  });

  factory QuizTakerModel.fromMap(Map<String, dynamic> map) {
    return QuizTakerModel(
      id: map[QuizTakerFields.id] ?? '',
      quizId: map[QuizTakerFields.quizId] ?? '',
      userId: map[QuizTakerFields.userId] ?? '',
      displayname: map[QuizTakerFields.displayname] ?? '',
      avatarUsed: map[QuizTakerFields.avatarUsed] ?? '',
      points: (map[QuizTakerFields.points] ?? 0).toDouble(),
      createdAt: map[QuizTakerFields.createdAt] != null
          ? DateTime.tryParse(map[QuizTakerFields.createdAt])
          : null,
      updatedAt: map[QuizTakerFields.updatedAt] != null
          ? DateTime.tryParse(map[QuizTakerFields.updatedAt])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    QuizTakerFields.id: id,
    QuizTakerFields.quizId: quizId,
    QuizTakerFields.userId: userId,
    QuizTakerFields.displayname: displayname,
    QuizTakerFields.avatarUsed: avatarUsed,
    QuizTakerFields.points: points,
    QuizTakerFields.createdAt: createdAt?.toIso8601String(),
    QuizTakerFields.updatedAt: updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());

  factory QuizTakerModel.fromJson(String source) =>
      QuizTakerModel.fromMap(json.decode(source));
}
