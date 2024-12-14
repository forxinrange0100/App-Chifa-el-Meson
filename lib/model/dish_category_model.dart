import 'package:flutter/material.dart';

class DishCategory {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final int displayOrder;
  GlobalKey categoryKey;

  DishCategory(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.description,
      required this.displayOrder})
      : categoryKey = GlobalKey();
}
