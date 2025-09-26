import 'package:biblioverso_flutter/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/screens/splash/splash_screen.dart';
import 'viewmodel/splash_viewmodel.dart';
import 'viewmodel/onboarding_viewmodel.dart';
import 'view/screens/welcome/welcome_screen.dart';
import 'viewmodel/welcome_viewmodel.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
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
          "/welcome": (context) => const WelcomeScreen(),
          "/login": (context) => const Placeholder(),    // lo haremos luego
          "/register": (context) => const Placeholder(), // lo haremos luego

        },
      ),
    );
  }
}
