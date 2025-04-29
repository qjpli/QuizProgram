import 'package:flutter/material.dart';
import 'package:quizprogram/themes/light_theme.dart';
import 'package:quizprogram/themes/dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData currentTheme() {
    return _themeMode == ThemeMode.dark ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
