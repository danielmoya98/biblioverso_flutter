import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isGridView = true; // ✅ por defecto grid view

  final List<Map<String, dynamic>> favorites = [
    {
      "title": "Cien años de soledad",
      "author": "Gabriel García Márquez",
      "price": "€18.99",
      "rating": 4.8,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
    },
    {
      "title": "Sapiens: De animales a dioses",
      "author": "Yuval Noah Harari",
      "price": "€22.95",
      "rating": 4.6,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/713jIoMO3UL.jpg",
    },
    {
      "title": "La Sombra del Viento",
      "author": "Carlos Ruiz Zafón",
      "price": "€19.95",
      "rating": 4.8,
      "status": "Disponible",
      "image": "https://m.media-amazon.com/images/I/91b0C2YNSrL.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Favoritos",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 Barra superior con contador + botones de vista
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${favorites.length} libros guardados",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  constraints:
                  const BoxConstraints(minWidth: 40, minHeight: 36),
                  isSelected: [isGridView, !isGridView],
                  onPressed: (index) {
                    setState(() {
                      isGridView = index == 0;
                    });
                  },
                  children: const [
                    Icon(Icons.grid_view, size: 20),
                    Icon(Icons.list, size: 20),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Lista de favoritos
          Expanded(
            child: isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  // ✅ Vista Grid
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return _BookCard(book: book);
      },
    );
  }

  // ✅ Vista Lista
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return _BookListTile(book: book);
      },
    );
  }
}

// ---------------- Widgets internos ----------------

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
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(book["price"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                    Text(book["rating"].toString(),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(book["status"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookListTile extends StatelessWidget {
  final Map<String, dynamic> book;

  const _BookListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            book["image"],
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(book["title"],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book["author"], style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 16),
                Text(book["rating"].toString(),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(book["price"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            Text(book["status"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
