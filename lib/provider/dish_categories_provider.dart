import 'package:delivera/model/dish_categories_model.dart';
import 'package:flutter/material.dart';

class DishCategoriesProvider extends ChangeNotifier {
  DishCategories _dishCategories = DishCategories.example();
  DishCategoriesProvider();
  DishCategories get dishCategories => _dishCategories;

  void init(DishCategories dishCategories) {
    _dishCategories = dishCategories;
    notifyListeners();
  }
}
