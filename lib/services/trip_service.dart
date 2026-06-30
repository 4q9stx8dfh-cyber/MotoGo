import '../models/trip_model.dart';

class TripService {

  TripModel? currentTrip;

  void createTrip(TripModel trip) {
    currentTrip = trip;
  }

  void updateTrip(TripModel trip) {
    currentTrip = trip;
  }

  void finishTrip() {
    currentTrip = null;
  }
}