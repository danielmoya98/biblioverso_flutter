import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  String? selectedSubject;

  final subjects = [
    "Problemas con una reserva",
    "Sugerencia de libro",
    "Problemas con mi cuenta",
    "Otro"
  ];

  final faqs = [
    {
      "q": "¿Cómo puedo reservar un libro?",
      "a": "Busca el libro, entra a su ficha y pulsa en 'Reservar'."
    },
    {
      "q": "¿Cuánto tiempo tengo para recoger mi reserva?",
      "a": "Dispones de 48 horas desde que recibes la confirmación."
    },
    {
      "q": "¿Puedo cancelar una reserva?",
      "a": "Sí, desde 'Mis Reservas' puedes cancelarla en cualquier momento."
    },
    {
      "q": "¿Hay límite en el número de reservas?",
      "a": "Puedes reservar hasta 5 libros de manera simultánea."
    },
    {
      "q": "¿Cómo funciona la lista de espera?",
      "a":
      "Si un libro está agotado, podrás unirte a la lista de espera y se te notificará cuando esté disponible."
    },
    {
      "q": "¿Puedo cambiar la sucursal de recogida?",
      "a":
      "Una vez confirmada la reserva, no es posible cambiar la sucursal. Deberás cancelarla y hacer una nueva en la sucursal deseada."
    },
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayuda y Soporte"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Ayuda rápida
          const Text("¿Necesitas ayuda rápida?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickHelpCard(
                  icon: Icons.phone,
                  title: "Llamar",
                  subtitle: "900 123 456",
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickHelpCard(
                  icon: Icons.email,
                  title: "Email",
                  subtitle: "ayuda@biblioverso.com",
                  color: Colors.blue,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 🔹 FAQs
          const Text("Preguntas Frecuentes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq["q"]!),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faq["a"]!),
              )
            ],
          )),
          const SizedBox(height: 24),

          // 🔹 Formulario de contacto
          const Text("Contáctanos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: _inputDecoration("Nombre"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            decoration: _inputDecoration("Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration("Asunto"),
            initialValue: selectedSubject,
            items: subjects
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => selectedSubject = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: messageController,
            maxLines: 5,
            maxLength: 500,
            decoration: _inputDecoration("Mensaje").copyWith(
              hintText: "Describe tu consulta o problema...",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // lógica para enviar mensaje
            },
            child: const Text("Enviar mensaje",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(height: 24),

          // 🔹 Horarios
          const Text("Horarios de Atención",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          _scheduleRow("Lunes a Viernes", "9:00 - 20:00"),
          _scheduleRow("Sábados", "10:00 - 18:00"),
          _scheduleRow("Domingos", "Cerrado"),
        ],
      ),
    );
  }

  // ---------------- Widgets auxiliares ----------------

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _scheduleRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontSize: 14)),
          Text(hours, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _QuickHelpCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickHelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), // ✅ reemplazo de withOpacity
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 20,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
