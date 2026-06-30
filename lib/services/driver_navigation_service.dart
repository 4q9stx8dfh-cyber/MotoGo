import 'dart:async';
import 'package:latlong2/latlong.dart';

class DriverNavigationService {
  Stream<LatLng> simulateDriverMovement({
    required LatLng start,
    required LatLng end,
  }) async* {
    const steps = 80;

    for (int i = 0; i <= steps; i++) {
      final lat =
          start.latitude + (end.latitude - start.latitude) * i / steps;

      final lng =
          start.longitude + (end.longitude - start.longitude) * i / steps;

      await Future.delayed(const Duration(milliseconds: 250));

      yield LatLng(lat, lng);
    }
  }
}