import 'package:biblioverso_flutter/core/postgres_client.dart';
import '../../core/utils/hash_helper.dart';
import '../models/usuario.dart';

class UsuarioService {
  Future<Usuario?> login(String email, String password) async {
    final hashedPassword = HashHelper.hashPassword(password);

    final result = await NeonDb.query(
      '''
  SELECT id_usuario, nombre, email
  FROM usuario
  WHERE email = @correo AND password = @password
''',
      params: {"correo": email, "password": hashedPassword},
    );

    if (result.isNotEmpty) {
      return Usuario.fromRow(result.first);
    }
    return null;
  }

  Future<Usuario?> register(
    String nombre,
    String apellido,
    String email,
    String password,
  ) async {
    try {
      final hashedPassword = HashHelper.hashPassword(password);

      final result = await NeonDb.query(
        '''
        INSERT INTO usuario (nombre,apellido, email, password, fecha_creacion, fecha_actualizacion)
        VALUES (@nombre,@apellido, @correo, @password, now(), now())
        RETURNING id_usuario, nombre, email
      ''',
        params: {"nombre": nombre,"apellido": apellido, "correo": email, "password": hashedPassword},
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Usuario(idUsuario: row[0], nombre: row[1], email: row[2]);
      }
      return null;
    } catch (e) {
      throw Exception("Error al registrar usuario: $e");
    }
  }
}
