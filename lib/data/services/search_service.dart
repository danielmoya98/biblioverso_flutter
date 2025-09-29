import '../../core/postgres_client.dart';

class SearchService {
  /// Traer libros
  Future<List<Map<String, dynamic>>> getBooks({
    String query = "",
    String filter = "Todos",
  }) async {
    final sql = """
      SELECT l.id_libro,
             l.titulo,
             l.editorial,
             l.fecha_publicacion::TEXT AS year,
             l.portada AS image,
             l.sinopsis AS description,
             c.nombre AS categoria,
             COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) AS disponibles
      FROM libro l
      LEFT JOIN stock s ON l.id_libro = s.id_libro
      LEFT JOIN categoria c ON l.id_categoria = c.id_categoria
      WHERE l.eliminado = FALSE
        AND (@query = '' OR l.titulo ILIKE @query OR l.editorial ILIKE @query OR c.nombre ILIKE @query)
        AND (@filter = 'Todos' OR c.nombre ILIKE @filter)
      GROUP BY l.id_libro, l.titulo, l.editorial, l.fecha_publicacion, l.portada, l.sinopsis, c.nombre
      ORDER BY l.titulo ASC;
    """;

    final result = await NeonDb.query(sql, params: {
      "query": query.isEmpty ? "" : "%$query%",
      "filter": filter,
    });

    return result.map((row) {
      final disponibles = row[7] as int;
      return {
        "id": row[0],
        "title": row[1],
        "editorial": row[2],
        "year": row[3],
        "image": row[4],
        "description": row[5],
        "category": row[6],
        "disponibles": disponibles,
        "status": (disponibles > 0) ? "Disponible" : "Agotado",
      };
    }).toList();
  }

  /// Traer categorías dinámicamente
  Future<List<String>> getCategories() async {
    const sql = """
      SELECT nombre FROM categoria ORDER BY nombre ASC;
    """;

    final result = await NeonDb.query(sql);

    // Siempre agregamos "Todos" al inicio
    return ["Todos", ...result.map((row) => row[0] as String)];
  }
}
