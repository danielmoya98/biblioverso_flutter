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
}
