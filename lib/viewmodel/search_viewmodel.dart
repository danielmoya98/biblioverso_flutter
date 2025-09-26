import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final searchController = TextEditingController();

  String _selectedFilter = "Todos";
  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
