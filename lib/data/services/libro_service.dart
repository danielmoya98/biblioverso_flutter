import '../../core/postgres_client.dart';
import '../models/libro.dart';

class LibroService {
  // 🔹 Libros por categoría
  Future<List<Libro>> getLibrosByCategoria(int idCategoria) async {
    final result = await NeonDb.query('''
      SELECT l.id_libro,
             l.titulo,
             l.portada,
             l.sinopsis,
             l.editorial,
             l.fecha_publicacion,
             COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) AS disponibles
      FROM libro l
      LEFT JOIN stock s ON l.id_libro = s.id_libro
      WHERE l.id_categoria = $idCategoria
      GROUP BY l.id_libro, l.titulo, l.portada, l.sinopsis, l.editorial, l.fecha_publicacion
      ORDER BY l.titulo;
    ''');

    return result.map((row) => Libro.fromRow(row)).toList();
  }

  // 🔹 Detalle de un libro
  Future<Libro> getLibroDetalle(int idLibro) async {
    final result = await NeonDb.query('''
      SELECT l.id_libro,
             l.isbn,
             l.titulo,
             l.sinopsis,
             l.editorial,
             l.fecha_publicacion,
             l.portada,
             c.nombre AS categoria,
             STRING_AGG(a.nombre, ', ') AS autores,
             COUNT(CASE WHEN s.disponibilidad = TRUE THEN 1 END) AS disponibles,
             COALESCE(ROUND(AVG(o.calificacion),1), 0) AS rating,
             COUNT(o.id_opinion) AS reviews
      FROM libro l
      LEFT JOIN categoria c ON l.id_categoria = c.id_categoria
      LEFT JOIN libro_autor la ON l.id_libro = la.id_libro
      LEFT JOIN autor a ON la.id_autor = a.id_autor
      LEFT JOIN stock s ON l.id_libro = s.id_libro
      LEFT JOIN opiniones o ON l.id_libro = o.id_libro
      WHERE l.id_libro = @idLibro
        AND l.eliminado = FALSE
      GROUP BY l.id_libro, l.isbn, l.titulo, l.sinopsis, l.editorial, l.fecha_publicacion, l.portada, c.nombre;
    ''', params: {"idLibro": idLibro});

    return Libro.fromDetailRow(result.first);
  }

  // 🔹 Agregar opinión
  Future<void> addOpinion(int libroId, int userId, int rating, String comment) async {
    await NeonDb.query('''
      INSERT INTO opiniones (id_libro, id_usuario, calificacion, comentario, fecha)
      VALUES (@libroId, @userId, @rating, @comment, NOW());
    ''', params: {
      "libroId": libroId,
      "userId": userId,
      "rating": rating,
      "comment": comment,
    });
  }

  // 🔹 Crear reserva
  Future<void> addReserva(int libroId, int userId, int cantidad) async {
    final sql = '''
      INSERT INTO reserva (id_usuario, id_libro, fecha_reserva, estado)
      VALUES (@userId, @libroId, NOW(), 'pendiente');
    ''';
    for (int i = 0; i < cantidad; i++) {
      await NeonDb.query(sql, params: {
        "libroId": libroId,
        "userId": userId,
      });
    }
  }
}
