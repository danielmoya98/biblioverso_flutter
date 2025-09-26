import 'package:biblioverso_flutter/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/screens/splash/splash_screen.dart';
import 'viewmodel/splash_viewmodel.dart';
import 'viewmodel/onboarding_viewmodel.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Biblioverso",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashScreen(),
          "/onboarding": (context) => const OnboardingScreen(),
          "/welcome": (context) => const Placeholder(),
        },
      ),
    );
  }
}
