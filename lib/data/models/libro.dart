class Libro {
  final int idLibro;
  final String? isbn;
  final String titulo;
  final String? portada;
  final String? sinopsis;
  final String? editorial;
  final DateTime? fechaPublicacion;
  final bool disponible; // 🔹 Calculado con tabla stock

  Libro({
    required this.idLibro,
    this.isbn,
    required this.titulo,
    this.portada,
    this.sinopsis,
    this.editorial,
    this.fechaPublicacion,
    required this.disponible,
  });

  factory Libro.fromRow(List<dynamic> row) {
    return Libro(
      idLibro: row[0],
      isbn: row[1],
      titulo: row[2],
      portada: row[3],
      sinopsis: row[4],
      editorial: row[5],
      fechaPublicacion: row[6] != null ? DateTime.tryParse(row[6].toString()) : null,
      disponible: row[7], // viene de stock.disponibilidad o situacion
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idLibro": idLibro,
      "isbn": isbn,
      "titulo": titulo,
      "portada": portada,
      "sinopsis": sinopsis,
      "editorial": editorial,
      "fechaPublicacion": fechaPublicacion?.toIso8601String(),
      "disponible": disponible,
    };
  }
}
