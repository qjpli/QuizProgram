import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class QuizController {
  final SQLController _sqlController = SQLController();

  // Insert a new quiz
  Future<QuizModel> insertQuiz(QuizModel quiz) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'quizzes',
      quiz.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return quiz;
  }

  // Fetch all quizzes
  Future<List<QuizModel>> getAllQuizzes() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quizzes');
    return maps.map((map) => QuizModel.fromMap(map)).toList();
  }

  // Update an existing quiz
  Future<int> updateQuiz(QuizModel quiz) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'quizzes',
      quiz.toMap(),
      where: 'id = ?',
      whereArgs: [quiz.id],
    );
  }

  // Delete a quiz by ID
  Future<int> deleteQuiz(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'quizzes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
