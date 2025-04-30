import 'package:quizprogram/models/quiz_question_choice_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class QuizQuestionChoiceController {
  final SQLController _sqlController = SQLController();

  // Insert a new quiz question choice
  Future<QuizQuestionChoiceModel> insertQuizQuestionChoice(QuizQuestionChoiceModel choice) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'quiz_question_choices',
      choice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return choice;
  }

  // Fetch all quiz question choices
  Future<List<QuizQuestionChoiceModel>> getAllQuizQuestionChoices() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_question_choices');
    return maps.map((map) => QuizQuestionChoiceModel.fromMap(map)).toList();
  }

  // Fetch all quiz question choices
  Future<List<QuizQuestionChoiceModel>> getAllQuizQuestionChoicesForQuestion(String questionId) async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('quiz_question_choices', where: 'id = ?', whereArgs: [questionId]);
    return maps.map((map) => QuizQuestionChoiceModel.fromMap(map)).toList();
  }

  // Update an existing quiz question choice
  Future<int> updateQuizQuestionChoice(QuizQuestionChoiceModel choice) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'quiz_question_choices',
      choice.toMap(),
      where: 'id = ?',
      whereArgs: [choice.id],
    );
  }

  // Delete a quiz question choice by ID
  Future<int> deleteQuizQuestionChoice(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'quiz_question_choices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
