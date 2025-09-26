import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  Future<void> register(BuildContext context) async {
    _loading = true;
    notifyListeners();

    // Simula creación de usuario
    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();

    Navigator.pushReplacementNamed(context, "/home");
  }
}
