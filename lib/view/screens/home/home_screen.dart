import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../profile/profile_screen.dart';
import '../reservations/reservations_screen.dart';
// import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    final pages = [
      const HomeContent(),
      const SearchScreen(),
      const ReservationsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[vm.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.selectedIndex,
        onTap: vm.onTabTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Reservas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
