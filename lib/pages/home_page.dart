import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/task_page.dart';

import '../model/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<TaskProvider>(context, listen: false).getAllTasks();
    }
    isFirst = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        elevation: 1,
      ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskPage()));
          },
          child: const Icon(Icons.add),
        ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          if (provider.taskList.isEmpty) {
            return const Center(
              child: Text("Nothing to show"),
            );
          } else {
            return ListView.builder(
                itemCount: provider.taskList.length,
                itemBuilder: (context, index) {
                  final task = provider.taskList[index];
                  return Dismissible(
                    ///for swipable delete
                    key: ValueKey(task.id),
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: _showConfirmationDialog,
                    onDismissed: (direction) async {
                      ///onDismissed tokhoni call hobe jokhon "_showConfirmationDialog" eta true return kobe
                      await provider.deleteTask(task.id);
                      showMsg(context, 'Deleted');
                    },
                    direction: DismissDirection.endToStart,
                    child: ListTile(
                      ///navigator = (context, kun page e jabo, ki niye jabo parameter hisebe)
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskPage(),
                        settings: RouteSettings(
                        arguments: task.id,
                      ),
                      )),
                      title: Text(
                        task.title,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        task.description,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          provider.updateTaskField(
                              task, tblTaskColStatus);
                        },
                        icon: Icon(task.status
                            ? Icons.done
                            : Icons.done_all),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text('Are you sure to delete this contact?'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('NO'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('YES'),
            ),
          ],
        ));
  }
  void _fetchData() {
    switch(selectedIndex) {
      case 0:
        Provider.of<TaskProvider>(context, listen: false).getAllTasks();
        break;
      /*case 1:
        Provider.of<TaskProvider>(context, listen: false).getAllDoneTasks();
        break;*/
    }
  }
}
