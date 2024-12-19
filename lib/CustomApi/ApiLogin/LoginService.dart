// login_controller.dart
import 'package:flutter/material.dart';

import 'Apilogin.dart';


class LoginController extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  String errorMessage = '';

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      errorMessage = 'من فضلك ادخل اسم المستخدم وكلمة المرور';
      notifyListeners();
      return;
    }

    Map<String, dynamic> response = await _loginService.login(username, password);

    if (response['status'] == 'success') {
      errorMessage = '';
      // Handle successful login
    } else {
      errorMessage = response['message'] ?? 'Error logging in';
      notifyListeners();
    }
  }
}
