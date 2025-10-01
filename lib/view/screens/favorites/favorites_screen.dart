import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/favorites_viewmodel.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    // ✅ Usar addPostFrameCallback en lugar de microtask para evitar problemas con context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // seguridad extra
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      final favVM = Provider.of<FavoritesViewModel>(context, listen: false);
      if (profileVM.idUsuario != null) {
        favVM.fetchFavoritos(profileVM.idUsuario!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FavoritesViewModel>(context);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final userId = profileVM.idUsuario!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis Favoritos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 Barra superior
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${vm.favoritos.length} libros guardados",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  constraints:
                  const BoxConstraints(minWidth: 40, minHeight: 36),
                  isSelected: [isGridView, !isGridView],
                  onPressed: (index) {
                    setState(() => isGridView = index == 0);
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
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                ? Center(child: Text(vm.errorMessage!))
                : vm.favoritos.isEmpty
                ? const Center(child: Text("No tienes favoritos aún"))
                : isGridView
                ? _buildGridView(vm.favoritos, vm, userId)
                : _buildListView(vm.favoritos, vm, userId),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(
      List<Map<String, dynamic>> favorites, FavoritesViewModel vm, int userId) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return _BookCard(book: book, vm: vm, userId: userId);
      },
    );
  }

  Widget _buildListView(
      List<Map<String, dynamic>> favorites, FavoritesViewModel vm, int userId) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final book = favorites[index];
        return _BookListTile(book: book, vm: vm, userId: userId);
      },
    );
  }
}

// ---------------- Widgets internos ----------------
class _BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final FavoritesViewModel vm;
  final int userId;

  const _BookCard({required this.book, required this.vm, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📸 Imagen con ícono de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  book["image"] ?? "",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    vm.removeFavorito(userId, book["idLibro"]);
                  },
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite, color: Colors.red, size: 18),
                  ),
                ),
              )
            ],
          ),
          // 📖 Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book["title"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(book["editorial"] ?? "Editorial desconocida",
                    style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text("Publicado: ${book["year"] ?? "?"}",
                    style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(book["status"] ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (book["status"] == "Disponible")
                            ? Colors.green
                            : Colors.red)),
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
  final FavoritesViewModel vm;
  final int userId;

  const _BookListTile(
      {required this.book, required this.vm, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(book["image"] ?? "",
              width: 50, height: 70, fit: BoxFit.cover),
        ),
        title: Text(book["title"] ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book["editorial"] ?? "Editorial desconocida",
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(book["description"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                vm.removeFavorito(userId, book["id"]);
              },
              child: const Icon(Icons.favorite, color: Colors.red),
            ),
            Text(book["status"] ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (book["status"] == "Disponible")
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
