import 'dart:math';

import 'package:latlong2/latlong.dart';

import '../models/driver_model.dart';

class DriverService {
  List<DriverModel> generateDrivers(LatLng center) {
    const double radius = 0.004; // separación aprox. 400 m

    return List.generate(12, (index) {
      final angle = (2 * pi * index) / 12;
      final variation = 0.0008 * ((index % 3) + 1);

      final latOffset = cos(angle) * (radius + variation);
      final lngOffset = sin(angle) * (radius + variation);

      return DriverModel(
        id: "driver_$index",
        name: "Conductor ${index + 1}",
        rating: 4.5 + (index % 5) * 0.1,
        motorcycle: "Honda Wave",
        plate: "M${100 + index}",
        position: LatLng(
          center.latitude + latOffset,
          center.longitude + lngOffset,
        ),
      );
    });
  }
}