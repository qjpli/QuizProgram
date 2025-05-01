import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/screens/auth/sign_in.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final authUserProvider = Provider.of<AuthUserProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFf0ee9c),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(screenSize * 0.01),
                    child: SvgPicture.asset(
                      'assets/svgs/general/user-icon.svg',
                      width: screenSize * 0.03,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Text(
                    authUserProvider.authUser?.name ?? 'User Name',
                    style: TextStyle(
                      fontSize: screenSize * 0.016,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await authUserProvider.logoutUser();
                Get.offAll(() => const SignIn()); // Navigate to SignIn screen after logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF313235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(
                  screenWidth * 0.8,
                  screenHeight * 0.06,
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenSize * 0.013,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
          ],
        ),
      ),
    );
  }
}
