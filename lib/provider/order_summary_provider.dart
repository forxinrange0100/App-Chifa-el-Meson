import 'package:chifa_el_meson/model/order_result_model.dart';
import 'package:chifa_el_meson/model/order_summary_model.dart';
import 'package:chifa_el_meson/model/shopping_cart_model.dart';
import 'package:chifa_el_meson/model/user_details_model.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/utils/fetch_order.dart';
import 'package:flutter/material.dart';

class OrderSummaryProvider extends ChangeNotifier {
  OrderSummary _orderSummary = OrderSummary(
      details: PickUp(address: ""),
      userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
      shoppingCart: ShoppingCart());
  final RestaurantInfoProvider _restaurantInfoProvider;
  final ShoppingCartProvider _shoppingCartProvider;
  OrderResult _orderResult = OrderResult(urlPayment: "", publicId: 0);
  DeliveryDetails _details;
  OrderSummaryProvider(this._restaurantInfoProvider, this._shoppingCartProvider)
      : _details =
            PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
  DeliveryDetails get details => _details;
  OrderResult get orderResult => _orderResult;

  Future<void> setOrderSummary(
      String fullName, String email, String phoneNumber) async {
    _orderSummary = OrderSummary(
        details: details,
        userDetails: UserDetails(
            fullName: fullName, email: email, phoneNumber: phoneNumber),
        shoppingCart: _shoppingCartProvider.shoppingCart);
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

  void clearUrlPayment() {
    _orderResult.urlPayment = "";
  }

  void clearOrderSummary() {
    _orderSummary = OrderSummary(
        details: PickUp(address: ""),
        userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
        shoppingCart: ShoppingCart());
    notifyListeners();
  }
}
