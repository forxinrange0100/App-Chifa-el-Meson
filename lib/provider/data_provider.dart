import 'package:delivera/provider/delivery_details_provider.dart';
import 'package:delivera/provider/dish_categories_provider.dart';
import 'package:delivera/provider/dishes_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/utils/fetch_delivery_zones.dart';
import 'package:delivera/utils/fetch_dish_categories.dart';
import 'package:delivera/utils/fetch_dishes.dart';
import 'package:delivera/utils/fetch_restaurant_info.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  final RestaurantInfoProvider _restaurantInfoProvider;
  final DishesProvider _dishesProvider;
  final DishCategoriesProvider _dishCategoriesProvider;
  final DeliveryDetailsProvider _deliveryDetailsProvider;
  String _errorMessage = '';
  bool _done = false;

  DataProvider(this._restaurantInfoProvider, this._dishesProvider,
      this._dishCategoriesProvider, this._deliveryDetailsProvider);
  String get errorMessage => _errorMessage;
  bool get done => _done;

  Future<void> getData() async {
    try {
      await getRestaurant();
      await getDishes();
      await getDishCategories();
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

  Future<void> getDishes() async {
    _dishesProvider.init(await fetchDishes());
  }

  Future<void> getDishCategories() async {
    _dishCategoriesProvider.init(await fetchDishCategories());
  }

  Future<void> getDeliveryDetails() async {
    _deliveryDetailsProvider.init(await fetchDeliveryZones());
  }

  void reset() {
    _errorMessage = '';
    _done = false;
  }
}
