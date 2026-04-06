import 'package:flutter/material.dart';

class Category {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final int displayOrder;
  GlobalKey categoryKey;

  Category(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.description,
      required this.displayOrder})
      : categoryKey = GlobalKey();
}
