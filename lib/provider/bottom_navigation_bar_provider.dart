import 'package:chifa_el_meson/enum/bottom_navigation_bar_enum.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  BottomNavigationBarEnum _bottomNavigationBarStatus =
      BottomNavigationBarEnum.home;
  bool _isLoading = false;
  BottomNavigationBarProvider();
  int get index => _bottomNavigationBarStatus.index;
  bool get isLoading => _isLoading;

  void setIndex(int index) {
    _isLoading = true;
    notifyListeners();
    if (index == BottomNavigationBarEnum.home.index) {
      showHome();
    } else if (index == BottomNavigationBarEnum.shoppingCar.index) {
      showShoppingCar();
    }
  }

  void showHome() {
    _bottomNavigationBarStatus = BottomNavigationBarEnum.home;
    _isLoading = false;
    notifyListeners();
  }

  void showShoppingCar() {
    _bottomNavigationBarStatus = BottomNavigationBarEnum.shoppingCar;
    _isLoading = false;
    notifyListeners();
  }
}
