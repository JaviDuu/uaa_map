// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Importa flutter_markdown
import 'package:uaa_map/models/building.dart';
import 'package:uaa_map/services/building_service.dart';

void main() {
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    // Optionally handle uncaught errors
  }, zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
      if (!message.contains('SVG Warning: Discarding:')) {
        parent.print(zone, message);
      }
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Map',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController = TransformationController();
  List<Building> buildings = [];
  String? selectedBuildingName;
  String? selectedBuildingInfo;
  late BuildingService buildingService;

  @override
  void initState() {
    super.initState();
    buildingService = BuildingService(
      baseUrl: 'http://192.168.68.119:3000',
      syncInterval: Duration(seconds: 30),
    );

    // Cargar los edificios inmediatamente al iniciar
    _loadAllBuildings();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Configurar la matriz inicial para centrar y ajustar el nivel de zoom
      final scale = 0.36;
      final dx = (MediaQuery.of(context).size.width / 2) - (3900 / 2 * scale);
      final dy = (MediaQuery.of(context).size.height / 2) - (4600 / 2 * scale);

      _transformationController.value = Matrix4.identity()
        ..translate(dx, dy)
        ..scale(scale);
    });
  }

  // Modificar el método de búsqueda para manejar mejor los resultados
  Future<List<Building>> _searchBuildings(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    try {
      final results = await buildingService.searchBuildings(pattern);
      // Eliminar duplicados basados en el nombre
      return results.toSet().toList();
    } catch (e) {
      print('Error en la búsqueda: $e');
      return [];
    }
  }

  Future<void> _loadAllBuildings() async {
    try {
      final fetchedBuildings = await buildingService.getAllBuildings();
      setState(() {
        buildings = fetchedBuildings;
      });
    } catch (e) {
      print('Error al cargar edificios: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los edificios')),
      );
    }
  }

  void _showBuildingInfo(BuildContext context, String name, String info) {
    setState(() {
      selectedBuildingName = name;
      selectedBuildingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBuildingName = null;
          selectedBuildingInfo = null;
        });
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 89, 166, 8),
        appBar: AppBar(
          title: Text('University Map'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadField<Building>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return [];
                      }
                      return _searchBuildings(pattern);
                    },
                    itemBuilder: (context, Building suggestion) {
                      final query = _searchController.text;
                      final name = suggestion.name;
                      final index = name.toLowerCase().indexOf(query.toLowerCase());

                      if (index != -1) {
                        final before = name.substring(0, index);
                        final match = name.substring(index, index + query.length);
                        final after = name.substring(index + query.length);

                        return ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: before,
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: match,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: after,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(suggestion.name),
                        );
                      }
                    },
                    onSuggestionSelected: (Building suggestion) {
                      double scale = 1.5;
                      final screenSize = MediaQuery.of(context).size;
                      final x = (screenSize.width / 2) - (suggestion.left * scale);
                      final y = (screenSize.height / 2) - (suggestion.top * scale) - 250;

                      final zoomedMatrix = Matrix4.identity()
                        ..translate(x, y)
                        ..scale(scale);

                      _transformationController.value = zoomedMatrix;

                      setState(() {
                        selectedBuildingName = suggestion.name;
                        selectedBuildingInfo = suggestion.info;
                      });

                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.05,
                    maxScale: 5.0,
                    constrained: false,
                    child: Container(
                      width: 3000,
                      height: 4000,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 1000,
                            child: SvgPicture.asset(
                              'assets/images/background/background.svg',
                              width: 2000,
                              height: 2000,
                              fit: BoxFit.contain,
                            ),
                          ),
                          ...buildings.map((building) {
                            return Positioned(
                              left: building.left,
                              top: building.top,
                              child: GestureDetector(
                                onTap: () {
                                  _showBuildingInfo(
                                    context,
                                    building.name,
                                    building.info,
                                  );
                                },
                                child: SvgPicture.asset(
                                  building.svg,
                                  width: building.size,
                                  height: building.size,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                          ...buildings.where((b) => b.number != null && b.number!.isNotEmpty).map((building) {
                            return Positioned(
                              left: building.left + (building.numberOffset?.dx ?? 0),
                              top: building.top + (building.numberOffset?.dy ?? 0),
                              child: IgnorePointer(
                                child: Text(
                                  building.number!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: building.numberFontSize ?? 16.0,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedBuildingName != null && selectedBuildingInfo != null)
              GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.1,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            height: 4.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    selectedBuildingName!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: MarkdownBody( // Usa MarkdownBody en lugar de Text
                                    data: selectedBuildingInfo!,
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                      p: TextStyle(fontSize: 16),
                                      h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      // Puedes personalizar más estilos aquí si lo deseas
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
