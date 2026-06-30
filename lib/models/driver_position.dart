import 'package:latlong2/latlong.dart';

class DriverPosition {
  final LatLng position;
  final double heading;

  const DriverPosition({
    required this.position,
    required this.heading,
  });

  DriverPosition copyWith({
    LatLng? position,
    double? heading,
  }) {
    return DriverPosition(
      position: position ?? this.position,
      heading: heading ?? this.heading,
    );
  }
}