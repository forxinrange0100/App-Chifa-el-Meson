import 'package:delivera/model/order_model.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  final OrderSummaryProvider _orderSummaryProvider;
  bool _isGettingInvoice = false;

  Order _order = Order(
      id: 0,
      publicId: 0,
      subtotal: 0,
      total: 0,
      timestamp: DateTime.now(),
      deliveryType: '',
      deliveryCost: 0,
      status: '',
      paymentStatus: '',
      paymentType: '',
      clientAddress: '',
      clientPhone: '',
      clientEmail: '',
      clientName: '',
      orderProducts: []);
  InvoiceProvider(this._orderSummaryProvider);
  Order get order => _order;
  bool get isGettingInvoice => _isGettingInvoice;
  Future<void> getOrder() async {
    _order =
        await fetchOrderFull(_orderSummaryProvider.orderResult.publicId);
    notifyListeners();
  }

  void setIseGettingInvoice(bool value) {
    _isGettingInvoice = value;
    notifyListeners();
  }
}
