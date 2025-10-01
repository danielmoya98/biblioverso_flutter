import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/libro_viewmodel.dart';
import '../details/book_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final int categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibroViewModel()..fetchLibrosByCategoria(categoryId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categoryName,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
              child: Consumer<LibroViewModel>(
                builder: (context, vm, _) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _FilterChip(
                        label: "Relevancia",
                        selected: vm.orden == LibroOrden.relevancia,
                        onTap: () => vm.cambiarOrden(LibroOrden.relevancia),
                      ),
                      _FilterChip(
                        label: "Título",
                        selected: vm.orden == LibroOrden.titulo,
                        onTap: () => vm.cambiarOrden(LibroOrden.titulo),
                      ),
                      _FilterChip(
                        label: "Editorial",
                        selected: vm.orden == LibroOrden.editorial,
                        onTap: () => vm.cambiarOrden(LibroOrden.editorial),
                      ),
                      _FilterChip(
                        label: "Disponibilidad",
                        selected: vm.orden == LibroOrden.disponibilidad,
                        onTap: () => vm.cambiarOrden(LibroOrden.disponibilidad),
                      ),
                      _FilterChip(
                        label: "Año",
                        selected: vm.orden == LibroOrden.anio,
                        onTap: () => vm.cambiarOrden(LibroOrden.anio),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Contenido
            Expanded(
              child: Consumer<LibroViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (vm.errorMessage != null) {
                    return Center(child: Text(vm.errorMessage!));
                  }
                  if (vm.libros.isEmpty) {
                    return const _EmptyCategory();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: vm.libros.length,
                    itemBuilder: (context, index) {
                      final libro = vm.libros[index];
                      return GestureDetector(
                        onTap: () {
                          // 📌 Abrir detalle
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(
                                book: {
                                  "title": libro.titulo,
                                  "author": "Autor pendiente",
                                  "image": libro.portada ?? "",
                                  "description": libro.sinopsis ?? "",
                                  "status": libro.disponibles > 0
                                      ? "Disponible"
                                      : "Agotado",
                                },
                              ),
                            ),
                          );
                        },
                        child: _BookCard(
                          title: libro.titulo,
                          editorial:
                          libro.editorial ?? "Editorial desconocida",
                          sinopsis: libro.sinopsis,
                          fechaPublicacion: libro.fechaPublicacion,
                          portada: libro.portada,
                          disponibles: libro.disponibles,
                        ),
                      );
                    },
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

// ---------------- Widgets internos ----------------

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.green,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final String editorial;
  final String? portada;
  final String? sinopsis;
  final DateTime? fechaPublicacion;
  final int disponibles;

  const _BookCard({
    required this.title,
    required this.editorial,
    required this.portada,
    required this.disponibles,
    this.sinopsis,
    this.fechaPublicacion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📸 Imagen de la portada
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: portada != null && portada!.isNotEmpty
                ? Image.network(
              portada!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(
              height: 140,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.menu_book,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),

          // 📖 Detalles
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Editorial
                  Text(
                    editorial,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Año de publicación
                  if (fechaPublicacion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Publicado: ${fechaPublicacion!.year}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],

                  // Sinopsis breve
                  if (sinopsis != null && sinopsis!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      sinopsis!,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Disponibilidad
                  Row(
                    children: [
                      Icon(
                        disponibles > 0
                            ? Icons.check_circle
                            : Icons.cancel_outlined,
                        size: 16,
                        color: disponibles > 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        disponibles > 0
                            ? "$disponibles disponibles"
                            : "Agotado",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: disponibles > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
          const Icon(Icons.menu_book_outlined, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            "No hay libros en esta categoría",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Pronto añadiremos más títulos a esta sección",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Explorar otras categorías"),
          ),
        ],
      ),
    );
  }
}
