import 'package:flutter/cupertino.dart';
import '../../core/postgres_client.dart';

class ReservationsService {
  /// Obtener reservas del usuario (activas y en espera)
  Future<List<Map<String, dynamic>>> getReservas(int userId) async {
    const sql = """
      SELECT r.id_reserva, r.id_libro, r.estado, r.fecha_reserva,
             l.titulo, l.portada, l.editorial
      FROM reserva r
      JOIN libro l ON r.id_libro = l.id_libro
      WHERE r.id_usuario = @userId
      ORDER BY r.fecha_reserva DESC;
    """;

    final result = await NeonDb.query(sql, params: {"userId": userId});
    return result.map((row) {
      return {
        "idReserva": row[0],
        "idLibro": row[1],
        "estado": row[2],
        "fechaReserva": row[3]?.toString(),
        "titulo": row[4],
        "portada": row[5],
        "editorial": row[6],
      };
    }).toList();
  }

  /// Cancelar reserva
  Future<void> cancelarReserva(int reservaId) async {
    const sql = """
      UPDATE reserva
      SET estado = 'cancelada'
      WHERE id_reserva = @reservaId;
    """;
    await NeonDb.execute(sql, params: {"reservaId": reservaId});
  }

  /// Crear nueva reserva
  Future<void> reservarLibro(int userId, int libroId, int cantidad) async {
    const sql = """
      INSERT INTO reserva (id_usuario, id_libro, estado)
      VALUES (@userId, @libroId, 'pendiente');
    """;

    final affected = await NeonDb.execute(
      sql,
      params: {"userId": userId, "libroId": libroId},
    );
    debugPrint("✅ Reserva creada (rows: $affected)");
  }

  /// Unirse a lista de espera (cuando no hay stock)
  Future<void> unirseListaEspera(int userId, int libroId) async {
    const sql = """
      INSERT INTO reserva (id_usuario, id_libro, estado)
      VALUES (@userId, @libroId, 'lista_espera')
      ON CONFLICT DO NOTHING;
    """;

    final affected = await NeonDb.execute(
      sql,
      params: {"userId": userId, "libroId": libroId},
    );
    debugPrint("🕒 Usuario $userId unido a lista de espera de libro $libroId (rows: $affected)");
  }
}
