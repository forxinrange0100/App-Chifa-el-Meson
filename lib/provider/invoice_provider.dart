import 'package:chifa_el_meson/model/order_result_full_model.dart';
import 'package:chifa_el_meson/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  bool _isLoading = false;
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
  InvoiceProvider();
  bool get isLoading => _isLoading;
  OrderResultFull get orderResultFull => _orderResultFull;
  Future<void> getOrderResultFull(int publicId) async {
    _isLoading = true;
    notifyListeners();
    _orderResultFull = await fetchOrderFull(publicId);
    _isLoading = false;
    notifyListeners();
  }
}
