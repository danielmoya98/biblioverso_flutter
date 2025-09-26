import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> login(BuildContext context) async {
    _loading = true;
    notifyListeners();

    // Simula autenticación
    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();

    // Ejemplo: autenticación exitosa
    Navigator.pushReplacementNamed(context, "/home");
  }
}
