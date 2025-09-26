import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre Biblioverso"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Biblioverso",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "Biblioverso es una aplicación para gestionar y reservar libros "
                  "de tu biblioteca favorita. Nuestra misión es acercar la lectura "
                  "a más personas de forma rápida y sencilla.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Text("Versión: v1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
