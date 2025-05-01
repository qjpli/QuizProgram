import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/models/quiz_question_choice_model.dart';
import 'package:quizprogram/models/quiz_question_model.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';

class CreateQuiz3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the quiz provider that holds all the questions and choices
    final quizProvider = Provider.of<CreateQuizProvider>(context);
    final questions = quizProvider.questions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Your Quiz'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final choices = quizProvider.choices
              .where((choice) => choice.quizQuestionId == question.id)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}: ${question.question}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...List.generate(choices.length, (choiceIndex) {
                      final choice = choices[choiceIndex];
                      return ListTile(
                        title: Text(choice.value),
                        leading: Radio(
                          value: choice.isCorrect,
                          groupValue: true,
                          onChanged: null, // Disable interaction
                        ),
                        trailing: choice.isCorrect
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                      );
                    }),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Edit page if required
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditQuestionPage(question: question),
                              ),
                            );
                          },
                          child: Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle the finalize quiz logic if everything is correct
                            quizProvider.finalizeQuiz();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Quiz created successfully")),
                            );
                          },
                          child: Text('Finalize Quiz'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditQuestionPage extends StatefulWidget {
  final QuizQuestionModel question;

  const EditQuestionPage({super.key, required this.question});

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late TextEditingController _questionController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Edit Question',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                });
              },

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return after editing
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
