import 'package:flutter/material.dart';
import '../data/services/reservations_service.dart';

class ReservationsViewModel extends ChangeNotifier {
  final ReservationsService _service = ReservationsService();

  List<Map<String, dynamic>> activeReservations = [];
  List<Map<String, dynamic>> historyReservations = [];

  bool isLoading = false;
  String? errorMessage;
  int tabIndex = 0;

  /// Cambiar de tab
  void setTab(int index) {
    tabIndex = index;
    notifyListeners();
  }

  /// Cargar reservas del usuario
  Future<void> fetchReservas(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.getReservas(userId);

      activeReservations = data
          .where((r) =>
      r["status"] == "pendiente" ||
          r["status"] == "recoger") // Activas
          .toList();

      historyReservations = data
          .where((r) =>
      r["status"] == "recogido" || r["status"] == "cancelado") // Historial
          .toList();

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar reservas: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  /// Cancelar reserva
  Future<void> cancelReserva(int reservaId) async {
    try {
      await _service.cancelarReserva(reservaId);
      // refrescamos reservas
    } catch (e) {
      errorMessage = "Error al cancelar la reserva: $e";
      notifyListeners();
    }
  }
}
