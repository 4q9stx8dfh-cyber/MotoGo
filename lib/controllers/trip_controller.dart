import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../models/driver_model.dart';
import '../services/driver_service.dart';

class TripController extends ChangeNotifier {
  final DriverService _driverService = DriverService();

  List<DriverModel> drivers = [];

  DriverModel? assignedDriver;

  void generateDrivers(LatLng passengerLocation) {
    drivers = _driverService.generateDrivers(passengerLocation);
    notifyListeners();
  }

  void assignNearestDriver() {
    if (drivers.isEmpty) return;

    assignedDriver = drivers.first;

    notifyListeners();
  }

  void cancelTrip() {
    assignedDriver = null;
    notifyListeners();
  }
}