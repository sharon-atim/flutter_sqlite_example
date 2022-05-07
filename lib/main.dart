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
      await addUsers(); // When the future is complete, addUsers to database.
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqlite Demo'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder(
          future: handler.retrieveUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await handler.deleteUser(snapshot.data![index].id!);
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                        child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].age.toString()),
                    )),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
