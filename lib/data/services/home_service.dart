import '../../core/postgres_client.dart';

class HomeService {
  Future<List<Map<String, dynamic>>> getNovedades() async {
    final sql = """
      SELECT l.id_libro,
             l.titulo,
             l.editorial,
             l.portada AS image,
             l.fecha_publicacion::TEXT AS year,
             l.sinopsis AS description,
             c.nombre AS categoria,
             COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) AS disponibles
      FROM libro l
      LEFT JOIN stock s ON l.id_libro = s.id_libro
      LEFT JOIN categoria c ON l.id_categoria = c.id_categoria
      WHERE l.eliminado = FALSE
      GROUP BY l.id_libro, l.titulo, l.editorial, l.fecha_publicacion, l.portada, l.sinopsis, c.nombre
      ORDER BY l.fecha_creacion DESC
      LIMIT 3;
    """;

    final result = await NeonDb.query(sql);

    return result.map((row) {
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "image": row[3],
        "year": row[4],
        "description": row[5],
        "category": row[6],
        "disponibles": row[7],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDestacados() async {
    const sql = """
      SELECT l.id_libro,
             l.titulo,
             l.editorial,
             l.portada,
             l.fecha_publicacion::TEXT AS year,
             l.sinopsis,
             c.nombre AS categoria,
             (
               SELECT COUNT(*)
               FROM reserva r
               WHERE r.id_libro = l.id_libro
                 AND r.estado NOT IN ('cancelada')
             ) AS reservas,
             (
               SELECT COUNT(*)
               FROM stock s
               WHERE s.id_libro = l.id_libro
                 AND s.disponibilidad = TRUE
             ) AS disponibles
      FROM libro l
      LEFT JOIN categoria c ON l.id_categoria = c.id_categoria
      WHERE l.eliminado = FALSE
        AND (
          SELECT COUNT(*)
          FROM reserva r
          WHERE r.id_libro = l.id_libro
            AND r.estado NOT IN ('cancelada')
        ) >= 1
      ORDER BY reservas DESC
      LIMIT 5; -- 🔹 solo los 5 más destacados
    """;

    final result = await NeonDb.query(sql);

    return result.map((row) {
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "image": row[3],
        "year": row[4],
        "description": row[5],
        "category": row[6],
        "reservas": row[7],
        "disponibles": row[8],
      };
    }).toList();
  }
}
