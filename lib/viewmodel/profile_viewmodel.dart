import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  String memberSince = "marzo de 2023";

  // 🔹 Datos del perfil
  String _name = "María González";
  String _email = "maria.gonzalez@email.com";
  String _phone = "+34 612 345 678";
  String _address = "Calle Mayor 45, 28013 Madrid";
  String _favoriteGenre = "Ficción";
  DateTime? _birthDate = DateTime(1990, 5, 15);
  String? _photoUrl =
      "https://i.pravatar.cc/150?img=47"; // URL mock de foto de perfil

  // 🔹 Getters
  String get name => _name;

  String get email => _email;

  String get phone => _phone;

  String get address => _address;

  String get favoriteGenre => _favoriteGenre;

  DateTime? get birthDate => _birthDate;

  String? get photoUrl => _photoUrl;
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

  // 🔹 Método para actualizar el perfil
  void updateProfile({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newAddress,
    DateTime? newBirthDate,
    String? newFavoriteGenre,
    String? newPhotoUrl,
  }) {
    if (newName != null) _name = newName;
    if (newEmail != null) _email = newEmail;
    if (newPhone != null) _phone = newPhone;
    if (newAddress != null) _address = newAddress;
    if (newBirthDate != null) _birthDate = newBirthDate;
    if (newFavoriteGenre != null) _favoriteGenre = newFavoriteGenre;
    if (newPhotoUrl != null) _photoUrl = newPhotoUrl;

    notifyListeners(); // 🔔 Notifica a la UI que los datos cambiaron
  }

  // 🔹 Método para actualizar solo la foto
  void updatePhoto(String url) {
    _photoUrl = url;
    notifyListeners();
  }
}
