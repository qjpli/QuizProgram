import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quizprogram/globals.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
