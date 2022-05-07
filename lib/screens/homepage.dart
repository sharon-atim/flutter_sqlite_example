import 'package:flutter/material.dart';
import 'dart:math';

import '../models/user_model.dart';
import '../services/database_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Random color generator for leading circle avatar.
  final List<Color> avatarColors = [
    Colors.blue,
    Colors.blueAccent.shade700,
    Colors.blueGrey,
    Colors.lightBlue.shade400
  ];
  Color randomColorGenerator() {
    return avatarColors[Random().nextInt(2)];
  }

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
    User secondUser = User(name: "Himari", age: 30, country: 'Japan');
    User thirdUser = User(name: "Sophia", age: 30, country: 'Greece');
    User fourthUser = User(name: "Andrea", age: 28, country: 'Italy');
    User fifthUser = User(name: "Bruno", age: 43, country: 'Canada');

    List<User> listOfUsers = [
      firstUser,
      secondUser,
      thirdUser,
      fourthUser,
      fifthUser
    ];
    return await handler.insertUser(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sqlite Demo'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Column(
          children: <Widget>[
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: const Text(
                'Swipe left to delete',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: handler.retrieveUsers(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                            leading: CircleAvatar(
                                backgroundColor: randomColorGenerator()),
                            title: Text(snapshot.data![index].name),
                            subtitle:
                                Text(snapshot.data![index].age.toString()),
                            trailing:
                                Text(snapshot.data![index].country.toString()),
                          )),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ));
  }
}
