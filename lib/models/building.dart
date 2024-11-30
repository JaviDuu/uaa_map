// lib/models/building.dart
import 'package:flutter/material.dart';

class Building {
  final String name;
  final String info;
  final String svg;
  final double left;
  final double top;
  final double size;
  final String? number;
  final Offset? numberOffset; // Posición personalizada del número
  final double? numberFontSize; // Tamaño de la fuente del número

  Building({
    required this.name,
    required this.info,
    required this.svg,
    required this.left,
    required this.top,
    required this.size,
    this.number,
    this.numberOffset,
    this.numberFontSize,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      name: json['name'],
      info: json['info'],
      svg: json['svg'],
      left: (json['left_coord'] as num).toDouble(),
      top: (json['top_coord'] as num).toDouble(),
      size: (json['size'] as num).toDouble(),
      number: json['number'],
      numberOffset: json['number_offset_x'] != null && json['number_offset_y'] != null
          ? Offset(
              (json['number_offset_x'] as num).toDouble(),
              (json['number_offset_y'] as num).toDouble(),
            )
          : null,
      numberFontSize: json['number_font_size'] != null
          ? (json['number_font_size'] as num).toDouble()
          : null,
    );
  }
}
