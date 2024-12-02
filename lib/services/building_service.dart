// lib/services/building_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/building.dart';
import '../database/database_helper.dart';

class BuildingService {
  final String baseUrl;
  final DatabaseHelper dbHelper;
  final Duration syncInterval;
  DateTime? _lastSync;

  BuildingService({
    required this.baseUrl,
    this.syncInterval = const Duration(hours: 1),
  }) : dbHelper = DatabaseHelper.instance;

  Future<bool> _hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  Future<bool> _shouldSync() async {
    if (_lastSync == null) return await _hasInternetConnection();
    
    if (DateTime.now().difference(_lastSync!) < syncInterval) return false;
    
    return await _hasInternetConnection();
  }

  Future<void> _syncWithServer() async {
    if (!await _hasInternetConnection()) {
      print('No hay conexión a internet, usando datos locales');
      return;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/buildings'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> buildingsData = responseData['data'] ?? [];
        
        // Limpiar la base de datos local antes de insertar los nuevos datos
        await dbHelper.clearBuildings();
        
        // Insertar los nuevos datos
        for (var buildingData in buildingsData) {
          final building = Building.fromJson(buildingData);
          await dbHelper.insertBuilding(building);
        }
        
        _lastSync = DateTime.now();
      }
    } catch (e) {
      print('Error durante la sincronización: $e');
      // No relanzamos el error para permitir el uso offline
    }
  }


Future<List<Building>> searchBuildings(String query) async {
  // Primero intentamos buscar en la base de datos local
  final localResults = await dbHelper.searchBuildings(query);
  
  // Si hay resultados locales, los devolvemos
  if (localResults.isNotEmpty) {
    return localResults;
  }
  
  // Si no hay resultados locales, intentamos buscar en el servidor
  if (await _hasInternetConnection()) {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> buildingsData = responseData['data'] ?? [];
        final buildings = buildingsData.map((item) => Building.fromJson(item)).toList();
        
        // Guardamos los resultados en la base de datos local
        for (var building in buildings) {
          await dbHelper.insertBuilding(building);
        }
        
        return buildings;
      }
    } catch (e) {
      print('Error en la búsqueda online: $e');
    }
  }
  
  // Si no hay resultados locales y no se pudo buscar en el servidor, devolvemos vacio
  return [];
}

  Future<List<Building>> getAllBuildings() async {
    // Primero obtenemos los datos locales
    final localBuildings = await dbHelper.getAllBuildings();
    
    // Si hay datos locales y no es momento de sincronizar, los devolvemos
    if (localBuildings.isNotEmpty && !await _shouldSync()) {
      return localBuildings;
    }

    // Intentamos sincronizar con el servidor
    try {
      await _syncWithServer();
    } catch (e) {
      print('Error al sincronizar con el servidor: $e');
      // Continuamos con los datos locales si hay error
    }

    // Devolvemos los datos locales actualizados
    return await dbHelper.getAllBuildings();
  }
}
