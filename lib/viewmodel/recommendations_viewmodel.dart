import 'package:flutter/material.dart';

class RecommendationsViewModel extends ChangeNotifier {
  int tabIndex = 0;

  // 🔹 Mock de libros por categoría
  final Map<int, List<Map<String, dynamic>>> _booksByTab = {
    0: [
      {
        "title": "Cien años de soledad",
        "author": "Gabriel García Márquez",
        "price": "€18.99",
        "rating": 4.8,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
      },
      {
        "title": "El Principito",
        "author": "Antoine de Saint-Exupéry",
        "price": "€12.5",
        "rating": 4.9,
        "status": "Sin stock",
        "image": "https://m.media-amazon.com/images/I/71SmHgZWGPL.jpg",
      },
      {
        "title": "Dune",
        "author": "Frank Herbert",
        "price": "€24.9",
        "rating": 4.7,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/91A2W98J+RL.jpg",
      },
      {
        "title": "La Sombra del Viento",
        "author": "Carlos Ruiz Zafón",
        "price": "€19.95",
        "rating": 4.8,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/81l3rZK4lnL.jpg",
      },
    ],
    1: [
      {
        "title": "1984",
        "author": "George Orwell",
        "price": "€14.95",
        "rating": 4.6,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/71kxa1-0mfL.jpg",
      },
    ],
    2: [
      {
        "title": "El Infinito en un Junco",
        "author": "Irene Vallejo",
        "price": "€21.90",
        "rating": 4.9,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/81yB4QF2FEL.jpg",
      },
    ],
  };

  List<Map<String, dynamic>> get books => _booksByTab[tabIndex] ?? [];

  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
