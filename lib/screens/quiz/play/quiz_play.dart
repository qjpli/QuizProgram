import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/screens/quiz/play/quiz_result.dart';
import '../../../providers/quiz_category_provider.dart';
import '../../../providers/quiz_provider.dart';
import '../../../providers/quiz_question_choice_provider.dart';
import '../../../providers/quiz_question_provider.dart';
import '../../../providers/quiz_taker_provider.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;
  final String nameOfTaker;
  final String avatar;

  const QuizPlay({
    super.key,
    required this.quizId,
    required this.nameOfTaker,
    required this.avatar,
  });

  @override
  State<QuizPlay> createState() => _QuizPlayState();
}

class _QuizPlayState extends State<QuizPlay> {
  late PageController _pageController;
  String currentSelectedAnswer = '';
  int _currentPage = 0;
  int _secondsLeft = -1;
  Timer? _timer;
  List<dynamic> _questions = [];
  bool isAnswered = false;
  int totalPoints = 0;
  List<Map<String, dynamic>> answerResults = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final quizQuestionProvider = Provider.of<QuizQuestionProvider>(context, listen: false);

      final quiz = quizProvider.quizzes.firstWhere((quiz) => quiz.id == widget.quizId);
      final questions = quizQuestionProvider.quizQuestions
          .where((q) => q.quizId == widget.quizId)
          .toList();

      if (quiz.randomizeQuestion) {
        questions.shuffle(Random());
      } else {
        print('Not randomized');
      }

      _questions = questions;
      _secondsLeft = quiz.maxTimePerQuestion;
      _startTimer();
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final quiz = quizProvider.quizzes.firstWhere((quiz) => quiz.id == widget.quizId);
    _secondsLeft = quiz.maxTimePerQuestion;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          if (_currentPage < _questions.length - 1) {
            timer.cancel();
            _goToNextPage();
          } else {
            _timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => QuizResultPage(
                  totalPoints: totalPoints,
                  results: answerResults,
                  nameOfTaker: widget.nameOfTaker,
                  avatar: widget.avatar,
                ),
              ),
            );
          }
        }
      });
    });
  }

  void _goToNextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPage++;
        currentSelectedAnswer = '';
        isAnswered = false;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(
            totalPoints: totalPoints,
            results: answerResults,
            nameOfTaker: widget.nameOfTaker,
            avatar: widget.avatar,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quizQuestionChoiceProvider = Provider.of<QuizQuestionChoiceProvider>(context);

    if (!isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final quiz = quizProvider.quizzes.firstWhere((quiz) => quiz.id == widget.quizId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(quiz.name),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentPage + 1} of ${_questions.length}',
                  style: TextStyle(
                    fontSize: screenSize * 0.015,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: screenSize * 0.03,
                      height: screenSize * 0.03,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: _secondsLeft / quiz.maxTimePerQuestion,
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, _) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    ),
                    Text(
                      '$_secondsLeft',
                      style: TextStyle(
                        fontSize: screenSize * 0.013,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                final choices = quizQuestionChoiceProvider.choices
                    .where((q) => q.quizQuestionId == question.id)
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2FCE5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        constraints: BoxConstraints(minHeight: screenHeight * 0.2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: screenWidth * 0.0,
                              top: screenHeight * 0.01,
                              child: Icon(
                                Icons.question_mark,
                                size: 100,
                                color: Colors.teal.withOpacity(0.1),
                              ),
                            ),
                            Positioned(
                              left: screenWidth * 0.06,
                              top: screenHeight * 0.01,
                              child: Transform.rotate(
                                angle: -(pi / 4),
                                child: Icon(
                                  Icons.question_answer,
                                  size: 60,
                                  color: Colors.teal.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                question.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        child: Column(
                          children: choices.map((choice) {
                            Color bgColor = Colors.transparent;
                            if (currentSelectedAnswer == choice.id) {
                              if (!isAnswered) {
                                bgColor = Colors.blue;
                              } else if (choice.isCorrect) {
                                bgColor = Colors.green;
                              } else {
                                bgColor = Colors.red;
                              }
                            }
                            return InkWell(
                              onTap: () {
                                if (isAnswered) return;
                                setState(() {
                                  currentSelectedAnswer = choice.id;
                                  isAnswered = true;
                                });
                                Future.delayed(const Duration(seconds: 1), () {
                                  int points = 0;
                                  if (choice.isCorrect) {
                                    points = (_secondsLeft * 1000 ~/ quiz.maxTimePerQuestion);
                                    totalPoints += points;
                                  }
                                  answerResults.add({
                                    'question': question.question,
                                    'choices': choices,
                                    'selected': choice.id,
                                    'correct': choice.isCorrect,
                                    'correctAnswerId': choices.firstWhere((c) => c.isCorrect).id,
                                    'points': points,
                                  });
                                  _goToNextPage();
                                });
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  border: Border.all(
                                    color: bgColor == Colors.transparent ? Colors.grey.shade300 : bgColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.017,
                                  horizontal: screenWidth * 0.04,
                                ),
                                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                child: Text(choice.value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
