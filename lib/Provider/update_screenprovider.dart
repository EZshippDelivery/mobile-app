import 'package:flutter/material.dart';

class UpdateScreenProvider extends ChangeNotifier {
  bool onMOve = false;
  updateScreen() {
    notifyListeners();
  }
}
