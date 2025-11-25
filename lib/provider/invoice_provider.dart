import 'package:delivera/model/order_model.dart';
import 'package:delivera/utils/fetch_order_full.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  int? publicId;
  bool _isDownloadingInvoice = false;
  Order _order = Order.empty();

  bool get isDownloadingInvoice => _isDownloadingInvoice;
  Order get order => _order;

  InvoiceProvider();

  /// Realiza peticion para obtener el pedido completo usando el publicId.
  /// Guarda el pedido obtenido en el provider,establece publicId en null y borra los datos de pago del almacenamiento local.
  Future<void> getOrder() async {
    if (publicId == null) {
      throw Exception("publicId is null");
    }
    try {
      _order = await fetchOrderFull(publicId!);
    } catch (_) {
      rethrow;
    }
    publicId = null;
    notifyListeners();
  }

  void setOrder(Order order) {
    _order = order;
    notifyListeners();
  }

  void clearOrder() {
    _order = Order.empty();
    notifyListeners();
  }

  void setIsDownloadingInvoice(bool value) {
    _isDownloadingInvoice = value;
    notifyListeners();
  }
}
