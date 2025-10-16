import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/user_details_model.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/utils/fetch_order.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;

class OrderSummaryProvider extends ChangeNotifier {
  // TODO: hacer _details nullable
  OrderSummary _orderSummary = OrderSummary.empty();
  final RestaurantInfoProvider _restaurantInfoProvider;
  final ShoppingCartProvider _shoppingCartProvider;
  PaymentResult _orderResult = PaymentResult(publicId: 0);
  /// To track the delivery details selection
  DeliveryDetails _deliveryDetails;

  PaymentResult get orderResult => _orderResult;
  DeliveryDetails get deliveryDetails => _deliveryDetails;

  OrderSummaryProvider(this._restaurantInfoProvider, this._shoppingCartProvider)
      : _deliveryDetails = PickUp(address: _restaurantInfoProvider.restaurantInfo.address);


  void setOrderSummary(String fullName, String email, String phoneNumber, String paymentType) {
    _orderSummary = OrderSummary(
        deliveryDetails: _deliveryDetails,
        userDetails: UserDetails(fullName: fullName, email: email, phoneNumber: phoneNumber),
        shoppingCart: _shoppingCartProvider.shoppingCart,
        paymentType: paymentType);
    notifyListeners();
  }

  /// Realiza peticion para crear el pedido y guarda el resultado. La petición incluye el token FCM para notificaciones push.
  Future<void> postOrder() async {
    _orderResult = await fetchOrder(_orderSummary);
    notifyListeners();
  }

  void setDeliveryDetailsPickUp() {
    _deliveryDetails = PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
    notifyListeners();
  }

  void setDeliveryDetailsDispatch(Dispatch dispatch) {
    _deliveryDetails = dispatch;
    notifyListeners();
  }

  void setDeliveryAddress(String address) {
    if (_deliveryDetails is Dispatch) {
      (_deliveryDetails as Dispatch).address = address;
    }
  }

  // TODO: hacer _details nullable
  void clearDeliveryDetails() {
    _deliveryDetails = PickUp(address: _restaurantInfoProvider.restaurantInfo.address);
    notifyListeners();
  }

  void clearPaymentData() {
    _orderResult.paymentData = null;
  }

  void clearOrderSummary() {
    _orderSummary = OrderSummary.empty();
    notifyListeners();
  }

  /// Guarda los datos del usuario y los datos de envio de forma local
  void storeUserData() {
    final userBox = Hive.box(name: 'user');
    userBox.putAll({
      'name': _orderSummary.userDetails.fullName,
      'email': _orderSummary.userDetails.email,
      'phone': _orderSummary.userDetails.phoneNumber,
    });

    if (_deliveryDetails is Dispatch) {
      userBox.putAll({
        'deliveryZoneId': (_deliveryDetails as Dispatch).zone.id,
        'deliveryAddress': (_deliveryDetails as Dispatch).address,
      });
    } else if (userBox.get('deliveryZoneId') == null) {
      userBox.putAll({
        'deliveryZoneId': null,
        'deliveryAddress': null,
      });
    }

    userBox.close();
  }
}
