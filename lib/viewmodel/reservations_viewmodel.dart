import 'package:flutter/material.dart';

class ReservationsViewModel extends ChangeNotifier {
  int _tabIndex = 0; // 0 = Activas, 1 = Historial
  int get tabIndex => _tabIndex;

  void setTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  // Datos mock
  final activeReservations = [
    {
      "title": "Cien años de soledad",
      "author": "Gabriel García Márquez",
      "reserved": "14/1/2024",
      "expires": "21/1/2024",
      "branch": "Sucursal Centro",
      "code": "BV2024-001",
      "status": "recoger",
    },
    {
      "title": "Sapiens: De animales a dioses",
      "author": "Yuval Noah Harari",
      "reserved": "17/1/2024",
      "expires": "24/1/2024",
      "branch": "Sucursal Norte",
      "code": "BV2024-002",
      "status": "pendiente",
    },
  ];

  final historyReservations = [
    {
      "title": "La Sombra del Viento",
      "author": "Carlos Ruiz Zafón",
      "reserved": "9/1/2024",
      "expires": "16/1/2024",
      "branch": "Sucursal Sur",
      "code": "BV2024-003",
      "collected": "15/1/2024",
    },
  ];
}
