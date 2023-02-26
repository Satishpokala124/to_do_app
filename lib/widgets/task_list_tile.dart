import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/widgets/edit_task.dart';

import '../providers/tasks.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    var tasks = context.watch<Tasks>();

    return ListTile(
      leading: IconButton(
        icon: task.isCompleted
            ? Icon(
                Icons.check_box,
                semanticLabel: 'Mark as pending',
                color: Colors.greenAccent[700],
              )
            : const Icon(
                Icons.check_box_outline_blank,
                semanticLabel: 'Mark as done',
              ),
        onPressed: () {
          tasks.toggleTaskCompleted(task.id);
        },
      ),
      onTap: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Create Task'),
            ),
            content: EditTask(
              task: task,
            ),
          ),
        ),
      },
      title: Text(task.title),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          semanticLabel: 'Delete',
        ),
        color: Colors.red[600],
        onPressed: () {
          tasks.removeTask(task.id);
        },
      ),
    );
  }
}
