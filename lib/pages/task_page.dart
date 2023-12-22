import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/extensions.dart';

class TaskPage extends StatefulWidget {
  final TaskModel? taskModel;

  const TaskPage({Key? key, this.taskModel}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Set initial values if taskModel is provided
    if (widget.taskModel != null) {
      titleController.text = widget.taskModel!.title;
      descriptionController.text = widget.taskModel!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task"),
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () => _updateTheTask(),
            child: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    prefixIcon: Icon(Icons.title),
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
                    prefixIcon: Icon(Icons.description),
                    filled: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTheTask() {
    if (widget.taskModel == null) {
      // Create a new task if taskModel is not available
      if (formKey.currentState!.validate()) {
        final newTask = TaskModel(
          title: titleController.text,
          description: descriptionController.text,
        );

        // Perform any additional logic for creating a new task
        Provider.of<TaskProvider>(context, listen: false)
            .insertTask(newTask)
            .then((rowId) {
          if (rowId > 0) {
            // Show a message or perform other actions
            showMsg(context, 'Task Created');
            Navigator.pop(context); // Navigate back to the previous screen
          }
        });
      }
    } else {
      // Update an existing task if taskModel is available
      final updatedTask = TaskModel(
        id: widget.taskModel!.id,
        title: titleController.text,
        description: descriptionController.text,
      );

      // Perform any additional logic for updating an existing task
      Provider.of<TaskProvider>(context, listen: false)
          .updateTask(updatedTask)
          .then((_) {
        // Show a message or perform other actions
        showMsg(context, 'Task Updated');
        Navigator.pop(context); // Navigate back to the previous screen
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
