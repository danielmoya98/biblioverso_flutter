import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "q": "¿Cómo puedo reservar un libro?",
        "a": "Busca el libro, entra a su ficha y pulsa en 'Reservar'."
      },
      {
        "q": "¿Qué pasa si un libro está sin stock?",
        "a": "Podrás unirte a la lista de espera y se te notificará cuando esté disponible."
      },
      {
        "q": "¿Cómo cancelo una reserva?",
        "a": "En 'Mis Reservas', selecciona la reserva y pulsa 'Cancelar'."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayuda y Soporte"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Preguntas Frecuentes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq["q"]!),
            children: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(faq["a"]!),
            )],
          )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Aquí iría un formulario de contacto o integración con correo
            },
            icon: const Icon(Icons.mail),
            label: const Text("Contactar soporte"),
          )
        ],
      ),
    );
  }
}
