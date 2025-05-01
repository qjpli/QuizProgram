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
  Map<String, String?> _correctChoices = {};

  QuizModel? get quiz => _quiz;
  List<QuizQuestionModel> get questions => _questions;
  List<QuizQuestionChoiceModel> get choices => _choices;

  String? getSelectedChoiceId(String questionId) {
    return _correctChoices[questionId];
  }

  void setCorrectChoice(String questionId, String? choiceId) {
    // Debugging: Print the initial state
    print('Setting correct choice for question $questionId to choice $choiceId');

    // Step 1: Update the correct choice map for this question
    final previousCorrectChoiceId = _correctChoices[questionId];

    // Debugging: Print the previous correct choice
    print('Previous correct choice for question $questionId: $previousCorrectChoiceId');

    // Step 2: Find the index of the previous correct choice in the _choices list
    if (previousCorrectChoiceId != null) {
      final previousIndex = _choices.indexWhere((c) => c.id == previousCorrectChoiceId);

      if (previousIndex != -1) {
        // Set the previous correct choice's 'isCorrect' to false
        _choices[previousIndex] = _choices[previousIndex].copyWith(isCorrect: false);

        // Debugging: Print the updated previous choice
        print('Updated previous choice at index $previousIndex to isCorrect: false');
      }
    }

    // Step 3: Update the correct choice map with the new choiceId
    _correctChoices[questionId] = choiceId;

    // Debugging: Print the updated correctChoices map
    print('Updated _correctChoices: $_correctChoices');

    // Step 4: Find the index of the newly selected correct choice
    final index = _choices.indexWhere((c) => c.id == choiceId);

    // Debugging: Check if the choice is found
    print('Found choice index: $index');

    if (index != -1) {
      // Step 5: Update the 'isCorrect' value for the new correct choice
      _choices[index] = _choices[index].copyWith(isCorrect: true);

      // Debugging: Print the updated choice
      print('Updated choice at index $index to isCorrect: true');
    } else {
      // Debugging: In case no choice was found for the given choiceId
      print('No choice found for choiceId: $choiceId');
    }

    // Step 6: Notify listeners to update the UI
    notifyListeners();

    // Debugging: Confirm that listeners were notified
    print('Listeners notified.');
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
    // Prevent adding duplicate choice values for the same question
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
    notifyListeners();
  }

  void finalizeQuiz() {
    print("Quiz finalized: ${_quiz?.name}");
    resetQuiz();
  }
}
