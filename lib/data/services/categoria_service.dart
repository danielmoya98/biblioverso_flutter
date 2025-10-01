import 'package:flutter/foundation.dart';
import '../../core/postgres_client.dart';
import '../models/categoria.dart';

class CategoriaService {
  Future<List<Categoria>> getAllCategoriasConConteo() async {
    final result = await NeonDb.query('''
      SELECT c.id_categoria,
             c.nombre,
             COALESCE(COUNT(l.id_libro), 0) AS cantidad_libros
      FROM categoria c
      LEFT JOIN libro l ON l.id_categoria = c.id_categoria
      GROUP BY c.id_categoria, c.nombre
      ORDER BY c.nombre;
    ''');

    debugPrint("🔹 Resultado crudo con conteo: $result");

    final categorias = result.map((row) {
      debugPrint("➡️ Fila: $row");
      return Categoria.fromRow(row);
    }).toList();

    debugPrint(
      "✅ Categorías con conteo: ${categorias.map((c) => "${c.nombre} (${c.cantidadLibros})").toList()}",
    );

    return categorias;
  }
}
