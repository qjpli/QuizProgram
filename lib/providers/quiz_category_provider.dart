import 'package:flutter/material.dart';
import 'package:quizprogram/models/quiz_category_model.dart';
import 'package:quizprogram/controllers/quiz_category_controller.dart';

class QuizCategoryProvider extends ChangeNotifier {
  final QuizCategoryController _quizCategoryController = QuizCategoryController();

  List<QuizCategoryModel> _quizCategories = [];

  List<QuizCategoryModel> get quizCategories => _quizCategories;

  QuizCategoryProvider() {
    getAllQuizCategories();
  }

  // Fetch all quiz categories
  Future<void> getAllQuizCategories() async {
    _quizCategories = await _quizCategoryController.getAllQuizCategories();

    if(_quizCategories.isEmpty) {
      await _addDefaultCategories();
    } else {
      print('Not empty');
    }

    notifyListeners();
  }

  // Method to add default categories if no categories exist
  Future<void> _addDefaultCategories() async {
    List<QuizCategoryModel> defaultCategories = [
      QuizCategoryModel(id: '1', name: 'Science', isAvailable: true, svgIcon: 'science'),
      QuizCategoryModel(id: '2', name: 'Mathematics', isAvailable: true, svgIcon: 'mathematics'),
      QuizCategoryModel(id: '3', name: 'History', isAvailable: true, svgIcon: 'history'),
      QuizCategoryModel(id: '4', name: 'Geography', isAvailable: true, svgIcon: 'geography'),
      QuizCategoryModel(id: '5', name: 'Literature', isAvailable: true, svgIcon: 'literature'),
      QuizCategoryModel(id: '6', name: 'Technology', isAvailable: true, svgIcon: 'technology'),
      QuizCategoryModel(id: '7', name: 'Art & Culture', isAvailable: true, svgIcon: 'art-and-culture'),
      QuizCategoryModel(id: '8', name: 'Social Studies', isAvailable: true, svgIcon: 'social-studies'),
      QuizCategoryModel(id: '9', name: 'Sports', isAvailable: true, svgIcon: 'sports'),
    ];

    // Insert default categories into the database
    for (var category in defaultCategories) {
      await _quizCategoryController.insertQuizCategory(category);
    }

    print('Uploaded');
    _quizCategories = defaultCategories;
    notifyListeners();
  }

  Future<void> addQuizCategory(QuizCategoryModel quizCategory) async {
    await _quizCategoryController.insertQuizCategory(quizCategory);
    await getAllQuizCategories(); // Refresh list
  }

  Future<void> updateQuizCategory(QuizCategoryModel quizCategory) async {
    await _quizCategoryController.updateQuizCategory(quizCategory);
    await getAllQuizCategories(); // Refresh list
  }

  Future<void> deleteQuizCategory(String id) async {
    await _quizCategoryController.deleteQuizCategory(id);
    await getAllQuizCategories(); // Refresh list
  }
}
