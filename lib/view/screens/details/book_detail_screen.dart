import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/libro_viewmodel.dart';

class BookDetailScreen extends StatefulWidget {
  final int idLibro;

  const BookDetailScreen({super.key, required this.idLibro});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isFavorite = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LibroViewModel>(context, listen: false)
          .fetchLibroDetalle(widget.idLibro);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LibroViewModel>(context);

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalles del Libro")),
        body: Center(child: Text(vm.errorMessage!)),
      );
    }

    final book = vm.libroDetalle;
    if (book == null) {
      return const Scaffold(
        body: Center(child: Text("Libro no encontrado")),
      );
    }

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
            // 🔹 Portada
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book.portada != null
                    ? Image.network(book.portada!, height: 180)
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

            // 🔹 Título + Autores
            Text(book.titulo,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(book.autores ?? "Autor desconocido",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),

            // 🔹 Rating + año + editorial
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                const SizedBox(width: 4),
                Text("${book.rating ?? 0} (${book.reviews ?? 0} reseñas)"),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.date_range,
                text: "${book.fechaPublicacion?.year ?? "N/A"}"),
            _InfoRow(
                icon: Icons.business,
                text: book.editorial ?? "Editorial desconocida"),
            const SizedBox(height: 12),

            // 🔹 Disponibilidad
            Text("${book.disponibles} disponibles",
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w500)),

            const SizedBox(height: 20),

            // 🔹 Descripción
            const Text("Descripción",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              book.sinopsis ?? "Sin descripción disponible para este libro.",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // 🔹 Detalles extra
            const Text("Detalles del libro",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            _DetailRow(label: "ISBN", value: book.isbn ?? "N/A"),
            _DetailRow(label: "Categoría", value: book.categoria ?? "General"),
            _DetailRow(
                label: "Editorial", value: book.editorial ?? "Editorial"),
            const SizedBox(height: 20),

            // 🔹 Reseñas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Reseñas",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () => _showReviewDialog(context, vm, book.idLibro),
                  child: const Text("Escribir reseña"),
                ),
              ],
            ),
            if ((book.reviews ?? 0) == 0)
              const Text("Aún no hay reseñas para este libro"),
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
          vm.reservarLibro(book.idLibro, 1, quantity); // userId = 1 mock
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Reserva realizada de ${book.titulo}")),
          );
        },
      ),
    );
  }

  // ---------------------- Diálogo de Reseña ----------------------
  void _showReviewDialog(
      BuildContext context, LibroViewModel vm, int idLibro) {
    final TextEditingController controller = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Escribir Reseña"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu reseña...",
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                vm.agregarOpinion(idLibro, 1, rating,
                    controller.text); // userId=1 mock
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Reseña publicada con éxito")));
              },
              child: const Text("Publicar"),
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
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4),
      ]),
      child: Row(
        children: [
          // Selector cantidad
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
