import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/controllers/quiz_controller.dart';

import 'auth_user_provider.dart';

class QuizProvider extends ChangeNotifier {
  final QuizController _quizController = QuizController();

  List<QuizModel> _quizzes = [];

  List<QuizModel> get quizzes => _quizzes;

  QuizProvider() {
    getAllQuizzes();
    fetchQuizzesForUser();
  }

  Future<void> fetchQuizzesForUser() async {
    final authUserProvider = Provider.of<AuthUserProvider>(Get.context as BuildContext, listen: false);

    final userId = authUserProvider.authUser?.id ?? '';

    // Fetch all quizzes
    List<QuizModel> allQuizzes = await _quizController.getAllQuizzes();

    // Filter based on createdBy id
    _quizzes = allQuizzes.where((quiz) => quiz.createdBy == userId).toList();

    notifyListeners();
  }

  // Fetch all quizzes
  Future<void> getAllQuizzes() async {
    _quizzes = await _quizController.getAllQuizzes();
    notifyListeners();
  }

  Future<void> addQuiz(QuizModel quiz) async {
    await _quizController.insertQuiz(quiz);
    await getAllQuizzes();
  }

  Future<void> updateQuiz(QuizModel quiz) async {
    await _quizController.updateQuiz(quiz);
    await getAllQuizzes();
  }

  Future<void> deleteQuiz(String id) async {
    await _quizController.deleteQuiz(id);
    await getAllQuizzes();
  }
}
