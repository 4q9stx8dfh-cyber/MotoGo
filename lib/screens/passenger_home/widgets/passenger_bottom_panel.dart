import 'package:flutter/material.dart';

import '../../../map/nominatim_service.dart';
import '../../../widgets/fare_offer_widget.dart';
import '../../../widgets/driver_accept_card.dart';
import '../../../models/driver_model.dart';
import '../../../models/trip_state.dart';

class PassengerBottomPanel extends StatelessWidget {
  final PlaceResult? destination;
  final double? distanceKm;
  final double? minimumOffer;
  final double? currentOffer;
  final DriverModel? assignedDriver;
  final VoidCallback onSearchTap;
  final VoidCallback onRequestTrip;
  final VoidCallback onCancelTrip;
  final ValueChanged<double> onOfferChanged;
  final TripState tripState;

  const PassengerBottomPanel({
    super.key,
    required this.destination,
    required this.distanceKm,
    required this.minimumOffer,
    required this.currentOffer,
    required this.assignedDriver,
    required this.onSearchTap,
    required this.onRequestTrip,
    required this.onCancelTrip,
    required this.onOfferChanged,
    required this.tripState,
  });

  static const Color green = Color(0xFF00C853);
  static const Color dark = Color(0xFF121212);
  static const Color card = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    final hasDriver = assignedDriver != null;
    final driverArrived = tripState == TripState.driverArrived;

    return Positioned(
      left: 18,
      right: 18,
      bottom: 24,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: dark.withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: hasDriver ? null : onSearchTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: green.withOpacity(0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        destination == null
                            ? '¿A dónde quieres ir?'
                            : destination!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: destination == null
                              ? Colors.white70
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (hasDriver) ...[
              const SizedBox(height: 14),
              DriverAcceptCard(
                driver: assignedDriver!,
                onCancel: onCancelTrip,
              ),
              if (driverArrived)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: green),
                  ),
                  child: const Text(
                    'Tu conductor ha llegado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ] else ...[
              if (destination != null &&
                  distanceKm != null &&
                  minimumOffer != null &&
                  currentOffer != null)
                FareOfferWidget(
                  minimumOffer: minimumOffer!,
                  currentOffer: currentOffer!,
                  onOfferChanged: onOfferChanged,
                ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: destination == null ? null : onRequestTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Solicitar Moto',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}