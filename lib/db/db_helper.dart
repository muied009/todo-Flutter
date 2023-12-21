import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:todo/model/task_model.dart';

class DbHelper {
  final String _createTaskTable = """create table $taskTable(
  $tblTaskColId integer primary key autoincrement,
  $tblTaskColTitle text,
  $tblTaskColDescription text,
  $tblTaskColStatus integer)""";
  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = p.join(root, "task.db");
    return openDatabase(dbPath,version: 1 , onCreate: (db, version){
      db.execute(_createTaskTable);
    },);
  }

  Future<List<TaskModel>> getAllDoneTasks() async {
    final db = await _open();
    final mapList = await db.query(taskTable, where: '$tblTaskColStatus = ?', whereArgs: [1]);
    return List.generate(mapList.length, (index) => TaskModel.fromMap(mapList[index]));
  }


  Future<int> insertTask(TaskModel taskModel) async {
    final db = await _open();
    return db.insert(taskTable, taskModel.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await _open();
    final mapList = await db.query(taskTable);
    return List.generate(mapList.length, (index) => TaskModel.fromMap(mapList[index]));
  }

  Future<TaskModel> getTaskById(int id) async {
    final db = await _open();
    final mapList = await db.query(taskTable, where: '$tblTaskColId = ?', whereArgs: [id]);
    return TaskModel.fromMap(mapList.first);
  }

  Future<int> deleteTask(int id) async {
    final db = await _open();
    return db.delete(taskTable, where: '$tblTaskColId = ?', whereArgs: [id]);
  }

  Future<int> updateTaskField(int id, Map<String, dynamic> map) async {
    final db = await _open();
    return db.update(taskTable, map, where: '$tblTaskColId = ?', whereArgs: [id]);
  }
}