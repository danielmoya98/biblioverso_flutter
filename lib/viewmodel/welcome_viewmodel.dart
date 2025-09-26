import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }
}
