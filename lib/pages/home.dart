import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/pages/settings.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/widgets/add_task.dart';
import 'package:to_do_app/widgets/task_list_tile.dart';

import '../providers/navigate.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var navigation = context.watch<Navigation>();

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = SettingsPage();
        break;
      case 2:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 500,
        ),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          widget.title,
          style: theme.textTheme.displaySmall!
              .copyWith(color: colorScheme.primary),
        ),
        backgroundColor: colorScheme.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: mainArea),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Create Task'),
              ),
              content: AddTask(),
            ),
          ),
        },
        tooltip: 'Create Task',
        child: const Icon(Icons.add_task),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brush_outlined),
            activeIcon: Icon(Icons.brush),
            label: 'Theme',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
            navigation.setTitle(value);
          });
        },
        backgroundColor: colorScheme.background,
        fixedColor: colorScheme.primary,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.primary,
    );
    var tasks = context.watch<Tasks>().tasks;

    return Container(
      alignment: tasks.isEmpty ? Alignment.center : Alignment.topCenter,
      child: tasks.isEmpty
          ? const Text('Add a task by clicking button below')
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (Task task in tasks.values) TaskListTile(task: task)
                ],
              ),
            ),
    );
  }
}
