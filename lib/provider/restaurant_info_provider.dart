import 'package:chifa_el_meson/model/restaurant_info_model.dart';
import 'package:flutter/material.dart';

class RestaurantInfoProvider extends ChangeNotifier {
  RestaurantInfo _restaurantInfo = RestaurantInfo.example();
  RestaurantInfoProvider();
  RestaurantInfo get restaurantInfo => _restaurantInfo;
  void init(RestaurantInfo restaurantInfo) {
    _restaurantInfo = restaurantInfo;
    notifyListeners();
  }
}
