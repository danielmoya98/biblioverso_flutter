import 'package:flutter/material.dart';
import '../data/services/opinion_service.dart';

class OpinionViewModel extends ChangeNotifier {
  final OpinionService _service = OpinionService();

  List<Map<String, dynamic>> opiniones = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchOpiniones(int libroId) async {
    try {
      isLoading = true;
      notifyListeners();

      opiniones = await _service.getOpiniones(libroId);
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar opiniones: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarOpinion(
      int userId, int libroId, int calificacion, String comentario) async {
    await _service.agregarOpinion(userId, libroId, calificacion, comentario);
    await fetchOpiniones(libroId);
  }
}
