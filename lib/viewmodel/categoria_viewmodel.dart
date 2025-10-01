import 'package:flutter/material.dart';
import '../data/models/categoria.dart';
import '../data/services/categoria_service.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service = CategoriaService();
  List<Categoria> categorias = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCategorias() async {
    try {
      isLoading = true;
      notifyListeners();
      debugPrint("📡 Cargando categorías con conteo...");

      categorias = await _service.getAllCategoriasConConteo();
      debugPrint("🎯 Categorías recibidas en ViewModel: ${categorias.length}");

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar categorías: $e";
      debugPrint("❌ Error en fetchCategorias: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      debugPrint("🔄 Estado actualizado: isLoading=$isLoading");
    }
  }
}
