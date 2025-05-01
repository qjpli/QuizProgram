import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:uuid/uuid.dart';

class CreateQuizProvider with ChangeNotifier {
  QuizModel? _quiz;
  final List<QuizQuestionModel> _questions = [];
  final List<QuizQuestionChoiceModel> _choices = [];

  QuizModel? get quiz => _quiz;
  List<QuizQuestionModel> get questions => _questions;
  List<QuizQuestionChoiceModel> get choices => _choices;

  void setQuizMetadata({
    required String quizCategoryId,
    required String name,
    required String description,
    required String difficulty,
    required int maxTimePerQuestion,
    required bool randomizeQuestion,
  }) {
    final authUserProvider = Provider.of<AuthUserProvider>(Get.context as BuildContext, listen: false);

    _quiz = QuizModel(
      id: Uuid().v4(),
      quizCategoryId: quizCategoryId,
      createdBy: authUserProvider.authUser?.id ?? '',
      name: name,
      description: description,
      difficulty: difficulty,
      totalTakers: 0,
      isAvailable: true,
      maxTimePerQuestion: maxTimePerQuestion,
      randomizeQuestion: randomizeQuestion,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void addQuestion({
    required String questionText,
  }) {
    final newQuestion = QuizQuestionModel(
      id: Uuid().v4(),
      quizId: _quiz?.id ?? '',
      question: questionText,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _questions.add(newQuestion);
    notifyListeners();
  }

  void updateQuestion({
    required int index,
    required String updatedQuestionText,
  }) {
    if (index >= 0 && index < _questions.length) {
      _questions[index] = _questions[index].copyWith(
        question: updatedQuestionText,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void removeQuestion({
    required int index,
  }) {
    if (index >= 0 && index < _questions.length) {
      _questions.removeAt(index);
      notifyListeners();
    }
  }

  void addChoiceForQuestion({
    required int questionIndex,
    required String choiceValue,
    required bool isCorrect,
  }) {
    if (questionIndex >= 0 && questionIndex < _questions.length) {
      final newChoice = QuizQuestionChoiceModel(
        id: Uuid().v4(),
        quizQuestionId: _questions[questionIndex].id,
        value: choiceValue,
        isCorrect: isCorrect,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _choices.add(newChoice);
      notifyListeners();
    }
  }

  void removeChoice({
    required int index,
  }) {
    if (index >= 0 && index < _choices.length) {
      _choices.removeAt(index);
      notifyListeners();
    }
  }

  void resetQuiz() {
    _quiz = null;
    _questions.clear();
    _choices.clear();
    notifyListeners();
  }

  void finalizeQuiz() {
    print("Quiz finalized: ${_quiz?.name}");
    resetQuiz();
  }
}
