import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/screens/main/hub.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../models/quiz_taker_model.dart';
import '../../../providers/quiz_taker_provider.dart';

class QuizResultPage extends StatefulWidget {
  final int totalPoints;
  final String quizId;
  final List<Map<String, dynamic>> results;
  final String nameOfTaker;
  final String avatar;

  const QuizResultPage({
    Key? key,
    required this.totalPoints,
    required this.quizId,
    required this.results,
    required this.nameOfTaker,
    required this.avatar,
  }) : super(key: key);

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> with TickerProviderStateMixin {
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      uploadResults();
    });
  }

  void uploadResults() async {
    final authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    final quizTakerProvider = Provider.of<QuizTakerProvider>(context, listen: false);
    final quizTaker = QuizTakerModel(
      id: const Uuid().v4(),
      quizId: widget.quizId,
      userId: authUserProvider.authUser!.id,
      displayname: widget.nameOfTaker,
      avatarUsed: widget.avatar,
      points: widget.totalPoints.toDouble(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await quizTakerProvider.addQuizTaker(quizTaker);
  }

  @override
  Widget build(BuildContext context) {
    final authUserProvider = Provider.of<AuthUserProvider>(context);
    final quizTakerProvider = Provider.of<QuizTakerProvider>(context);
    final double avatarSize = screenWidth * 0.15;

    return Scaffold(
      // backgroundColor: const Color(0xFFb2fce5),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // backgroundColor: const Color(0xFFb2fce5),
        title: Text(
          'Quiz Result',
          style: TextStyle(
            fontSize: screenSize * 0.016,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.03,
                    ),
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          offset: const Offset(0, 0),
                          spreadRadius: 3,
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFb2fce5),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatars/${widget.avatar}',
                              fit: BoxFit.cover,
                              width: avatarSize,
                              height: avatarSize,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          widget.nameOfTaker,
                          style: TextStyle(
                            fontSize: screenSize * 0.014,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Total Score: ${widget.totalPoints}',
                          style: TextStyle(fontSize: screenSize * 0.012),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAnswers = !_showAnswers;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF313235),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    ),
                    child: Text(
                      _showAnswers ? 'Hide Answers' : 'Show Answers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: screenSize * 0.013,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _showAnswers
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.results.length,
                      itemBuilder: (context, index) {
                        final r = widget.results[index];
                        final selectedChoice = r['choices'].firstWhere((c) => c.id == r['selected']);
                        final correctChoice = r['choices'].firstWhere((c) => c.id == r['correctAnswerId']);
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(13),
                                offset: const Offset(0, 0),
                                spreadRadius: 1,
                                blurRadius: 2,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.018,
                          ),
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Question ${index + 1}',
                                    style: TextStyle(
                                      fontSize: screenSize * 0.014,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Points: ${r['points']}',
                                      style: TextStyle(
                                        fontSize: screenSize * 0.011,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.grey.shade200),
                              SizedBox(height: screenHeight * 0.003),
                              Text(
                                r['question'],
                                style: TextStyle(
                                  fontSize: screenSize * 0.013,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    color: (r['correct'] ? Colors.green : Colors.red).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: (r['correct'] ? Colors.green : Colors.red)
                                    )
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                    horizontal: screenWidth * 0.02
                                ),
                                child: Text(selectedChoice.value,
                                  style: TextStyle(
                                    color: r['correct'] ? Colors.green : Colors.red,
                                    fontSize: screenSize * 0.011,
                                  ),
                                ),
                              ),
                              if (!r['correct'])
                                Container(
                                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                                  child: Text(
                                    'Correct Answer: ${correctChoice.value}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: screenSize * 0.011,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(height: screenHeight * 0.1),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: ElevatedButton(
              onPressed: () async {
                Get.offAll(() => const Hub());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF313235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(screenWidth * 0.9, screenHeight * 0.06),
              ),
              child: Text(
                'Go Back to Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenSize * 0.013,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
