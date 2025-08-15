import 'package:delivera/enum/bottom_navigation_bar_enum.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  BottomNavigationBarEnum _bottomNavigationBarStatus =
      BottomNavigationBarEnum.home;
  bool _isLoading = false;
  BottomNavigationBarProvider();
  int get index => _bottomNavigationBarStatus.index;
  bool get isLoading => _isLoading;

  void setIndex(BottomNavigationBarEnum bottomNavigationBarEnum) {
    _isLoading = true;
    notifyListeners();
    switch (bottomNavigationBarEnum) {
      case BottomNavigationBarEnum.home:
        showHome();
        break;
      case BottomNavigationBarEnum.shoppingCar:
        showShoppingCar();
        break;
      case BottomNavigationBarEnum.history:
        showHistory();
        break;
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

  void showHistory() {
    _bottomNavigationBarStatus = BottomNavigationBarEnum.history;
    _isLoading = false;
    notifyListeners();
  }
}
