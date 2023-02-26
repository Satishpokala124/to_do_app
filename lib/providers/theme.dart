import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme extends ChangeNotifier {
  var color = Colors.blue;
  bool? darkMode = false;
  final appColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  SharedPreferences? prefs;

  AppTheme() {
    _initializePerfs();
    loadTheme();
    // developer.log('Constructor');
  }

  _initializePerfs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  void loadTheme() async {
    await _initializePerfs();
    darkMode = prefs!.getBool('darkMode');
    // developer.log('loadTheme : ${darkMode.toString()}');
    var savedColor = prefs!.getString('color') ?? Colors.blue.toString();
    for (var appColor in appColors) {
      if (appColor.toString() == savedColor) {
        color = appColor;
      }
    }
  }

  void setColor(MaterialColor newColor) async {
    await _initializePerfs();
    prefs!.setString('color', newColor.toString());
    color = newColor;
    notifyListeners();
  }

  void setDarkMode(bool? isDarkMode) async {
    await _initializePerfs();
    // developer.log(isDarkMode.toString());
    if (isDarkMode == null) {
      prefs!.remove('darkMode');
    } else {
      prefs!.setBool('darkMode', isDarkMode);
    }
    darkMode = isDarkMode;
    notifyListeners();
  }

  void setDefaultColor() {
    color = Colors.blue;
    notifyListeners();
  }
}
