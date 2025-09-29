import 'package:biblioverso_flutter/core/postgres_client.dart';
import '../../core/utils/hash_helper.dart';
import '../models/usuario.dart';

class UsuarioService {
  Future<Usuario?> login(String email, String password) async {
    final hashedPassword = HashHelper.hashPassword(password);

    final result = await NeonDb.query(
      '''
      SELECT id_usuario, usuario, password, nombre, apellido, email, telefono, direccion, genero, fecha_nac, nacionalidad, biografia, foto
      FROM usuario
      WHERE email = @correo AND password = @password
      LIMIT 1
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
        INSERT INTO usuario (nombre, apellido, email, password, fecha_creacion, fecha_actualizacion,id_rol)
        VALUES (@nombre, @apellido, @correo, @password, now(), now() ,2)
        RETURNING id_usuario, usuario, password, nombre, apellido, email, telefono, direccion, genero, fecha_nac, nacionalidad, biografia, foto
        ''',
        params: {
          "nombre": nombre,
          "apellido": apellido,
          "correo": email,
          "password": hashedPassword
        },
      );

      if (result.isNotEmpty) {
        return Usuario.fromRow(result.first);
      }
      return null;
    } catch (e) {
      throw Exception("Error al registrar usuario: $e");
    }
  }

  Future<void> updateUsuario(Usuario user) async {
    try {
      await NeonDb.query(
        '''
        UPDATE usuario 
        SET 
          usuario = @usuario,
          nombre = @nombre,
          apellido = @apellido,
          email = @correo,
          telefono = @telefono,
          direccion = @direccion,
          genero = @genero,
          fecha_nac = @fechaNac,
          nacionalidad = @nacionalidad,
          biografia = @biografia,
          foto = @foto,
          fecha_actualizacion = now()
        WHERE id_usuario = @id
        ''',
        params: {
          "id": user.idUsuario,
          "usuario": user.usuario,
          "nombre": user.nombre,
          "apellido": user.apellido,
          "correo": user.email,
          "telefono": user.telefono,
          "direccion": user.direccion,
          "genero": user.genero,
          "fechaNac": user.fechaNac?.toIso8601String(),
          "nacionalidad": user.nacionalidad,
          "biografia": user.biografia,
          "foto": user.foto,
        },
      );
    } catch (e) {
      throw Exception("Error al actualizar usuario: $e");
    }
  }
}
