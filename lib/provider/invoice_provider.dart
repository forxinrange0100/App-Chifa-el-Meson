import 'package:chifa_el_meson/model/order_result_full_model.dart';
import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:chifa_el_meson/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  final OrderSummaryProvider _orderSummaryProvider;
  bool _isGettingInvoice = false;

  OrderResultFull _orderResultFull = OrderResultFull(
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
  OrderResultFull get orderResultFull => _orderResultFull;
  bool get isGettingInvoice => _isGettingInvoice;
  Future<void> getOrderResultFull() async {
    _orderResultFull =
        await fetchOrderFull(_orderSummaryProvider.orderResult.publicId);
    notifyListeners();
  }

  void setIseGettingInvoice(bool value) {
    _isGettingInvoice = value;
    notifyListeners();
  }
}
