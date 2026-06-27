import 'package:flutter/material.dart';

class FareOfferWidget extends StatelessWidget {
  final double minimumOffer;
  final double currentOffer;
  final ValueChanged<double> onOfferChanged;

  const FareOfferWidget({
    super.key,
    required this.minimumOffer,
    required this.currentOffer,
    required this.onOfferChanged,
  });

  static const Color green = Color(0xFF00C853);
  static const Color card = Color(0xFF1E1E1E);

  void _increase() {
    onOfferChanged(currentOffer + 1);
  }

  void _decrease() {
    final next = currentOffer - 1;

    if (next < minimumOffer) {
      onOfferChanged(minimumOffer);
    } else {
      onOfferChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estimatedDrivers = (currentOffer / minimumOffer * 5).clamp(3, 18).round();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            'Oferta mínima: S/ ${minimumOffer.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tu oferta',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(
                icon: Icons.remove,
                onTap: _decrease,
              ),
              const SizedBox(width: 22),
              Text(
                'S/ ${currentOffer.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: green,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 22),
              _CircleButton(
                icon: Icons.add,
                onTap: _increase,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '🛵 $estimatedDrivers conductores disponibles aprox.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  static const Color green = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: green,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }
}