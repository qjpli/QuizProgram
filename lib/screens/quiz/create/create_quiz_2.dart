import 'package:flutter/material.dart';

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
    required this.timePerQuestion
  });

  @override
  State<CreateQuiz2> createState() => _CreateQuiz2State();
}

class _CreateQuiz2State extends State<CreateQuiz2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compose a Questions'),
      ),
      body: Container(
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}
