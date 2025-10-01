import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isFinished = false;
  bool get isFinished => _isFinished;

  Future<void> startSplashTimer(BuildContext context) async {
    // Capturamos el Navigator ANTES de cualquier await
    final navigator = Navigator.of(context);

    // Simulación de espera inicial
    await Future.delayed(const Duration(seconds: 2));

    // Llamadas async
    final seenOnboarding = await SessionManager.hasSeenOnboarding();
    final loggedIn = await SessionManager.isLoggedIn();

    // 🔒 Seguridad adicional: evitar usar navigator si el contexto ya no está montado
    if (!context.mounted) return;

    // Navegación segura
    if (!seenOnboarding) {
      navigator.pushReplacementNamed("/onboarding");
    } else if (loggedIn) {
      navigator.pushReplacementNamed("/home");
    } else {
      navigator.pushReplacementNamed("/welcome");
    }

    _isFinished = true;
    notifyListeners();
  }
}
