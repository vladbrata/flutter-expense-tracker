import 'package:flutter/material.dart';

class MyCategory {
  final String name;
  final String type;
  final IconData icon;
  final Color color;

  static MyCategory? current;

  MyCategory({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });
}
