import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/search_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<SearchViewModel>(context, listen: false);
      vm.fetchCategories();
      vm.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SearchViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      final homeVM =
                      Provider.of<HomeViewModel>(context, listen: false);
                      homeVM.onTabTapped(0);
                    },
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
                            hintText: "Buscar libros, editoriales, categorías...",
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

            // 🔹 Filtros dinámicos por categoría
            SizedBox(
              height: 40,
              child: vm.categories.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: vm.categories.map((filter) {
                  final isSelected = vm.selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => vm.setFilter(filter),
                      selectedColor: Colors.deepPurple,
                      labelStyle: TextStyle(
                        color:
                        isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Resultados
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.errorMessage != null
                  ? Center(child: Text(vm.errorMessage!))
                  : vm.results.isEmpty
                  ? const Center(child: Text("No se encontraron libros"))
                  : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: vm.results.length,
                itemBuilder: (context, index) {
                  final book = vm.results[index];
                  return _BookCard(
                    title: book["title"],
                    author: book["editorial"] ??
                        "Editorial desconocida",
                    year: book["year"] ?? "?",
                    category:
                    book["category"] ?? "Sin categoría",
                    status: book["status"],
                    image: book["image"] ?? "",
                    disponibles: book["disponibles"],
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

// 🔹 Card de libro
class _BookCard extends StatelessWidget {
  final String title, author, year, category, status, image;
  final int disponibles;

  const _BookCard({
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    required this.status,
    required this.image,
    required this.disponibles,
  });

  @override
  Widget build(BuildContext context) {
    final available = disponibles > 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📸 Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Container(
                height: 140,
                color: Colors.grey.shade200,
                child: const Icon(Icons.book, size: 40, color: Colors.grey),
              ),
            ),
          ),

          // 📖 Info
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
                const SizedBox(height: 4),
                Text("Categoría: $category",
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black54)),
                Text("Publicado: $year",
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(
                  available
                      ? "Disponibles: $disponibles"
                      : "Agotado",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: available ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
