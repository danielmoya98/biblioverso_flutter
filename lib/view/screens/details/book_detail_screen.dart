import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isFavorite = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Libro"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Portada o icono
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book["image"] != null
                    ? Image.network(book["image"], height: 180)
                    : Container(
                  height: 180,
                  width: 120,
                  color: Colors.deepPurple.shade50,
                  child: const Icon(Icons.menu_book,
                      size: 60, color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Título y autor
            Text(book["title"] ?? "",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(book["author"] ?? "",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),

            // 🔹 Rating + páginas + año + editorial
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                const SizedBox(width: 4),
                Text("${book["rating"]} (${book["reviews"] ?? "0"} reseñas)"),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.menu_book, text: "${book["pages"] ?? 0} páginas"),
            _InfoRow(icon: Icons.date_range, text: "${book["year"] ?? ""}"),
            _InfoRow(
                icon: Icons.business, text: book["editorial"] ?? "Editorial"),
            const SizedBox(height: 12),

            // 🔹 Precio y stock
            Text(book["price"] ?? "",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            Text("${book["stock"] ?? 0} disponibles",
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w500)),

            const SizedBox(height: 20),

            // 🔹 Descripción
            const Text("Descripción",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              book["description"] ??
                  "Sin descripción disponible para este libro.",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // 🔹 Detalles extra
            const Text("Detalles del libro",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            _DetailRow(label: "ISBN", value: book["isbn"] ?? "N/A"),
            _DetailRow(label: "Idioma", value: book["language"] ?? "Español"),
            _DetailRow(
                label: "Categoría", value: book["category"] ?? "General"),
            _DetailRow(
                label: "Editorial", value: book["editorial"] ?? "Editorial"),
            const SizedBox(height: 20),

            // 🔹 Reseñas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Reseñas",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () => _showReviewDialog(context),
                  child: const Text("Escribir reseña"),
                ),
              ],
            ),
            _ReviewTile(
              name: "Ana Ruiz",
              rating: 5,
              date: "2024-01-12",
              comment:
              "Harari tiene la capacidad única de explicar conceptos complejos de manera accesible. Este libro cambió mi perspectiva sobre la humanidad.",
            ),
            _ReviewTile(
              name: "Carlos Mendoza",
              rating: 4,
              date: "2024-01-08",
              comment:
              "Libro complejo pero gratificante. Requiere atención para seguir la genealogía familiar, pero vale la pena cada página.",
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // 🔹 Footer con cantidad + reservar
      bottomNavigationBar: _ReservationFooter(
        quantity: quantity,
        onQuantityChanged: (newQty) {
          setState(() => quantity = newQty);
        },
        onReserve: () {
          _showConfirmReservationDialog(context, quantity, book);
        },
      ),
    );
  }

  // ---------------------- Diálogo de Reseña ----------------------
  void _showReviewDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Escribir Reseña",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                "Comparte tu opinión sobre este libro",
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ⭐ Calificación
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text("Calificación",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 📝 Comentario
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text("Comentario",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLength: 500,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Escribe tu reseña...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      counterText:
                      "${controller.text.length.toString()}/500 caracteres",
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ],
              );
            },
          ),
          actionsPadding:
          const EdgeInsets.only(bottom: 16, right: 16, left: 16, top: 8),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Reseña publicada con $rating estrellas: ${controller.text}"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Publicar"),
            ),
          ],
        );
      },
    );
  }

  // ---------------------- Diálogo de Confirmar Reserva ----------------------
  void _showConfirmReservationDialog(
      BuildContext context, int quantity, Map<String, dynamic> book) {
    final double price = double.tryParse(
      book["price"].toString().replaceAll("€", "").trim(),
    ) ??
        0.0;
    final double total = price * quantity;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Confirmar Reserva"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "¿Deseas reservar $quantity ejemplares de \"${book["title"]}\"?",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text("Cantidad: $quantity"),
              Text("Precio unitario: ${book["price"]}"),
              Text("Total: €${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Reserva confirmada: $quantity x ${book["title"]}"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------- Widgets auxiliares ----------------------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black54))),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String name, comment, date;
  final int rating;

  const _ReviewTile(
      {required this.name,
        required this.comment,
        required this.date,
        required this.rating});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.shade50,
        child: const Icon(Icons.person, color: Colors.deepPurple),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:
            List.generate(5, (index) => Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 16,
            )),
          ),
          Text(comment),
        ],
      ),
    );
  }
}

class _ReservationFooter extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onReserve;

  const _ReservationFooter(
      {required this.quantity,
        required this.onQuantityChanged,
        required this.onReserve});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Selector de cantidad
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: quantity > 1
                      ? () => onQuantityChanged(quantity - 1)
                      : null,
                ),
                Text(quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => onQuantityChanged(quantity + 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onReserve,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Reservar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
