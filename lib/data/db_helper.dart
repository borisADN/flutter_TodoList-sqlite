


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, done INTEGER)');
      },
    );
  }

  static Future<int>addTask(String task) async {
    final db = await getDatabase();
    return await db.insert('todos',{'task': task, 'done': 0});
    // await db.execute('INSERT INTO todos (task, done) VALUES (?, 0)', [task]);
    // db.close();
  }


  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await getDatabase();
    return await db.query('todos');
  }

  static Future<int> deleteTask(int id) async {
    final db = await getDatabase();
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateTask(int id, int done) async {
    final db = await getDatabase();
   return await db.update('todos', {'done': done}, where: 'id = ?', whereArgs: [id]);
  }
}
