import 'package:flutter/material.dart';

class PassengerHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const PassengerHeader({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  static const Color dark = Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: dark.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  '👋 Hola, $userName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: dark.withOpacity(0.92),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white70,
                ),
                onPressed: onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}