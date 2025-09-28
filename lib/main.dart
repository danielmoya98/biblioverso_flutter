import 'package:flutter/material.dart';
import 'app.dart';
import 'core/postgres_client.dart';

Future<void> main() async {
  await NeonDb.connect();
  runApp(const MyApp());
}
