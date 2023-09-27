import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/model/to_do_model.dart';
import 'package:todoapp/view/widgets/button_widget.dart';
import 'package:todoapp/view/widgets/input_field_widget.dart';

class EditToDOScreen extends StatelessWidget {
  EditToDOScreen({
    required this.toDoModel,
    super.key,
  });

  final ToDoModel toDoModel;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _toDoTitleController =
        TextEditingController(text: toDoModel.title);
    TextEditingController _toDoRemarksController =
        TextEditingController(text: toDoModel.remarks);
    final todoStatusUpdateProvider = StateProvider<String>(
      (ref) => toDoModel.toDoStatus,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Update To Do'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InputFieldWidget(
              controller: _toDoTitleController,
              labelText: "To do title",
              validator: (value) => value == null ? "Enter the title" : null,
            ),
            InputFieldWidget(
              controller: _toDoRemarksController,
              labelText: "Remarks",
              validator: (value) => value == null ? "Enter the Remarks" : null,
            ),
            Consumer(
              builder: (context, ref, child) {
                return Column(
                  children: [
                    Row(
                      children: <Widget>[
                        const Text('To Do Status: '),
                        Expanded(
                          child: DropdownButton<String>(
                            underline: const SizedBox.shrink(),
                            value: ref.watch(todoStatusUpdateProvider),
                            onChanged: (String? value) {
                              ref
                                  .read(todoStatusUpdateProvider.notifier)
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
                    ButtonWidget(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            updateToDoData(
                              updatedToDomdel: ToDoModel(
                                title: _toDoTitleController.text,
                                remarks: _toDoRemarksController.text,
                                createdOn: DateTime.now().toString(),
                                toDoStatus: ref.watch(todoStatusUpdateProvider),
                              ),
                            );

                            _toDoTitleController.clear();
                            _toDoRemarksController.clear();
                            Navigator.pop(context);
                          }
                        },
                        buttonTitle: "Update To Do"),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  updateToDoData({required ToDoModel updatedToDomdel}) {
    print(
        '==============${toDoModel.title}${toDoModel.createdOn}===============');
    var collection = FirebaseFirestore.instance.collection('Todolist');
    collection
        .doc('${toDoModel.title}${toDoModel.createdOn}')
        .update(updatedToDomdel.toJson());
  }
}
