// qjpli-quizprogram/lib/controllers/sql_controller.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quizprogram/models/user_model.dart';

class SQLController {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        ${UserFields.id} TEXT PRIMARY KEY,
        ${UserFields.name} TEXT NOT NULL,
        ${UserFields.username} TEXT NOT NULL,
        ${UserFields.password} TEXT NOT NULL,
        ${UserFields.createdAt} TEXT
      )
      ''');
  }
}
