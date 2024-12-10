import 'package:chifa_el_meson/provider/delivery_details_provider.dart';
import 'package:chifa_el_meson/provider/dish_categories_provider.dart';
import 'package:chifa_el_meson/provider/dishes_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/utils/fetch_delivery_zones.dart';
import 'package:chifa_el_meson/utils/fetch_dish_categories.dart';
import 'package:chifa_el_meson/utils/fetch_dishes.dart';
import 'package:chifa_el_meson/utils/fetch_restaurant_info.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  final RestaurantInfoProvider _restaurantInfoProvider;
  final DishesProvider _dishesProvider;
  final DishCategoriesProvider _dishCategoriesProvider;
  final DeliveryDetailsProvider _deliveryDetailsProvider;
  String _errorMessage = '';

  DataProvider(this._restaurantInfoProvider, this._dishesProvider,
      this._dishCategoriesProvider, this._deliveryDetailsProvider);
  String get errorMessage => _errorMessage;

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
}
