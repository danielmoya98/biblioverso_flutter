import 'package:flutter/material.dart';

import '../core/utils/SessionManager.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isFinished = false;
  bool get isFinished => _isFinished;

  Future<void> startSplashTimer(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final seenOnboarding = await SessionManager.hasSeenOnboarding();
    final loggedIn = await SessionManager.isLoggedIn();

    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, "/onboarding");
    } else if (loggedIn) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/welcome");
    }

    _isFinished = true;
    notifyListeners();
  }
}
