const String taskTable = "Task_Table";
const String tblTaskColId = "id";
const String tblTaskColTitle = "title";
const String tblTaskColDescription = "description";
const String tblTaskColStatus = "status";

class TaskModel {
  int id;
  String title;
  String description;
  bool status;

  TaskModel(
      {this.id = -1,
      required this.title,
      required this.description,
      this.status = false});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblTaskColTitle: title,
      tblTaskColDescription: description,
      tblTaskColStatus: status ? 1 : 0,
    };
    if (id > 0) {
      map[tblTaskColId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, status: $status}';
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map[tblTaskColId],
        title: map[tblTaskColTitle],
        description: map[tblTaskColDescription],
        status: map[tblTaskColStatus] == 1 ? true : false,
      );
}
