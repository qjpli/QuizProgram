import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:uuid/uuid.dart';

import '../../main/hub.dart';

class CreateQuiz3 extends StatefulWidget {
  const CreateQuiz3({super.key});

  @override
  State<CreateQuiz3> createState() => _CreateQuiz3State();
}

class _CreateQuiz3State extends State<CreateQuiz3> {
  @override
  Widget build(BuildContext context) {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context);

    bool isQuizValid = createQuizProvider.questions.isNotEmpty &&
        createQuizProvider.questions.every((question) =>
        createQuizProvider.choices.where((c) => c.quizQuestionId == question.id).length >= 2 &&
            createQuizProvider.choices.where((c) => c.quizQuestionId == question.id).any((choice) => choice.isCorrect) && question.question.isNotEmpty);


    return Scaffold(
      appBar: AppBar(
        title: Text('Review Your Quiz'),
        actions: [
          IconButton(
            onPressed: () {
              createQuizProvider.setNoOfQuestions(createQuizProvider.noOfQuestions + 1);

              final String id = Uuid().v4();
              createQuizProvider.addQuestion(
                questionId: id,
                questionText: '',
              );
              createQuizProvider.addQuestionController();
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: createQuizProvider.questions.length,
          itemBuilder: (context, index) {

            final question = createQuizProvider.questions[index];

            final choicesForQuestion = createQuizProvider.choices.where((choice) => choice.quizQuestionId == question.id).toList();
            if(choicesForQuestion.firstWhereOrNull((choice) => choice.isCorrect) == null) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.024,
                ),
                child: Column(
                  children: [
                    Text(
                      'No details available for this question yet.',
                      style: TextStyle(
                        fontSize: screenSize * 0.013,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back(
                          result: {
                            'for': 'edit',
                            'questionId': question.id,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313235),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Add Details'),
                    ),
                  ],
                )
              );
            }

            final correctChoicesForQuestion = choicesForQuestion.where((choice) => choice.isCorrect).first;

            return InkWell(
              onTap: () => Get.back(
                result: {
                  'for': 'edit',
                  'questionId': question.id
                }
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenSize * 0.014),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(question.question,
                          style: TextStyle(
                            fontSize: screenSize * 0.0128
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ...choicesForQuestion.map((choice) {
                          bool isCorrect = choice.isCorrect;
                          return Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.02
                            ),
                            margin: EdgeInsets.only(
                              bottom: screenHeight * 0.01
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${choice.value}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                // SizedBox(width: 10),
                                // if (isCorrect)
                                //   Icon(
                                //     Icons.check_circle,
                                //     color: Colors.green,
                                //     size: 20,
                                //   ),
                                // if (!isCorrect)
                                //   Icon(
                                //     Icons.cancel,
                                //     color: Colors.red,
                                //     size: 20,
                                //   ),
                              ],
                            ),
                          );
                        }).toList(),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correct Answer',
                                style: TextStyle(
                                  fontSize: screenSize * 0.009
                                ),
                              ),
                              Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green
                                  )
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                  horizontal: screenWidth * 0.02
                                ),
                                child: Text(correctChoicesForQuestion.value),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isQuizValid ? () async {
            await createQuizProvider.finalizeQuiz();

            Get.offAll(() => const Hub());
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF313235),
            foregroundColor: Colors.white,
          ),
          child: Text('Finalize Quiz'),
        ),
      ),
    );
  }
}
