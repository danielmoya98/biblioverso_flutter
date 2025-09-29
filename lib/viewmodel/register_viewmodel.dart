import 'package:flutter/material.dart';
import '../core/utils/SessionManager.dart';
import '../data/services/usuario_service.dart';
import '../data/models/usuario.dart';

class RegisterViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final UsuarioService _usuarioService = UsuarioService();

  bool _loading = false;
  bool get loading => _loading;

  Usuario? _nuevoUsuario;

  Future<void> register(BuildContext context) async {
    _setLoading(true);

    try {
      final user = await _usuarioService.register(
        nameController.text.trim(),
        apellidoController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        _nuevoUsuario = user;

        // ✅ Guardar sesión al registrarse
        await SessionManager.saveLoginSession(user);


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Usuario registrado con éxito")),
        );

        Navigator.pushReplacementNamed(context, "/home");
      } else {
        _showError(context, "No se pudo registrar el usuario");
      }
    } catch (e) {
      _showError(context, "Error en el registro: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
