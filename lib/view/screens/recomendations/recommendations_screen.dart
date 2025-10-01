import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/recommendations_viewmodel.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecommendationsViewModel>(context);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

    // 🔹 cargar por defecto la primera vez
    if (vm.books.isEmpty && !vm.isLoading) {
      vm.fetchBooks(userId: profileVM.idUsuario);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Recomendaciones", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Descubre tu próxima lectura",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 Tabs
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _TabButton(
                  text: "Para ti",
                  selected: vm.tabIndex == 0,
                  onTap: () => vm.setTab(0, userId: profileVM.idUsuario),
                ),
                _TabButton(
                  text: "Populares",
                  selected: vm.tabIndex == 1,
                  onTap: () => vm.setTab(1),
                ),
                _TabButton(
                  text: "Novedades",
                  selected: vm.tabIndex == 2,
                  onTap: () => vm.setTab(2),
                ),
              ],
            ),
          ),

          // 🔹 Grid de libros
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                ? Center(child: Text(vm.errorMessage!))
                : vm.books.isEmpty
                ? const Center(child: Text("No hay libros para mostrar"))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: vm.books.length,
              itemBuilder: (context, index) {
                final book = vm.books[index];
                return _BookCard(book: book);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Widgets internos ----------------

class _TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: selected
                ? [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.deepPurple : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              book["image"] ?? "",
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book["title"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(book["editorial"] ?? "Editorial desconocida",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(book["status"] ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (book["status"] == "Disponible" || book["status"] == "Nuevo")
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
