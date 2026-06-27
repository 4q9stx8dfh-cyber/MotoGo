import 'package:flutter/material.dart';

class SearchingDriverScreen extends StatelessWidget {
  const SearchingDriverScreen({super.key});

  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.two_wheeler,
                color: green,
                size: 90,
              ),
              const SizedBox(height: 24),
              const Text(
                'Buscando conductor...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Estamos buscando una moto cercana para ti.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 35),
              const CircularProgressIndicator(color: green),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar búsqueda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}