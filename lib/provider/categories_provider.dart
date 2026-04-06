import 'package:delivera/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories = [];
  CategoriesProvider();
  List<Category> get categories => _categories;

  void init(List<Category> categories) {
    _categories = categories;
    _categories.sort((a, b) => a.displayOrder - b.displayOrder);
    notifyListeners();
  }
}
