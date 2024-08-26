import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  final List<Map<String, dynamic>> buildings = [
    {'name': 'Edificio 1', 'info': 'Este es el Edificio 1.', 'rect': Rect.fromLTWH(50, 100, 100, 200)},
    {'name': 'Edificio 2', 'info': 'Este es el Edificio 2.', 'rect': Rect.fromLTWH(200, 300, 150, 100)},
    {'name': 'Edificio 3', 'info': 'Este es el Edificio 3.', 'rect': Rect.fromLTWH(400, 100, 120, 180)},
    {'name': 'Edificio 4', 'info': 'Este es el Edificio 4.', 'rect': Rect.fromLTWH(550, 250, 100, 150)},
    {'name': 'Edificio 5', 'info': 'Este es el Edificio 5.', 'rect': Rect.fromLTWH(100, 400, 130, 160)},
    {'name': 'Edificio 6', 'info': 'Este es el Edificio 6.', 'rect': Rect.fromLTWH(300, 500, 100, 100)},
    {'name': 'Edificio 7', 'info': 'Este es el Edificio 7.', 'rect': Rect.fromLTWH(500, 450, 150, 100)},
    {'name': 'Edificio 8', 'info': 'Este es el Edificio 8.', 'rect': Rect.fromLTWH(650, 150, 120, 180)},
    {'name': 'Edificio 9', 'info': 'Este es el Edificio 9.', 'rect': Rect.fromLTWH(800, 300, 130, 100)},
    {'name': 'Edificio 10', 'info': 'Este es el Edificio 10.', 'rect': Rect.fromLTWH(950, 200, 110, 150)},
    {'name': 'Edificio 11', 'info': 'Este es el Edificio 11.', 'rect': Rect.fromLTWH(950, 1000, 110, 150)},
    {'name': 'Edificio 12', 'info': 'Este es el Edificio 12.', 'rect': Rect.fromLTWH(1100, 200, 100, 200)},
    {'name': 'Edificio 13', 'info': 'Este es el Edificio 13.', 'rect': Rect.fromLTWH(1200, 400, 150, 120)},
    {'name': 'Edificio 14', 'info': 'Este es el Edificio 14.', 'rect': Rect.fromLTWH(1300, 600, 120, 180)},
    {'name': 'Edificio 15', 'info': 'Este es el Edificio 15.', 'rect': Rect.fromLTWH(1400, 300, 130, 100)},
    {'name': 'Edificio 16', 'info': 'Este es el Edificio 16.', 'rect': Rect.fromLTWH(1250, 700, 150, 100)},
    {'name': 'Edificio 17', 'info': 'Este es el Edificio 17.', 'rect': Rect.fromLTWH(1300, 850, 100, 120)},
    {'name': 'Edificio 18', 'info': 'Este es el Edificio 18.', 'rect': Rect.fromLTWH(1400, 950, 150, 100)},
    {'name': 'Edificio 19', 'info': 'Este es el Edificio 19.', 'rect': Rect.fromLTWH(1200, 1100, 120, 150)},
    {'name': 'Edificio 20', 'info': 'Este es el Edificio 20.', 'rect': Rect.fromLTWH(1300, 1250, 130, 110)},
    {'name': 'Edificio 21', 'info': 'Este es el Edificio 21.', 'rect': Rect.fromLTWH(1450, 1300, 100, 130)},
    {'name': 'Edificio 22', 'info': 'Este es el Edificio 22.', 'rect': Rect.fromLTWH(1200, 1450, 150, 100)},
    {'name': 'Edificio 23', 'info': 'Este es el Edificio 23.', 'rect': Rect.fromLTWH(1350, 1450, 120, 150)},
    {'name': 'Edificio 24', 'info': 'Este es el Edificio 24.', 'rect': Rect.fromLTWH(1450, 1200, 130, 120)},
    {'name': 'Edificio 25', 'info': 'Este es el Edificio 25.', 'rect': Rect.fromLTWH(1000, 1300, 100, 100)},
    {'name': 'Edificio 26', 'info': 'Este es el Edificio 26.', 'rect': Rect.fromLTWH(1050, 1450, 150, 120)},
    {'name': 'Edificio 27', 'info': 'Este es el Edificio 27.', 'rect': Rect.fromLTWH(1150, 1450, 120, 150)},
    {'name': 'Edificio 28', 'info': 'Este es el Edificio 28.', 'rect': Rect.fromLTWH(1450, 1100, 130, 100)},
    {'name': 'Edificio 29', 'info': 'Este es el Edificio 29.', 'rect': Rect.fromLTWH(950, 1050, 100, 120)},
    {'name': 'Edificio 30', 'info': 'Este es el Edificio 30.', 'rect': Rect.fromLTWH(850, 1300, 150, 100)},
    {'name': 'Edificio 31', 'info': 'Este es el Edificio 31.', 'rect': Rect.fromLTWH(1450, 950, 120, 150)},
    {'name': 'Edificio 32', 'info': 'Este es el Edificio 32.', 'rect': Rect.fromLTWH(1450, 800, 130, 100)},
    {'name': 'Edificio 33', 'info': 'Este es el Edificio 33.', 'rect': Rect.fromLTWH(1450, 650, 100, 130)},
    {'name': 'Edificio 34', 'info': 'Este es el Edificio 34.', 'rect': Rect.fromLTWH(1450, 500, 150, 120)},
    {'name': 'Edificio 35', 'info': 'Este es el Edificio 35.', 'rect': Rect.fromLTWH(1450, 1450, 110, 150)},
  ];

  void _showBuildingInfo(BuildContext context, String name, String info) {
    setState(() {
      selectedBuildingName = name;
      selectedBuildingInfo = info;
    });
  }

  void _searchBuilding() {
    final searchTerm = _searchController.text.trim().toLowerCase();
    Rect rect = Rect.zero;
    double scale = 2.0; // Nivel de zoom predeterminado

    switch (searchTerm) {
      case 'edificio 1':
      case '1':
        rect = Rect.fromLTWH(50, 100, 100, 200);
        break;
      case 'edificio 2':
      case '2':
        rect = Rect.fromLTWH(200, 300, 150, 100);
        break;
      case 'edificio 3':
      case '3':
        rect = Rect.fromLTWH(400, 100, 120, 180);
        break;
      case 'edificio 4':
      case '4':
        rect = Rect.fromLTWH(550, 250, 100, 150);
        break;
      case 'edificio 5':
      case '5':
        rect = Rect.fromLTWH(100, 400, 130, 160);
        break;
      case 'edificio 6':
      case '6':
        rect = Rect.fromLTWH(300, 500, 100, 100);
        break;
      case 'edificio 7':
      case '7':
        rect = Rect.fromLTWH(500, 450, 150, 100);
        break;
      case 'edificio 8':
      case '8':
        rect = Rect.fromLTWH(650, 150, 120, 180);
        break;
      case 'edificio 9':
      case '9':
        rect = Rect.fromLTWH(800, 300, 130, 100);
        break;
      case 'edificio 10':
      case '10':
        rect = Rect.fromLTWH(950, 200, 110, 150);
        break;
      case 'edificio 11':
      case '11':
        rect = Rect.fromLTWH(950, 1000, 110, 150);
        break;
      case 'edificio 12':
      case '12':
        rect = Rect.fromLTWH(1100, 200, 100, 200);
        break;
      case 'edificio 13':
      case '13':
        rect = Rect.fromLTWH(1200, 400, 150, 120);
        break;
      case 'edificio 14':
      case '14':
        rect = Rect.fromLTWH(1300, 600, 120, 180);
        break;
      case 'edificio 15':
      case '15':
        rect = Rect.fromLTWH(1400, 300, 130, 100);
        break;
      case 'edificio 16':
      case '16':
        rect = Rect.fromLTWH(1250, 700, 150, 100);
        break;
      case 'edificio 17':
      case '17':
        rect = Rect.fromLTWH(1300, 850, 100, 120);
        break;
      case 'edificio 18':
      case '18':
        rect = Rect.fromLTWH(1400, 950, 150, 100);
        break;
      case 'edificio 19':
      case '19':
        rect = Rect.fromLTWH(1200, 1100, 120, 150);
        break;
      case 'edificio 20':
      case '20':
        rect = Rect.fromLTWH(1300, 1250, 130, 110);
        break;
      case 'edificio 21':
      case '21':
        rect = Rect.fromLTWH(1450, 1300, 100, 130);
        break;
      case 'edificio 22':
      case '22':
        rect = Rect.fromLTWH(1200, 1450, 150, 100);
        break;
      case 'edificio 23':
      case '23':
        rect = Rect.fromLTWH(1350, 1450, 120, 150);
        break;
      case 'edificio 24':
      case '24':
        rect = Rect.fromLTWH(1450, 1200, 130, 120);
        break;
      case 'edificio 25':
      case '25':
        rect = Rect.fromLTWH(1000, 1300, 100, 100);
        break;
      case 'edificio 26':
      case '26':
        rect = Rect.fromLTWH(1050, 1450, 150, 120);
        break;
      case 'edificio 27':
      case '27':
        rect = Rect.fromLTWH(1150, 1450, 120, 150);
        break;
      case 'edificio 28':
      case '28':
        rect = Rect.fromLTWH(1450, 1100, 130, 100);
        break;
      case 'edificio 29':
      case '29':
        rect = Rect.fromLTWH(950, 1050, 100, 120);
        break;
      case 'edificio 30':
      case '30':
        rect = Rect.fromLTWH(850, 1300, 150, 100);
        break;
      case 'edificio 31':
      case '31':
        rect = Rect.fromLTWH(1450, 950, 120, 150);
        break;
      case 'edificio 32':
      case '32':
        rect = Rect.fromLTWH(1450, 800, 130, 100);
        break;
      case 'edificio 33':
      case '33':
        rect = Rect.fromLTWH(1450, 650, 100, 130);
        break;
      case 'edificio 34':
      case '34':
        rect = Rect.fromLTWH(1450, 500, 150, 120);
        break;
      case 'edificio 35':
      case '35':
        rect = Rect.fromLTWH(1450, 1450, 110, 150);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edificio no encontrado')),
        );
        return;
    }

