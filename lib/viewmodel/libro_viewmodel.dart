import 'package:flutter/material.dart';
import '../data/models/libro.dart';
import '../data/services/libro_service.dart';

/// Enum para definir los filtros de ordenamiento
enum LibroOrden { relevancia, titulo, editorial, disponibilidad, anio }

class LibroViewModel extends ChangeNotifier {
  final LibroService _service = LibroService();

  List<Libro> libros = [];
  bool isLoading = false;
  String? errorMessage;

  // 🔹 Orden seleccionado
  LibroOrden _orden = LibroOrden.relevancia;
  LibroOrden get orden => _orden;

  Future<void> fetchLibrosByCategoria(int idCategoria) async {
    try {
      isLoading = true;
      notifyListeners();

      libros = await _service.getLibrosByCategoria(idCategoria);
      errorMessage = null;

      print("✅ Libros recibidos (${libros.length})");

      aplicarOrden(); // Orden inicial
    } catch (e) {
      errorMessage = "Error al cargar libros: $e";
      print("❌ Error en fetchLibrosByCategoria: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cambiar el filtro de ordenamiento
  void cambiarOrden(LibroOrden nuevo) {
    _orden = nuevo;
    aplicarOrden();
    notifyListeners();
  }

  /// Aplica el orden según el filtro seleccionado
  void aplicarOrden() {
    switch (_orden) {
      case LibroOrden.titulo:
        libros.sort((a, b) => a.titulo.compareTo(b.titulo));
        break;
      case LibroOrden.editorial:
        libros.sort((a, b) => (a.editorial ?? "").compareTo(b.editorial ?? ""));
        break;
      case LibroOrden.disponibilidad:
        libros.sort((a, b) => b.disponibles.compareTo(a.disponibles));
        break;
      case LibroOrden.anio:
        libros.sort((a, b) {
          final anioA = a.fechaPublicacion?.year ?? 0;
          final anioB = b.fechaPublicacion?.year ?? 0;
          return anioB.compareTo(anioA); // Más recientes primero
        });
        break;
      case LibroOrden.relevancia:
      // Aquí puedes implementar lógica de "relevancia" más adelante
        break;
    }
  }
}
