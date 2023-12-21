import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> taskList = [];
  final db = DbHelper();


  Future<int> insertTask(TaskModel taskModel) async {
    final rowId = await db.insertTask(taskModel);
    taskModel.id = rowId;
    taskList.add(taskModel);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllTasks() async {
    taskList = await db.getAllTasks();
    notifyListeners();
  }

  Future<void> getAllDoneTasks() async {
    taskList = await db.getAllDoneTasks();
    notifyListeners();
  }

  Future<TaskModel> getTaskById(int id) => db.getTaskById(id);

  Future<int> deleteTask(int id) {
    return db.deleteTask(id);
  }

  Future<void> updateTaskField(TaskModel taskModel, String field) async {
    await db.updateTaskField(taskModel.id, {field : taskModel.status ? 0 : 1});
    final index = taskList.indexOf(taskModel);
    taskList[index].status = !taskList[index].status;
    notifyListeners();
  }

}