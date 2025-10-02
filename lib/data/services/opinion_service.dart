import 'package:flutter/foundation.dart';
import '../../core/postgres_client.dart';

class OpinionService {
  /// Agregar una reseña
  Future<void> agregarOpinion(
      int userId, int libroId, int calificacion, String comentario) async {
    await NeonDb.execute("""
      INSERT INTO opiniones (id_libro, id_usuario, calificacion, comentario, fecha)
      VALUES (@libroId, @userId, @calificacion, @comentario, now());
    """, params: {
      "libroId": libroId,
      "userId": userId,
      "calificacion": calificacion,
      "comentario": comentario,
    });
    debugPrint("⭐ Opinión agregada: $calificacion estrellas");
  }

  /// Obtener reseñas de un libro
  Future<List<Map<String, dynamic>>> getOpiniones(int libroId) async {
    const sql = """
      SELECT o.id_opinion, o.calificacion, o.comentario, o.fecha, 
             u.nombre AS usuario
      FROM opiniones o
      JOIN usuario u ON u.id_usuario = o.id_usuario
      WHERE o.id_libro = @libroId
      ORDER BY o.fecha DESC;
    """;

    final result = await NeonDb.query(sql, params: {"libroId": libroId});
    return result.map((row) {
      return {
        "idOpinion": row[0],
        "calificacion": row[1],
        "comentario": row[2],
        "fecha": row[3].toString(),
        "usuario": row[4],
      };
    }).toList();
  }
}
