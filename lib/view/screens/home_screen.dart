import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/controller/to_do_provider.dart';
import 'package:todoapp/controller/to_do_status_provider.dart';
import 'package:todoapp/model/to_do_model.dart';
import 'package:todoapp/view/screens/details_screen.dart';
import 'package:todoapp/view/widgets/button_widget.dart';
import 'package:todoapp/view/widgets/input_field_widget.dart';

/// firebaseFirestore Instance
final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

class HomeScreen extends ConsumerWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  addTodo({required ToDoModel toDoModel}) {
    DocumentReference ref = firebaseInstance
        .collection("Todolist")
        .doc(toDoModel.toJson()['createdOn']);

    ref.set(toDoModel.toJson()).whenComplete(() => print("added sucessfully"));
  }

  deleteTodo(String todocreatedOn) {
    DocumentReference ref =
        firebaseInstance.collection("Todolist").doc(todocreatedOn);

    ref.delete().whenComplete(() => print("$todocreatedOn deleted"));
  }

  final TextEditingController _toDoTitleController = TextEditingController();
  final TextEditingController _toDoRemarksController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ToDoModel>> toDoLists = ref.watch(toDoProvider);

    final List<ToDoModel> notStartedtoDoLists =
        ref.watch(notStartedToDoProvider);
    final List<ToDoModel> inprogresstoDoLists =
        ref.watch(inProgressToDoProvider);
    final List<ToDoModel> completedtoDoLists = ref.watch(completedToDoProvider);
    final User user = FirebaseAuth.instance.currentUser!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('${user.email}'),
              accountName: Text('User Email'),
              currentAccountPicture: CircleAvatar(
                child: Text('E'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
            )
          ],
        )),
        appBar: AppBar(
          title: Text("Simple To do App"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Text('All')),
              Tab(icon: Text('Not Started')),
              Tab(icon: Text('In Progress')),
              Tab(icon: Text('Completed')),
            ],
          ),
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
                    content: Consumer(
                      builder: (context, ref, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InputFieldWidget(
                              controller: _toDoTitleController,
                              labelText: "To do title",
                              validator: (value) =>
                                  value == null ? "Enter the title" : null,
                            ),
                            InputFieldWidget(
                              controller: _toDoRemarksController,
                              labelText: "Remarks",
                              validator: (value) =>
                                  value == null ? "Enter the Remarks" : null,
                            ),
                            Row(
                              children: <Widget>[
                                const Text('To Do Status: '),
                                Expanded(
                                  child: DropdownButton<String>(
                                    underline: const SizedBox.shrink(),
                                    value: ref.watch(todoStatusProvider),
                                    onChanged: (String? value) {
                                      ref
                                          .read(todoStatusProvider.notifier)
                                          .update(
                                            (state) => value!,
                                          );
                                    },
                                    items: const <DropdownMenuItem<String>>[
                                      DropdownMenuItem<String>(
                                        value: 'not_started',
                                        child: Text('Not Started'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'in_progress',
                                        child: Text('In Progress'),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'completed',
                                        child: Text('Completed'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
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
                                      createdOn: DateTime.now().toString(),
                                      toDoStatus: ref.watch(todoStatusProvider),
                                    ));

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
        body: TabBarView(
          children: [
            toDoLists.when(
              data: (toDodatas) {
                return toDodatas.isNotEmpty
                    ? ListView.builder(
                        itemCount: toDodatas.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  toDoModel: toDodatas[index],
                                ),
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      deleteTodo(
                                          '${toDodatas[index].createdOn}');
                                    },
                                    icon: Icon(Icons.delete)),
                                title: Text(toDodatas[index].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(toDodatas[index].remarks),
                                    LinearProgressIndicator(
                                        backgroundColor: Colors.blue.shade100,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                toDodatas[index].toDoStatus ==
                                                        'not_started'
                                                    ? Colors.blue
                                                    : toDodatas[index]
                                                                .toDoStatus ==
                                                            'in_progress'
                                                        ? Colors.yellow
                                                        : Colors.green),
                                        value: toDodatas[index].toDoStatus ==
                                                'not_started'
                                            ? 0.1
                                            : toDodatas[index].toDoStatus ==
                                                    'in_progress'
                                                ? 0.5
                                                : 1),
                                  ],
                                ),
                              ),
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
            notStartedtoDoLists.isNotEmpty
                ? ListView.builder(
                    itemCount: notStartedtoDoLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              toDoModel: notStartedtoDoLists[index],
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteTodo(
                                      '${notStartedtoDoLists[index].createdOn}');
                                },
                                icon: Icon(Icons.delete)),
                            title: Text(notStartedtoDoLists[index].title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(notStartedtoDoLists[index].remarks),
                                LinearProgressIndicator(
                                    backgroundColor: Colors.blue.shade100,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            notStartedtoDoLists[index]
                                                        .toDoStatus ==
                                                    'not_started'
                                                ? Colors.blue
                                                : notStartedtoDoLists[index]
                                                            .toDoStatus ==
                                                        'in_progress'
                                                    ? Colors.yellow
                                                    : Colors.green),
                                    value:
                                        notStartedtoDoLists[index].toDoStatus ==
                                                'not_started'
                                            ? 0.1
                                            : notStartedtoDoLists[index]
                                                        .toDoStatus ==
                                                    'in_progress'
                                                ? 0.5
                                                : 1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('No Any Not Started To Do List Found'),
                    ),
                  ),
            inprogresstoDoLists.isNotEmpty
                ? ListView.builder(
                    itemCount: inprogresstoDoLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              toDoModel: inprogresstoDoLists[index],
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteTodo(
                                      '${inprogresstoDoLists[index].createdOn}');
                                },
                                icon: Icon(Icons.delete)),
                            title: Text(inprogresstoDoLists[index].title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(inprogresstoDoLists[index].remarks),
                                LinearProgressIndicator(
                                    backgroundColor: Colors.blue.shade100,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            inprogresstoDoLists[index]
                                                        .toDoStatus ==
                                                    'not_started'
                                                ? Colors.blue
                                                : inprogresstoDoLists[index]
                                                            .toDoStatus ==
                                                        'in_progress'
                                                    ? Colors.yellow
                                                    : Colors.green),
                                    value:
                                        inprogresstoDoLists[index].toDoStatus ==
                                                'not_started'
                                            ? 0.1
                                            : inprogresstoDoLists[index]
                                                        .toDoStatus ==
                                                    'in_progress'
                                                ? 0.5
                                                : 1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('No Any In Progress To Do List Found'),
                    ),
                  ),
            completedtoDoLists.isNotEmpty
                ? ListView.builder(
                    itemCount: completedtoDoLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              toDoModel: completedtoDoLists[index],
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteTodo(
                                      '${completedtoDoLists[index].createdOn}');
                                },
                                icon: Icon(Icons.delete)),
                            title: Text(completedtoDoLists[index].title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(completedtoDoLists[index].remarks),
                                LinearProgressIndicator(
                                    backgroundColor: Colors.blue.shade100,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            completedtoDoLists[index]
                                                        .toDoStatus ==
                                                    'not_started'
                                                ? Colors.blue
                                                : completedtoDoLists[index]
                                                            .toDoStatus ==
                                                        'in_progress'
                                                    ? Colors.yellow
                                                    : Colors.green),
                                    value:
                                        completedtoDoLists[index].toDoStatus ==
                                                'not_started'
                                            ? 0.1
                                            : completedtoDoLists[index]
                                                        .toDoStatus ==
                                                    'in_progress'
                                                ? 0.5
                                                : 1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('No Any Completed To Do List Found'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
