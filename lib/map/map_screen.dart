import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'map_controller.dart';

class MotoGoMapScreen extends StatefulWidget {
  const MotoGoMapScreen({super.key});

  @override
  State<MotoGoMapScreen> createState() => _MotoGoMapScreenState();
}

class _MotoGoMapScreenState extends State<MotoGoMapScreen> {
  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1E);

  final MapControllerMotoGo _controller = MapControllerMotoGo();

  @override
  void initState() {
    super.initState();
    _controller.loadLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final current = _controller.currentLocation;

        return Scaffold(
          backgroundColor: dark,
          body: current == null
              ? const Center(
            child: CircularProgressIndicator(color: green),
          )
              : Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: current,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.motogo',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: current,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: green.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.my_location,
                              color: green,
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: dark.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          'MotoGo',
                          style: TextStyle(
                            color: green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 18,
                right: 18,
                bottom: 24,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: dark.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: green),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '¿A dónde quieres ir?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Solicitar Moto',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}