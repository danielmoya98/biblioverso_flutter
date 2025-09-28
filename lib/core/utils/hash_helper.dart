import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashHelper {
  /// Cifra un texto plano usando SHA256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
