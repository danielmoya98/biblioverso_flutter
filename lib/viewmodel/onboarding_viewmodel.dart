import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  void setPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> skip(BuildContext context) async {
    // ✅ Capturamos Navigator antes del await
    final navigator = Navigator.of(context);

    await SessionManager.setOnboardingSeen();

    if (!context.mounted) return; // Seguridad extra
    navigator.pushReplacementNamed("/welcome");
  }

  Future<void> finish(BuildContext context) async {
    // ✅ Capturamos Navigator antes del await
    final navigator = Navigator.of(context);

    await SessionManager.setOnboardingSeen();

    if (!context.mounted) return; // Seguridad extra
    navigator.pushReplacementNamed("/welcome");
  }
}
