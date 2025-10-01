import '../../core/postgres_client.dart';

class RecommendationsService {
  /// Para ti (basado en favoritos del usuario, con fallback si no tiene)
  Future<List<Map<String, dynamic>>> getForYou(int userId) async {
    final sql = """
    SELECT l.id_libro,
           l.titulo,
           l.editorial,
           l.portada AS image,
           l.sinopsis,
           c.nombre AS categoria,
           COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) AS disponibles
    FROM libro l
    LEFT JOIN categoria c ON l.id_categoria = c.id_categoria
    LEFT JOIN stock s ON l.id_libro = s.id_libro
    WHERE l.eliminado = FALSE
      AND (
        -- ✅ Caso 1: el usuario tiene favoritos → se filtra por esas categorías
        (
          EXISTS (
            SELECT 1 FROM favoritos f WHERE f.id_usuario = @userId
          )
          AND l.id_categoria IN (
            SELECT l2.id_categoria
            FROM favoritos f
            JOIN libro l2 ON f.id_libro = l2.id_libro
            WHERE f.id_usuario = @userId
          )
        )
        -- ✅ Caso 2: no tiene favoritos → se muestran libros generales
        OR NOT EXISTS (
          SELECT 1 FROM favoritos f WHERE f.id_usuario = @userId
        )
      )
    GROUP BY l.id_libro, l.titulo, l.editorial, l.portada, l.sinopsis, c.nombre
    ORDER BY RANDOM()
    LIMIT 10;
  """;

    final result = await NeonDb.query(sql, params: {"userId": userId});
    return result.map((row) {
      final disponibles = row[6] as int;
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "image": row[3],
        "description": row[4],
        "category": row[5],
        "disponibles": disponibles,
        "status": (disponibles > 0) ? "Disponible" : "Agotado",
      };
    }).toList();
  }

  /// Populares (más reservados)
  Future<List<Map<String, dynamic>>> getPopular() async {
    final sql = """
      SELECT l.id_libro,
             l.titulo,
             l.editorial,
             l.portada AS image,
             COUNT(r.id_reserva) AS reservas
      FROM libro l
      JOIN reserva r ON r.id_libro = l.id_libro
      WHERE l.eliminado = FALSE
        AND r.estado NOT IN ('cancelada')
      GROUP BY l.id_libro, l.titulo, l.editorial, l.portada
      ORDER BY reservas DESC
      LIMIT 10;
    """;

    final result = await NeonDb.query(sql);
    return result.map((row) {
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "image": row[3],
        "reservas": row[4],
        "status": "Disponible" // 🔹 aquí asumimos que si está reservado, está activo
      };
    }).toList();
  }

  /// Novedades (últimos agregados)
  Future<List<Map<String, dynamic>>> getRecent() async {
    final sql = """
      SELECT l.id_libro,
             l.titulo,
             l.editorial,
             l.portada AS image,
             l.fecha_publicacion::TEXT AS year
      FROM libro l
      WHERE l.eliminado = FALSE
      ORDER BY l.fecha_creacion DESC
      LIMIT 10;
    """;

    final result = await NeonDb.query(sql);
    return result.map((row) {
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "image": row[3],
        "year": row[4],
        "status": "Nuevo"
      };
    }).toList();
  }
}
