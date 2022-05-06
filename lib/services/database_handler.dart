import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

// Takes care of all the operations regarding SQLite database.
class DatabaseHandler {
// This async function initializes the database, opens it then creates a table.
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath(); // Gets the database location.
    return openDatabase(
      // Opens the database at the given path.
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          // Executes SQL query.
          // Creates a table
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
      version: 1,
    );
  }

// This async function inserts users inside the table we just created above.
  Future<int> insertUser(List<User> users) async {
    int result = 0; // Initial value for result is 0.
    final Database db = await initializeDB();
    for (var user in users) {
      //For each user in the Users List, insert each user ot the table users.
      result = await db.insert('users', user.toMap());
    }
    return result;
    // Result = inserted map of users data
  }

// This async function retrieves data from the users table.
  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('users'); // Queries the 'users' table.
// For each element in the query result list, transform into a list.
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

// This async function deletes data from the database.
  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
