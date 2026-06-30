import 'package:flutter/material.dart';

import '../models/driver_model.dart';

class DriverAcceptCard extends StatelessWidget {
  final DriverModel driver;
  final VoidCallback onCancel;

  const DriverAcceptCard({
    super.key,
    required this.driver,
    required this.onCancel,
  });

  static const Color green = Color(0xFF00C853);
  static const Color card = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Conductor asignado',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: green,
                child: Icon(Icons.person, color: Colors.black, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${driver.motorcycle} • ${driver.plate}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    Text(
                      '⭐ ${driver.rating.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: green),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, color: green),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: onCancel,
              child: const Text('Cancelar viaje'),
            ),
          ),
        ],
      ),
    );
  }
}