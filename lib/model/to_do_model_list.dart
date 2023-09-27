import 'package:todoapp/model/to_do_model.dart';

class ToDoModelList {
  ToDoModelList({required this.todoModelList});

  factory ToDoModelList.fromJson(List<dynamic> json) => ToDoModelList(
        todoModelList: json
            .map((e) => ToDoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  List<ToDoModel> todoModelList;
}
