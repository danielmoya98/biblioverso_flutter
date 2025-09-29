import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/SessionManager.dart';

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
    await SessionManager.setOnboardingSeen();
    Navigator.pushReplacementNamed(context, "/welcome");
  }

  Future<void> finish(BuildContext context) async {
    await SessionManager.setOnboardingSeen();
    Navigator.pushReplacementNamed(context, "/welcome");
  }
}
