class ToDoModel {
  String title;
  String remarks;
  String createdOn;

  ToDoModel(
      {required this.title, required this.remarks, required this.createdOn});

  ToDoModel.fromJson(Map<String, dynamic> json)
      : title = json['todotitle'] as String,
        remarks = json['remarks'] as String,
        createdOn = json['createdOn'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'todotitle': title,
        'remarks': remarks,
        'createdOn': createdOn
      };
}
