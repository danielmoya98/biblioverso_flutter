import '../../core/postgres_client.dart';

class AccesoRapidoService {
  /// 🔹 Obtener cantidad de reservas activas de un usuario
  Future<int> getReservasActivas(int userId) async {
    final result = await NeonDb.query(
      '''
    SELECT COUNT(*) 
    FROM reserva 
    WHERE id_usuario = @idUsuario AND estado = 'pendiente';
    ''',
      params: {"idUsuario": userId},
    );

    // 👇 convertir BigInt a int
    final count = result[0][0];
    return (count is BigInt) ? count.toInt() : count as int;
  }


  /// 🔹 Obtener cantidad de libros en favoritos de un usuario
  Future<int> getFavoritos(int userId) async {
    final result = await NeonDb.query(
      '''
    SELECT COUNT(*) 
    FROM favoritos 
    WHERE id_usuario = @idUsuario;
    ''',
      params: {"idUsuario": userId},
    );

    final count = result[0][0];
    return (count is BigInt) ? count.toInt() : count as int;
  }

}
