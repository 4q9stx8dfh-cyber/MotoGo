import 'driver_model.dart';

class TripModel {
  final String id;

  final String passengerId;
  final String driverId;

  final double originLat;
  final double originLng;

  final double destinationLat;
  final double destinationLng;

  final double offeredFare;

  final DriverModel? driver;

  final TripStatus status;

  const TripModel({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.offeredFare,
    required this.status,
    this.driver,
  });

  TripModel copyWith({
    String? id,
    String? passengerId,
    String? driverId,
    double? originLat,
    double? originLng,
    double? destinationLat,
    double? destinationLng,
    double? offeredFare,
    DriverModel? driver,
    TripStatus? status,
  }) {
    return TripModel(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      originLat: originLat ?? this.originLat,
      originLng: originLng ?? this.originLng,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
      offeredFare: offeredFare ?? this.offeredFare,
      driver: driver ?? this.driver,
      status: status ?? this.status,
    );
  }
}

enum TripStatus {
  searching,
  accepted,
  arriving,
  started,
  completed,
  cancelled,
}