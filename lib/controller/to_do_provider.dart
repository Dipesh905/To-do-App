import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/model/to_do_model.dart';
import 'package:todoapp/view/screens/home_screen.dart';

Stream<List<ToDoModel>> _fetchToDoLists() =>
    firebaseInstance.collection('Todolist').snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    ToDoModel.fromJson(e.data()),
              )
              .toList(),
        );

final StreamProvider<List<ToDoModel>> toDoProvider =
    StreamProvider<List<ToDoModel>>(
  (StreamProviderRef<List<ToDoModel>> ref) => _fetchToDoLists(),
);
