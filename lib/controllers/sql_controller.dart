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
    // Users
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    // Quiz Categories
    await db.execute('''
    CREATE TABLE quiz_categories (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      is_available INTEGER NOT NULL,
      svg_icon TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    // Quizzes
    await db.execute('''
    CREATE TABLE quizzes (
      id TEXT PRIMARY KEY,
      quiz_category_id TEXT NOT NULL,
      created_by TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      difficulty TEXT,
      total_takers INTEGER DEFAULT 0,
      is_available INTEGER NOT NULL,
      max_time_per_question INTEGER NOT NULL,
      randomize_question INTEGER NOT NULL,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    // Quiz Questions
    await db.execute('''
    CREATE TABLE quiz_questions (
      id TEXT PRIMARY KEY,
      quiz_id TEXT NOT NULL,
      question TEXT NOT NULL,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    // Quiz Question Choices
    await db.execute('''
    CREATE TABLE quiz_question_choices (
      id TEXT PRIMARY KEY,
      quiz_question_id TEXT NOT NULL,
      value TEXT NOT NULL,
      is_correct INTEGER NOT NULL,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    // Quiz Takers
    await db.execute('''
    CREATE TABLE quiz_takers (
      id TEXT PRIMARY KEY,
      quiz_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      displayname TEXT NOT NULL,
      avatar_used TEXT NOT NULL,
      points REAL NOT NULL,
      created_at TEXT,
      updated_at TEXT
    )
  ''');
  }

}
