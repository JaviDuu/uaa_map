// lib/models/building.dart
import 'package:flutter/material.dart';

class Building {
  final int? id;
  final String name;
  final String info;
  final String svg;
  final double left;
  final double top;
  final double size;
  final String? number;
  final Offset? numberOffset;
  final double? numberFontSize;

  Building({
    this.id,
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

  factory Building.fromMap(Map<String, dynamic> map) {
    return Building(
      id: map['id'],
      name: map['name'],
      info: map['info'],
      svg: map['svg'],
      left: (map['left_coord'] as num).toDouble(),
      top: (map['top_coord'] as num).toDouble(),
      size: (map['size'] as num).toDouble(),
      number: map['number'],
      numberOffset: (map['number_offset_x'] != null && map['number_offset_y'] != null)
          ? Offset(
              (map['number_offset_x'] as num).toDouble(),
              (map['number_offset_y'] as num).toDouble(),
            )
          : null,
      numberFontSize: map['number_font_size'] != null
          ? (map['number_font_size'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'svg': svg,
      'left_coord': left,
      'top_coord': top,
      'size': size,
      'number': number,
      'number_offset_x': numberOffset?.dx,
      'number_offset_y': numberOffset?.dy,
      'number_font_size': numberFontSize,
    };
  }

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'info': info,
      'svg': svg,
      'left_coord': left,
      'top_coord': top,
      'size': size,
      'number': number,
      'number_offset_x': numberOffset?.dx,
      'number_offset_y': numberOffset?.dy,
      'number_font_size': numberFontSize,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Building &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
