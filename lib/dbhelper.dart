import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class dbHelper {
  static final dbHelper instance = dbHelper._init();

  static Database? _database;

  dbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finances.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await  getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);
    final db = sqlite3.open(path);

    await createTables(db);

    return db;
  }

  Future<void> createTables(Database db) async {
    db.execute('''
      CREATE TABLE IF NOT EXISTS finances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        nominal TEXT NOT NULL,
        description TEXT NOT NULL
        )
   ''');
  }

  Future<void> insertFinance(Map<String, dynamic> finance) async {
    final db = await database;
    db.execute('''
      INSERT INTO finances (type, nominal, description) VALUES (?, ?, ?)
    ''', [finance['type'], finance['nominal'], finance['description']]);
  }

  Future<List<Map<String, dynamic>>> getFinances() async {
    final db = await database;
    final result = db.select('SELECT * FROM finances');
    return result.map((row) => {
      'id': row['id'],
      'type': row['type'],
      'nominal': row['type'],
      'description': row['description']
    }).toList();
  }

  Future<void> updateFinance(Map<String, dynamic> finance) async {
    final db = await database;
    print('Updating finance with id: ${finance['id']}, Type: ${finance['id'].runtimeType}');
    db.execute('''
      UPDATE finances SET type = ?, nominal = ?, description = ? WHERE id = ?
    ''', [finance['type'], finance['nominal'], finance['description']]);
    print('Updated finance: $finance');
  }

  Future<void> deleteFinance(int id) async {
    final db = await database;
    db.execute('DELETE FROM finances WHERE id = ?', [id]);
  }
}