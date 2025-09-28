class Usuario {
  final int idUsuario;
  final String? usuario;
  final String? nombre;
  final String? apellido;
  final String email;
  final String? telefono;
  final String? direccion;
  final String? foto;

  Usuario({
    required this.idUsuario,
    this.usuario,
    this.nombre,
    this.apellido,
    required this.email,
    this.telefono,
    this.direccion,
    this.foto,
  });

  /// Construir desde fila de BD
  factory Usuario.fromRow(List<dynamic> row) {
    return Usuario(
      idUsuario: row[0],
      nombre: row[1],
      email: row[2],
    );
  }
}
