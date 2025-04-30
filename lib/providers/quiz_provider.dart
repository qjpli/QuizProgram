import 'package:flutter/material.dart';
import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/controllers/quiz_controller.dart';

class QuizProvider extends ChangeNotifier {
  final QuizController _quizController = QuizController();

  List<QuizModel> _quizzes = [];

  List<QuizModel> get quizzes => _quizzes;

  QuizProvider() {
    getAllQuizzes();
  }

  // Fetch all quizzes
  Future<void> getAllQuizzes() async {
    _quizzes = await _quizController.getAllQuizzes();
    notifyListeners();
  }

  // Add a new quiz
  Future<void> addQuiz(QuizModel quiz) async {
    await _quizController.insertQuiz(quiz);
    await getAllQuizzes(); // Refresh list
  }

  // Update an existing quiz
  Future<void> updateQuiz(QuizModel quiz) async {
    await _quizController.updateQuiz(quiz);
    await getAllQuizzes(); // Refresh list
  }

  // Delete a quiz
  Future<void> deleteQuiz(String id) async {
    await _quizController.deleteQuiz(id);
    await getAllQuizzes(); // Refresh list
  }
}
