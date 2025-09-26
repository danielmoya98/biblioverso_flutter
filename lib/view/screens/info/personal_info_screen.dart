import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    final nameController = TextEditingController(text: vm.name);
    final emailController = TextEditingController(text: vm.email);
    final genreController = TextEditingController(text: vm.favoriteGenre);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Información Personal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(labelText: "Género Favorito"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                vm.updateProfile(
                  newName: nameController.text,
                  newEmail: emailController.text,
                  newFavoriteGenre: genreController.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            )
          ],
        ),
      ),
    );
  }
}
