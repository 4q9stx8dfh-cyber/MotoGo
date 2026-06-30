import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  Future<List<LatLng>> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};'
          '${end.longitude},${end.latitude}'
          '?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener la ruta');
    }

    final data = jsonDecode(response.body);
    final coordinates = data['routes'][0]['geometry']['coordinates'] as List;

    return coordinates.map((point) {
      return LatLng(point[1], point[0]);
    }).toList();
  }
}