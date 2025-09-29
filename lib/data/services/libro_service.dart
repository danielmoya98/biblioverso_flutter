import '../../core/postgres_client.dart';
import '../models/libro.dart';

class LibroService {
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

    print("📚 Resultado crudo libros: $result");

    return result.map((row) => Libro.fromRow(row)).toList();
  }
}
