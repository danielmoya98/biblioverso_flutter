import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/profile_viewmodel.dart';
import '../about/about_screen.dart';
import '../help/help_support_screen.dart';
import '../info/personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Mi Perfil",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 Header con info del usuario
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(vm.foto ??
                      "https://i.pravatar.cc/150?img=47"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.nombre ,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(vm.email,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("Miembro desde ${vm.memberSince}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 🔹 Lista de opciones
          Expanded(
            child: ListView(
              children: [
                _ProfileOption(
                  icon: Icons.person_outline,
                  title: "Información Personal",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                    );
                  },
                ),
                _ProfileOption(
                  icon: Icons.help_outline,
                  title: "Ayuda y Soporte",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                    );
                  },
                ),
                _ProfileOption(
                  icon: Icons.info_outline,
                  title: "Sobre Biblioverso",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),   const Divider(),
                _ProfileOption(
                  icon: Icons.logout,
                  title: "Cerrar Sesión",
                  onTap: () => vm.logout(context),
                  isDestructive: true,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Biblioverso v1.0.0",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Widgets internos ----------------

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDestructive ? Colors.red : Colors.black)),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
