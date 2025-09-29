class Categoria {
  final int idCategoria;
  final String nombre;
  final int cantidadLibros;

  Categoria({
    required this.idCategoria,
    required this.nombre,
    required this.cantidadLibros,
  });

  factory Categoria.fromRow(List<dynamic> row) {
    return Categoria(
      idCategoria: row[0],
      nombre: row[1],
      cantidadLibros: row[2] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idCategoria": idCategoria,
      "nombre": nombre,
      "cantidadLibros": cantidadLibros,
    };
  }
}
