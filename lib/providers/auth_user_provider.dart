// THIS PROVIDER IS FOR LOGGED IN USER
import 'package:flutter/material.dart';
import 'package:quizprogram/models/user_model.dart';
import 'package:quizprogram/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserProvider extends ChangeNotifier {
  final UserController _userController = UserController();

  UserModel? _authUser;

  UserModel? get authUser => _authUser;

  AuthUserProvider() {
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('logged_in_user_id');
    if (userId != null) {
      await getAuthUser(userId);
    }
  }

  Future<bool> setAuthUser(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user_id', user.id);
      _authUser = user;
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
    _authUser = null;
    notifyListeners();
  }

  Future<void> getAuthUser(String id) async {
    _authUser = await _userController.getUser(id);
    notifyListeners();
  }

  Future<void> updateAuthUser(UserModel updatedUser) async {
    if (_authUser == null) return;
    await _userController.updateUser(updatedUser);
    _authUser = updatedUser;
    notifyListeners();
  }

  Future<void> deleteAuthUser(String id) async {
    await _userController.deleteUser(id);
    await removeAuthUser();
    notifyListeners();
  }

  Future<void> loginUser(String username, String password) async {
    UserModel? user =
        await _userController.authenticateUser(username, password);

    if (user != null) {
      await setAuthUser(user);
    } else {
      print('Login failed');
    }
  }

  Future<void> logoutUser() async {
    await removeAuthUser();
  }

  Future<UserModel?> authenticateUser(String username, String password) async {
    //add user controller method and implement user data verification
    return null;
  }
}
