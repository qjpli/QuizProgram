import 'package:flutter/material.dart';
import 'package:quizprogram/controllers/quiz_taker_controller.dart';
import 'package:quizprogram/models/quiz_taker_model.dart';

class QuizTakerProvider extends ChangeNotifier {
  final QuizTakerController _quizTakerController = QuizTakerController();

  List<QuizTakerModel> _quizTakers = [];
  List<QuizTakerModel> get quizTakers => _quizTakers;

  QuizTakerProvider() {
    fetchQuizTakers();
  }

  // Fetch all quiz takers
  Future<void> fetchQuizTakers() async {
    _quizTakers = await _quizTakerController.getAllQuizTakers();
    notifyListeners();
  }

  // Add a new quiz taker
  Future<void> addQuizTaker(QuizTakerModel quizTaker) async {
    await _quizTakerController.insertQuizTaker(quizTaker);
    _quizTakers.add(quizTaker);

    fetchQuizTakers();
    notifyListeners();
  }

  // Update an existing quiz taker
  Future<void> updateQuizTaker(QuizTakerModel updatedQuizTaker) async {
    await _quizTakerController.updateQuizTaker(updatedQuizTaker);
    int index = _quizTakers.indexWhere((taker) => taker.id == updatedQuizTaker.id);
    if (index != -1) {
      _quizTakers[index] = updatedQuizTaker;
      notifyListeners();
    }
  }

  // Delete a quiz taker by ID
  Future<void> deleteQuizTaker(String id) async {
    await _quizTakerController.deleteQuizTaker(id);
    _quizTakers.removeWhere((taker) => taker.id == id);
    notifyListeners();
  }
}
