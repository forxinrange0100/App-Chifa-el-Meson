import 'dart:developer' show log;

import 'package:delivera/enum/payment_type_enum.dart' show PaymentTypeEnum;
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/user_details_model.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/toast/toast.dart' show serverErrorToast;
import 'package:delivera/utils/fetch_order.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart' show Hive;

class OrderSummaryProvider extends ChangeNotifier {
  // TODO: hacer _details nullable
  OrderSummary _orderSummary = OrderSummary.empty();
  OrderSummary get orderSummary => _orderSummary;
  final ShoppingCartProvider _shoppingCartProvider;
  PaymentResult? _orderResult;

  /// To track the delivery details selection
  DeliveryDetails _deliveryDetails;

  PaymentResult? get orderResult => _orderResult;
  DeliveryDetails get deliveryDetails => _deliveryDetails;

  OrderSummaryProvider(this._shoppingCartProvider) : _deliveryDetails = PickUp();

  void setOrderSummary(String fullName, String email, String phoneNumber, PaymentTypeEnum paymentType) {
    _orderSummary = OrderSummary(
        deliveryDetails: _deliveryDetails,
        userDetails: UserDetails(fullName: fullName, email: email, phoneNumber: phoneNumber),
        shoppingCart: _shoppingCartProvider.shoppingCart,
        paymentType: paymentType);
    notifyListeners();
  }

  /// Realiza peticion para crear el pedido y guarda el resultado. 
  /// La petición incluye el token FCM para notificaciones push.
  /// Devuelve true si la petición fue exitosa, false en caso contrario
  Future<bool> postOrder() async {
    _orderResult = null;
    try {
      _orderResult = await fetchOrder(_orderSummary);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }

    if (_orderResult == null) {
      serverErrorToast("Error al realizar el pedido. Por favor, intente más tarde.");
      notifyListeners();
      return false;
    }

    _orderResult!.store();

    notifyListeners();
    return true;
  }

  void setOrderResult(PaymentResult paymentResult) => _orderResult = paymentResult;

  void setDeliveryDetailsPickUp() {
    _deliveryDetails = PickUp();
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
  void clearDeliveryDetails() => setDeliveryDetailsPickUp();

  void clearPaymentData() {
    _orderResult = null;
  }

  void clearOrderSummary() {
    _orderSummary = OrderSummary.empty();
    notifyListeners();
  }

  /// Guarda los datos del usuario y los datos de envio de forma local
  void storeUserData() async {
    try {
      final userBox = Hive.box('user');
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
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }
}
