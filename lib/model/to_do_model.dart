class ToDoModel {
  String title;
  String remarks;
  String createdOn;
  String? lastModifiedOn;
  String toDoStatus;

  ToDoModel(
      {required this.title,
      required this.remarks,
      required this.createdOn,
      required this.toDoStatus,
      this.lastModifiedOn});

  ToDoModel.fromJson(Map<String, dynamic> json)
      : title = json['todotitle'] as String,
        remarks = json['remarks'] as String,
        lastModifiedOn = json['lastModifiedOn'] as String?,
        toDoStatus = json['toDoStatus'] as String,
        createdOn = json['createdOn'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'todotitle': title,
        'remarks': remarks,
        'createdOn': createdOn,
        'lastModifiedOn': lastModifiedOn,
        'toDoStatus': toDoStatus
      };
}
