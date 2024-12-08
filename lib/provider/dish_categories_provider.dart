import 'package:chifa_el_meson/model/dish_categories_model.dart';
import 'package:flutter/material.dart';

class DishCategoriesProvider extends ChangeNotifier {
  final DishCategories _dishCategories = DishCategories.example();
  DishCategoriesProvider();
  DishCategories get dishCategories => _dishCategories;
}
