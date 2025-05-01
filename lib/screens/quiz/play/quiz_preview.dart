import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/screens/quiz/play/quiz_play.dart';

import '../../../customs/fields/custom_text_field.dart';
import '../../../globals.dart';
import '../../../providers/quiz_category_provider.dart';
import '../../../providers/quiz_provider.dart';
import '../../../providers/quiz_question_provider.dart';
import '../../../providers/quiz_taker_provider.dart';

class QuizPreview extends StatefulWidget {
  final String quizId;

  const QuizPreview({
    super.key,
    required this.quizId
  });

  @override
  State<QuizPreview> createState() => _QuizPreviewState();
}

class _QuizPreviewState extends State<QuizPreview> {
  final TextEditingController _nameOfTakerController = TextEditingController();
  List<String> avatars = ['human-1.png', 'human-2.png', 'human-3.png', 'animal-1.png', 'animal-2.png', 'animal-3.png'];
  String selectedAvatar = 'human-1.png';
  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quizCategoryProvider = Provider.of<QuizCategoryProvider>(context);
    final quizTakerProvider = Provider.of<QuizTakerProvider>(context);
    final quizQuestionProvider = Provider.of<QuizQuestionProvider>(context);

    final quiz = quizProvider.quizzes.firstWhere((quiz) => quiz.id == widget.quizId);
    final questions = quizQuestionProvider.quizQuestions.where((question) => question.quizId == widget.quizId).toList();
    final quizCategory = quizCategoryProvider.quizCategories.firstWhere((quizCategory) => quizCategory.id == quiz.quizCategoryId);
    Color quizColor = Colors.black;


    switch (quizCategory.svgIcon) {
      case 'art-and-culture':
        quizColor = Colors.blue.shade800;
        break;
      case 'geography':
        quizColor = Colors.green.shade800;
        break;
      case 'history':
        quizColor = Colors.purple.shade800;
        break;
      case 'literature':
        quizColor = Colors.orange.shade800;
        break;
      case 'mathematics':
        quizColor = Colors.red.shade800;
        break;
      case 'science':
        quizColor = Colors.yellow.shade800;
        break;
      case 'society-studies':
        quizColor = Colors.indigo.shade800;
        break;
      case 'sports':
        quizColor = Colors.pink.shade800;
        break;
      case 'technology':
        quizColor = Colors.teal.shade800;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.3,
                          width: screenWidth,
                          margin: EdgeInsets.only(bottom: screenHeight * 0.06),
                          color: quizColor,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: screenHeight * 0.24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.lerp(quizColor, Colors.white, 0.4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2
                                  )
                                ),
                                padding: EdgeInsets.all(screenSize * 0.016),
                                child: SvgPicture.asset('assets/svgs/categoryicons/${quizCategory.svgIcon}.svg',
                                  width: screenSize * 0.04,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(quiz.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize * 0.015,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(quizCategory.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize * 0.01,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 0.3,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(quiz.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize * 0.01,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          children: [
                            Text('More Details about this quiz',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenSize * 0.01,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        ),
                        TitleValue(title: 'Difficulty', value: quiz.difficulty),
                        TitleValue(title: 'Total Takers', value: '${quizTakerProvider.quizTakers.where((quizTaker) => quizTaker.quizId == quiz.id).length}'),
                        TitleValue(title: 'Highest Score', value: '${quizTakerProvider.quizTakers.firstWhereOrNull((quizTaker) => quizTaker.quizId == quiz.id)?.points ?? 0}'),
                        TitleValue(title: 'Randomized Questions', value: quiz.randomizeQuestion ? 'Yes' : 'No'),
                        TitleValue(title: 'Time per Questions', value: '${quiz.maxTimePerQuestion} secs'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF313235),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: Size(
                      screenWidth * 0.9,
                      screenHeight * 0.06
                  )
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // important!
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight * 0.034),
                                        Text('Enter a name for this quiz'),
                                        SizedBox(height: screenHeight * 0.02),
                                        CustomTextFormField(
                                          controller: _nameOfTakerController,
                                          hintText: 'Enter your name',
                                          labelText: 'Name',
                                          onChanged: (value) {
                                            setState(() {

                                            });
                                          },
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
                                        Text('Select an Avatar'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: screenHeight * 0.1,
                                    child: ListView.builder(
                                      itemCount: avatars.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedAvatar = avatars[index];
                                              });
                                            },
                                            splashFactory: NoSplash.splashFactory,
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: index == 0 ? screenWidth * 0.06 : screenWidth * 0.03,
                                                right: index == avatars.length - 1 ? screenWidth * 0.06 : 0
                                              ),
                                              decoration: BoxDecoration(
                                                border: selectedAvatar == avatars[index] ?
                                                Border.all(
                                                    color: quizColor,
                                                    width: 2
                                                ) : null,
                                                shape: BoxShape.circle
                                              ),
                                              child: Image.asset('assets/images/avatars/${avatars[index]}',
                                                width: screenWidth * 0.14,
                                              ),
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF313235),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        fixedSize: Size(
                                            screenWidth * 0.9,
                                            screenHeight * 0.06
                                        )
                                    ),
                                    onPressed: _nameOfTakerController.text.trim().isEmpty ? null : () {
                                      Get.back();
                                      Get.to(() => QuizPlay(
                                        quizId: quiz.id,
                                        nameOfTaker: _nameOfTakerController.text.trim(),
                                        avatar: selectedAvatar
                                      ));
                                    },
                                    child: Text('Continue'),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Text('Play', style: TextStyle(color: Colors.white),),
              )
            ),
            Positioned(
              top: screenHeight * 0.06,
              right: screenWidth * 0.05,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.005
                ),
                child: Text('${questions.length} Questions',
                  style: TextStyle(
                    fontSize: screenSize * 0.01,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TitleValue extends StatefulWidget {
  final String title;
  final String value;

  const TitleValue({
    super.key,
    required this.title,
    required this.value
  });

  @override
  State<TitleValue> createState() => _TitleValueState();
}

class _TitleValueState extends State<TitleValue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.005
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.6
          )
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.02
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title,
            style: TextStyle(
              fontSize: screenSize * 0.01
            ),
          ),
          Text(widget.value,
            style: TextStyle(
              fontSize: screenSize * 0.01
            ),
          ),
        ],
      ),
    );
  }
}

