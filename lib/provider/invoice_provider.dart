import 'package:delivera/model/order_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;

class InvoiceProvider extends ChangeNotifier {
  final OrderSummaryProvider _orderSummaryProvider;
  bool _isGettingInvoice = false;
  DeliveryDetails get deliveryDetails => _orderSummaryProvider.details;

  Order _order = Order.empty();

  Order get order => _order;
  bool get isGettingInvoice => _isGettingInvoice;

  InvoiceProvider(this._orderSummaryProvider);

  Future<void> getOrder() async {
    _order = await fetchOrderFull(_orderSummaryProvider.orderResult.publicId);
    notifyListeners();
  }

  void setOrder(Order order) {
    _order = order;
    notifyListeners();
  }

  void storeOrder() {
    // Store order in Hive
    Hive.box(name: 'orders').put(_order.publicId.toString(), _order);
    Hive.box(name: 'orders').close();
  }

  void setIsGettingInvoice(bool value) {
    _isGettingInvoice = value;
    notifyListeners();
  }
}
