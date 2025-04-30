import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class QuizQuestionController {
  final SQLController _sqlController = SQLController();

  // Insert a new quiz question
  Future<QuizQuestionModel> insertQuizQuestion(QuizQuestionModel quizQuestion) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'quiz_questions',
      quizQuestion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return quizQuestion;
  }

  // Fetch all quiz questions
  Future<List<QuizQuestionModel>> getAllQuizQuestions() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_questions');
    return maps.map((map) => QuizQuestionModel.fromMap(map)).toList();
  }

  // Update an existing quiz question
  Future<int> updateQuizQuestion(QuizQuestionModel quizQuestion) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'quiz_questions',
      quizQuestion.toMap(),
      where: 'id = ?',
      whereArgs: [quizQuestion.id],
    );
  }

  // Delete a quiz question by ID
  Future<int> deleteQuizQuestion(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'quiz_questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
