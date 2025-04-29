import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:quizprogram/globals.dart';
import 'package:quizprogram/screens/auth/sign_up_1.dart';

import '../../customs/fields/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('assets/images/general/app-logo-1.png',
                        width: screenWidth * 0.3,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025 ),
                    Text('Welcome',
                      style: TextStyle(
                        fontSize: screenSize * 0.016,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Text('Logging in takes you straight to your account',
                      style: TextStyle(
                        fontSize: screenSize * 0.012,
                        color: const Color(0xFF808080),
                        fontWeight: FontWeight.w300
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.visiblePassword,
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
                      onChanged: (value) {
        
                      },
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
                      onPressed: () {
        
                      },
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
                      child: Text('Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: const Color(0xFF808080),
                              fontSize: screenSize * 0.012,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              color: const Color(0xFF313235),
                              fontSize: screenSize * 0.012,
                              fontWeight: FontWeight.w500
                            ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Clicked');
                                  Get.to(() => const SignUp1(),
                                    transition: Transition.rightToLeft
                                  );
                                }
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
