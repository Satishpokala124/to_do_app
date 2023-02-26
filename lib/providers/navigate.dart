import 'package:flutter/material.dart';

class Navigation extends ChangeNotifier {
  String title = 'Check List';
  Map<int, String> titles = {
    0: "Check List",
    1: "Theme",
  };

  void setTitle(int index) {
    title = (titles.containsKey(index) ? titles[index] : "Unimplemented")!;
    notifyListeners();
  }
}
