import 'package:delivera/model/product_model.dart';
import 'package:delivera/model/dishes_model.dart';
import 'package:flutter/material.dart';

class DishesProvider extends ChangeNotifier {
  Dishes _dishes = Dishes.example();
  DishesProvider();
  Dishes get dishes => _dishes;

  void init(Dishes dishes) {
    _dishes = dishes;
    notifyListeners();
  }

  List<Product> getDishesByCategory(int categoryId) {
    return _dishes.dishes
        .where((dish) => dish.categoryId == categoryId)
        .toList();
  }
}
