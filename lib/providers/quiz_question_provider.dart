import 'package:flutter/material.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/controllers/quiz_question_controller.dart';

class QuizQuestionProvider extends ChangeNotifier {
  final QuizQuestionController _quizQuestionController = QuizQuestionController();

  List<QuizQuestionModel> _quizQuestions = [];

  List<QuizQuestionModel> get quizQuestions => _quizQuestions;

  QuizQuestionProvider() {
    getAllQuizQuestions();
  }

  Future<void> getAllQuizQuestions() async {
    _quizQuestions = await _quizQuestionController.getAllQuizQuestions();
    notifyListeners();
  }

  Future<void> addQuizQuestion(QuizQuestionModel quizQuestion) async {
    await _quizQuestionController.insertQuizQuestion(quizQuestion);

    await getAllQuizQuestions();
  }

  Future<void> updateQuizQuestion(QuizQuestionModel quizQuestion) async {
    await _quizQuestionController.updateQuizQuestion(quizQuestion);

    await getAllQuizQuestions();
  }

  Future<void> deleteQuizQuestion(String id) async {
    await _quizQuestionController.deleteQuizQuestion(id);
    await getAllQuizQuestions();
  }
}
