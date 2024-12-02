// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/building.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('buildings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE buildings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        info TEXT NOT NULL,
        svg TEXT NOT NULL,
        left_coord REAL NOT NULL,
        top_coord REAL NOT NULL,
        size REAL NOT NULL,
        number TEXT UNIQUE,
        number_offset_x REAL,
        number_offset_y REAL,
        number_font_size REAL,
        last_updated INTEGER
      )
    ''');
  }

  Future<void> insertBuilding(Building building) async {
    final db = await database;
    await db.insert(
      'buildings',
      {
        'name': building.name,
        'info': building.info,
        'svg': building.svg,
        'left_coord': building.left,
        'top_coord': building.top,
        'size': building.size,
        'number': building.number,
        'number_offset_x': building.numberOffset?.dx,
        'number_offset_y': building.numberOffset?.dy,
        'number_font_size': building.numberFontSize,
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Building>> getAllBuildings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('buildings');

    return List.generate(maps.length, (i) {
      return Building(
        name: maps[i]['name'],
        info: maps[i]['info'],
        svg: maps[i]['svg'],
        left: maps[i]['left_coord'],
        top: maps[i]['top_coord'],
        size: maps[i]['size'],
        number: maps[i]['number'],
        numberOffset: maps[i]['number_offset_x'] != null
            ? Offset(maps[i]['number_offset_x'], maps[i]['number_offset_y'])
            : null,
        numberFontSize: maps[i]['number_font_size'],
      );
    });
  }

  Future<void> clearBuildings() async {
    final db = await database;
    await db.delete('buildings');
  }

  // Mejora el método searchBuildings para usar LIKE de manera más efectiva
  Future<List<Building>> searchBuildings(String query) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'buildings',
    where: 'LOWER(name) LIKE ? OR number LIKE ? OR LOWER(info) LIKE ?', // Añadido info
    whereArgs: [
      '%${query.toLowerCase()}%',
      '%$query%',
      '%${query.toLowerCase()}%', // Añadido info
    ],
  );

  return List.generate(maps.length, (i) => Building.fromMap(maps[i]));
}
}
