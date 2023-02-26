import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  int id;
  String title;
  String description;
  DateTime timeStamp;
  bool isCompleted;

  Task(
    this.id,
    this.title,
    this.description,
    this.timeStamp,
    this.isCompleted,
  );

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  Map toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "timeStamp": timeStamp.toString(),
        "isCompleted": isCompleted
      };
}

class Tasks extends ChangeNotifier {
  int lastIndex = 0;
  Map<int, Task> tasks = {};
  SharedPreferences? prefs;
  bool initialized = false;

  _initializePrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  Tasks() {
    _initializePrefs();
    loadTasks();
  }

  void loadTasks() async {
    await _initializePrefs();
    Map<int, Task> savedTasks = {};
    lastIndex = prefs!.getInt('lastIndex') ?? 0;
    Map rawTasks = jsonDecode(prefs!.getString('tasks') ?? '{}');
    rawTasks.forEach((key, value) {
      int id = int.parse(key);
      String title = value['title'];
      String description = value['description'];
      DateTime timeStamp = DateTime.parse(value['timeStamp']);
      bool isCompleted = value['isCompleted'];
      savedTasks[id] = Task(id, title, description, timeStamp, isCompleted);
    });
    tasks = savedTasks;
    initialized = true;
    notifyListeners();
  }

  void addTask(String title, String description, DateTime timeStamp) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title);
    }
    lastIndex++;
    tasks[lastIndex] = Task(lastIndex, title, description, timeStamp, false);
    notifyListeners();
  }

  void changeTask(
      int id, String title, String description, DateTime timeStamp) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title);
    }
    tasks[id]!.title = title;
    tasks[id]!.description = description;
    tasks[id]!.timeStamp = timeStamp;
    notifyListeners();
  }

  Map toJson() {
    Map jsonMap = {};
    tasks.forEach((id, task) {
      jsonMap[id] = task.toJson();
    });
    return jsonMap;
  }

  void saveData() async {
    _initializePrefs();
    prefs!.setInt('lastIndex', lastIndex);
    Map map = {};
    tasks.forEach((id, task) {
      map[id.toString()] = task.toJson();
    });
    prefs!.setString('tasks', jsonEncode(map));
  }

  void toggleTaskCompleted(int id) {
    tasks[id]?.toggleCompleted();
    notifyListeners();
  }

  void removeTask(id) {
    tasks.remove(id);
    notifyListeners();
  }
}
