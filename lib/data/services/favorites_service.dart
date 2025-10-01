import 'package:flutter/foundation.dart';
import '../../core/postgres_client.dart';

class FavoritesService {
  /// Obtener favoritos del usuario
  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    const sql = """
      SELECT f.id_favorito,
             f.id_libro,                   
             l.titulo AS title,
             l.sinopsis AS description,
             l.editorial AS editorial,
             l.fecha_publicacion::TEXT AS year,
             l.portada AS image,
             CASE
               WHEN COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) > 0
               THEN 'Disponible'
               ELSE 'Agotado'
             END AS status
      FROM favoritos f
      JOIN libro l ON f.id_libro = l.id_libro
      LEFT JOIN stock s ON l.id_libro = s.id_libro
      WHERE f.id_usuario = @userId
      GROUP BY f.id_favorito, f.id_libro, l.titulo, l.sinopsis, l.editorial, l.fecha_publicacion, l.portada
      ORDER BY MAX(f.fecha_agregado) DESC;
    """;

    final result = await NeonDb.query(sql, params: {"userId": userId});

    return result.map((row) {
      return {
        "idFavorito": row[0],
        "idLibro": row[1],
        "title": row[2],
        "description": row[3],
        "editorial": row[4],
        "year": row[5],
        "image": row[6],
        "status": row[7],
      };
    }).toList();
  }

  /// Agregar un libro a favoritos
  Future<void> addFavorito(int userId, int libroId) async {
    const sql = """
      INSERT INTO favoritos (id_usuario, id_libro)
      VALUES (@userId, @libroId)
      ON CONFLICT (id_usuario, id_libro) DO NOTHING;
    """;

    final affected =
    await NeonDb.execute(sql, params: {"userId": userId, "libroId": libroId});
    debugPrint("⭐ Favorito agregado (rows: $affected)");
  }

  /// Eliminar un favorito
  Future<void> removeFavorito(int userId, int libroId) async {
    const sql = """
      DELETE FROM favoritos
      WHERE id_usuario = @userId AND id_libro = @libroId;
    """;

    final affected =
    await NeonDb.execute(sql, params: {"userId": userId, "libroId": libroId});
    debugPrint("🗑️ Favorito eliminado (rows: $affected)");
  }
}
