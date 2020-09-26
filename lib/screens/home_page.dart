import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String newinput = "";
  String remarks = "";

  GlobalKey<FormState> _globalKey = GlobalKey();

  addTodo() {
    DocumentReference ref =
        Firestore.instance.collection("Todolist").document(newinput);

    Map<String, String> todolist = {"todotitle ": newinput, "remarks": remarks};

    ref.setData(todolist).whenComplete(() => print("$newinput created"));
  }

  deleteTodo(item) {
    DocumentReference ref =
        Firestore.instance.collection("Todolist").document(item);

    ref.delete().whenComplete(() => print("$item deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To do App  (By Dipesh Ghimire)"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Form(
                key: _globalKey,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    "Add your Todo's",
                  ),
                  content: Container(
                    height: 160,
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: "To do title"),
                          onChanged: (String value) {
                            newinput = value;
                          },
                          validator: (value) =>
                              value.isEmpty ? "Enter the title" : null,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Remarks"),
                          onChanged: (String value) {
                            remarks = value;
                          },
                          validator: (value) =>
                              value.isEmpty ? "Enter the Remarks" : null,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("(App By ghimiredipesh5@gmail.com)")
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          if (_globalKey.currentState.validate()) {
                            addTodo();
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Ok")),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("Todolist").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot =
                    snapshot.data.documents[index];
                return Card(
                  elevation: 3.0,
                  child: ListTile(
                    title: Text(documentSnapshot['todotitle ']),
                    subtitle: Text(documentSnapshot['remarks']),
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTodo(
                          documentSnapshot['todotitle '],
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
