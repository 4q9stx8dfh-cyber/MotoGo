import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';

class MotoGoApp extends StatelessWidget {
  const MotoGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoGo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00C853),
      ),
      home: const SplashScreen(),
    );
  }
}