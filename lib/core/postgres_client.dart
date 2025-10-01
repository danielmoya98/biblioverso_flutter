import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

class NeonDb {
  static late PostgreSQLConnection connection;

  /// Inicializa la conexión a Neon
  static Future<void> connect() async {
    connection = PostgreSQLConnection(
      "ep-soft-truth-adn780tq-pooler.c-2.us-east-1.aws.neon.tech", // host
      5432,                     // puerto por defecto
      "neondb",                 // nombre de la BD
      username: "neondb_owner",
      password: "npg_8LsPxfKyH5du",
      useSSL: true,             // 🔹 obligatorio en Neon
    );

    await connection.open();
    debugPrint("✅ Conectado a NeonDB");
  }

  /// Ejecutar consultas simples
  static Future<List<List<dynamic>>> query(String sql,
      {Map<String, dynamic>? params}) async {
    if (connection.isClosed) {
      await connect();
    }
    return await connection.query(sql, substitutionValues: params);
  }

  /// Ejecutar comandos de modificación (INSERT, UPDATE, DELETE)
  static Future<int> execute(String sql,
      {Map<String, dynamic>? params}) async {
    if (connection.isClosed) {
      await connect();
    }
    return await connection.execute(sql, substitutionValues: params);
  }
}
