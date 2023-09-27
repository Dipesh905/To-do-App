import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// firebaseFirestore Instance
final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

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
        firebaseInstance.collection("Todolist").doc(newinput);

    Map<String, String> todolist = {"todotitle ": newinput, "remarks": remarks};

    ref.set(todolist).whenComplete(() => print("$newinput created"));
  }

  deleteTodo(item) {
    DocumentReference ref = firebaseInstance.collection("Todolist").doc(item);

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
                              value == null ? "Enter the title" : null,
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Remarks"),
                          onChanged: (String value) {
                            remarks = value;
                          },
                          validator: (value) =>
                              value == null ? "Enter the Remarks" : null,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("(App By ghimiredipesh5@gmail.com)")
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
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
        stream: firebaseInstance.collection("Todolist").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
            // return ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: snapshot.data.documents.length,
            //   itemBuilder: (context, index) {
            //     DocumentSnapshot documentSnapshot =
            //         snapshot.data.documents[index];
            //     return Card(
            //       elevation: 3.0,
            //       child: ListTile(
            //         title: Text(documentSnapshot['todotitle ']),
            //         subtitle: Text(documentSnapshot['remarks']),
            //         leading: CircleAvatar(
            //           child: Text("${index + 1}"),
            //         ),
            //         trailing: IconButton(
            //           icon: Icon(Icons.delete),
            //           onPressed: () {
            //             deleteTodo(
            //               documentSnapshot['todotitle '],
            //             );
            //           },
            //         ),
            //       ),
            //     );
            //   },
            // );
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
