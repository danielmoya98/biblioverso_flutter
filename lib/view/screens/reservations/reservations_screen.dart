import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/profile_viewmodel.dart';
import '../../../viewmodel/reservations_viewmodel.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final reservationsVM =
    Provider.of<ReservationsViewModel>(context, listen: false);

    // 🔹 Cargar reservas al abrir la pantalla
    reservationsVM.fetchReservas(profileVM.idUsuario!);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReservationsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reservas",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : Column(
        children: [
          // ✅ Tabs Activas / Historial
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _TabButton(
                  text: "Activas (${vm.activeReservations.length})",
                  selected: vm.tabIndex == 0,
                  onTap: () => vm.setTab(0),
                ),
                _TabButton(
                  text:
                  "Historial (${vm.historyReservations.length})",
                  selected: vm.tabIndex == 1,
                  onTap: () => vm.setTab(1),
                ),
              ],
            ),
          ),

          // ✅ Lista de reservas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              itemCount: vm.tabIndex == 0
                  ? vm.activeReservations.length
                  : vm.historyReservations.length,
              itemBuilder: (context, index) {
                final data = vm.tabIndex == 0
                    ? vm.activeReservations[index]
                    : vm.historyReservations[index];
                return _ReservationCard(
                  data: data,
                  isActive: vm.tabIndex == 0,
                  onCancel: () => vm.cancelReserva(data["id"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Widgets internos ------------------

class _TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: selected
                ? [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.deepPurple : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isActive;
  final VoidCallback onCancel;

  const _ReservationCard({
    required this.data,
    required this.isActive,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final status = data["status"]?.toString().toLowerCase();
    Color statusColor;
    String statusText;

    switch (status) {
      case "recoger":
        statusColor = Colors.green;
        statusText = "Recoger";
        break;
      case "pendiente":
        statusColor = Colors.orange;
        statusText = "Pendiente";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data["title"] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isActive && statusText.isNotEmpty)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha:  0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor),
                    ),
                  ),
              ],
            ),

            Text(data["author"] ?? "",
                style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 8),

            // Info
            _InfoRow(icon: Icons.event, text: "Reservado: ${data["reserved"]}"),
            _InfoRow(icon: Icons.timelapse, text: "Expira: ${data["expires"]}"),
            _InfoRow(icon: Icons.store, text: data["branch"] ?? ""),
            _InfoRow(
                icon: Icons.confirmation_number,
                text: "Código: ${data["code"]}"),

            if (!isActive && data["collected"] != null)
              _InfoRow(
                  icon: Icons.check_circle,
                  text: "Recogido: ${data["collected"]}"),

            const SizedBox(height: 12),

            // Botones
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // 📌 Aquí luego podemos abrir detalle del libro
                  },
                  child: const Text("Ver libro"),
                ),
                const Spacer(),
                if (isActive) ...[
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text("Cancelar"),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
