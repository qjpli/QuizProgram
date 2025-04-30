// THIS PROVIDER HANDLES THE OVERALL USERS
import 'package:flutter/material.dart';
import 'package:quizprogram/models/user_model.dart';
import 'package:quizprogram/controllers/user_controller.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  final UserController _userController = UserController();
  final _uuid = Uuid();

  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<UserModel?> createUser({
    required String name,
    required String username,
    required String password,
  }) async {
    try {
      final id = _uuid.v4();
      final newUser = UserModel(
        id: id,
        name: name,
        username: username,
        password: password,
      );

      await _userController.insertUser(newUser);
      _users.add(newUser);
      notifyListeners();

      return newUser;
    } catch (e) {
      print('Error encountered while creating: $e');

      return null;
    }
  }

  Future<void> fetchUsers() async {
    _users = await _userController.getAllUsers();
    notifyListeners();
  }

  Future<bool> isUserExisting(String username) async {
    bool notExisting = false;

    if (_users.any((element) =>
        element.username.toLowerCase() == username.trim().toLowerCase())) {
      notExisting = true;
    }

    return notExisting;
  }
}
