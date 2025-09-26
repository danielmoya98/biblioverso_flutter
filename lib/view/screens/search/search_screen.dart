import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/search_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool showFilterPanel = false;
  String selectedOrder = "Relevancia";

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SearchViewModel>(context);

    final filters = ["Todos", "Literatura Clásica", "Ciencia Ficción", "Historia"];

    final List<Map<String, dynamic>> books = [
      {
        "title": "Cien años de soledad",
        "author": "Gabriel García Márquez",
        "price": "€18.99",
        "rating": 4.8,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
      },
      {
        "title": "El Principito",
        "author": "Antoine de Saint-Exupéry",
        "price": "€12.5",
        "rating": 4.9,
        "status": "Sin stock",
        "image": "https://m.media-amazon.com/images/I/71SmHgZWGPL.jpg",
      },
      {
        "title": "Sapiens: De animales a dioses",
        "author": "Yuval Noah Harari",
        "price": "€21.5",
        "rating": 4.7,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/713jIoMO3UL.jpg",
      },
      {
        "title": "Dune",
        "author": "Frank Herbert",
        "price": "€24.9",
        "rating": 4.7,
        "status": "Disponible",
        "image": "https://m.media-amazon.com/images/I/91A2W98J+RL.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Barra de búsqueda con Hero
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Hero(
                      tag: "searchBarHero",
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          controller: vm.searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Buscar libros, autores...",
                            prefixIcon: const Icon(Icons.search),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Filtros principales + botón Filtros
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // Botón de filtros
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        showFilterPanel = !showFilterPanel;
                      });
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text("Filtros"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Chips de categorías
                  ...filters.map((filter) {
                    final isSelected = vm.selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => vm.setFilter(filter),
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // ✅ Panel de filtros avanzados (ordenar por…)
            if (showFilterPanel)
              Padding(
                padding: const EdgeInsets.all(12),
                child: _FilterPanel(
                  selected: selectedOrder,
                  onSelected: (value) {
                    setState(() {
                      selectedOrder = value;
                    });
                  },
                ),
              ),

            const SizedBox(height: 10),

            // ✅ Resultados
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return _BookCard(
                    title: book["title"] as String,
                    author: book["author"] as String,
                    price: book["price"] as String,
                    rating: book["rating"] as double,
                    status: book["status"] as String,
                    image: book["image"] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Panel de filtros avanzados
class _FilterPanel extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _FilterPanel({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = ["Relevancia", "Título", "Autor", "Precio", "Calificación", "Año"];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: options.map((option) {
          final isSelected = option == selected;
          return ChoiceChip(
            label: Text(option),
            selected: isSelected,
            onSelected: (_) => onSelected(option),
            selectedColor: Colors.green,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ✅ Card de libro
class _BookCard extends StatelessWidget {
  final String title, author, price, status, image;
  final double rating;

  const _BookCard({
    required this.title,
    required this.author,
    required this.price,
    required this.status,
    required this.image,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final available = status == "Disponible";

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
              image,
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
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Row(
                  children: [
                    Icon(Icons.star,
                        color: Colors.amber.shade700, size: 16),
                    Text(rating.toString(),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: available ? Colors.green : Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
