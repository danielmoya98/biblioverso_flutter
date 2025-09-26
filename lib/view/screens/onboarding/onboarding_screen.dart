import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../viewmodel/onboarding_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OnboardingViewModel>(context);

    final pages = [
      {
        "title": "Explora la biblioteca",
        "subtitle": "Descubre miles de libros de diferentes categorías.",
        "animation": "lib/assets/animations/Learning.json"
      },
      {
        "title": "Reserva fácilmente",
        "subtitle": "Separa tus libros favoritos y recógelos en la sucursal.",
        "animation": "lib/assets/animations/Learning.json"
      },
      {
        "title": "Lee y comenta",
        "subtitle": "Deja tus reseñas y comparte tu experiencia con otros.",
        "animation": "lib/assets/animations/Learning.json"
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Botón de "Saltar"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => vm.skip(context),
                child: const Text("Saltar"),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: vm.pageController,
                onPageChanged: vm.setPage,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(page["animation"]!,
                            width: 250, height: 250, fit: BoxFit.contain),
                        const SizedBox(height: 30),
                        Text(
                          page["title"]!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          page["subtitle"]!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicador
            SmoothPageIndicator(
              controller: vm.pageController,
              count: pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.deepPurple,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            const SizedBox(height: 20),
            // Botón siguiente / terminar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (vm.currentPage == pages.length - 1) {
                    vm.finish(context);
                  } else {
                    vm.nextPage();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  vm.currentPage == pages.length - 1 ? "Empezar" : "Siguiente",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
