import 'package:quizprogram/models/quiz_category_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class QuizCategoryController {
  final SQLController _sqlController = SQLController();

  // Insert a new quiz category
  Future<QuizCategoryModel> insertQuizCategory(QuizCategoryModel quizCategory) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'quiz_categories',
      quizCategory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return quizCategory;
  }

  // Fetch all quiz categories
  Future<List<QuizCategoryModel>> getAllQuizCategories() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_categories');
    return maps.map((map) => QuizCategoryModel.fromMap(map)).toList();
  }

  // Update an existing quiz category
  Future<int> updateQuizCategory(QuizCategoryModel quizCategory) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'quiz_categories',
      quizCategory.toMap(),
      where: 'id = ?',
      whereArgs: [quizCategory.id],
    );
  }

  // Delete a quiz category by ID
  Future<int> deleteQuizCategory(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'quiz_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
