import 'package:flutter/material.dart';

class HomeController extends ValueNotifier<List<int>> {
  HomeController() : super([]);

  addItem() {
    final item = value.length + 1;
    value.add(item);
    notifyListeners();
  }

  removeItem() {
    final item = value.length;
    if (item >= 0) {
      value.remove(item);
      notifyListeners();
    }
  }
}
