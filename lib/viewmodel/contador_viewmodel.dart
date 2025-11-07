import 'package:flutter/material.dart';

class ContadorViewModel extends ChangeNotifier {
  int _money = 0;
  bool _shouldShowConfetti = false;

  int get money => _money;
  bool get shouldShowConfetti => _shouldShowConfetti;

  void addMoney() {
    _money += 100;
    _shouldShowConfetti = true;
    notifyListeners();
  }

  void removeMoney() {
    if (_money >= 100) {
      _money -= 100;
      notifyListeners();
    }
  }

  void onConfettiCompleted() {
    _shouldShowConfetti = false;
    // No need to notify listeners here, as this is just resetting the state
    // and doesn't require a UI rebuild for this specific change.
  }
}
