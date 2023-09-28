import 'package:flutter/material.dart';
import 'package:todoapp/model/to_do_model.dart';
import 'package:todoapp/view/screens/edit_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    required this.toDoModel,
    super.key,
  });

  final ToDoModel toDoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Details'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditToDOScreen(
                      toDoModel: toDoModel,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${toDoModel.title} '),
            Text('Remarks: ${toDoModel.remarks} '),
            Text('Created On: ${toDoModel.createdOn}'),
            Text(
                'To Do Status: ${toDoModel.toDoStatus == 'not_started' ? 'Not Started' : toDoModel.toDoStatus == 'in_progress' ? 'In Progress' : 'Completed'} '),
            if (toDoModel.lastModifiedOn != null) ...{
              Text('Last Modified On: ${toDoModel.lastModifiedOn}')
            }
          ],
        ),
      ),
    );
  }
}
