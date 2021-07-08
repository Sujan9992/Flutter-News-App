import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'news.db';
  static final _dbVer = 1;
  static final _tableName = 'newsData';
  static final columnId = '_id';
  static final title = 'title';
  static final description = 'description';
  static final content = 'content';
  static final urlToImage = 'urlToImage';
  static final author = 'author';
  static final publishedAt = 'publishedAt';

  DatabaseHelper._constructor();

  static final DatabaseHelper instance = DatabaseHelper._constructor();

  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDatabase();
    return _db;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVer,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''
      CREATE TABLE $_tableName (
      $columnId INTEGER PRIMARY KEY,
      $title TEXT NOT NULL,
      $description TEXT NOT NULL,
      $content TEXT NOT NULL,
      $urlToImage TEXT NOT NULL,
      $author TEXT NOT NULL,
      $publishedAt TEXT NOT NULL )
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    return await db!.query(_tableName);
  }

  Future update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!
        .delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
