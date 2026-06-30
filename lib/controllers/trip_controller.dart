import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/driver_model.dart';
import '../services/driver_service.dart';
import '../models/trip_state.dart';

class TripController extends ChangeNotifier {
  final DriverService _driverService = DriverService();

  List<DriverModel> drivers = [];

  DriverModel? assignedDriver;
  TripState state = TripState.idle;

  void generateDrivers(LatLng passengerLocation) {
    drivers = _driverService.generateDrivers(passengerLocation);
    state = TripState.idle;
    notifyListeners();
  }

  void assignNearestDriver() {
    if (drivers.isEmpty) return;

    state = TripState.searching;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      assignedDriver = drivers.first;
      state = TripState.driverAssigned;
      notifyListeners();
    });
  }

  void cancelTrip() {
    assignedDriver = null;
    state = TripState.cancelled;
    notifyListeners();
  }
}