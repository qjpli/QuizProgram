import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/models/quiz_model.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/providers/quiz_category_provider.dart';
import 'package:quizprogram/providers/quiz_provider.dart';
import 'package:quizprogram/screens/quiz/play/quiz_preview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzesForUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUserProvider = Provider.of<AuthUserProvider>(context);
    final quizCategoryProvider = Provider.of<QuizCategoryProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);

    if (authUserProvider.authUser == null) {
      return Center(
        child: Text('Please log in to view content.'),
      );
    }

    return Scaffold(
      body: Container(
        child: Column(
            children: [
            Container(
            margin: EdgeInsets.only(
            top: screenHeight * 0.07,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            child: Row(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: screenWidth * 0.05,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.002),
                            child: Text(
                              'GOOD DAY',
                              style: TextStyle(
                                fontSize: screenSize * 0.012,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFf0ee9c),
                                shape: BoxShape.circle),
                            padding: EdgeInsets.all(screenSize * 0.008),
                            child: SvgPicture.asset(
                              'assets/svgs/general/user-icon.svg',
                              width: screenSize * 0.021,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            authUserProvider.authUser?.name ?? '',
                            style: TextStyle(
                                fontSize: screenSize * 0.013,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Column(
                  children: [
              Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Questionnaire',
                      style: TextStyle(
                          fontSize: screenSize * 0.014, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(fontSize: screenSize * 0.012),
                    )
                  ]),
            ),
            Container(
              height: screenHeight * 0.13,
              margin: EdgeInsets.only(top: screenHeight * 0.01),
              width: screenWidth,
              child: ListView.builder(
                itemCount: quizCategoryProvider.quizCategories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = quizCategoryProvider.quizCategories[index];

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              offset: Offset(0, 0),
                              spreadRadius: 3,
                              blurRadius: 5
                          )
                        ],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: screenWidth * 0.26,
                    margin: EdgeInsets.only(
                        left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.03,
                        right: index == quizCategoryProvider.quizCategories.length - 1 ? screenWidth * 0.05 : 0,
                        top: screenHeight * 0.01,
                        bottom: screenHeight * 0.01
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.02
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/svgs/categoryicons/${category.svgIcon}.svg',
                          width: screenWidth * 0.08,
                        ),
                        SizedBox(height: screenHeight * 0.007),
                        Text(category.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: screenSize * 0.01,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Created Quizzes',
                    style: TextStyle(
                        fontSize: screenSize * 0.014, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(fontSize: screenSize * 0.012),
                  ),
                ],
              ),
            ),
            quizProvider.quizzes.isEmpty
                    ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.02),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Center(
                    child: Text('No created quizzes yet.',
                      style: TextStyle(fontSize: screenSize * 0.012),
                    ),
                  ),
                )
                : Container(
              height: screenHeight * 0.15,
              margin: EdgeInsets.only(top: screenHeight * 0.01),
              width: screenWidth,
              child: ListView.builder(
                itemCount: quizProvider.quizzes.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final quiz = quizProvider.quizzes[index];
                  return InkWell(
                    onTap: () => Get.to(() => QuizPreview(quizId: quiz.id),
                      transition: Transition.fadeIn
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                offset: Offset(0, 0),
                                spreadRadius: 3,
                                blurRadius: 5
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      width: screenWidth * 0.26,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.03,
                          right: index == quizProvider.quizzes.length - 1 ? screenWidth * 0.05 : 0,
                          top: screenHeight * 0.01,
                          bottom: screenHeight * 0.01
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.02
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.quiz, // Or any other appropriate icon
                            size: screenWidth * 0.08,
                          ),
                          SizedBox(height: screenHeight * 0.007),
                          Text(
                            quiz.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: screenSize * 0.01,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          ),
          )
          ],
        ),
      ),
    );
  }
}
