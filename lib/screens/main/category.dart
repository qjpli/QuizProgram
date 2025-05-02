import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/providers/quiz_category_provider.dart';

import '../../globals.dart';
import '../../providers/quiz_provider.dart';
import '../quiz/play/quiz_preview.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    final quizCategoryProvider = Provider.of<QuizCategoryProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Wrap(
          spacing: 10.0, // gap between adjacent chips
          runSpacing: 10.0, // gap between lines
          children: <Widget>[
            for (var category in quizCategoryProvider.quizCategories)
              InkWell(
                onTap: () => Get.to(() => null),
                child: Container(
                  width: screenWidth * 0.45,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/categoryicons/${category.svgIcon}.svg',
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        '${quizProvider.quizzes.where((quiz) => quiz.quizCategoryId == category.id).length} Quizzes',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
