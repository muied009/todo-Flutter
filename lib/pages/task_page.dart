import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/home_page.dart';

import '../model/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/extensions.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String title = "",
      description = "";
  late TaskModel taskModel;

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is TaskModel) {
      taskModel = arguments;
      titleController.text = taskModel.title;
      descriptionController.text = taskModel.description;
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
        elevation: 1,
        actions: [
          TextButton(onPressed: () => _createTheTask(),
              child: const Icon(Icons.save))
        ],
      ),
      body: SafeArea(
        child: Form(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    prefixIcon: Icon(Icons.call),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.call),
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ),),
    );
  }
  @override
  void dispose() {
    // 1 kind of lifecycle method
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  _createTheTask() async {
    final taskModel = TaskModel(
      title: title,
      description: description,
    );

    taskModel.title = titleController.text;
    taskModel.description = descriptionController.text;
    Provider.of<TaskProvider>(context, listen: false)
        .insertTask(taskModel)
        .then((rowId) {
      if (rowId > 0) {
        showMsg(context, 'Saved');
        Navigator.pop(context);
        print(Navigator.of(context).toString());//homepage na asa porjonto pop korte thakbe
      }
    });
  }
}
