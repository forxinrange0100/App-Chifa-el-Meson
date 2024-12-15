import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoading = true;
  PaymentProvider();
  bool get isLoading => _isLoading;
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