final screenSize = MediaQuery.of(context).size;
  final x = (screenSize.width / 2) - (rect.left + rect.width / 2) * scale;
  final y = (screenSize.height / 2) - (rect.top + rect.height / 2) * scale - 250; // Ajusta según sea necesario

  final zoomedMatrix = Matrix4.identity()
    ..translate(x, y)
    ..scale(scale);

  _transformationController.value = zoomedMatrix;

  setState(() {
    selectedBuildingName = searchTerm;
    selectedBuildingInfo = buildings.firstWhere(
      (building) => building['name'].toLowerCase() == searchTerm || building['name'].contains(searchTerm),
      orElse: () => {'name': 'No encontrado', 'info': 'No se encontró información'},
    )['info'];
  });

  // Ocultar el teclado después de la búsqueda
  FocusScope.of(context).unfocus();
    
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
      appBar: AppBar(
        title: Text('University Map'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Building',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchBuilding,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  constrained: false,
                  child: Container(
                    width: 2000,
                    height: 2000,
                    color: Colors.green,
                    child: Stack(
                      children: buildings.map((building) {
                        return Positioned(
                          left: building['rect'].left,
                          top: building['rect'].top,
                          width: building['rect'].width,
                          height: building['rect'].height,
                          child: GestureDetector(
                            onTap: () {
                              _showBuildingInfo(
                                context,
                                building['name'],
                                building['info'],
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  color: Color.fromARGB(255, 88, 97, 106),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Text(
                                    '${buildings.indexOf(building) + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                          height: 4.0, // Ajusta el tamaño de la línea aquí
                          width: 40.0, // Ajusta el ancho de la línea aquí
                          decoration: BoxDecoration(
                            color: Colors.grey[600], // Color de la línea
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