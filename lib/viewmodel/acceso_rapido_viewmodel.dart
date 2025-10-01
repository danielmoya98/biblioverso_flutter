import 'package:flutter/material.dart';
import '../data/services/acceso_rapido_service.dart';

class AccesoRapidoViewModel extends ChangeNotifier {
  final AccesoRapidoService _service = AccesoRapidoService();

  int reservasActivas = 0;
  int favoritos = 0;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchAccesos(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      reservasActivas = await _service.getReservasActivas(userId);
      favoritos = await _service.getFavoritos(userId);

      errorMessage = null;

      // ✅ Solo debug, no afecta producción
      debugPrint(
          "✅ Acceso rápido → reservas=$reservasActivas, favoritos=$favoritos");
    } catch (e) {
      errorMessage = "Error al cargar accesos rápidos: $e";
      debugPrint("❌ Error en fetchAccesos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
