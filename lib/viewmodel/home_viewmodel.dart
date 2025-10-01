import 'package:flutter/material.dart';
import '../data/services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  final HomeService _service = HomeService();

  List<Map<String, dynamic>> novedades = [];
  bool isLoading = false;
  String? errorMessage;


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

}
