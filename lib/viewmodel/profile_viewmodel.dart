import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';
import '../data/services/usuario_service.dart';
import '../data/models/usuario.dart';

class ProfileViewModel extends ChangeNotifier {
  String memberSince = "marzo de 2023";
  final UsuarioService _usuarioService = UsuarioService();

  // 🔹 Campos de la tabla usuario
  int? _idUsuario;
  String? _clUsuario;
  String? _usuario;
  String? _password; // ⚠️ solo si vas a mostrar/cambiar (normalmente no se expone)
  String _nombre = "";
  String _apellido = "";
  String _email = "";
  String _telefono = "";
  String _direccion = "";
  String _genero = "";
  DateTime? _fechaNac;
  String _nacionalidad = "";
  String _biografia = "";
  String? _foto;
  int? _idRol;

  // 🔹 Getters
  int? get idUsuario => _idUsuario;
  String? get clUsuario => _clUsuario;
  String? get usuario => _usuario;
  String? get password => _password;
  String get nombre => _nombre;
  String get apellido => _apellido;
  String get email => _email;
  String get telefono => _telefono;
  String get direccion => _direccion;
  String get genero => _genero;
  DateTime? get fechaNac => _fechaNac;
  String get nacionalidad => _nacionalidad;
  String get biografia => _biografia;
  String? get foto => _foto;
  int? get idRol => _idRol;

  ProfileViewModel() {
    loadUserData();
  }

  /// Carga datos guardados en sesión (SharedPreferences)
  Future<void> loadUserData() async {
    final data = await SessionManager.getUserData();

    _idUsuario = data["id_usuario"];
    _clUsuario = data["cl_usuario"];
    _usuario = data["usuario"];
    _password = data["password"];
    _nombre = data["nombre"] ?? "";
    _apellido = data["apellido"] ?? "";
    _email = data["email"] ?? "";
    _telefono = data["telefono"] ?? "";
    _direccion = data["direccion"] ?? "";
    _genero = data["genero"] ?? "";
    _nacionalidad = data["nacionalidad"] ?? "";
    _biografia = data["biografia"] ?? "";
    _idRol = data["id_rol"];

    final fechaNacStr = data["fecha_nac"];
    if (fechaNacStr != null && fechaNacStr.isNotEmpty) {
      _fechaNac = DateTime.tryParse(fechaNacStr);
    }

    _foto = data["foto"];

    notifyListeners();
    debugPrint("✅ Usuario cargado: $_nombre $_apellido ($_email)");
  }

  Future<void> updateProfile({
    String? usuario,
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? direccion,
    String? genero,
    DateTime? fechaNac,
    String? nacionalidad,
    String? biografia,
    String? foto,
  }) async {
    final current = await SessionManager.getUserData();

    // Construimos el objeto actualizado
    final updatedUser = Usuario(
      idUsuario: current["id_usuario"],
      usuario: usuario ?? _usuario,
      password: current["password"],
      nombre: nombre ?? _nombre,
      apellido: apellido ?? _apellido,
      email: email ?? _email,
      telefono: telefono ?? _telefono,
      direccion: direccion ?? _direccion,
      genero: genero ?? _genero,
      fechaNac: fechaNac ?? _fechaNac,
      nacionalidad: nacionalidad ?? _nacionalidad,
      biografia: biografia ?? _biografia,
      foto: foto ?? _foto,
    );

    // 🔹 Actualizar en BD Neon
    await _usuarioService.updateUsuario(updatedUser);

    // 🔹 Guardar en SharedPreferences
    await SessionManager.saveLoginSession(updatedUser);

    // 🔹 Actualizar en memoria
    _usuario = updatedUser.usuario;
    _nombre = updatedUser.nombre ?? "";
    _apellido = updatedUser.apellido ?? "";
    _email = updatedUser.email;
    _telefono = updatedUser.telefono ?? "";
    _direccion = updatedUser.direccion ?? "";
    _genero = updatedUser.genero ?? "";
    _fechaNac = updatedUser.fechaNac;
    _nacionalidad = updatedUser.nacionalidad ?? "";
    _biografia = updatedUser.biografia ?? "";
    _foto = updatedUser.foto;

    notifyListeners();
    debugPrint("✅ Perfil actualizado en BD y sesión: $_nombre $_apellido");
  }

  /// Logout
  Future<void> logout(BuildContext context) async {
    // ✅ Capturamos el Navigator ANTES del await
    final navigator = Navigator.of(context);

    await SessionManager.clearSession();

    if (!context.mounted) return; // Seguridad extra
    navigator.pushNamedAndRemoveUntil("/welcome", (_) => false);
  }
}
