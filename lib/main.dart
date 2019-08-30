import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Users List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUserList() async {
    var data = await http.get("https://reqres.in/api/users?page=1&per_page=12");

    var jsonData = json.decode(data.body)["data"];

    List<User> userList = [];

    for (var u in jsonData) {
      User user = User(
          u["id"], u["email"], u["first_name"], u["last_name"], u["avatar"]);
      userList.add(user);
    }

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    _getUserList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUserList(),
          builder: (BuildContext cxt, AsyncSnapshot itens) {
            if (itens.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: itens.data.length,
                itemBuilder: (BuildContext ctx2, int index) {
                  return Card(
                    elevation: 6,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(itens.data[index].avatar),
                        maxRadius: 25,
                      ),
                      title: Text(
                          '${itens.data[index].firstName} ${itens.data[index].lastName}'),
                      subtitle: Text(itens.data[index].email),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User(this.id, this.email, this.firstName, this.lastName, this.avatar);
}
