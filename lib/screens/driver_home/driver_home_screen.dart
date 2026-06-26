import 'package:flutter/material.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          "MotoGo Conductor",
          style: TextStyle(
            color: Color(0xFF00C853),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),

            Text(
              "🏍 Bienvenido",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Conductor",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30),

            Text(
              "Esperando solicitudes...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}