import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/fields/custom_text_field.dart';
import 'create_quiz_3.dart';

class CreateQuiz2 extends StatefulWidget {
  final int noOfQuestions;
  const CreateQuiz2({
    super.key,
    required this.noOfQuestions,
  });

  @override
  State<CreateQuiz2> createState() => _CreateQuiz2State();
}

class _CreateQuiz2State extends State<CreateQuiz2> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<TextEditingController> _questionControllers = [];
  Map<String, TextEditingController> _choicesController = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }

  @override
  void dispose() {
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    _choicesController.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void initializeData() async {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context, listen: false);

    for (int i = 0; i < widget.noOfQuestions; i++) {
      final String id = Uuid().v4();
      createQuizProvider.addQuestion(
        questionId: id,
        questionText: '',
      );
      _questionControllers.add(TextEditingController());
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.noOfQuestions - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // On the last question, navigate to CreateQuiz3 to review the quiz
      Get.to(() => CreateQuiz3());
    }
  }


  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Questions'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: createQuizProvider.questions.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final question = createQuizProvider.questions[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenSize * 0.016,
                      ),
                    ),
                    CustomTextFormField(
                      controller: _questionControllers[index],
                      hintText: 'Enter your question',
                      labelText: 'Question Text',
                      onChanged: (value) {
                        createQuizProvider.updateQuestion(
                          index: index,
                          updatedQuestionText: value,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // Display Choices for this Question
                    for (int i = 0; i < createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).length; i++)
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.016),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // X mark to delete the choice
                            GestureDetector(
                              onTap: () {
                                final choiceId = createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id;
                                createQuizProvider.removeChoiceForQuestion(choiceId: choiceId);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.red, // You can customize the color here
                              ),
                            ),
                            SizedBox(width: 10),
                            // Choice Text Field
                            Expanded(
                              child: CustomTextFormField(
                                controller: _choicesController[createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id] ?? TextEditingController(),
                                hintText: 'Enter choice',
                                labelText: 'Choice ${i + 1}',
                                onChanged: (value) {
                                  createQuizProvider.updateChoiceForQuestion(
                                    questionId: question.id,
                                    choiceId: createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id,
                                    updatedChoiceValue: value,
                                    updatedIsCorrect: false, // This could be based on your logic later
                                  );
                                },
                              ),
                            ),
                            // Radio Button to mark as correct
                            Radio<String>(
                              value: createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id,
                              groupValue: createQuizProvider.getSelectedChoiceId(question.id), // Get selected choice from provider
                              onChanged: (String? selectedChoiceId) {
                                setState(() {
                                  createQuizProvider.setCorrectChoice(question.id, selectedChoiceId);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final String id = Uuid().v4();
                            createQuizProvider.addChoiceForQuestion(
                              choiceId: id,
                              questionId: question.id,
                              choiceValue: '',
                              isCorrect: false, // Set the correct flag based on your logic
                            );
                            _choicesController[id] = TextEditingController(text: '');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF313235),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Add Choice'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _goToPreviousPage,
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _goToNextPage,
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
