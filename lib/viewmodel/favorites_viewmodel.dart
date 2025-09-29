import 'package:flutter/material.dart';
import '../data/services/favorites_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  List<Map<String, dynamic>> favoritos = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchFavoritos(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      favoritos = await _service.getFavorites(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar favoritos: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorito(int userId, int libroId) async {
    await _service.addFavorito(userId, libroId);
    await fetchFavoritos(userId);
  }

  Future<void> removeFavorito(int userId, int libroId) async {
    await _service.removeFavorito(userId, libroId);
    await fetchFavoritos(userId);
  }
}
