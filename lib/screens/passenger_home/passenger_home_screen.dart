import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/trip_controller.dart';
import '../../map/map_controller.dart';
import '../../map/nominatim_service.dart';
import '../../map/search_screen.dart';
import '../../map/searching_driver_screen.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../welcome/welcome_screen.dart';
import 'widgets/passenger_bottom_panel.dart';
import 'widgets/passenger_header.dart';
import '../../services/route_service.dart';
import '../../models/trip_state.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);

  final MapController _mapController = MapController();
  final MapControllerMotoGo _locationController = MapControllerMotoGo();
  final TripController _tripController = TripController();

  Future<UserModel?>? _userFuture;

  PlaceResult? _destination;
  double? _distanceKm;
  double? _minimumOffer;
  double? _currentOffer;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();

    _locationController.loadLocation();

    _tripController.addListener(_followDriver);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      _userFuture = FirestoreService().getUser(uid);
    }
  }

  @override
  void dispose() {
    _tripController.removeListener(_followDriver);

    _locationController.dispose();
    _tripController.dispose();

    super.dispose();
  }
  void _followDriver() {
    final movingDriver = _tripController.movingDriverPosition;

    if (movingDriver != null) {
      _mapController.move(movingDriver, 16.5);
    }
  }
  Future<void> _openSearch() async {
    final result = await Navigator.push<PlaceResult>(
      context,
      MaterialPageRoute(
        builder: (_) => const SearchScreen(),
      ),
    );

    if (result == null) return;

    final current = _locationController.currentLocation;
    final movingDriver = _tripController.movingDriverPosition;

    if (movingDriver != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(movingDriver, 16.5);
      });
    }

    if (current != null) {
      final distance = const Distance();
      final meters = distance(current, result.location);
      final km = meters / 1000;
      final route = await RouteService().getRoute(
        start: current,
        end: result.location,
      );

      setState(() {
        _destination = result;
        _distanceKm = km;
        _minimumOffer = km < 1 ? 1.0 : km;
        _currentOffer = _minimumOffer!;
        _routePoints = route;
      });

      _tripController.generateDrivers(current);
    } else {
      setState(() {
        _destination = result;
      });
    }

    _mapController.move(result.location, 16);
  }

  Future<void> _requestTrip() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final origin = _locationController.currentLocation;

    if (uid == null || origin == null || _destination == null) return;

    _tripController.createTrip(
      passengerId: uid,
      origin: origin,
      destination: _destination!.location,
      offer: _currentOffer ?? 0,
    );

    final searchScreen = Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => SearchingDriverScreen(
          offer: _currentOffer ?? 0,
        ),
      ),
    );

    await _tripController.assignNearestDriver();

    final accepted = await searchScreen;

    if (accepted == true && mounted) {
      final passengerLocation = _locationController.currentLocation;

      if (passengerLocation != null) {
        final driver = _tripController.assignedDriver;

        if (driver != null) {
          final driverRoute = await RouteService().getRoute(
            start: driver.position,
            end: passengerLocation,
          );

          _tripController.moveAssignedDriverByRoute(
            driverRoute,
            completedState: TripState.driverArrived,
          );
        }

        Future.delayed(const Duration(milliseconds: 500), () {
          final movingPosition = _tripController.movingDriverPosition;

          if (movingPosition != null) {
            _mapController.move(movingPosition, 16.5);
          }
        });
      }
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
          (route) => false,
    );
  }

  void _cancelTrip() {
    _tripController.cancelTrip();
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
          animation: Listenable.merge([
            _locationController,
            _tripController,
          ]),
          builder: (context, _) {
            final current = _locationController.currentLocation;

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
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: green,
                              strokeWidth: 5,
                            ),
                          ],
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
                          ..._tripController.drivers.map(
                                (driver) {
                              final isAssigned =
                                  _tripController.assignedDriver?.id ==
                                      driver.id;

                              final point = isAssigned &&
                                  _tripController.movingDriverPosition !=
                                      null
                                  ? _tripController.movingDriverPosition!
                                  : driver.position;

                              return Marker(
                                point: point,
                                width: 46,
                                height: 46,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF121212),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isAssigned
                                          ? Colors.orangeAccent
                                          : green,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.two_wheeler,
                                    color: isAssigned
                                        ? Colors.orangeAccent
                                        : green,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  PassengerHeader(
                    userName: user.name,
                    onLogout: _logout,
                  ),

                  PassengerBottomPanel(
                    tripState: _tripController.state,
                    destination: _destination,
                    distanceKm: _distanceKm,
                    minimumOffer: _minimumOffer,
                    currentOffer: _currentOffer,
                    assignedDriver: _tripController.assignedDriver,
                    onSearchTap: _openSearch,
                    onRequestTrip: _requestTrip,
                    onCancelTrip: _cancelTrip,
                    onOfferChanged: (value) {
                      setState(() {
                        _currentOffer = value;
                      });
                    },
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