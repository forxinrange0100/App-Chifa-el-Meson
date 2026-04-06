import 'package:delivera/provider/delivery_details_provider.dart';
import 'package:delivera/provider/categories_provider.dart';
import 'package:delivera/provider/products_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/utils/fetch_categories.dart';
import 'package:delivera/utils/fetch_products.dart';
import 'package:delivera/utils/fetch_restaurant_info.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  final RestaurantInfoProvider _restaurantInfoProvider;
  final ProductsProvider _productsProvider;
  final CategoriesProvider _categoriesProvider;
  final DeliveryDetailsProvider _deliveryDetailsProvider;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _done = false;
  bool get done => _done;

  DataProvider(this._restaurantInfoProvider, this._productsProvider,
      this._categoriesProvider, this._deliveryDetailsProvider);

  Future<void> getData() async {
    reset();
    try {
      await getRestaurant();
      await getProducts();
      await getCategories();
      await getDeliveryDetails();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
    _done = true;
    notifyListeners();
  }

  Future<void> getRestaurant() async {
    _restaurantInfoProvider.init(await fetchRestaurantInfo());
  }

  Future<void> getProducts() async {
    _productsProvider.init(await fetchProducts());
  }

  Future<void> getCategories() async {
    _categoriesProvider.init(await fetchCategories());
  }

  Future<void> getDeliveryDetails() async {
    await _deliveryDetailsProvider.update();
  }

  void reset() {
    _errorMessage = '';
    _done = false;
    notifyListeners();
  }
}
