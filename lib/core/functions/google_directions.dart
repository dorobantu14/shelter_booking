import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
  final apiUrl = 'https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World/solve?'
      'f=json&'
      'token=AAPK0c541817ab564851bc8357710d6f7af54Wf1-bhKEqQ82lnwt5UUPcZBytYIUOB6crHo0q9cQrojImLFwWMdf3qHDXZ4MAYf&'
      'stops=${origin.latitude},${origin.longitude};${destination.latitude},${destination.longitude}&'
      'startTime=now&returnDirections=true&'
      'directionsLanguage=ro';

  final response = await http.get(Uri.parse(apiUrl));
  final jsonString = jsonDecode(response.body)["routes"]["features"][0]["geometry"]["paths"][0];
  List<dynamic> list = json.decode(jsonString.toString());
  List<List<double>> resultList = list.map((item) => List<double>.from(item)).toList();
  return resultList.map((e) => LatLng(e[0], e[1])).toList();
}
