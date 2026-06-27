import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'location_service.dart';

class MapControllerMotoGo extends ChangeNotifier {
  LatLng? currentLocation;

  Future<void> loadLocation() async {
    final position = await LocationService().getCurrentLocation();

    currentLocation = LatLng(
      position.latitude,
      position.longitude,
    );

    notifyListeners();
  }
}