import 'package:latlong2/latlong.dart';

class DriverModel {
  final String id;
  final String name;
  final double rating;
  final String motorcycle;
  final String plate;
  LatLng position;
  bool available;

  DriverModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.motorcycle,
    required this.plate,
    required this.position,
    this.available = true,
  });
}