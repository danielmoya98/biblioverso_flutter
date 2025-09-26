import 'package:flutter/material.dart';

class FavoritesViewModel extends ChangeNotifier {
  bool isGrid = true;

  final List<Map<String, dynamic>> _favorites = [
    {
      "title": "Cien años de soledad",
      "author": "Gabriel García Márquez",
      "category": "Literatura Clásica",
      "price": "€18.99",
      "rating": 4.8,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
    },
    {
      "title": "Sapiens: De animales a dioses",
      "author": "Yuval Noah Harari",
      "category": "Historia y Ciencias",
      "price": "€22.95",
      "rating": 4.6,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/713jIoMO3UL.jpg",
    },
    {
      "title": "La Sombra del Viento",
      "author": "Carlos Ruiz Zafón",
      "category": "Novela Histórica",
      "price": "€19.95",
      "rating": 4.8,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/81Me3tlHk0L.jpg",
    },
  ];

  List<Map<String, dynamic>> get favorites => _favorites;

  void toggleViewMode() {
    isGrid = !isGrid;
    notifyListeners();
  }

  void removeFavorite(int index) {
    _favorites.removeAt(index);
    notifyListeners();
  }

  void addFavorite(Map<String, dynamic> book) {
    _favorites.add(book);
    notifyListeners();
  }
}
