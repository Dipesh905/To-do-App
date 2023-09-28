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

final Provider<List<ToDoModel>> allToDosProvider =
    Provider<List<ToDoModel>>((ProviderRef<Object?> ref) {
  final AsyncValue<List<ToDoModel>> todos = ref.watch(toDoProvider);

  return todos.when(
    data: (List<ToDoModel> data) => data.reversed.toList(),
    error: (Object error, StackTrace stackTrace) {
      return <ToDoModel>[];
    },
    loading: () => <ToDoModel>[],
  );
});

final Provider<List<ToDoModel>> notStartedToDoProvider =
    Provider<List<ToDoModel>>((ProviderRef<Object?> ref) {
  final List<ToDoModel> allToDos = ref.watch(allToDosProvider);

  return allToDos
      .where(
        (ToDoModel element) => element.toDoStatus.contains('not_started'),
      )
      .toList();
});

final Provider<List<ToDoModel>> inProgressToDoProvider =
    Provider<List<ToDoModel>>((ProviderRef<Object?> ref) {
  final List<ToDoModel> allToDos = ref.watch(allToDosProvider);

  return allToDos
      .where(
        (ToDoModel element) => element.toDoStatus.contains('in_progress'),
      )
      .toList();
});

final Provider<List<ToDoModel>> completedToDoProvider =
    Provider<List<ToDoModel>>((ProviderRef<Object?> ref) {
  final List<ToDoModel> allToDos = ref.watch(allToDosProvider);

  return allToDos
      .where(
        (ToDoModel element) => element.toDoStatus.contains('completed'),
      )
      .toList();
});
