import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre Biblioverso"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Header con logo y misión
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                children: const [
                  Icon(Icons.menu_book, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text("Biblioverso",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 6),
                  Text("Tu biblioteca digital de confianza",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Nuestra misión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Nuestra Misión",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "En Biblioverso creemos que la lectura debe ser accesible para todos. "
                        "Nuestra misión es democratizar el acceso a los libros mediante tecnología innovadora "
                        "que conecta a los lectores con su próxima gran historia.\n\n"
                        "Desde 2020, hemos ayudado a miles de lectores a descubrir, reservar y disfrutar de libros "
                        "de manera sencilla y conveniente.",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ✅ ¿Por qué elegir Biblioverso?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("¿Por qué elegir Biblioverso?",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _FeatureItem(
                      icon: Icons.library_books,
                      title: "Catálogo Extenso",
                      subtitle:
                      "Más de 10,000 títulos disponibles en todas las categorías"),
                  _FeatureItem(
                      icon: Icons.phone_android,
                      title: "Reserva Móvil",
                      subtitle:
                      "Reserva tus libros desde cualquier lugar con nuestra app"),
                  _FeatureItem(
                      icon: Icons.notifications_active,
                      title: "Notificaciones",
                      subtitle:
                      "Te avisamos cuando tu libro esté listo para recoger"),
                  _FeatureItem(
                      icon: Icons.store_mall_directory,
                      title: "Múltiples Sucursales",
                      subtitle:
                      "Recoge en la sucursal que más te convenga"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Nuestros números
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nuestros Números",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatCard(value: "10,000+", label: "Libros disponibles"),
                      _StatCard(value: "50,000+", label: "Usuarios activos"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatCard(value: "15", label: "Sucursales"),
                      _StatCard(value: "98%", label: "Satisfacción"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Nuestro equipo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Nuestro Equipo",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _TeamMember(
                      name: "Ana García",
                      role: "Directora General",
                      imageUrl: "https://i.pravatar.cc/150?img=5"),
                  _TeamMember(
                      name: "Carlos Mendoza",
                      role: "Jefe de Tecnología",
                      imageUrl: "https://i.pravatar.cc/150?img=12"),
                  _TeamMember(
                      name: "Laura Ruiz",
                      role: "Responsable de Contenidos",
                      imageUrl: "https://i.pravatar.cc/150?img=47"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Contacto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Contacto",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.green),
                    title: Text("info@biblioverso.com"),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.green),
                    title: Text("+34 900 123 456"),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.green),
                    title: Text("Calle Principal 123, Madrid, España"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Footer versión
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("© 2024 Biblioverso. Todos los derechos reservados.\nVersión 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- Widgets auxiliares ----------------

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const _TeamMember(
      {required this.name, required this.role, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role),
    );
  }
}
