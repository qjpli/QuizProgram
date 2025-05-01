import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/customs/fields/custom_text_field.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:quizprogram/screens/quiz/create/create_quiz_3.dart'; // Import the provider

class CreateQuiz2 extends StatefulWidget {
  final String name;
  final String description;
  final String type;
  final int noOfQuestions;
  final int timePerQuestion;

  const CreateQuiz2({
    super.key,
    required this.name,
    required this.description,
    required this.type,
    required this.noOfQuestions,
    required this.timePerQuestion,
  });

  @override
  State<CreateQuiz2> createState() => _CreateQuiz2State();
}

class _CreateQuiz2State extends State<CreateQuiz2> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<bool> isPageValid = [];

  @override
  void initState() {
    super.initState();
    isPageValid = List.filled(widget.noOfQuestions, false);
  }

  void updatePageValidity(int pageIndex, bool isValid) {
    setState(() {
      isPageValid[pageIndex] = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'Compose Questions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.noOfQuestions,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return QuestionInput(
                  questionNumber: index + 1,
                  question: QuizQuestionModel(id: '', quizId: '', question: ''), // Just example data
                  onValidationChanged: (isValid) => updatePageValidity(index, isValid),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.06,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF313235),
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.013),
                    ),
                    child: Text(
                      "Previous",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.013,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isPageValid[_currentPage]
                        ? () {
                      if (_currentPage < widget.noOfQuestions - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Handle Finish
                        // Save the quiz data by calling the provider methods
                        // Provider.of<CreateQuizProvider>(context, listen: false).finalizeQuiz();

                        print('s');
                        Get.to(() => CreateQuiz3());
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF313235),
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.013),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.013,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class QuestionInput extends StatefulWidget {
  final int questionNumber;
  final QuizQuestionModel question;
  final Function(bool isValid)? onValidationChanged;

  const QuestionInput({
    super.key,
    required this.questionNumber,
    required this.question,
    this.onValidationChanged,
  });

  @override
  State<QuestionInput> createState() => _QuestionInputState();
}

class _QuestionInputState extends State<QuestionInput> {
  late TextEditingController _questionController;
  List<QuizQuestionChoiceModel> choices = [];
  final List<TextEditingController> _choiceControllers = [];
  int? _selectedChoiceIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _questionController.addListener(validate);
    addChoice(); // Start with one
    addChoice(); // Ensure at least 2
  }

  void addChoice() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(validate);
      _choiceControllers.add(controller);
      choices.add(QuizQuestionChoiceModel(id: '', quizQuestionId: '', value: '', isCorrect: false));
    });
  }

  void selectCorrectChoice(int index) {
    setState(() {
      _selectedChoiceIndex = index;
      choices = List.generate(
        choices.length,
            (i) => choices[i].copyWith(isCorrect: i == index),
      );
    });
    validate();
  }

  void validate() {
    final hasQuestion = _questionController.text.trim().isNotEmpty;
    final validChoices = _choiceControllers.where((c) => c.text.trim().isNotEmpty).toList();
    final hasCorrectChoice = choices.any((c) => c.isCorrect);

    final isValid = hasQuestion && validChoices.length >= 2 && hasCorrectChoice;
    widget.onValidationChanged?.call(isValid);
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${widget.questionNumber}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomTextFormField(
            controller: _questionController,
            hintText: 'Enter question',
          ),
          SizedBox(height: 10),
          Text(
            'Choices',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: choices.length,
            itemBuilder: (context, index) {
              return ChoiceInput(
                choiceNumber: index + 1,
                controller: _choiceControllers[index],
                isSelected: choices[index].isCorrect,
                onSelected: () => selectCorrectChoice(index),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: addChoice,
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF313235),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06)),
              child: Text('Add Choice'),
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceInput extends StatelessWidget {
  final int choiceNumber;
  final TextEditingController controller;
  final bool isSelected;
  final VoidCallback onSelected;

  const ChoiceInput({
    super.key,
    required this.choiceNumber,
    required this.controller,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Choice $choiceNumber',
            ),
          ),
          Radio<int>(
            value: choiceNumber,
            groupValue: isSelected ? choiceNumber : null,
            onChanged: (_) => onSelected(),
          ),
        ],
      ),
    );
  }
}
