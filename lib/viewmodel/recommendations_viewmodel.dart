import 'package:flutter/material.dart';
import '../data/services/recommendations_service.dart';

class RecommendationsViewModel extends ChangeNotifier {
  final RecommendationsService _service = RecommendationsService();

  int tabIndex = 0; // 0 = Para ti, 1 = Populares, 2 = Novedades
  List<Map<String, dynamic>> books = [];
  bool isLoading = false;
  String? errorMessage;

  /// Cambiar de pestaña y recargar libros
  Future<void> setTab(int index, {int? userId}) async {
    tabIndex = index;
    await fetchBooks(userId: userId);
    notifyListeners();
  }

  /// Cargar libros según pestaña
  Future<void> fetchBooks({int? userId}) async {
    try {
      isLoading = true;
      notifyListeners();

      if (tabIndex == 0) {
        if (userId == null) throw Exception("Se requiere userId para 'Para ti'");
        books = await _service.getForYou(userId);
      } else if (tabIndex == 1) {
        books = await _service.getPopular();
      } else {
        books = await _service.getRecent();
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar recomendaciones: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
