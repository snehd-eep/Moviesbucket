import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'movies.dart';

class DatabaseManager {
  static final _dbName = "Movies.db";

  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database? _database = null;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    print('created');
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creates the database structure
  Future _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute('''CREATE TABLE Movies(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            image TEXT,
            director TEXT 

          )''');
  }

  Future<List<movies>> fetchAllMovies() async {
    Database database = _database!;
    List<Map<String, dynamic>> maps = await database.query('Movies');

    return maps.map((map) => movies.fromDbMap(map)).toList() != null
        ? maps.map((map) => movies.fromDbMap(map)).toList()
        : [];
  }

  Future<int> addMovies(movies movies) async {
    Database database = _database!;

    return database.insert(
      'Movies',
      movies.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMovie(movies movie) async {
    Database database = _database!;
    return database.update(
      'Movies',
      movie.toDbMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteMovies(int id) async {
    Database database = _database!;
    return database.delete(
      'Movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
