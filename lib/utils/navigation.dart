import 'package:delivera/pages/payment_page.dart' show PaymentPage;
import 'package:flutter/material.dart' show MaterialPageRoute;
import 'package:flutter/widgets.dart' show NavigatorState;

/// Navega a la pantalla de pago.
/// Siempre antes de navegar se debe asignar [OrderSummaryProvider.orderResult], 
/// ya sea manualmente o mediante [OrderSummaryProvider.postOrder].
void navigatePayment(NavigatorState navigator) {
  navigator.push(
    MaterialPageRoute(builder: (context) => PaymentPage()),
  );
}
