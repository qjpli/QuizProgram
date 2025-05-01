import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/providers/user_provider.dart';
import 'package:quizprogram/screens/main/hub.dart';

import '../../customs/fields/custom_text_field.dart';

class SignUp2 extends StatefulWidget {
  final String username;
  final String password;

  const SignUp2({super.key, required this.username, required this.password});

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authUserProvider = Provider.of<AuthUserProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/general/app-logo-1.png',
                      width: screenWidth * 0.3,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Choose your name',
                    style: TextStyle(
                        fontSize: screenSize * 0.016,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "What should we call you?",
                    style: TextStyle(
                        fontSize: screenSize * 0.012,
                        color: const Color(0xFF808080),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (val) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    onPressed: _nameController.text.trim().isNotEmpty
                        ? () async {
                            final status = await userProvider.createUser(
                                name: _nameController.text.trim(),
                                username: widget.username,
                                password: widget.password);

                            if (status != null) {
                              final setAuth =
                                  await authUserProvider.setAuthUser(status);

                              if(setAuth) {
                                Get.offAll(() => const Hub(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 300)
                                );
                              }

                              print('Account Successfully Created');
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313235),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize:
                            Size(screenWidth * 0.9, screenHeight * 0.06)),
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600,
                          fontSize: screenSize * 0.013),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.07),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                              color: const Color(0xFF808080),
                              fontSize: screenSize * 0.012,
                              fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                                color: const Color(0xFF313235),
                                fontSize: screenSize * 0.012,
                                fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Clicked');
                                Get.back();
                              })
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
