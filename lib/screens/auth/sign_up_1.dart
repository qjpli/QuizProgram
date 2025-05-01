import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:quizprogram/globals.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/screens/auth/sign_up_2.dart';
import '../../providers/user_provider.dart';
import '../../customs/fields/custom_text_field.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _usernameController.dispose();
    _passwordController.dispose();
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
                    'Creating Account',
                    style: TextStyle(
                        fontSize: screenSize * 0.016,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Start your quizzer account today',
                    style: TextStyle(
                        fontSize: screenSize * 0.012,
                        color: const Color(0xFF808080),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  CustomTextFormField(
                    controller: _usernameController,
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (val) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (value) {},
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton(
                    onPressed: _usernameController.text.trim().isNotEmpty
                        ? () async {
                            if (_usernameController.text.trim().length < 8) {
                              print(
                                  'Username must be at least 8 characters in length.');

                              return;
                            }

                            bool isExisting = await userProvider.isUserExisting(
                                _usernameController.text.trim());

                            if (isExisting) {
                              print('Existing');

                              return;
                            }

                            print('Not Existing');
                            Get.to(() => SignUp2(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text.trim()));
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
                      'Sign up',
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
