import 'dart:async';
import 'package:flutter/material.dart';

class SearchingDriverScreen extends StatefulWidget {
  final double offer;

  const SearchingDriverScreen({
    super.key,
    required this.offer,
  });

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen> {
  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context, true);
    });
  }

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
              const Icon(Icons.two_wheeler, color: green, size: 90),
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
              Text(
                'Oferta enviada: S/ ${widget.offer.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 35),
              const CircularProgressIndicator(color: green),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
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