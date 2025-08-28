import 'package:delivera/model/order_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;

class InvoiceProvider extends ChangeNotifier {
  final OrderSummaryProvider _orderSummaryProvider;
  bool _isDownloadingInvoice = false;
  Order _order = Order.empty();

  DeliveryDetails get deliveryDetails => _orderSummaryProvider.deliveryDetails;
  bool get isDownloadingInvoice => _isDownloadingInvoice;
  Order get order => _order;

  InvoiceProvider(this._orderSummaryProvider);

  Future<void> getOrder() async {
    try {
      _order = await fetchOrderFull(_orderSummaryProvider.orderResult.publicId);
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  void setOrder(Order order) {
    _order = order;
    notifyListeners();
  }

  void storeOrder() {
    // Store order in Hive
    final orderBox = Hive.box<Order>(name:'orders');
    orderBox.put((_order.publicId).toString(), _order);
    orderBox.close();
  }

  void setIsDownloadingInvoice(bool value) {
    _isDownloadingInvoice = value;
    notifyListeners();
  }
}
