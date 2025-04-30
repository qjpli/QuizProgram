import 'package:quizprogram/models/quiz_taker_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class QuizTakerController {
  final SQLController _sqlController = SQLController();

  // Insert a new quiz taker
  Future<QuizTakerModel> insertQuizTaker(QuizTakerModel quizTaker) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'quiz_takers',
      quizTaker.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return quizTaker;
  }

  // Fetch all quiz takers
  Future<List<QuizTakerModel>> getAllQuizTakers() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_takers');
    return maps.map((map) => QuizTakerModel.fromMap(map)).toList();
  }

  // Update an existing quiz taker
  Future<int> updateQuizTaker(QuizTakerModel quizTaker) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'quiz_takers',
      quizTaker.toMap(),
      where: 'id = ?',
      whereArgs: [quizTaker.id],
    );
  }

  // Delete a quiz taker by ID
  Future<int> deleteQuizTaker(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'quiz_takers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
