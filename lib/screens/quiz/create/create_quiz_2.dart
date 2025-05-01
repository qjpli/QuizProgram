import 'package:flutter/material.dart';
import 'package:quizprogram/customs/fields/custom_text_field.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';

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
  List<QuizQuestionModel> questions = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    questions = List.generate(widget.noOfQuestions, (i) => QuizQuestionModel(id: '', quizId: '', question: ''));
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
              itemBuilder: (context, index) {
                return QuestionInput(
                  questionNumber: index + 1,
                  question: questions[index],
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: screenHeight * 0.06,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05
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
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF313235),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.013
                      )
                    ),
                    child: Text("Previous",
                      style: TextStyle(
                        fontSize: screenSize * 0.013,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < widget.noOfQuestions - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Handle Finish
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313235),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.013
                        )
                    ),
                    child: Text("Next",
                      style: TextStyle(
                          fontSize: screenSize * 0.013,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
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
  const QuestionInput({
    super.key,
    required this.questionNumber,
    required this.question,
  });

  @override
  State<QuestionInput> createState() => _QuestionInputState();
}

class _QuestionInputState extends State<QuestionInput> {
  late TextEditingController _questionController;
  List<QuizQuestionChoiceModel> choices = [];
  List<TextEditingController> _choiceControllers = [];
  int? _selectedChoiceIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    addChoice();
  }

  void addChoice() {
    setState(() {
      choices.add(QuizQuestionChoiceModel(id: '', quizQuestionId: '', value: '', isCorrect: false));
      _choiceControllers.add(TextEditingController());
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
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06
                )
              ),
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
