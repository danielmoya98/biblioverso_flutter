class Usuario {
  final int idUsuario;
  final String? usuario;
  final String? password;
  final String? nombre;
  final String? apellido;
  final String email;
  final String? telefono;
  final String? direccion;
  final String? genero;
  final DateTime? fechaNac;
  final String? nacionalidad;
  final String? biografia;
  final String? foto;

  Usuario({
    required this.idUsuario,
    this.usuario,
    this.password,
    this.nombre,
    this.apellido,
    required this.email,
    this.telefono,
    this.direccion,
    this.genero,
    this.fechaNac,
    this.nacionalidad,
    this.biografia,
    this.foto,
  });

  factory Usuario.fromRow(List<dynamic> row) {
    return Usuario(
      idUsuario: row[0],
      usuario: row[1],
      password: row[2],
      nombre: row[3],
      apellido: row[4],
      email: row[5],
      telefono: row[6],
      direccion: row[7],
      genero: row[8],
      fechaNac: row[9] != null ? DateTime.tryParse(row[9].toString()) : null,
      nacionalidad: row[10],
      biografia: row[11],
      foto: row[12],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idUsuario": idUsuario,
      "usuario": usuario,
      "nombre": nombre,
      "apellido": apellido,
      "email": email,
      "telefono": telefono,
      "direccion": direccion,
      "genero": genero,
      "fechaNac": fechaNac?.toIso8601String(),
      "nacionalidad": nacionalidad,
      "biografia": biografia,
      "foto": foto,
    };
  }
}
