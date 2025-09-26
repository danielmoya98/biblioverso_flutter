import 'package:flutter/material.dart';

class CategoriesViewModel extends ChangeNotifier {
  // 🔹 Lista de categorías y sus libros
  final Map<String, List<Map<String, dynamic>>> _booksByCategory = {
    "Literatura": [
      {
        "title": "Cien años de soledad",
        "author": "Gabriel García Márquez",
        "price": "€18.99",
        "rating": 4.8,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
      },
      {
        "title": "El Quijote",
        "author": "Miguel de Cervantes",
        "price": "€20.0",
        "rating": 4.7,
        "status": "Sin stock",
        "image": "https://m.media-amazon.com/images/I/71Q1Iu4suSL.jpg",
      },
    ],
    "Ciencia Ficción": [
      {
        "title": "Dune",
        "author": "Frank Herbert",
        "price": "€24.9",
        "rating": 4.7,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/91A2W98J+RL.jpg",
      },
      {
        "title": "Neuromante",
        "author": "William Gibson",
        "price": "€18.5",
        "rating": 4.6,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/81WcnNQ-TBL.jpg",
      },
    ],
    "Historia": [],
    "Infantil": [],
    "Filosofía": [],
    "Romance": [],
  };

  Map<String, List<Map<String, dynamic>>> get booksByCategory =>
      _booksByCategory;

  // 🔹 Obtener libros por categoría con tipado correcto
  List<Map<String, dynamic>> getBooksForCategory(String category) {
    final list = _booksByCategory[category];
    if (list == null) return <Map<String, dynamic>>[];
    return List<Map<String, dynamic>>.from(list);
  }
}
