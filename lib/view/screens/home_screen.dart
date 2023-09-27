import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/controller/to_do_provider.dart';
import 'package:todoapp/model/to_do_model.dart';
import 'package:todoapp/view/widgets/button_widget.dart';
import 'package:todoapp/view/widgets/input_field_widget.dart';

/// firebaseFirestore Instance
final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

class HomeScreen extends ConsumerWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  addTodo({required ToDoModel toDoModel}) {
    DocumentReference ref = firebaseInstance
        .collection("Todolist")
        .doc(toDoModel.toJson()['todotitle'] + toDoModel.toJson()['createdOn']);

    ref.set(toDoModel.toJson()).whenComplete(() => print("added sucessfully"));
  }

  deleteTodo(String uniqueTitleAndDate) {
    DocumentReference ref =
        firebaseInstance.collection("Todolist").doc(uniqueTitleAndDate);

    ref.delete().whenComplete(() => print("$uniqueTitleAndDate deleted"));
  }

  final TextEditingController _toDoTitleController = TextEditingController();
  final TextEditingController _toDoRemarksController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ToDoModel>> toDoLists = ref.watch(toDoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple To do App"),
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
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InputFieldWidget(
                        controller: _toDoTitleController,
                        hintText: "To do title",
                        //  decoration: InputDecoration(hintText: ),
                        validator: (value) =>
                            value == null ? "Enter the title" : null,
                      ),
                      InputFieldWidget(
                        controller: _toDoRemarksController,
                        hintText: "Remarks",
                        // decoration: InputDecoration(hintText: "Remarks"),
                        validator: (value) =>
                            value == null ? "Enter the Remarks" : null,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonWidget(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              buttonTitle: 'Cancel'),
                          ButtonWidget(
                              onPressed: () {
                                if (_globalKey.currentState!.validate()) {
                                  addTodo(
                                      toDoModel: ToDoModel(
                                          title: _toDoTitleController.text,
                                          remarks: _toDoRemarksController.text,
                                          createdOn:
                                              DateTime.now().toString()));

                                  _toDoTitleController.clear();
                                  _toDoRemarksController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              buttonTitle: "Add"),
                        ],
                      ),
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
          return toDodatas.isNotEmpty
              ? ListView.builder(
                  itemCount: toDodatas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              deleteTodo(
                                  '${toDodatas[index].title}${toDodatas[index].createdOn}');
                            },
                            icon: Icon(Icons.delete)),
                        title: Text(toDodatas[index].title),
                        subtitle: Text(toDodatas[index].remarks),
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                        'Empty to do list, Add new by tapping + button in bottom right corner'),
                  ),
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
