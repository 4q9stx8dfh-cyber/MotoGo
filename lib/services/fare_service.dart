class FareService {
  static const double minimumPricePerKm = 1.00;

  double calculateMinimumOffer(double distanceKm) {
    final minimum = distanceKm * minimumPricePerKm;

    if (minimum < 1.00) {
      return 1.00;
    }

    return minimum;
  }
}