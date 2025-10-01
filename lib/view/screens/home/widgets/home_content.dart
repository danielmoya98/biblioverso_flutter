import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/acceso_rapido_viewmodel.dart';
import '../../../../viewmodel/categoria_viewmodel.dart';
import '../../../../viewmodel/home_viewmodel.dart';
import '../../../../viewmodel/libro_viewmodel.dart';
import '../../../../viewmodel/profile_viewmodel.dart';

import '../../category/category_screen.dart';
import '../../details/book_detail_screen.dart';
import '../../recomendations/recommendations_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      // 🔹 Categorías
      Provider.of<CategoriaViewModel>(context, listen: false).fetchCategorias();

      // 🔹 Acceso rápido
      final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
      if (profileVM.idUsuario != null) {
        final accesoVM = Provider.of<AccesoRapidoViewModel>(
          context,
          listen: false,
        );
        accesoVM.fetchAccesos(profileVM.idUsuario!);
      }

      // 🔹 Novedades
      Provider.of<HomeViewModel>(context, listen: false).fetchNovedades();

      Provider.of<HomeViewModel>(context, listen: false).fetchDestacados();

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header fijo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<ProfileViewModel>(
                  builder: (context, profileVM, _) {
                    final nombre =
                        profileVM.nombre.isNotEmpty
                            ? profileVM.nombre
                            : "Usuario";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "¡Hola, $nombre!",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "¿Qué vas a leer hoy?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
                Consumer<ProfileViewModel>(
                  builder: (context, profileVM, _) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                        profileVM.foto ??
                            "https://i.pravatar.cc/150?img=47", // fallback
                      ),
                      radius: 20,
                    );
                  },
                ),
              ],
            ),
          ),

          // ✅ Barra de búsqueda fija
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                final homeVM = Provider.of<HomeViewModel>(
                  context,
                  listen: false,
                );
                homeVM.onTabTapped(1); // ir al tab de búsqueda
              },
              child: Hero(
                tag: "searchBarHero",
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Buscar libros, autores...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Contenido dinámico
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Categorías
                  const Text(
                    "Categorías",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: Consumer<CategoriaViewModel>(
                      builder: (context, vm, _) {
                        if (vm.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (vm.errorMessage != null) {
                          return Center(child: Text(vm.errorMessage!));
                        }
                        if (vm.categorias.isEmpty) {
                          return const Center(
                            child: Text("No hay categorías disponibles"),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.categorias.length,
                          itemBuilder: (context, index) {
                            final categoria = vm.categorias[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CategoryScreen(
                                          categoryName: categoria.nombre,
                                          categoryId: categoria.idCategoria,
                                        ),
                                  ),
                                );
                              },
                              child: _CategoryCard(
                                categoria.nombre,
                                "${categoria.cantidadLibros} libros",
                                Icons.menu_book,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Acceso rápido
                  const Text(
                    "Acceso rápido",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Consumer<AccesoRapidoViewModel>(
                    builder: (context, accesoVM, _) {
                      if (accesoVM.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (accesoVM.errorMessage != null) {
                        return Center(child: Text(accesoVM.errorMessage!));
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final homeVM = Provider.of<HomeViewModel>(
                                  context,
                                  listen: false,
                                );
                                homeVM.onTabTapped(2);
                              },
                              child: _QuickAccessCard(
                                title: "Mis Reservas",
                                subtitle: "${accesoVM.reservasActivas} activas",
                                color: Colors.greenAccent,
                                icon: Icons.bookmark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/favorites");
                              },
                              child: _QuickAccessCard(
                                title: "Favoritos",
                                subtitle: "${accesoVM.favoritos} libros",
                                color: Colors.pinkAccent,
                                icon: Icons.favorite,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Destacados (dinámico desde BD)
                  _SectionHeader(title: "Destacados"),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: Consumer<HomeViewModel>(
                      builder: (context, vm, _) {
                        if (vm.isLoadingDestacados) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (vm.errorMessageDestacados != null) {
                          return Center(child: Text(vm.errorMessageDestacados!));
                        }
                        if (vm.destacados.isEmpty) {
                          return const Center(child: Text("No hay destacados aún"));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.destacados.length,
                          itemBuilder: (context, index) {
                            final book = vm.destacados[index];
                            return _BookCard(
                              book["title"] ?? "",
                              book["editorial"] ?? "Editorial desconocida",
                              "Reservas: ${book["reservas"]}",
                              4.5, // 🔹 mock rating por ahora
                              imageUrl: book["image"] ?? "",
                              idLibro: book["id"] as int,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Novedades dinámicas
                  _SectionHeader(title: "Novedades"),
                  Consumer<HomeViewModel>(
                    builder: (context, vm, _) {
                      if (vm.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (vm.errorMessage != null) {
                        return Text(
                          vm.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        );
                      }
                      if (vm.novedades.isEmpty) {
                        return const Text("No hay novedades");
                      }

                      return Column(
                        children:
                            vm.novedades.map((book) {
                              return _ListBookTile(
                                book["title"] ?? "",
                                book["editorial"] ?? "Editorial desconocida",
                                book["category"] ?? "No hay cataegoria",
                                book["year"] ?? "?",
                                idLibro: book["id"] as int,
                              );
                            }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Recomendados
                  _SectionHeader(title: "Recomendado para ti"),
                  const SizedBox(height: 10),
                  _RecommendationCard(
                    title: "Basado en tus favoritos",
                    subtitle: "Te gustan los libros de Literatura Clásica",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecommendationsScreen(),
                        ),
                      );
                    },
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

// ---------------- Widgets internos ----------------

class _CategoryCard extends StatelessWidget {
  final String title, count;
  final IconData icon;

  const _CategoryCard(this.title, this.count, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            count,
            style: const TextStyle(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title, subtitle;
  final Color color;
  final IconData icon;

  const _QuickAccessCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text("Ver recomendaciones"),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title, author, price, imageUrl;
  final double rating;
  final int idLibro; // 👈 Nuevo parámetro

  const _BookCard(
      this.title,
      this.author,
      this.price,
      this.rating, {
        required this.imageUrl,
        required this.idLibro,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => LibroViewModel()..fetchLibroDetalle(idLibro),
              child: BookDetailScreen(idLibro: idLibro),
            ),
          ),
        );

      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl,
                  height: 180, width: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              author,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListBookTile extends StatelessWidget {
  final String title, author, price, rating;
  final int idLibro; // 👈 Nuevo parámetro

  const _ListBookTile(
      this.title,
      this.author,
      this.price,
      this.rating, {
        required this.idLibro,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => LibroViewModel()..fetchLibroDetalle(idLibro),
              child: BookDetailScreen(idLibro: idLibro),
            ),
          ),
        );

      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade50,
          child: const Icon(Icons.menu_book, color: Colors.deepPurple),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(author,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: Colors.blue, size: 16),
                Text(rating.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
