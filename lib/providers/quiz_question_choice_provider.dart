import 'package:flutter/material.dart';
import 'package:quizprogram/controllers/quiz_question_choice_controller.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';

class QuizQuestionChoiceProvider extends ChangeNotifier {
  final QuizQuestionChoiceController _quizQuestionChoiceController = QuizQuestionChoiceController();

  List<QuizQuestionChoiceModel> _choices = [];
  List<QuizQuestionChoiceModel> get choices => _choices;

  QuizQuestionChoiceProvider() {
    fetchAllChoices();
  }

  Future<void> fetchAllChoices() async {
    _choices = await _quizQuestionChoiceController.getAllQuizQuestionChoices();
    notifyListeners();
  }

  Future<void> fetchChoices(String questionId) async {
    _choices = await _quizQuestionChoiceController.getAllQuizQuestionChoicesForQuestion(questionId);
    notifyListeners();
  }

  Future<void> addChoice(QuizQuestionChoiceModel choice) async {
    await _quizQuestionChoiceController.insertQuizQuestionChoice(choice);
    _choices.add(choice);

    notifyListeners();
    await fetchAllChoices();
  }

  Future<void> updateChoice(QuizQuestionChoiceModel updatedChoice) async {
    await _quizQuestionChoiceController.updateQuizQuestionChoice(updatedChoice);
    int index = _choices.indexWhere((choice) => choice.id == updatedChoice.id);
    if (index != -1) {
      _choices[index] = updatedChoice;
      notifyListeners();
    }
  }

  // Delete a choice by ID
  Future<void> deleteChoice(String id) async {
    await _quizQuestionChoiceController.deleteQuizQuestionChoice(id);
    _choices.removeWhere((choice) => choice.id == id);
    notifyListeners();
  }
}
