import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/fields/custom_text_field.dart';
import 'create_quiz_3.dart';

class CreateQuiz2 extends StatefulWidget {
  const CreateQuiz2({
    super.key,
  });

  @override
  State<CreateQuiz2> createState() => _CreateQuiz2State();
}

class _CreateQuiz2State extends State<CreateQuiz2> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int noOfQuestions = 0;

  bool isForEdit = false;

  // final List<TextEditingController> _questionControllers = [];
  final Map<String, TextEditingController> _choicesController = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }

  @override
  void dispose() {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context, listen: false);
    for (var controller in createQuizProvider.questionControllers) {
      controller.dispose();
    }
    _choicesController.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void initializeData() async {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context, listen: false);
    noOfQuestions = createQuizProvider.noOfQuestions;

    for (int i = 0; i < noOfQuestions; i++) {
      final String id = Uuid().v4();
      createQuizProvider.addQuestion(
        questionId: id,
        questionText: '',
      );

      createQuizProvider.addQuestionController();
    }
  }

  void _goToNextPage() {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context, listen: false);
    final question = createQuizProvider.questions[_currentPage];

    if (question.question.isEmpty) {
      Get.snackbar('Error', 'Please enter a valid question.');
      return;
    }

    final choicesForQuestion = createQuizProvider.choices
        .where((e) => e.quizQuestionId == question.id)
        .toList();

    if (choicesForQuestion.length < 2) {
      Get.snackbar('Error', 'Please add at least 2 choices.');
      return;
    }

    bool hasCorrectChoice = choicesForQuestion.any((choice) => choice.isCorrect);

    if (!hasCorrectChoice) {
      Get.snackbar('Error', 'Please select at least 1 correct choice.');
      return;
    }

    if (_currentPage < noOfQuestions - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.to(() => CreateQuiz3())?.then((val) {
            print('Executing');
            if(val != null) {
              if(val is Map) {
                if(val['for'] == 'edit') {
                  String questionId = val['questionId'];

                  print('Going to this');

                  int pageToBack = createQuizProvider
                    .questions.indexWhere((q) => q.id == questionId);

                  if (mounted) {
                    setState(() {
                      _currentPage = pageToBack;
                      isForEdit = true;
                    });
                  }



                  _pageController.animateToPage(
                    _currentPage,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );

                }
              }
            }
      });
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
    noOfQuestions = createQuizProvider.noOfQuestions;

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
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextFormField(
                      controller: createQuizProvider.questionControllers[index],
                      hintText: 'Enter your question',
                      labelText: 'Question',
                      onChanged: (value) {
                        createQuizProvider.updateQuestion(
                          index: index,
                          updatedQuestionText: value,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    for (int i = 0; i < createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).length; i++)
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.016),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                final choiceId = createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id;
                                createQuizProvider.removeChoiceForQuestion(choiceId: choiceId);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 10),
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
                                    updatedIsCorrect: false,
                                  );
                                },
                              ),
                            ),
                            Radio<String>(
                              value: createQuizProvider.choices.where((e) => e.quizQuestionId == question.id).toList()[i].id,
                              groupValue: createQuizProvider.getSelectedChoiceId(question.id),
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
                              isCorrect: false,
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
            child: isForEdit ?
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isForEdit = false;
                          });

                          Get.to(() => const CreateQuiz3())?.then((val) {
                            print('Executing');
                            if(val != null) {
                              if(val is Map) {
                                if(val['for'] == 'edit') {
                                  String questionId = val['questionId'];

                                  print('Going to this');

                                  int pageToBack = createQuizProvider
                                      .questions.indexWhere((q) => q.id == questionId);

                                  if (mounted) {
                                    setState(() {
                                      _currentPage = pageToBack;
                                      isForEdit = true;
                                    });
                                  }



                                  _pageController.animateToPage(
                                    _currentPage,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );

                                }
                              }
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF313235),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Done Edit'),
                      ),
                    ),
                  ],
                ),
              ) :
              Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313235),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Previous'),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313235),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Next'),
                    ),
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
