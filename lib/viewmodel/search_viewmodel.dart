import 'package:flutter/material.dart';
import '../data/services/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchService _service = SearchService();

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];
  List<String> categories = ["Todos"];
  String selectedFilter = "Todos";
  bool isLoading = false;
  String? errorMessage;

  SearchViewModel() {
    fetchCategories();
    fetchBooks();

    // 🔹 Búsqueda en tiempo real
    searchController.addListener(() {
      fetchBooks();
    });
  }

  /// Cargar libros
  Future<void> fetchBooks() async {
    try {
      isLoading = true;
      notifyListeners();

      results = await _service.getBooks(
        query: searchController.text.trim(),
        filter: selectedFilter,
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = "Error al cargar libros: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar categorías desde la BD
  Future<void> fetchCategories() async {
    try {
      categories = await _service.getCategories();
      notifyListeners();
    } catch (e) {
      errorMessage = "Error al cargar categorías: $e";
      notifyListeners();
    }
  }

  /// Cambiar filtro
  void setFilter(String filter) {
    selectedFilter = filter;
    fetchBooks();
  }
}
