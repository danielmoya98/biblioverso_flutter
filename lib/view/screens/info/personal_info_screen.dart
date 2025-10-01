import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/CloudinaryService.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController usuarioController;
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController direccionController;
  late TextEditingController nacionalidadController;
  late TextEditingController biografiaController;
  late TextEditingController fechaNacController;

  String? selectedGenero;
  DateTime? selectedFechaNac;
  String? fotoUrl;
  File? localImageFile;

  final List<String> generos = ["Masculino", "Femenino", "Otro"];

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ProfileViewModel>(context, listen: false);

    usuarioController = TextEditingController(text: vm.usuario ?? "");
    nombreController = TextEditingController(text: vm.nombre);
    apellidoController = TextEditingController(text: vm.apellido);
    emailController = TextEditingController(text: vm.email);
    telefonoController = TextEditingController(text: vm.telefono);
    direccionController = TextEditingController(text: vm.direccion);
    nacionalidadController = TextEditingController(text: vm.nacionalidad);
    biografiaController = TextEditingController(text: vm.biografia);

    selectedGenero = generos.contains(vm.genero) ? vm.genero : null;
    selectedFechaNac = vm.fechaNac;

    fechaNacController = TextEditingController(
      text: selectedFechaNac != null
          ? "${selectedFechaNac!.day}/${selectedFechaNac!.month}/${selectedFechaNac!.year}"
          : "",
    );

    fotoUrl = vm.foto;
  }

  @override
  void dispose() {
    usuarioController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    nacionalidadController.dispose();
    biografiaController.dispose();
    fechaNacController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final messenger = ScaffoldMessenger.of(context);

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        localImageFile = File(pickedFile.path);
      });

      try {
        final url = await CloudinaryService.uploadImage(localImageFile!);
        if (!mounted) return;

        setState(() {
          fotoUrl = url;
        });

        messenger.showSnackBar(
          const SnackBar(content: Text("✅ Foto subida con éxito")),
        );
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text("❌ Error al subir foto: $e")),
        );
      }
    }
  }

  void _pickDate() async {
    DateTime initial = selectedFechaNac ?? DateTime(2000, 1, 1);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        selectedFechaNac = picked;
        fechaNacController.text =
        "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    final navigator = Navigator.of(context);

    await vm.updateProfile(
      usuario: usuarioController.text,
      nombre: nombreController.text,
      apellido: apellidoController.text,
      email: emailController.text,
      telefono: telefonoController.text,
      direccion: direccionController.text,
      genero: selectedGenero,
      fechaNac: selectedFechaNac,
      nacionalidad: nacionalidadController.text,
      biografia: biografiaController.text,
      foto: fotoUrl,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => const _SavedDialog(),
    ).then((_) => navigator.pop()); // opcional: cerrar después de guardar
  }

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _saveProfile,
              child: const Text("Guardar"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 Avatar editable
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: localImageFile != null
                          ? FileImage(localImageFile!)
                          : (fotoUrl != null
                          ? NetworkImage(fotoUrl!)
                          : const NetworkImage(
                          "https://i.pravatar.cc/150?img=47")) as ImageProvider,
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
                          onPressed: _pickImage,
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

              _buildInput("Usuario", usuarioController),
              const SizedBox(height: 16),
              _buildInput("Nombre", nombreController),
              const SizedBox(height: 16),
              _buildInput("Apellido", apellidoController),
              const SizedBox(height: 16),
              _buildInput("Correo electrónico", emailController,
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildInput("Teléfono", telefonoController,
                  inputType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildInput("Dirección", direccionController),
              const SizedBox(height: 16),
              _buildInput("Nacionalidad", nacionalidadController),
              const SizedBox(height: 16),
              _buildInput("Biografía", biografiaController, maxLines: 3),
              const SizedBox(height: 16),

              // 📅 Fecha de nacimiento
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: fechaNacController,
                    decoration: const InputDecoration(
                      labelText: "Fecha de nacimiento",
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 📚 Género
              DropdownButtonFormField<String>(
                value: generos.contains(selectedGenero) ? selectedGenero : null,
                items: generos
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedGenero = val;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Género",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      validator: (val) => val == null || val.isEmpty ? "Campo requerido" : null,
      decoration: InputDecoration(
        labelText: label,
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
