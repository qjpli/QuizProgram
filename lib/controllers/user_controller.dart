import 'package:quizprogram/models/user_model.dart';
import 'package:quizprogram/controllers/sql_controller.dart';
import 'package:sqflite/sqflite.dart';

class UserController {
  final SQLController _sqlController = SQLController();

  Future<UserModel> insertUser(UserModel user) async {
    final Database db = await _sqlController.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<UserModel?> getUser(String id) async {
    final Database db = await _sqlController.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final Database db = await _sqlController.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final Database db = await _sqlController.database;
    return await db.update(
      'users',
      user.toMap(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String id) async {
    final Database db = await _sqlController.database;
    return await db.delete(
      'users',
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<UserModel?> authenticateUser(String username, String password) async {
    final Database db = await _sqlController.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: '${UserFields.username} = ? AND ${UserFields.password} = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      print('Empty');
    }
    return null;
  }
}
