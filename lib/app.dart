import 'package:biblioverso_flutter/view/screens/favorites/favorites_screen.dart';
import 'package:biblioverso_flutter/view/screens/home/home_screen.dart';
import 'package:biblioverso_flutter/view/screens/onboarding/onboarding_screen.dart';
import 'package:biblioverso_flutter/view/screens/profile/profile_screen.dart';
import 'package:biblioverso_flutter/view/screens/search/search_screen.dart';
import 'package:biblioverso_flutter/view/screens/reservations/reservations_screen.dart';
import 'package:biblioverso_flutter/viewmodel/CategoriesViewModel.dart';
import 'package:biblioverso_flutter/viewmodel/categoria_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/favorites_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/home_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/profile_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/recommendations_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/search_viewmodel.dart';
import 'package:biblioverso_flutter/viewmodel/reservations_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/screens/splash/splash_screen.dart';
import 'viewmodel/splash_viewmodel.dart';
import 'viewmodel/onboarding_viewmodel.dart';
import 'view/screens/welcome/welcome_screen.dart';
import 'viewmodel/welcome_viewmodel.dart';
import 'view/screens/login/login_screen.dart';
import 'view/screens/register/register_screen.dart';
import 'viewmodel/login_viewmodel.dart';
import 'viewmodel/register_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => ReservationsViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => RecommendationsViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriaViewModel()),

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
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          "/home": (context) => const HomeScreen(),
          "/search": (context) => const SearchScreen(),
          "/reservations": (context) => const ReservationsScreen(),
          "/favorites": (context) => const FavoritesScreen(),
          "/profile": (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
