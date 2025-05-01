import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/providers/quiz_provider.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/quiz_controller.dart';
import '../../controllers/quiz_question_choice_controller.dart';
import '../../controllers/quiz_question_controller.dart';

class CreateQuizProvider with ChangeNotifier {
  QuizModel? _quiz;
  final List<QuizQuestionModel> _questions = [];
  final List<QuizQuestionChoiceModel> _choices = [];
  Map<String, String?> _correctChoices = {};
  int _noOfQuestions = 0;
  final List<TextEditingController> _questionControllers = [];


  QuizModel? get quiz => _quiz;
  List<QuizQuestionModel> get questions => _questions;
  List<QuizQuestionChoiceModel> get choices => _choices;
  int get noOfQuestions => _noOfQuestions;
  List<TextEditingController> get questionControllers => _questionControllers;

  void setNoOfQuestions(int noOfQuestions) {
    _noOfQuestions = noOfQuestions;
    notifyListeners();
  }

  void addQuestionController() {
    _questionControllers.add(TextEditingController());

    notifyListeners();
  }

  String? getSelectedChoiceId(String questionId) {
    return _correctChoices[questionId];
  }

  void setCorrectChoice(String questionId, String? choiceId) {
    final previousCorrectChoiceId = _correctChoices[questionId];
    if (previousCorrectChoiceId != null) {
      final previousIndex = _choices.indexWhere((c) => c.id == previousCorrectChoiceId);
      if (previousIndex != -1) {
        _choices[previousIndex] = _choices[previousIndex].copyWith(isCorrect: false);
      }
    }
    _correctChoices[questionId] = choiceId;
    final index = _choices.indexWhere((c) => c.id == choiceId);
    if (index != -1) {
      _choices[index] = _choices[index].copyWith(isCorrect: true);
    }
    notifyListeners();
  }

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

  void updateQuizMetadata({
    String? name,
    String? description,
    String? difficulty,
    int? maxTimePerQuestion,
    int? noOfQuestions,
    bool? randomizeQuestion,
    bool? isAvailable,
  }) {
    if (_quiz != null) {
      _quiz = _quiz!.copyWith(
        name: name ?? _quiz!.name,
        description: description ?? _quiz!.description,
        difficulty: difficulty ?? _quiz!.difficulty,
        maxTimePerQuestion: maxTimePerQuestion ?? _quiz!.maxTimePerQuestion,
        randomizeQuestion: randomizeQuestion ?? _quiz!.randomizeQuestion,
        isAvailable: isAvailable ?? _quiz!.isAvailable,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void addQuestion({
    required String questionId,
    required String questionText,
  }) {
    final newQuestion = QuizQuestionModel(
      id: questionId,
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
      final removedQuestion = _questions[index];
      _choices.removeWhere((choice) => choice.quizQuestionId == removedQuestion.id);
      _questions.removeAt(index);
      notifyListeners();
    }
  }

  void addChoiceForQuestion({
    required String choiceId,
    required String questionId,
    required String choiceValue,
    required bool isCorrect,
  }) {
    if (_choices.any((choice) => choice.quizQuestionId == questionId && choice.value == choiceValue)) {
      return;
    }
    final newChoice = QuizQuestionChoiceModel(
      id: choiceId,
      quizQuestionId: questionId,
      value: choiceValue,
      isCorrect: isCorrect,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _choices.add(newChoice);
    notifyListeners();
  }

  void removeChoiceForQuestion({
    required String choiceId,
  }) {
    _choices.removeWhere((choice) => choice.id == choiceId);
    notifyListeners();
  }

  void updateChoiceForQuestion({
    required String questionId,
    required String choiceId,
    required String updatedChoiceValue,
    required bool updatedIsCorrect,
  }) {
    final choiceIndex = _choices.indexWhere((choice) => choice.quizQuestionId == questionId && choice.id == choiceId);
    if (choiceIndex != -1) {
      _choices[choiceIndex] = _choices[choiceIndex].copyWith(
        value: updatedChoiceValue,
        isCorrect: updatedIsCorrect,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void resetQuiz() {
    _quiz = null;
    _questions.clear();
    _choices.clear();
    _correctChoices.clear();
    _noOfQuestions = 0;
    _questionControllers.clear();
    notifyListeners();
  }

  Future<void> finalizeQuiz() async {
    final quizProvider = Provider.of<QuizProvider>(Get.context as BuildContext, listen: false);
    final QuizController quizController = QuizController();
    final QuizQuestionController quizQuestionController = QuizQuestionController();
    final QuizQuestionChoiceController quizQuestionChoiceController = QuizQuestionChoiceController();

    if (_quiz == null) {
      print('Quiz metadata not set.');
      return;
    }

    try {
      await quizController.insertQuiz(_quiz!);

      for (final question in _questions) {
        await quizQuestionController.insertQuizQuestion(question);
        final questionChoices = _choices.where((c) => c.quizQuestionId == question.id);
        for (final choice in questionChoices) {
          await quizQuestionChoiceController.insertQuizQuestionChoice(choice);
        }
      }

      print('Quiz finalized and saved to database.');
      quizProvider.getAllQuizzes();
      resetQuiz();
    } catch (e) {
      print('Error saving quiz: $e');
    }

    notifyListeners();
  }
}
