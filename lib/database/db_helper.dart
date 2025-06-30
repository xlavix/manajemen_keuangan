import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE finance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        nominal TEXT,
        description TEXT,
        date TEXT
      );
    ''');
  }

  Future<void> registerUser(User user) async {
    final db = await database;

    final existing = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [user.username],
    );

    if (existing.isNotEmpty) {
      throw Exception("Username already exists");
    }

    await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> insertFinance(Map<String, dynamic> finance) async {
    final db = await database;
    return await db.insert('finance', finance);
  }

  Future<int> updateFinance(Map<String, dynamic> finance) async {
    final db = await database;
    return await db.update(
      'finance',
      finance,
      where: 'id = ?',
      whereArgs: [finance['id']],
    );
  }

  Future<int> deleteFinance(int id) async {
    final db = await database;
    return await db.delete(
      'finance',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllFinance() async {
    final db = await database;
    return await db.query('finance');
  }

  // Tambahan: Hapus akun
  Future<int> deleteUserByUsername(String username) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
