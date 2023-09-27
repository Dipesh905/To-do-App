import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/controller/to_do_provider.dart';
import 'package:todoapp/model/to_do_model.dart';

/// firebaseFirestore Instance
final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

class HomeScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ToDoModel>> toDoLists = ref.watch(toDoProvider);
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
      body: toDoLists.when(
        data: (toDodatas) {
          return ListView.builder(
            itemCount: toDodatas.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(toDodatas[index].title),
                subtitle: Text(toDodatas[index].remarks),
              );
            },
          );
        },
        error: (error, stackTrace) {
          print('========$error==============');
          return Text('SomeThing Went Wrong, please try Again Later');
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
