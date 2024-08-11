import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getAddressFromLatLng(double lat, double lng) async {
  final queryParams = {
    'format': 'jsonv2',
    'lat': lat.toStringAsPrecision(3),
    'lon': lng.toStringAsPrecision(3),
  };
  final url = Uri.https(
    'nominatim.openstreetmap.org',
    'reverse',
    queryParams,
  );

  final response = await http.get(url);
  Map<String, dynamic> geoData = jsonDecode(response.body);
  return geoData['display_name'];
}
