import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PlaceResult {
  final String name;
  final String address;
  final LatLng location;

  PlaceResult({
    required this.name,
    required this.address,
    required this.location,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      name: json['name'] ?? 'Lugar sin nombre',
      address: json['display_name'] ?? '',
      location: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }
}

class NominatimService {
  Future<List<PlaceResult>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
          '?q=${Uri.encodeComponent(query)}'
          '&format=json'
          '&limit=8'
          '&countrycodes=pe',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'MotoGoApp/1.0',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al buscar lugares');
    }

    final List data = jsonDecode(response.body);

    return data.map((item) => PlaceResult.fromJson(item)).toList();
  }
}