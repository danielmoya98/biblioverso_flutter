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
    final phoneController = TextEditingController(text: vm.phone);
    final addressController = TextEditingController(text: vm.address);

    DateTime selectedDate = vm.birthDate ?? DateTime(1990, 1, 1);
    String selectedGenre = vm.favoriteGenre;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Información Personal"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                vm.updateProfile(
                  newName: nameController.text,
                  newEmail: emailController.text,
                  newPhone: phoneController.text,
                  newAddress: addressController.text,
                  newBirthDate: selectedDate,
                  newFavoriteGenre: selectedGenre,
                );

                // 🔹 Mostrar el diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (_) => const _SavedDialog(),
                );
              },
              child: const Text("Guardar"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📸 Avatar editable
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(vm.photoUrl ??
                        "https://i.pravatar.cc/150?img=47"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.green,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                        onPressed: () {
                          // Lógica para cambiar foto
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Toca para cambiar foto",
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),

            // Inputs
            _buildInput("Nombre completo", nameController),
            const SizedBox(height: 16),
            _buildInput("Correo electrónico", emailController,
                inputType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildInput("Teléfono", phoneController,
                inputType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildInput("Dirección", addressController),
            const SizedBox(height: 16),

            // Fecha de nacimiento
            _DatePickerField(
              initialDate: selectedDate,
              onDateSelected: (date) {
                selectedDate = date;
              },
            ),
            const SizedBox(height: 16),

            // Género favorito
            _GenreDropdown(
              selectedGenre: selectedGenre,
              onChanged: (value) {
                selectedGenre = value ?? selectedGenre;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets auxiliares ----------------
  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// 📅 Selector de fecha
class _DatePickerField extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DatePickerField({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<_DatePickerField> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(
        text:
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      ),
      decoration: InputDecoration(
        labelText: "Fecha de nacimiento",
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => selectedDate = picked);
          widget.onDateSelected(picked);
        }
      },
    );
  }
}

// 📚 Dropdown de géneros
class _GenreDropdown extends StatelessWidget {
  final String selectedGenre;
  final ValueChanged<String?> onChanged;

  const _GenreDropdown({
    required this.selectedGenre,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final genres = ["Ficción", "Historia", "Romance", "Filosofía", "Infantil"];

    return DropdownButtonFormField<String>(
      value: selectedGenre,
      items: genres
          .map((genre) =>
          DropdownMenuItem(value: genre, child: Text(genre)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: "Género favorito",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ✅ Dialogo de confirmación
class _SavedDialog extends StatelessWidget {
  const _SavedDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE6F8EC),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              "Cambios guardados",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tu información personal ha sido actualizada correctamente.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Continuar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
