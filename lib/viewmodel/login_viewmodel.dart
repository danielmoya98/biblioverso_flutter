import 'package:flutter/material.dart';
import '../core/utils/SessionManager.dart';
import '../data/services/usuario_service.dart';
import '../data/models/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final UsuarioService _usuarioService = UsuarioService();

  bool _loading = false;
  bool get loading => _loading;

  Usuario? _usuarioActual;
  Usuario? get usuarioActual => _usuarioActual;

  String? _error;
  String? get error => _error;

  Future<void> login(BuildContext context) async {
    _setLoading(true);

    try {
      final user = await _usuarioService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        _usuarioActual = user;

        // ✅ Guardar sesión completa
        await SessionManager.saveLoginSession(user);


        _setLoading(false);
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        _setError("Correo o contraseña incorrectos", context);
      }
    } catch (e) {
      _setError("Error al conectar con NeonDB: $e", context);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String message, BuildContext context) {
    _error = message;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
