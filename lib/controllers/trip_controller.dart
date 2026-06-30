import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/trip_state.dart';
import '../services/driver_navigation_service.dart';
import '../services/driver_service.dart';
import '../services/trip_service.dart';

class TripController extends ChangeNotifier {
  final DriverService _driverService = DriverService();
  final TripService _tripService = TripService();
  final DriverNavigationService _navigationService = DriverNavigationService();

  List<DriverModel> drivers = [];

  DriverModel? assignedDriver;
  TripModel? currentTrip;
  LatLng? movingDriverPosition;

  TripState state = TripState.idle;

  StreamSubscription<LatLng>? _driverMovementSubscription;

  void generateDrivers(LatLng passengerLocation) {
    drivers = _driverService.generateDrivers(passengerLocation);
    assignedDriver = null;
    movingDriverPosition = null;
    state = TripState.idle;
    notifyListeners();
  }

  void createTrip({
    required String passengerId,
    required LatLng origin,
    required LatLng destination,
    required double offer,
  }) {
    final trip = TripModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      passengerId: passengerId,
      driverId: '',
      originLat: origin.latitude,
      originLng: origin.longitude,
      destinationLat: destination.latitude,
      destinationLng: destination.longitude,
      offeredFare: offer,
      status: TripStatus.searching,
    );

    currentTrip = trip;
    _tripService.createTrip(trip);

    state = TripState.searching;
    notifyListeners();
  }

  Future<void> assignNearestDriver() async {
    if (drivers.isEmpty) return;

    state = TripState.searching;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    assignedDriver = drivers.first;
    movingDriverPosition = assignedDriver!.position;
    state = TripState.driverAssigned;

    notifyListeners();
  }

  void moveAssignedDriverToPassenger(LatLng passengerLocation) {
    if (assignedDriver == null) return;

    _driverMovementSubscription?.cancel();

    _driverMovementSubscription = _navigationService
        .simulateDriverMovement(
      start: assignedDriver!.position,
      end: passengerLocation,
    )
        .listen((position) {
      movingDriverPosition = position;
      assignedDriver!.position = position;
      state = TripState.driverArriving;
      notifyListeners();
    });
  }

  void cancelTrip() {
    _driverMovementSubscription?.cancel();

    assignedDriver = null;
    movingDriverPosition = null;
    state = TripState.cancelled;

    notifyListeners();
  }

  @override
  void dispose() {
    _driverMovementSubscription?.cancel();
    super.dispose();
  }
}