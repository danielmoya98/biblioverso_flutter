import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  String name = "María González";
  String email = "maria.gonzalez@email.com";
  String memberSince = "marzo de 2023";
  String favoriteGenre = "Literatura Clásica";

  int totalReservations = 24;
  int achievements = 2;

  bool notificationsEnabled = true;

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void updateProfile({
    String? newName,
    String? newEmail,
    String? newFavoriteGenre,
  }) {
    if (newName != null) name = newName;
    if (newEmail != null) email = newEmail;
    if (newFavoriteGenre != null) favoriteGenre = newFavoriteGenre;
    notifyListeners();
  }
}
