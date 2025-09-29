import 'package:flutter/cupertino.dart';
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
      print("📡 Cargando categorías con conteo...");

      categorias = await _service.getAllCategoriasConConteo();
      print("🎯 Categorías recibidas en ViewModel: ${categorias.length}");

      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar categorías: $e";
      print("❌ Error en fetchCategorias: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      print("🔄 Estado actualizado: isLoading=$isLoading");
    }
  }
}
