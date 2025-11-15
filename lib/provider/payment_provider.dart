import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoading = true;  
  bool _hasError = false;
  bool _paymentOpened = false;

  PaymentProvider();

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get paymentOpened => _paymentOpened;

  void setIsLoading(bool value) {
    if (value == _isLoading) return;
    _isLoading = value;
    notifyListeners();
  }

  void setHasError(bool value) {
    if (value == _hasError) return;
    _hasError = value;
    notifyListeners();
  }

  void setPaymentOpened(bool value) {
    if (value == _paymentOpened) return;
    _paymentOpened = value;
    notifyListeners();
  }

  void onError() {
    setIsLoading(false);
    setPaymentOpened(false);
    setHasError(true);
  }

  void onOpened() {
    setIsLoading(false);
    setHasError(false);
    setPaymentOpened(true);
  }

  void onLoading() {
    setHasError(false);
    setPaymentOpened(false);
    setIsLoading(true);
  }
}
