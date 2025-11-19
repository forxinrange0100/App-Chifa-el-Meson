import 'package:delivera/pages/order_summary_page.dart' show OrderSummaryPage;
import 'package:delivera/pages/payment_page.dart' show PaymentPage;
import 'package:delivera/provider/shift_provider.dart' show ShiftProvider;
import 'package:delivera/toast/toast.dart' show shiftClosedToast;
import 'package:flutter/material.dart' show MaterialPageRoute;
import 'package:flutter/widgets.dart' show NavigatorState, BuildContext, Navigator;
import 'package:provider/provider.dart';

void navigateCheckout(BuildContext context) async {
  // Check if the shift is open before navigating to the order summary page
  bool success = await context.read<ShiftProvider>().updateIsOpen();

  if (!context.mounted) return;

  if (!success) return;

  if (!context.read<ShiftProvider>().isOpen) {
    shiftClosedToast();
    return;
  }

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
    (route) => false,
  );
}

/// Navega a la pantalla de pago.
/// Siempre antes de navegar se debe asignar [OrderSummaryProvider.orderResult], 
/// ya sea manualmente o mediante [OrderSummaryProvider.postOrder].
void navigatePayment(NavigatorState navigator) {
  navigator.push(
    MaterialPageRoute(builder: (context) => PaymentPage()),
  );
}
