import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/welcome");
  }

  void finish(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/welcome");
  }
}
