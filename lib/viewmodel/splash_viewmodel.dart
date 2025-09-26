import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isFinished = false;
  bool get isFinished => _isFinished;

  Future<void> startSplashTimer() async {
    // Simula tiempo de carga inicial (ej. validar sesión, cargar datos básicos)
    await Future.delayed(const Duration(seconds: 10));
    _isFinished = true;
    notifyListeners();
  }
}
