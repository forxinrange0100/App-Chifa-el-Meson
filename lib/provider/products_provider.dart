import 'package:delivera/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  ProductsProvider();
  List<Product> get products => _products;

  void init(List<Product> products) {
    _products = products;
    _products.sort((a, b) => a.displayOrder - b.displayOrder);
    notifyListeners();
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }
}
