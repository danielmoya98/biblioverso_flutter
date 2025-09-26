import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/screens/splash/splash_screen.dart';
import 'viewmodel/splash_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
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
          "/onboarding": (context) => const Placeholder(), // luego lo creamos
        },
      ),
    );
  }
}
