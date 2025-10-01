import 'package:flutter/material.dart';
import '../data/services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  final HomeService _service = HomeService();

  List<Map<String, dynamic>> novedades = [];
  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> destacados = [];
  bool isLoadingDestacados = false;
  String? errorMessageDestacados;

  void onTabTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> fetchNovedades() async {
    try {
      isLoading = true;
      notifyListeners();

      novedades = await _service.getNovedades();
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar novedades: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener destacados
  Future<void> fetchDestacados() async {
    try {
      isLoadingDestacados = true;
      notifyListeners();

      destacados = await _service.getDestacados();
      errorMessageDestacados = null;
    } catch (e) {
      errorMessageDestacados = "Error al cargar destacados: $e";
    } finally {
      isLoadingDestacados = false;
      notifyListeners();
    }
  }

}
