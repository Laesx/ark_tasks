import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "Ark.db";
  static const _databaseVersion = 1;

  static const table = 'task';

  // Maybe make this more modular to be able to support multiple tables

  // Or try to use https://isar.dev/tutorials/quickstart.html
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnData = 'data';
  static const columnCreatedAt = 'created_at';
  static const columnLastUpdated = 'last_updated';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await instance.database;
    return await db.insert(table, task);
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    Database db = await instance.database;
    return await db
        .update(table, task, where: '$columnId = ?', whereArgs: [task['id']]);
  }

  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // This can potentially cause issues
  Future<int?> countTasks() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // I think this is probably not necessary and can be done in the UI directly
  Future<List<Map<String, dynamic>>> queryTasksAfterDate(DateTime date) async {
    Database db = await instance.database;
    return await db.query(table,
        where: '$columnCreatedAt > ?', whereArgs: [date.toIso8601String()]);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnData TEXT NOT NULL,
            $columnCreatedAt TEXT NOT NULL,
            $columnLastUpdated TEXT NOT NULL
          )
          ''');
  }
}
