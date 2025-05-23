import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/customs/fields/custom_text_field.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/quiz_category_provider.dart';
import 'package:quizprogram/screens/quiz/create/create_quiz_2.dart';

import '../../../providers/creating_quiz/create_quiz_provider.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  List<String> difficulties = ['Easy', 'Medium', 'Hard'];


  String selectedCategory = '';
  final TextEditingController _quizNameController = TextEditingController();
  final TextEditingController _quizDescController = TextEditingController();
  final TextEditingController _quizQuestionsNoController = TextEditingController();
  final TextEditingController _quizTimePerQuestionController = TextEditingController();

  bool isRandomized = false;
  int selectedDifficulty = -1;

  @override
  Widget build(BuildContext context) {

    bool isAllowed =
        _quizNameController.text.trim().isNotEmpty &&
        _quizDescController.text.trim().isNotEmpty &&
        selectedCategory.isNotEmpty &&
        _quizQuestionsNoController.text.trim().isNotEmpty &&
        _quizTimePerQuestionController.text.trim().isNotEmpty;

    final quizCategoryProvider = Provider.of<QuizCategoryProvider>(context);
    final createQuizProvider = Provider.of<CreateQuizProvider>(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Create Quiz',
          style: TextStyle(
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.0
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Quiz Name',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      CustomTextFormField(
                        controller: _quizNameController,
                        hintText: 'Enter the name of the Quiz',
                        onChanged: (val) => setState(() {}),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Quiz Description',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      CustomTextFormField(
                        controller: _quizDescController,
                        hintText: 'Write the Quiz Description',
                        maxLines: 4,
                        onChanged: (val) => setState(() {}),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.08
                  ),
                  child: Text('Quiz Type',
                    style: TextStyle(

                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 0.055,
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.005
                  ),
                  child: ListView.builder(
                    itemCount: quizCategoryProvider.quizCategories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = quizCategoryProvider.quizCategories[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category.id;
                          });
                        },
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          margin: EdgeInsets.only(
                              left: index == 0 ?
                              screenWidth * 0.06 : screenWidth * 0.03,
                              right: index == quizCategoryProvider.quizCategories.length - 1 ? screenWidth * 0.06 : screenWidth * 0.0
                          ),
                          decoration: BoxDecoration(
                              color: selectedCategory == category.id ?
                              const Color(0xFFb2fce5) :
                              const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text(category.name,
                            style: TextStyle(
                              fontSize: screenSize * 0.012,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.035),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Quiz Difficulty',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.002
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf2f2f2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: selectedDifficulty >= 0 ? selectedDifficulty : null,
                            hint: Text('Select Difficulty', style: TextStyle(fontWeight: FontWeight.w300, fontSize: screenSize * 0.013),),
                            items: List.generate(difficulties.length, (index) {
                              return DropdownMenuItem<int>(
                                value: index,
                                child: Text(difficulties[index], style: TextStyle(fontWeight: FontWeight.w400),),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedDifficulty = value!;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.035),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Number of Questions',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      CustomTextFormField(
                        controller: _quizQuestionsNoController,
                        hintText: 'Enter number of Questions',
                        keyboardType: TextInputType.number,
                        onChanged: (val) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.035),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Timer per Question',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      CustomTextFormField(
                        controller: _quizTimePerQuestionController,
                        hintText: 'Enter time per question',
                        keyboardType: TextInputType.number,
                        onChanged: (val) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.035),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02
                        ),
                        child: Text('Randomized Questions',
                          style: TextStyle(

                          ),
                        ),
                      ),
                      Switch(
                        value: isRandomized,
                        onChanged: (val) {
                          setState(() {
                            isRandomized = val;
                          });
                        }
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.15)
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.06,
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            child: ElevatedButton(
              onPressed: isAllowed ? () {

                createQuizProvider.resetQuiz();

                createQuizProvider.setQuizMetadata(
                    quizCategoryId: selectedCategory,
                    name: _quizNameController.text.trim(),
                    description: _quizDescController.text.trim(),
                    difficulty: difficulties[selectedDifficulty],
                    maxTimePerQuestion: int.tryParse(_quizTimePerQuestionController.text.trim()) ?? 0,
                    randomizeQuestion: isRandomized
                );

                createQuizProvider.setNoOfQuestions(int.tryParse(_quizQuestionsNoController.text.trim()) ?? 0);

                  Get.to(() => const CreateQuiz2());
              } : null,
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
              child: Text('Continue',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: screenSize * 0.013
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
