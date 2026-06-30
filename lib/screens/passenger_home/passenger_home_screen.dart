import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../map/map_controller.dart';
import '../../map/nominatim_service.dart';
import '../../map/search_screen.dart';
import '../../map/searching_driver_screen.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../welcome/welcome_screen.dart';
import '../../services/fare_service.dart';
import '../../widgets/fare_offer_widget.dart';
import '../../models/driver_model.dart';
import '../../services/driver_service.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1E);

  final MapController _mapController = MapController();
  final MapControllerMotoGo _controller = MapControllerMotoGo();
  Future<UserModel?>? _userFuture;

  PlaceResult? _destination;
  double? _distanceKm;
  double? _estimatedFare;
  double? _minimumOffer;
  double? _currentOffer;
  List<DriverModel> _drivers = [];

  @override
  void initState() {
    super.initState();

    _controller.loadLocation();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      _userFuture = FirestoreService().getUser(uid);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openSearch() async {
    final result = await Navigator.push<PlaceResult>(
      context,
      MaterialPageRoute(
        builder: (_) => const SearchScreen(),
      ),
    );

    if (result == null) return;

    final current = _controller.currentLocation;

    if (current != null) {
      final distance = const Distance();
      final meters = distance(current, result.location);
      final km = meters / 1000;

      setState(() {
        _destination = result;
        _distanceKm = km;
        _minimumOffer = km < 1 ? 1.0 : km;
        _currentOffer = _minimumOffer!;
        _estimatedFare = _currentOffer;
      });
    } else {
      setState(() {
        _destination = result;
      });
    }

    _mapController.move(result.location, 16);
    if (current != null) {
      _generateDrivers(current);
    }
  }
  void _generateDrivers(LatLng center) {
    setState(() {
      _drivers = DriverService().generateDrivers(center);
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const WelcomeScreen();
    }

    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: dark,
            body: Center(
              child: CircularProgressIndicator(color: green),
            ),
          );
        }

        final user = userSnapshot.data;

        if (user == null) {
          return const WelcomeScreen();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final current = _controller.currentLocation;

            if (current == null) {
              return const Scaffold(
                backgroundColor: dark,
                body: Center(
                  child: CircularProgressIndicator(color: green),
                ),
              );
            }

            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: current,
                      initialZoom: 15.5,
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
                          if (_destination != null)
                            Marker(
                              point: _destination!.location,
                              width: 60,
                              height: 60,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                                size: 46,
                              ),
                            ),
                          ..._drivers.map(
                                (driver) => Marker(
                              point: driver.position,
                              width: 46,
                              height: 46,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121212),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: green, width: 2),
                                ),
                                child: const Icon(
                                  Icons.two_wheeler,
                                  color: green,
                                  size: 28,
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
                                '👋 Hola, ${user.name}',
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
                              onPressed: () async {
                                await AuthService().logout();

                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WelcomeScreen(),
                                    ),
                                        (route) => false,
                                  );
                                }
                              },
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
                        color: dark.withOpacity(0.95),
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
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: _openSearch,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: green.withOpacity(0.35),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, color: green),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _destination == null
                                          ? '¿A dónde quieres ir?'
                                          : _destination!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _destination == null
                                            ? Colors.white70
                                            : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (_destination != null &&
                              _distanceKm != null &&
                              _minimumOffer != null &&
                              _currentOffer != null)
                            FareOfferWidget(
                              minimumOffer: _minimumOffer!,
                              currentOffer: _currentOffer!,
                              onOfferChanged: (value) {
                                setState(() {
                                  _currentOffer = value;
                                  _estimatedFare = value;
                                });
                              },
                            ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _destination == null
                                  ? null
                                  : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const SearchingDriverScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                foregroundColor: Colors.black,
                                disabledBackgroundColor: Colors.white24,
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
      },
    );
  }
}