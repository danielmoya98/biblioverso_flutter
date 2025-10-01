import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/usuario.dart';

class SessionManager {
  // 🔹 Keys
  static const String _keyUserId = "id_usuario";
  static const String _keyClUsuario = "cl_usuario";
  static const String _keyUsuario = "usuario";
  static const String _keyPassword = "password"; // ⚠️ ojo, usualmente no se guarda plano
  static const String _keyNombre = "nombre";
  static const String _keyApellido = "apellido";
  static const String _keyEmail = "email";
  static const String _keyTelefono = "telefono";
  static const String _keyDireccion = "direccion";
  static const String _keyGenero = "genero";
  static const String _keyFechaNac = "fecha_nac";
  static const String _keyNacionalidad = "nacionalidad";
  static const String _keyBiografia = "biografia";
  static const String _keyFoto = "foto";
  static const String _keyIdRol = "id_rol";
  static const String _keyOnboardingSeen = "seen_onboarding";

  /// Guardar sesión del usuario
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user["id_usuario"] != null) {
      await prefs.setInt(_keyUserId, user["id_usuario"]);
    }
    if (user["cl_usuario"] != null) {
      await prefs.setString(_keyClUsuario, user["cl_usuario"]);
    }
    if (user["usuario"] != null) {
      await prefs.setString(_keyUsuario, user["usuario"]);
    }
    if (user["password"] != null) {
      await prefs.setString(_keyPassword, user["password"]);
    }
    if (user["nombre"] != null) {
      await prefs.setString(_keyNombre, user["nombre"]);
    }
    if (user["apellido"] != null) {
      await prefs.setString(_keyApellido, user["apellido"]);
    }
    if (user["email"] != null) {
      await prefs.setString(_keyEmail, user["email"]);
    }
    if (user["telefono"] != null) {
      await prefs.setString(_keyTelefono, user["telefono"]);
    }
    if (user["direccion"] != null) {
      await prefs.setString(_keyDireccion, user["direccion"]);
    }
    if (user["genero"] != null) {
      await prefs.setString(_keyGenero, user["genero"]);
    }
    if (user["fecha_nac"] != null) {
      await prefs.setString(_keyFechaNac, user["fecha_nac"]);
    }
    if (user["nacionalidad"] != null) {
      await prefs.setString(_keyNacionalidad, user["nacionalidad"]);
    }
    if (user["biografia"] != null) {
      await prefs.setString(_keyBiografia, user["biografia"]);
    }
    if (user["foto"] != null) {
      await prefs.setString(_keyFoto, user["foto"]);
    }
    if (user["id_rol"] != null) {
      await prefs.setInt(_keyIdRol, user["id_rol"]);
    }
  }

  /// ✅ Guardar sesión completa desde un objeto Usuario
  static Future<void> saveLoginSession(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyUserId, user.idUsuario);
    if (user.usuario != null) await prefs.setString(_keyUsuario, user.usuario!);
    if (user.password != null) await prefs.setString(_keyPassword, user.password!);
    if (user.nombre != null) await prefs.setString(_keyNombre, user.nombre!);
    if (user.apellido != null) await prefs.setString(_keyApellido, user.apellido!);
    await prefs.setString(_keyEmail, user.email);
    if (user.telefono != null) await prefs.setString(_keyTelefono, user.telefono!);
    if (user.direccion != null) await prefs.setString(_keyDireccion, user.direccion!);
    if (user.genero != null) await prefs.setString(_keyGenero, user.genero!);
    if (user.fechaNac != null) {
      await prefs.setString(_keyFechaNac, user.fechaNac!.toIso8601String());
    }
    if (user.nacionalidad != null) await prefs.setString(_keyNacionalidad, user.nacionalidad!);
    if (user.biografia != null) await prefs.setString(_keyBiografia, user.biografia!);
    if (user.foto != null) await prefs.setString(_keyFoto, user.foto!);
  }

  /// Revisar si hay usuario logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUserId);
  }

  /// Obtener datos del usuario
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "id_usuario": prefs.getInt(_keyUserId),
      "cl_usuario": prefs.getString(_keyClUsuario),
      "usuario": prefs.getString(_keyUsuario),
      "password": prefs.getString(_keyPassword),
      "nombre": prefs.getString(_keyNombre) ?? "",
      "apellido": prefs.getString(_keyApellido) ?? "",
      "email": prefs.getString(_keyEmail) ?? "",
      "telefono": prefs.getString(_keyTelefono) ?? "",
      "direccion": prefs.getString(_keyDireccion) ?? "",
      "genero": prefs.getString(_keyGenero) ?? "",
      "fecha_nac": prefs.getString(_keyFechaNac),
      "nacionalidad": prefs.getString(_keyNacionalidad) ?? "",
      "biografia": prefs.getString(_keyBiografia) ?? "",
      "foto": prefs.getString(_keyFoto),
      "id_rol": prefs.getInt(_keyIdRol),
    };
  }

  /// Guardar flag de onboarding visto
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingSeen, true);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingSeen) ?? false;
  }

  /// Cerrar sesión
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
