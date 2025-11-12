import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  double _balance = 0.00;

  double get balance => _balance;

  void deposit(double amount) {
    _balance += amount;
    notifyListeners();
  }

  void withdraw(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
      notifyListeners();
    }
  }
}
