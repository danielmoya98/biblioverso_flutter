
import '../../core/postgres_client.dart';

class ReservationsService {
  /// Traer reservas del usuario
  Future<List<Map<String, dynamic>>> getReservas(int userId) async {
    final sql = """
    SELECT r.id_reserva,
           l.titulo AS title,
           r.fecha_reserva AS reserved,
           r.estado AS status,
           r.fecha_expiracion AS expires,
           'Sucursal Central' AS branch, -- 🔹 mock por ahora
           r.id_reserva::TEXT AS code
    FROM reserva r
    JOIN libro l ON r.id_libro = l.id_libro
    WHERE r.id_usuario = @userId
    ORDER BY r.fecha_reserva DESC
  """;

    final result = await NeonDb.query(sql, params: {"userId": userId});

    return result.map((row) {
      return {
        "id": row[0],
        "title": row[1],
        "reserved": row[2]?.toString().split(" ").first,
        "status": row[3],
        "expires": row[4]?.toString().split(" ").first,
        "branch": row[5],
        "code": row[6],
      };
    }).toList();
  }



  /// Cancelar reserva
  Future<void> cancelarReserva(int reservaId) async {
    final sql = """
      UPDATE reserva
      SET estado = 'cancelado'
      WHERE id_reserva = @reservaId
    """;
    await NeonDb.query(sql, params: {"reservaId": reservaId});
  }
}
