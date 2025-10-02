import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/notificaciones_viewmodel.dart';
import '../../../viewmodel/profile_viewmodel.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    Provider.of<NotificacionesViewModel>(context, listen: false)
        .fetchNotificaciones(profileVM.idUsuario!);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NotificacionesViewModel>(context);
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        actions: [
          TextButton(
            onPressed: () => vm.marcarTodas(profileVM.idUsuario!),
            child: const Text("Marcar todas como leídas"),
          ),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? Center(child: Text(vm.errorMessage!))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vm.notificaciones.length,
        itemBuilder: (context, index) {
          final n = vm.notificaciones[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(
                n["leida"] ? Icons.notifications_none : Icons.notifications_active,
                color: n["leida"] ? Colors.grey : Colors.deepPurple,
              ),
              title: Text(n["titulo"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(n["mensaje"]),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => vm.marcarLeida(n["id"]),
              ),
            ),
          );
        },
      ),
    );
  }
}
