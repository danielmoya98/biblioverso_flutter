class Libro {
  final int idLibro;
  final String titulo;
  final String? portada;
  final String? sinopsis;
  final String? editorial;
  final DateTime? fechaPublicacion;
  final int disponibles;

  Libro({
    required this.idLibro,
    required this.titulo,
    this.portada,
    this.sinopsis,
    this.editorial,
    this.fechaPublicacion,
    required this.disponibles,
  });

  factory Libro.fromRow(List<dynamic> row) {
    return Libro(
      idLibro: row[0] as int,
      titulo: row[1] as String,
      portada: row[2] as String?,
      sinopsis: row[3] as String?,
      editorial: row[4] as String?,
      fechaPublicacion: row[5] != null
          ? DateTime.tryParse(row[5].toString())
          : null,
      disponibles: row[6] != null ? row[6] as int : 0,
    );
  }
}
