import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> books;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${books.length} libros disponibles",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Filtros de ordenamiento
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                _FilterChip(label: "Relevancia", selected: true),
                _FilterChip(label: "Título"),
                _FilterChip(label: "Autor"),
                _FilterChip(label: "Precio"),
                _FilterChip(label: "Año"),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 🔹 Contenido
          Expanded(
            child: books.isEmpty
                ? const _EmptyCategory()
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {},
        selectedColor: Colors.green,
        labelStyle:
        TextStyle(color: selected ? Colors.white : Colors.black),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              book["image"],
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
                Text(book["title"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(book["author"],
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(book["price"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Row(
                  children: [
                    Icon(Icons.star,
                        color: Colors.amber.shade700, size: 16),
                    Text(book["rating"].toString(),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  book["status"],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: book["status"] == "Disponible"
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined,
              size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("No hay libros en esta categoría",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Pronto añadiremos más títulos a esta sección",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Explorar otras categorías"),
          )
        ],
      ),
    );
  }
}
