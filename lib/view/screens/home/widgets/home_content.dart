import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodel/home_viewmodel.dart';
import '../../../../viewmodel/profile_viewmodel.dart';
import '../../category/category_screen.dart';
import '../../details/book_detail_screen.dart';
import '../../recomendations/recommendations_screen.dart';
import '../../search/search_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Mock de categorías con libros
    final Map<String, List<Map<String, dynamic>>> booksByCategory = {
      "Literatura": [
        {
          "title": "Cien años de soledad",
          "author": "Gabriel García Márquez",
          "price": "€18.99",
          "rating": 4.8,
          "status": "Disponible",
          "image": "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
          "description":
          "Una obra maestra del realismo mágico que narra la historia de la familia Buendía.",
          "pages": 471,
          "year": 1967,
          "publisher": "Editorial Sudamericana",
        }
      ],
      "Ciencia Ficción": [
        {
          "title": "Dune",
          "author": "Frank Herbert",
          "price": "€24.9",
          "rating": 4.7,
          "status": "Disponible",
          "image": "https://m.media-amazon.com/images/I/91A2W98J+RL.jpg",
          "description":
          "Un clásico de la ciencia ficción que explora política, religión y ecología en Arrakis.",
          "pages": 600,
          "year": 1965,
          "publisher": "Chilton Books",
        }
      ],
      "Historia": [],
      "Infantil": [],
      "Filosofía": [],
      "Romance": [],
    };

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
                    final nombre = profileVM.nombre.isNotEmpty
                        ? profileVM.nombre
                        : "Usuario"; // fallback si no hay nombre

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("¡Hola, $nombre!",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text("¿Qué vas a leer hoy?",
                            style: TextStyle(color: Colors.grey)),
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


          // ✅ Barra de búsqueda fija con Hero
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                final homeVM = Provider.of<HomeViewModel>(context, listen: false);
                homeVM.onTabTapped(1); // va al tab de búsqueda
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

          // ✅ Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Categorías
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: booksByCategory.keys.map((category) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                  categoryName: category,
                                  books: booksByCategory[category] ?? [],
                                ),
                              ),
                            );
                          },
                          child: _CategoryCard(
                            category,
                            "${booksByCategory[category]?.length ?? 0}",
                            Icons.menu_book,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Acceso rápido
                  const Text("Acceso rápido",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final homeVM = Provider.of<HomeViewModel>(context,
                                listen: false);
                            homeVM.onTabTapped(2);
                          },
                          child: const _QuickAccessCard(
                            title: "Mis Reservas",
                            subtitle: "3 activas",
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
                          child: const _QuickAccessCard(
                            title: "Favoritos",
                            subtitle: "3 libros",
                            color: Colors.pinkAccent,
                            icon: Icons.favorite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Destacados
                  _SectionHeader(title: "Destacados"),
                  SizedBox(
                    height: 250,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailScreen(
                                  book: booksByCategory["Literatura"]![0],
                                ),
                              ),
                            );
                          },
                          child: const _BookCard(
                            "Cien años de soledad",
                            "Gabriel García Márquez",
                            "€18.99",
                            4.8,
                            imageUrl:
                            "https://m.media-amazon.com/images/I/71UybzN9pML.jpg",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailScreen(
                                  book: booksByCategory["Ciencia Ficción"]![0],
                                ),
                              ),
                            );
                          },
                          child: const _BookCard(
                            "El Principito",
                            "Antoine de Saint-Exupéry",
                            "€12.5",
                            4.9,
                            imageUrl:
                            "https://m.media-amazon.com/images/I/71SmHgZWGPL.jpg",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Novedades
                  _SectionHeader(title: "Novedades"),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(
                                book: booksByCategory["Ciencia Ficción"]![0],
                              ),
                            ),
                          );
                        },
                        child: const _ListBookTile(
                          "Dune",
                          "Frank Herbert",
                          "€24.9",
                          4.7,
                          true,
                        ),
                      ),
                      const _ListBookTile("El Arte de la Guerra", "Sun Tzu",
                          "€15.99", 4.4, true),
                      const _ListBookTile("La Sombra del Viento",
                          "Carlos Ruiz Zafón", "€19.95", 4.8, true),
                    ],
                  ),

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
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text("Ver recomendaciones"),
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
        color: color.withOpacity(0.2),
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

class _BookCard extends StatelessWidget {
  final String title, author, price, imageUrl;
  final double rating;

  const _BookCard(this.title, this.author, this.price, this.rating,
      {required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, height: 180, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(author,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(rating.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListBookTile extends StatelessWidget {
  final String title, author, price;
  final double rating;
  final bool available;

  const _ListBookTile(
      this.title, this.author, this.price, this.rating, this.available);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.shade50,
        child: const Icon(Icons.menu_book, color: Colors.deepPurple),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(author),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(price,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(rating.toString()),
            ],
          ),
          if (available)
            const Text("Disponible",
                style: TextStyle(color: Colors.green, fontSize: 12)),
        ],
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
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text("Ver más")),
      ],
    );
  }
}
