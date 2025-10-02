import '../../core/postgres_client.dart';

class NotificacionesService {
  Future<List<Map<String, dynamic>>> getNotificaciones(int userId) async {
    const sql = """
      SELECT id_notificacion, titulo, mensaje, fecha, leida
      FROM notificacion
      WHERE id_usuario = @userId
      ORDER BY fecha DESC
    """;

    final result = await NeonDb.query(sql, params: {"userId": userId});
    return result.map((row) => {
      "id": row[0],
      "titulo": row[1],
      "mensaje": row[2],
      "fecha": row[3].toString(),
      "leida": row[4] ?? false,
    }).toList();
  }

  Future<void> marcarLeida(int idNotificacion) async {
    const sql = "UPDATE notificacion SET leida = TRUE WHERE id_notificacion = @id";
    await NeonDb.execute(sql, params: {"id": idNotificacion});
  }

  Future<void> marcarTodasLeidas(int userId) async {
    const sql = "UPDATE notificacion SET leida = TRUE WHERE id_usuario = @userId";
    await NeonDb.execute(sql, params: {"userId": userId});
  }
}
