import 'package:flutter/material.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;
  final String nameOfTaker;
  final String avatar;

  const QuizPlay({
    super.key,
    required this.quizId,
    required this.nameOfTaker,
    required this.avatar
  });

  @override
  State<QuizPlay> createState() => _QuizPlayState();
}

class _QuizPlayState extends State<QuizPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
