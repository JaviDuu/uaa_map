// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uaa_map/models/building.dart';
import 'package:uaa_map/services/building_service.dart';
import 'package:uaa_map/screens/loading_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

// Importar el widget SignsLayer
import 'package:uaa_map/widgets/signs_layer.dart';
import 'package:uaa_map/data/signs_data.dart'; // Importar la lista de señales

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  }, (error, stack) {
    // Manejo opcional de errores no capturados
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
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AppLoader(),
    );
  }
}

class AppLoader extends StatefulWidget {
  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  late Future<List<Building>> _initializationFuture;
  final BuildingService buildingService = BuildingService(
    baseUrl: 'http://172.16.132.229:3000',
    syncInterval: Duration(seconds: 30),
  );
  final Map<String, String> _precachedSvgs = {};

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<void> _precacheSvg(String assetName) async {
    try {
      if (!_precachedSvgs.containsKey(assetName)) {
        final String svgString = await rootBundle.loadString(assetName);
        _precachedSvgs[assetName] = svgString;
      }
    } catch (e) {
      print('Error precaching SVG $assetName: $e');
    }
  }

  Future<List<Building>> _initializeApp() async {
    try {
      await _precacheSvg('assets/images/background/background_v3.svg');
      final buildings = await buildingService.getAllBuildings();
      await Future.wait(
        buildings.map((building) => _precacheSvg(building.svg)),
      );

      // Precarga de señales SVG
      await _precacheSvg('assets/images/signs/bathroom.svg');
      await _precacheSvg('assets/images/signs/cafeteria.svg');
      await _precacheSvg('assets/images/signs/estacionamiento.svg');

      return buildings;
    } catch (e) {
      print('Error durante la inicialización: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Building>>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingScreen();
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error al cargar la aplicación'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initializationFuture = _initializeApp();
                      });
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return MapScreen(
          initialBuildings: snapshot.data!,
          precachedSvgs: _precachedSvgs,
        );
      },
    );
  }
}

class MapScreen extends StatefulWidget {
  final List<Building> initialBuildings;
  final Map<String, String> precachedSvgs;

  MapScreen({
    required this.initialBuildings,
    required this.precachedSvgs,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController = TransformationController();
  late List<Building> buildings;
  String? selectedBuildingName;
  String? selectedBuildingInfo;
  late BuildingService buildingService;
  final Map<String, String> _precachedSvgs = {};

  @override
  void initState() {
    super.initState();
    buildings = widget.initialBuildings;
    _precachedSvgs.addAll(widget.precachedSvgs);

    buildingService = BuildingService(
      baseUrl: 'http://192.168.68.119:3000',
      syncInterval: Duration(seconds: 30),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scale = 0.36;
      final dx = (MediaQuery.of(context).size.width / 2) - (3900 / 2 * scale);
      final dy = (MediaQuery.of(context).size.height / 2) - (4600 / 2 * scale);

      _transformationController.value = Matrix4.identity()
        ..translate(dx, dy)
        ..scale(scale);
    });
  }

  Widget _buildSvgPicture(String assetName, {double? width, double? height, BoxFit? fit}) {
    if (_precachedSvgs.containsKey(assetName)) {
      return SvgPicture.string(
        _precachedSvgs[assetName]!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }

  Future<List<Building>> _searchBuildings(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    try {
      final results = await buildingService.searchBuildings(pattern);
      return results.toSet().toList();
    } catch (e) {
      print('Error en la búsqueda: $e');
      return [];
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
        backgroundColor: Color.fromARGB(255, 37, 158, 26),
        appBar: AppBar(
          title: Text('UAA Map'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Campo de búsqueda con autocompletado
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
                // Mapa interactivo
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
                          // SVG de fondo
                          Positioned(
                            left: 0,
                            top: 1000,
                            child: _buildSvgPicture(
                              'assets/images/background/background_v3.svg',
                              width: 2000,
                              height: 2000,
                              fit: BoxFit.contain,
                            ),
                          ),
                          // SVGs de los edificios
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
                                child: _buildSvgPicture(
                                  building.svg,
                                  width: building.size,
                                  height: building.size,
                                ),
                              ),
                            );
                          }).toList(),
                          // Números de los edificios
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

                          // Agrega las señales usando el nuevo widget SignsLayer
                          SignsLayer(
                            signs: signs,
                            precachedSvgs: _precachedSvgs,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Información del edificio seleccionado
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
                                  child: MarkdownBody(
                                    data: selectedBuildingInfo!,
                                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                      p: TextStyle(fontSize: 16),
                                      h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
