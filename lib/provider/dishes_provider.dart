import 'package:chifa_el_meson/model/dish_model.dart';
import 'package:chifa_el_meson/model/dishes_model.dart';
import 'package:flutter/material.dart';

class DishesProvider extends ChangeNotifier {
  final Dishes _dishes = Dishes.example();
  DishesProvider();
  Dishes get dishes => _dishes;

  List<Dish> getDishesByCategory(int categoryId) {
    return _dishes.dishes
        .where((dish) => dish.categoryId == categoryId)
        .toList();
  }
}
