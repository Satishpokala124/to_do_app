import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/tasks.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();
  DateTime timeStamp = DateTime.now();
  TextEditingController timeStampInput = TextEditingController();
  bool _isTitleValid = true;

  @override
  void initState() {
    titleInput.text = '';
    descriptionInput.text = '';
    timeStampInput.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasks = context.watch<Tasks>();
    // var theme = Theme.of(context);
    // var colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        constraints:
            const BoxConstraints.tightForFinite(width: 300, height: 350),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
              child: TextField(
                autofocus: true,
                controller: titleInput,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'title',
                  errorText: !_isTitleValid ? 'title can\'t be empty' : null,
                ),
                maxLength: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
              child: TextField(
                autofocus: true,
                controller: descriptionInput,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'description',
                ),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: timeStampInput,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      timeStampInput.text = formattedDate;
                      timeStamp = pickedDate;
                    });
                  }
                },
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleInput.text.trim().isEmpty) {
                      setState(() {
                        _isTitleValid = false;
                      });
                    } else {
                      tasks.addTask(
                          titleInput.text, descriptionInput.text, timeStamp);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
