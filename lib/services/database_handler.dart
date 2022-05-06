import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Takes care of all the operations regarding SQLite database.
class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath(); //
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          // Creates a table
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
      version: 1,
    );
  }
}
