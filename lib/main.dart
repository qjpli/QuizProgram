// qjpli-quizprogram/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:quizprogram/providers/auth_user_provider.dart';
import 'package:quizprogram/providers/creating_quiz/create_quiz_provider.dart';
import 'package:quizprogram/providers/quiz_category_provider.dart';
import 'package:quizprogram/providers/quiz_provider.dart';
import 'package:quizprogram/providers/quiz_question_choice_provider.dart';
import 'package:quizprogram/providers/quiz_question_provider.dart';
import 'package:quizprogram/providers/quiz_taker_provider.dart';
import 'package:quizprogram/providers/theme_provider.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:quizprogram/providers/user_provider.dart';
import 'package:quizprogram/screens/auth/sign_in.dart';
import 'package:quizprogram/screens/main/hub.dart';
import 'package:sqflite/sqflite.dart';

import 'globals.dart' as globals; // Import SQLController

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // final path = join(await getDatabasesPath(), 'quiz_database.db');
  // await deleteDatabase(path);
  // print('Database deleted successfully');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthUserProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => QuizCategoryProvider()),
        ChangeNotifierProvider(create: (_) => QuizQuestionChoiceProvider()),
        ChangeNotifierProvider(create: (_) => QuizQuestionProvider()),
        ChangeNotifierProvider(create: (_) => QuizTakerProvider()),
        ChangeNotifierProvider(create: (_) => CreateQuizProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authUserProvider = Provider.of<AuthUserProvider>(context);

    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenSize = globals.screenHeight + globals.screenWidth;

    return GetMaterialApp(
      title: 'Quiz App',
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme(),
      home: authUserProvider.authUser == null ? const SignIn() : const Hub(),
    );
  }
}