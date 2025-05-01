import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/screens/main/category.dart';
import 'package:quizprogram/screens/main/history.dart';
import 'package:quizprogram/screens/main/home.dart';
import 'package:quizprogram/screens/main/profile.dart';
import 'package:quizprogram/screens/quiz/create/create_quiz_1.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  final _pageController = PageController();
  int selectedMenu = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      FlutterNativeSplash.remove();
    });
  }

  Widget navMenu({
    required int index,
    required String title,
    required String icon
    }
      ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = index;
        });
        _pageController.jumpToPage(selectedMenu);
      },
      splashColor:  Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/svgs/general/$icon.svg',
            width: screenSize * 0.018 ,
            colorFilter: ColorFilter.mode(
                selectedMenu == index ?
                const Color(0xFF101010) : const Color(0xFF808080).withValues(alpha: 0.6),
                BlendMode.srcIn
            )
          ),
          SizedBox(height: screenHeight * 0.003),
          Text(title,
            style: TextStyle(
              fontSize: screenSize * 0.01,
              color: selectedMenu == index ? const Color(0xFF101010) : const Color(0xFF808080).withValues(alpha: 0.6)
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (val) {
                  setState(() {
                    selectedMenu = val;
                  });

                  _pageController.jumpToPage(selectedMenu);
                },
                children: [
                  const Home(),
                  const Category(),
                  const History(),
                  const Profile()
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: const Color(0xFFE5E5E5)
                      )
                    )
                  ),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.04,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    top: screenHeight * 0.018
                  ),
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      navMenu(
                          index: 0,
                          title: 'Home',
                          icon: 'home'
                      ),
                      navMenu(
                          index: 1,
                          title: 'Category',
                          icon: 'category'
                      ),
                      SizedBox.shrink(),
                      navMenu(
                          index: 2,
                          title: 'History',
                          icon: 'leaderboard'
                      ),
                      navMenu(
                          index: 3,
                          title: 'Profile',
                          icon: 'profile'
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.07,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Get.to(() => const CreateQuiz()),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffb2fce5),
                            shape: BoxShape.circle
                          ),
                          padding: EdgeInsets.all(screenSize * 0.01),
                          child: Icon(Icons.add,
                            size: screenSize * 0.025,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
