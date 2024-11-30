// lib/services/building_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uaa_map/models/building.dart';

class BuildingService {
  final String baseUrl;

  BuildingService({required this.baseUrl});

  Future<List<Building>> searchBuildings(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Building.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar edificios');
    }
  }

  Future<List<Building>> getAllBuildings() async {
    final response = await http.get(Uri.parse('$baseUrl/buildings'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Building.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener todos los edificios');
    }
  }
}
