import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';

class CreateQuiz3 extends StatelessWidget {
  const CreateQuiz3({super.key});

  @override
  Widget build(BuildContext context) {
    final createQuizProvider = Provider.of<CreateQuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Your Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: createQuizProvider.questions.length,
          itemBuilder: (context, index) {
            final question = createQuizProvider.questions[index];
            final choicesForQuestion = createQuizProvider.choices.where((choice) => choice.quizQuestionId == question.id).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: ${question.question}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ...choicesForQuestion.map((choice) {
                        bool isCorrect = choice.isCorrect;
                        return Row(
                          children: [
                            Text(
                              '${choice.value}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 10),
                            if (isCorrect)
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                            if (!isCorrect)
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                          ],
                        );
                      }).toList(),
                      Divider(),
                    ],
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
          onPressed: () {
            // Finalize the quiz (this might trigger your saving logic)
            createQuizProvider.finalizeQuiz();
            Navigator.pop(context); // Close the review page after finalizing
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('Finalize Quiz'),
        ),
      ),
    );
  }
}
