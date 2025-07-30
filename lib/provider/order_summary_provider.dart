import 'package:delivera/model/order_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:delivera/model/user_details_model.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/utils/fetch_order.dart';
import 'package:flutter/material.dart';

class OrderSummaryProvider extends ChangeNotifier {
  // TODO: hacer _details nullable
  OrderSummary _orderSummary = OrderSummary(
      details: PickUp(address: ""),
      userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
      shoppingCart: ShoppingCart(),
      paymentType: "");
  final RestaurantInfoProvider _restaurantInfoProvider;
  final ShoppingCartProvider _shoppingCartProvider;
  OrderResult _orderResult = OrderResult(publicId: 0);
  // To track the delivery details selection
  DeliveryDetails _details;

  OrderSummaryProvider(this._restaurantInfoProvider, this._shoppingCartProvider)
      : _details =
            PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
  
  DeliveryDetails get details => _details;
  OrderResult get orderResult => _orderResult;

  Future<void> setOrderSummary(
      String fullName, String email, String phoneNumber, String paymentType) async {
    _orderSummary = OrderSummary(
        details: _details,
        userDetails: UserDetails(
            fullName: fullName, email: email, phoneNumber: phoneNumber),
        shoppingCart: _shoppingCartProvider.shoppingCart,
        paymentType: paymentType);
    _orderResult = await fetchOrder(_orderSummary);
    notifyListeners();
  }

  void setDeliveryDetailsPickUp() {
    _details = PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
    notifyListeners();
  }

  void setDeliveryDetailsHomeDelivery(HomeDelivery homeDelivery) {
    _details = homeDelivery;
    notifyListeners();
  }

  void setDeliveryAddress(String address) {
    if (_details is HomeDelivery) {
      (_details as HomeDelivery).address = address;
    }
  }

  // TODO: hacer _details nullable
  void clearDeliveryDetails() {
    _details = PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
    notifyListeners();
  }

  void clearPaymentData() {
    _orderResult.paymentData = null;
  }

  void clearOrderSummary() {
    _orderSummary = OrderSummary(
        details: PickUp(address: ""),
        userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
        shoppingCart: ShoppingCart(),
        paymentType: "");
    notifyListeners();
  }
}
