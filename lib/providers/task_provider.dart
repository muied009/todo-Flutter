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
    await db.updateTaskField(taskModel.id, {field: taskModel.status ? 0 : 1});
    final index = taskList.indexOf(taskModel);
    taskList[index].status = !taskList[index].status;
    notifyListeners();
  }

  Future<void> updateTask(TaskModel taskModel) async {
    final updatedStatus = taskModel.status ? 1 : 0;

    await db.updateTaskField(taskModel.id, {
      tblTaskColTitle: taskModel.title,
      tblTaskColDescription: taskModel.description,
      tblTaskColStatus: updatedStatus,
    });

    // Find the index of the updated task in the taskList
    final index = taskList.indexWhere((task) => task.id == taskModel.id);

    if (index != -1) {
      // Update only the necessary fields in the task in the taskList
      taskList[index].title = taskModel.title;
      taskList[index].description = taskModel.description;
      taskList[index].status = taskModel.status;

      // Notify listeners that the taskList has been updated
      notifyListeners();
    }
  }

  void sortTasks(bool isAscending) {
    taskList.sort((a, b) {
      final result = a.title.compareTo(b.title);
      return isAscending ? result : -result;
    });
    notifyListeners();
  }

}
