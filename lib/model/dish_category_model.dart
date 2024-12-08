import 'package:flutter/material.dart';

class DishCategory {
  final int id;
  final String name;
  GlobalKey categoryKey;

  DishCategory({required this.id, required this.name})
      : categoryKey = GlobalKey();
}
