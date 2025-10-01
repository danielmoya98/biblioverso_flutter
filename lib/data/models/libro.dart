class Libro {
  final int idLibro;
  final String titulo;
  final String? portada;
  final String? sinopsis;
  final String? editorial;
  final DateTime? fechaPublicacion;
  final int disponibles;

  // 🔹 Campos extra para detalle
  final String? isbn;
  final String? categoria;
  final String? autores;
  final double? rating;
  final int? reviews;

  Libro({
    required this.idLibro,
    required this.titulo,
    this.portada,
    this.sinopsis,
    this.editorial,
    this.fechaPublicacion,
    required this.disponibles,
    this.isbn,
    this.categoria,
    this.autores,
    this.rating,
    this.reviews,
  });

  /// Para lista (categoría)
  factory Libro.fromRow(List<dynamic> row) {
    return Libro(
      idLibro: int.tryParse(row[0].toString()) ?? 0,
      titulo: row[1]?.toString() ?? "Sin título",
      portada: row[2]?.toString(),
      sinopsis: row[3]?.toString(),
      editorial: row[4]?.toString(),
      fechaPublicacion:
      row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
      disponibles: int.tryParse(row[6]?.toString() ?? "0") ?? 0,
    );
  }

  /// Para detalle
  factory Libro.fromDetailRow(List<dynamic> row) {
    return Libro(
      idLibro: int.tryParse(row[0].toString()) ?? 0,
      isbn: row[1]?.toString(),
      titulo: row[2]?.toString() ?? "Sin título",
      sinopsis: row[3]?.toString(),
      editorial: row[4]?.toString(),
      fechaPublicacion:
      row[5] != null ? DateTime.tryParse(row[5].toString()) : null,
      portada: row[6]?.toString(),
      categoria: row[7]?.toString(),
      autores: row[8]?.toString(),
      disponibles: int.tryParse(row[9]?.toString() ?? "0") ?? 0,
      rating: row[10] != null
          ? double.tryParse(row[10].toString()) ?? 0.0
          : 0.0,
      reviews: int.tryParse(row[11]?.toString() ?? "0") ?? 0,
    );
  }
}
