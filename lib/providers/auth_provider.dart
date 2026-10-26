// File: lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  Employee? _currentEmployee;
  bool _isLoading = false;

  Employee? get currentEmployee => _currentEmployee;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentEmployee != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final employee = await DatabaseHelper.instance.login(username, password);
    _isLoading = false;

    if (employee != null) {
      _currentEmployee = employee;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentEmployee = null;
    notifyListeners();
  }
}