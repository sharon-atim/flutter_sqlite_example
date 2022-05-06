import 'package:flutter/material.dart';
import 'package:sqlite_tutorial/models/user_model.dart';

import 'services/database_handler.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler(); // Instance of the DatabaseHandler class
    handler.initializeDB().whenComplete(() async {
      // Initializes the DB handler.
      await addUsers(); // When the future is complete, addUsers is called.
      setState(() {});
    });
  }

  // This function adds two users to the list then calls the insertUser method.
  Future<int> addUsers() async {
    User firstUser = User(name: "Hannah", age: 24, country: 'United Kingdom');
    User secondUser = User(name: "John", age: 30, country: 'United Kingdom');
    List<User> listOfUsers = [firstUser, secondUser];
    return await handler.insertUser(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp();
  }
}
