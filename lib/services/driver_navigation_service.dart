import 'dart:async';
import 'package:latlong2/latlong.dart';

class DriverNavigationService {
  Stream<LatLng> simulateDriverMovementByRoute({
    required List<LatLng> routePoints,
  }) async* {
    if (routePoints.isEmpty) return;

    for (final point in routePoints) {
      await Future.delayed(const Duration(milliseconds: 180));
      yield point;
    }
  }
}