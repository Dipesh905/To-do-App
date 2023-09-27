class ToDoModel {
  String title;
  String remarks;

  ToDoModel({required this.title, required this.remarks});

  ToDoModel.fromJson(Map<String, dynamic> json)
      : title = json['todotitle '] as String,
        remarks = json['remarks'] as String;
}
