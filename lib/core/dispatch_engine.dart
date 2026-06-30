import '../controllers/trip_controller.dart';

class DispatchEngine {
  final TripController tripController;

  DispatchEngine({
    required this.tripController,
  });

  Future<void> requestTrip() async {
    tripController.assignNearestDriver();
  }

  Future<void> cancelTrip() async {
    tripController.cancelTrip();
  }
}