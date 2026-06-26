import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../theme/app_theme.dart';

class MotoGoApp extends StatelessWidget {
  const MotoGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoGo',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}