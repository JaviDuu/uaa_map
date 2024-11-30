//lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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

  String? selectedBuildingName;
  String? selectedBuildingInfo;

  late BuildingService buildingService;

@override
void initState() {
  super.initState();
buildingService = BuildingService(baseUrl: 'http://172.11.58.239:3000'); // Reemplaza con tu IP local real

  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Configurar la matriz inicial para centrar y ajustar el nivel de zoom
    final scale = 0.36; // Nivel inicial de zoom
    final dx = (MediaQuery.of(context).size.width / 2) - (3900 / 2 * scale);
    final dy = (MediaQuery.of(context).size.height / 2) - (4600 / 2 * scale);

    _transformationController.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);

    // Cargar todos los edificios
    _loadAllBuildings();
  });
}

Future<void> _loadAllBuildings() async {
  try {
    final fetchedBuildings = await buildingService.getAllBuildings(); // Implementa este método
    setState(() {
      buildings = fetchedBuildings;
    });
  } catch (e) {
    print('Error al cargar edificios: $e');
    // Opcional: Mostrar un mensaje de error al usuario
  }
}

  List<Building> buildings = [
//   Building(
//     name: 'Edificio 1',
//     info: 'Este es el Edificio 1.',
//     svg: 'assets/images/buildings/1.svg',
//     left: 1531.0,
//     top: 2475.0,
//     size: 150.0, 
//     number: '1',
//     numberOffset: Offset(70, 50), 
//     numberFontSize: 40.0, 
//   ),
Building(
    name: 'Edificio 1a',
    info: 'Este es el Edificio 1a.',
    svg: 'assets/images/buildings/1a.svg',
    left: 1240.5,
    top: 2489.0,
    size: 171.6,
    number: '1A',
      numberOffset: Offset(45, 50), 
      numberFontSize: 40.0, 
  ),
  Building(
    name: 'Edificio 1b',
    info: 'Este es el Edificio 1b.',
    svg: 'assets/images/buildings/1b.svg',
    left: 1325.0,
    top: 2047.5,
    size: 55.0,
    number: '1B',
      numberOffset: Offset(3, -2), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 2',
    info: 'Este es el Edificio 2.',
    svg: 'assets/images/buildings/2.svg',
    left: 1784.0,
    top: 2455.0,
    size: 136.0,
    number: '2',
      numberOffset: Offset(4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 3',
    info: 'Este es el Edificio 3.',
    svg: 'assets/images/buildings/3.svg',
    left: 1888.8,
    top: 2495.0,
    size: 136.0,
    number: '3',
      numberOffset: Offset(4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 4',
    info: 'Este es el Edificio 4.',
    svg: 'assets/images/buildings/4.svg',
    left: 2015.0,
    top: 2495.0,
    size: 136.0,
    number: '4',
      numberOffset: Offset(4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 5',
    info: 'Este es el Edificio 5.',
    svg: 'assets/images/buildings/5.svg',
    left: 2165.0,
    top: 2495.0,
    size: 136.0,
    number: '5',
      numberOffset: Offset(4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 6',
    info: 'Este es el Edificio 6.',
    svg: 'assets/images/buildings/6.svg',
    left: 2290.0,
    top: 2669.3,
    size: 100.0,
    number: '6',
      numberOffset: Offset(4, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 6a',
    info: 'Este es el Edificio 6a.',
    svg: 'assets/images/buildings/6a.svg',
    left: 2274.5,
    top: 2630.0,
    size: 39.5,
    number: '6A',
      numberOffset: Offset(25, -7), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 7',
    info: 'Este es el Edificio 7.',
    svg: 'assets/images/buildings/7.svg',
    left: 2317.7,
    top: 2494.0,
    size: 136.0,
    number: '7',
      numberOffset: Offset(4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 8',
    info: 'Este es el Edificio 8.',
    svg: 'assets/images/buildings/8.svg',
    left: 2388.0,
    top: 2627.5,
    size: 100.0,
    number: '8',
      numberOffset: Offset(4, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 8a',
    info: 'Este es el Edificio 8a.',
    svg: 'assets/images/buildings/8a.svg',
    left: 2335.0,
    top: 2739.5,
    size: 35.0,
    number: '8A',
      numberOffset: Offset(14, -11), 
      numberFontSize: 40.0,
  ),
  Building(
      name: 'Edificio 9',
      info: 'Este es el Edificio 9.',
      svg: 'assets/images/buildings/9.svg',
      left: 1810.0,
      top: 2310.5,
      size: 86.0,
      number: '9',
      numberOffset: Offset(58, 18), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 10',
    info: 'Este es el Edificio 10.',
    svg: 'assets/images/buildings/10.svg',
    left: 1990.0,
    top: 2325.0,
    size: 136.0,
    number: '10',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 11',
    info: 'Este es el Edificio 11.',
    svg: 'assets/images/buildings/11.svg',
    left: 2092.0,
    top: 2350.0,
    size: 136.0,
    number: '11',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 12',
    info: 'Este es el Edificio 12.',
    svg: 'assets/images/buildings/12.svg',
    left: 2240.3,
    top: 2412.0,
    size: 136.0,
    number: '12',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 13',
    info: 'Este es el Edificio 13.',
    svg: 'assets/images/buildings/13.svg',
    left: 2395.0,
    top: 2412.0,
    size: 136.0,
    number: '13',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 13b',
    info: 'Este es el Edificio 13b.',
    svg: 'assets/images/buildings/13b.svg',
    left: 2435.0,
    top: 2552.2,
    size: 62.3,
    number: '13B',
      numberOffset: Offset(-13, 8), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 14',
    info: 'Este es el Edificio 14.',
    svg: 'assets/images/buildings/14.svg',
    left: 2465.0,
    top: 2330.0,
    size: 136.0,
    number: '14',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 15',
    info: 'Este es el Edificio 15.',
    svg: 'assets/images/buildings/15.svg',
    left: 2393.0,
    top: 2201.0,
    size: 136.0,
    number: '15',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 16',
    info: 'Este es el Edificio 16.',
    svg: 'assets/images/buildings/16.svg',
    left: 2242.0,
    top: 2201.0,
    size: 136.0,
    number: '16',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 17',
    info: 'Este es el Edificio 17.',
    svg: 'assets/images/buildings/17.svg',
    left: 2540.0,
    top: 2201.0,
    size: 136.0,
    number: '17',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 18',
    info: 'Este es el Edificio 18.',
    svg: 'assets/images/buildings/18.svg',
    left: 2166.0,
    top: 2109.0,
    size: 136.0,
    number: '18',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 19',
    info: 'Este es el Edificio 19.',
    svg: 'assets/images/buildings/19.svg',
    left: 2317.7,
    top: 2109.0,
    size: 136.0,
    number: '19',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 20',
    info: 'Este es el Edificio 20.',
    svg: 'assets/images/buildings/20.svg',
    left: 2444.0,
    top: 2045.0,
    size: 90.0,
    number: '20',
      numberOffset: Offset(31, 15), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 21',
    info: 'Este es el Edificio 21.',
    svg: 'assets/images/buildings/21.svg',
    left: 2465.0,
    top: 2201.0,
    size: 90.0,
    number: '21',
      numberOffset: Offset(-5, 15), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 22',
    info: 'Este es el Edificio 22.',
    svg: 'assets/images/buildings/22.svg',
    left: 2585.0,
    top: 2010.0,
    size: 86.0,
    number: '22',
      numberOffset: Offset(3, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 23',
    info: 'Este es el Edificio 23.',
    svg: 'assets/images/buildings/23.svg',
    left: 2215.6,
    top: 1960.5,
    size: 90.0,
    number: '23',
      numberOffset: Offset(31, 12), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 24',
    info: 'Este es el Edificio 24.',
    svg: 'assets/images/buildings/24.svg',
    left: 2524.0,
    top: 1855.0,
    size: 130.0,
    number: '24',
      numberOffset: Offset(-7, 32), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 25',
    info: 'Este es el Edificio 25.',
    svg: 'assets/images/buildings/25.svg',
    left: 2421.3,
    top: 1898.0,
    size: 88.0,
    number: '25',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 26',
    info: 'Este es el Edificio 26.',
    svg: 'assets/images/buildings/26.svg',
    left: 2319.5,
    top: 1795.0,
    size: 136.0,
    number: '26',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 27',
    info: 'Este es el Edificio 27.',
    svg: 'assets/images/buildings/27.svg',
    left: 2470.0,
    top: 1773.0,
    size: 60.0,
    number: '27',
      numberOffset: Offset(-7, 5), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 28',
    info: 'Este es el Edificio 28.',
    svg: 'assets/images/buildings/28.svg',
    left: 2396.0,
    top: 1759.0,
    size: 75.0,
    number: '28',
      numberOffset: Offset(-7, 9), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 29',
    info: 'Este es el Edificio 29.',
    svg: 'assets/images/buildings/29.svg',
    left: 2241.2,
    top: 1710.0,
    size: 136.0,
    number: '29',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 30',
    info: 'Este es el Edificio 30.',
    svg: 'assets/images/buildings/30.svg',
    left: 2148.0,
    top: 1780.0,
    size: 88.0,
    number: '30',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 31',
    info: 'Este es el Edificio 31.',
    svg: 'assets/images/buildings/31.svg',
    left: 2027.0,
    top: 1780.0,
    size: 88.0,
    number: '31',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 32',
    info: 'Este es el Edificio 32.',
    svg: 'assets/images/buildings/32.svg',
    left: 2580.0,
    top: 1750.0,
    size: 165.0,
    number: '32',
      numberOffset: Offset(29, 85), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 33',
    info: 'Este es el Edificio 33.',
    svg: 'assets/images/buildings/33.svg',
    left: 2595.0,
    top: 1655.0,
    size: 70.0,
    number: '33',
      numberOffset: Offset(-7, 5), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 34',
    info: 'Este es el Edificio 34.',
    svg: 'assets/images/buildings/34.svg',
    left: 2486.0,
    top: 1655.0,
    size: 70.0,
    number: '34',
      numberOffset: Offset(2, 5), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 35',
    info: 'Este es el Edificio 35.',
    svg: 'assets/images/buildings/35.svg',
    left: 2430.0,
    top: 1640.0,
    size: 60.0,
    number: '35',
      numberOffset: Offset(-3, 5), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 36',
    info: 'Este es el Edificio 36.',
    svg: 'assets/images/buildings/36.svg',
    left: 2350.0,
    top: 1660.0,
    size: 40.0,
    number: '36',
      numberOffset: Offset(10, -7), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 37',
    info: 'Este es el Edificio 37.',
    svg: 'assets/images/buildings/37.svg',
    left: 2082.0,
    top: 1590.0,
    size: 136.0,
    number: '37',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 38',
    info: 'Este es el Edificio 38.',
    svg: 'assets/images/buildings/38.svg',
    left: 2000.0,
    top: 1568.0,
    size: 115.0,
    number: '38',
      numberOffset: Offset(-10, 27), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 39',
    info: 'Este es el Edificio 39.',
    svg: 'assets/images/buildings/39.svg',
    left: 1926.0,
    top: 1665.0,
    size: 136.0,
    number: '39',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 40',
    info: 'Este es el Edificio 40.',
    svg: 'assets/images/buildings/40.svg',
    left: 2578.5,
    top: 1470.0,
    size: 140.0,
    number: '40',
      numberOffset: Offset(-8, 46), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 41',
    info: 'Este es el Edificio 41.',
    svg: 'assets/images/buildings/41.svg',
    left: 2500.0,
    top: 1470.0,
    size: 40.0,
    number: '41',
      numberOffset: Offset(23, -8), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 42',
    info: 'Este es el Edificio 42.',
    svg: 'assets/images/buildings/42.svg',
    left: 2476.0,
    top: 1470.0,
    size: 136.0,
    number: '42',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 43',
    info: 'Este es el Edificio 43.',
    svg: 'assets/images/buildings/43.svg',
    left: 2385.0,
    top: 1425.0,
    size: 136.0,
    number: '43',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 44',
    info: 'Este es el Edificio 44.',
    svg: 'assets/images/buildings/44.svg',
    left: 2308.0,
    top: 1470.0,
    size: 136.0,
    number: '44',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 45',
    info: 'Este es el Edificio 45.',
    svg: 'assets/images/buildings/45.svg',
    left: 2191.0,
    top: 1443.0,
    size: 136.0,
    number: '45',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 46',
    info: 'Este es el Edificio 46.',
    svg: 'assets/images/buildings/46.svg',
    left: 2110.0,
    top: 1450.0,
    size: 85.0,
    number: '46',
      numberOffset: Offset(-7, 18), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 47',
    info: 'Este es el Edificio 47.',
    svg: 'assets/images/buildings/47.svg',
    left: 1945.0,
    top: 1416.2,
    size: 39.1,
    number: '47',
      numberOffset: Offset(17, -7), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 48',
    info: 'Este es el Edificio 48.',
    svg: 'assets/images/buildings/48.svg',
    left: 1903.0,
    top: 1536.0,
    size: 88.0,
    number: '48',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 49',
    info: 'Este es el Edificio 49.',
    svg: 'assets/images/buildings/49.svg',
    left: 1817.0,
    top: 1480.0,
    size: 115.0,
    number: '49',
      numberOffset: Offset(-10, 27), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 50',
    info: 'Este es el Edificio 50.',
    svg: 'assets/images/buildings/50.svg',
    left: 1755.0,
    top: 1448.0,
    size: 115.0,
    number: '50',
      numberOffset: Offset(-10, 27), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 51',
    info: 'Este es el Edificio 51.',
    svg: 'assets/images/buildings/51.svg',
    left: 1695.0,
    top: 1423.0,
    size: 136.0,
    number: '51',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 52',
    info: 'Este es el Edificio 52.',
    svg: 'assets/images/buildings/52.svg',
    left: 1758.0,
    top: 1620.0,
    size: 115.0,
    number: '52',
      numberOffset: Offset(-10, 27), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 53',
    info: 'Este es el Edificio 53.',
    svg: 'assets/images/buildings/53.svg',
    left: 1815.0,
    top: 1705.0,
    size: 136.0,
    number: '53',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 54',
    info: 'Este es el Edificio 54.',
    svg: 'assets/images/buildings/54.svg',
    left: 1880.0,
    top: 1830.0,
    size: 90.0,
    number: '54',
      numberOffset: Offset(31, 17), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 55',
    info: 'Este es el Edificio 55.',
    svg: 'assets/images/buildings/55.svg',
    left: 1712.0,
    top: 1860.1,
    size: 77.0,
    number: '55',
      numberOffset: Offset(17, 14), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 56',
    info: 'Este es el Edificio 56.',
    svg: 'assets/images/buildings/56.svg',
    left: 1498.0,
    top: 1865.5,
    size: 65.0,
    number: '56',
      numberOffset: Offset(15, 7), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 57',
    info: 'Este es el Edificio 57.',
    svg: 'assets/images/buildings/57.svg',
    left: 1538.0,
    top: 1680.0,
    size: 136.0,
    number: '57',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 58',
    info: 'Este es el Edificio 58.',
    svg: 'assets/images/buildings/58.svg',
    left: 1637.0,
    top: 1700.0,
    size: 136.0,
    number: '58',
      numberOffset: Offset(-8, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 59',
    info: 'Este es el Edificio 59.',
    svg: 'assets/images/buildings/59.svg',
    left: 1614.0,
    top: 1555.0,
    size: 88.0,
    number: '59',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 60',
    info: 'Este es el Edificio 60.',
    svg: 'assets/images/buildings/60.svg',
    left: 1532.0,
    top: 1555.0,
    size: 88.0,
    number: '60',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 61',
    info: 'Este es el Edificio 61.',
    svg: 'assets/images/buildings/61.svg',
    left: 1421.0,
    top: 1823.0,
    size: 88.0,
    number: '61',
      numberOffset: Offset(-3, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 62',
    info: 'Este es el Edificio 62.',
    svg: 'assets/images/buildings/62.svg',
    left: 1298.0,
    top: 2135.0,
    size: 90.0,
    number: '62',
      numberOffset: Offset(-10, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 63',
    info: 'Este es el Edificio 63.',
    svg: 'assets/images/buildings/63.svg',
    left: 1545.0,
    top: 2810.0,
    size: 18.0,
    number: '63',
      numberOffset: Offset(-29, -40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 64',
    info: 'Este es el Edificio 64.',
    svg: 'assets/images/buildings/64.svg',
    left: 2040.0,
    top: 2755.0,
    size: 18.0,
    number: '64',
      numberOffset: Offset(35, -12), 
      numberFontSize: 40.0,
    
  ),
  Building(
      name: 'Edificio 65',
      info: 'Este es el Edificio 65.',
      svg: 'assets/images/buildings/65.svg',
      left: 1513.0,
      top: 2000.0,
      size: 310.0,
      number: '65',
      numberOffset: Offset(58, 220), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 66',
    info: 'Este es el Edificio 66.',
    svg: 'assets/images/buildings/66.svg',
    left: 2244.0,
    top: 1384.0,
    size: 20.0,
    number: '66',
      numberOffset: Offset(30, 0), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 201',
    info: 'Este es el Edificio 201.',
    svg: 'assets/images/buildings/201.svg',
    left: 520.0,
    top: 1780.0,
    size: 75.0,
    number: '201',
      numberOffset: Offset(6, 15), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 202',
    info: 'Este es el Edificio 202.',
    svg: 'assets/images/buildings/202.svg',
    left: 1017.5,
    top: 1449.0,
    size: 250.0,
    number: '220',
      numberOffset: Offset(110, 80), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 203',
    info: 'Este es el Edificio 203.',
    svg: 'assets/images/buildings/203.svg',
    left: 1050.0,
    top: 1386.5,
    size: 110.0,
    number: '203',
      numberOffset: Offset(5, -20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 204',
    info: 'Este es el Edificio 204.',
    svg: 'assets/images/buildings/204.svg',
    left: 825.0,
    top: 1492.0,
    size: 113.0,
    number: '204',
      numberOffset: Offset(50, -15), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 205',
    info: 'Este es el Edificio 205.',
    svg: 'assets/images/buildings/205.svg',
    left: 1080.0,
    top: 1829.0,
    size: 120.0,
    number: '205',
      numberOffset: Offset(-8, 25), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 206',
    info: 'Este es el Edificio 206.',
    svg: 'assets/images/buildings/206.svg',
    left: 679.0,
    top: 1716.0,
    size: 88.0,
    number: '206',
      numberOffset: Offset(-8, 18), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 207',
    info: 'Este es el Edificio 207.',
    svg: 'assets/images/buildings/207.svg',
    left: 879.0,
    top: 1661.0,
    size: 90.0,
    number: '207',
      numberOffset: Offset(-4, 25), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 208',
    info: 'Este es el Edificio 208.',
    svg: 'assets/images/buildings/208.svg',
    left: 1285.0,
    top: 1350.0,
    size: 120.0,
    number: '208',
      numberOffset: Offset(40, -10), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 210',
    info: 'Este es el Edificio 210.',
    svg: 'assets/images/buildings/210.svg',
    left: 600.0,
    top: 1805.0,
    size: 85.0,
    number: '210',
      numberOffset: Offset(10, 18), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 211',
    info: 'Este es el Edificio 211.',
    svg: 'assets/images/buildings/211.svg',
    left: 946.0,
    top: 2051.5,
    size: 179.0,
    number: '211',
      numberOffset: Offset(10, 60), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 212',
    info: 'Este es el Edificio 212.',
    svg: 'assets/images/buildings/212.svg',
    left: 729.0,
    top: 2057.1,
    size: 75.0,
    number: '212',
      numberOffset: Offset(20, 21), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 213',
    info: 'Este es el Edificio 213.',
    svg: 'assets/images/buildings/213.svg',
    left: 601.3,
    top: 1993.5,
    size: 145.0,
    number: '213',
      numberOffset: Offset(0, 50), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 214',
    info: 'Este es el Edificio 214.',
    svg: 'assets/images/buildings/214.svg',
    left: 970.0,
    top: 2275.0,
    size: 115.0,
    number: '214',
      numberOffset: Offset(-5, 27), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 215',
    info: 'Este es el Edificio 215.',
    svg: 'assets/images/buildings/215.svg',
    left: 971.5,
    top: 1692.8,
    size: 90.0,
    number: '215',
      numberOffset: Offset(15, 20), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 219',
    info: 'Este es el Edificio 219.',
    svg: 'assets/images/buildings/219.svg',
    left: 429.0,
    top: 2447.5,
    size: 170.0,
    number: '219',
      numberOffset: Offset(25, 60), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 220',
    info: 'Este es el Edificio 220.',
    svg: 'assets/images/buildings/220.svg',
    left: 1020.5,
    top: 2690.0,
    size: 145.0,
    number: '220',
      numberOffset: Offset(53, 35), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 221',
    info: 'Este es el Edificio 221.',
    svg: 'assets/images/buildings/221.svg',
    left: 786.0,
    top: 2652.5,
    size: 150.0,
    number: '221',
      numberOffset: Offset(53, 42), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 222',
    info: 'Este es el Edificio 222.',
    svg: 'assets/images/buildings/222.svg',
    left: 635.0,
    top: 2650.0,
    size: 150.0,
    number: '222',
      numberOffset: Offset(5, 79), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 223',
    info: 'Este es el Edificio 223.',
    svg: 'assets/images/buildings/223.svg',
    left: 461.7,
    top: 2675.0,
    size: 80.0,
    number: '223',
      numberOffset: Offset(4, 25), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Edificio 224',
    info: 'Este es el Edificio 224.',
    svg: 'assets/images/buildings/224.svg',
    left: 725.6,
    top: 2458.5,
    size: 132.5,
    number: '224',
      numberOffset: Offset(-4, 40), 
      numberFontSize: 40.0,
  ),
  Building(
    name: 'Alberca',
    info: 'Esta es la Alberca.',
    svg: 'assets/images/buildings/alberca.svg',
    left: 805.0,
    top: 1785.0,
    size: 140.0,
  ),
 
];

  void _showBuildingInfo(BuildContext context, String name, String info) {
    setState(() {
      selectedBuildingName = name;
      selectedBuildingInfo = info;
    });
  }

  void _searchBuilding() {
    final searchTerm = _searchController.text.trim().toLowerCase();

    // Buscar el edificio en la lista
    final building = buildings.firstWhere(
      (b) =>
          b.name.toLowerCase() == searchTerm ||
          b.name.toLowerCase() == 'edificio $searchTerm',
      orElse: () => Building(
        name: 'No encontrado',
        info: 'No se encontró información',
        svg: '',
        left: 0.0,
        top: 0.0,
        size: 50.0,
      ),
    );

    if (building.name != 'No encontrado') {
      double scale = 1.5; // Nivel de zoom predeterminado

      // Calcula la posición para centrar el edificio en la pantalla
      final screenSize = MediaQuery.of(context).size;
      final x = (screenSize.width / 2) - (building.left * scale);
      final y =
          (screenSize.height / 2) - (building.top * scale) - 250; // Ajusta según sea necesario

      final zoomedMatrix = Matrix4.identity()
        ..translate(x, y)
        ..scale(scale);

      _transformationController.value = zoomedMatrix;

      setState(() {
        selectedBuildingName = building.name;
        selectedBuildingInfo = building.info;
      });

      // Ocultar el teclado después de la búsqueda
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edificio no encontrado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Si se hace clic fuera de la tarjeta, se oculta la información del edificio seleccionado
        setState(() {
          selectedBuildingName = null;
          selectedBuildingInfo = null;
        });
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 89, 166, 8), // Verde #59A608
        appBar: AppBar(
          title: Text('University Map'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Barra de búsqueda con autocompletado
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadField<Building>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar...',
                        fillColor: Colors.white, // Fondo blanco para la barra de búsqueda
                        filled: true, // Activa el color de fondo
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none, // Sin borde visible
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return [];
                      }
                      try {
                        return await buildingService.searchBuildings(pattern);
                      } catch (e) {
                        print('Error en suggestionsCallback: $e');
                        return [];
                      }
                    },
                    itemBuilder: (context, Building suggestion) {
                      // Resaltar la parte coincidente
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
                    // Al seleccionar una sugerencia
onSuggestionSelected: (Building suggestion) {
  // Centrar y hacer zoom en el edificio seleccionado
  double scale = 1.5; // Nivel de zoom predeterminado

  // Calcula la posición para centrar el edificio en la pantalla
  final screenSize = MediaQuery.of(context).size;
  final x = (screenSize.width / 2) - (suggestion.left * scale);
  final y = (screenSize.height / 2) - (suggestion.top * scale) - 250; // Ajusta según sea necesario

  final zoomedMatrix = Matrix4.identity()
    ..translate(x, y)
    ..scale(scale);

  _transformationController.value = zoomedMatrix;

  setState(() {
    selectedBuildingName = suggestion.name;
    selectedBuildingInfo = suggestion.info;
  });

  // Limpiar el campo de búsqueda
  _searchController.clear();

  // Ocultar el teclado después de la búsqueda
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
                    minScale: 0.05, // Reducido para permitir mayor zoom out
                    maxScale: 5.0,
                    constrained: false,
                    child: Container(
                      width: 3000, // Ajustado el tamaño para eliminar el espacio vacío
                      height: 4000,
                      child: Stack(
                        children: [
                          // Fondo del mapa SVG centrado
                          Positioned(
                            left: 0, // Movido completamente hacia la izquierda
                            top: 1000, // Centrado verticalmente
                            child: SvgPicture.asset(
                              'assets/images/background/background.svg',
                              width: 2000, // Tamaño del fondo SVG
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

// Números sobre los edificios
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
            // Tarjeta de información del edificio seleccionado
            if (selectedBuildingName != null && selectedBuildingInfo != null)
              GestureDetector(
                onTap: () {
                  // Este GestureDetector está vacío para evitar que el clic en la tarjeta cierre la tarjeta
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.1,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
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
                          // Línea de manejo
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            height: 4.0, // Tamaño de la línea
                            width: 40.0, // Ancho de la línea
                            decoration: BoxDecoration(
                              color: Colors.grey[600], // Color de la línea
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                          // Contenido de la tarjeta
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    selectedBuildingInfo!,
                                    style: TextStyle(fontSize: 16),
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