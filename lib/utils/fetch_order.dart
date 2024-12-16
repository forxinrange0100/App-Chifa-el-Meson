import 'dart:convert';
import 'package:chifa_el_meson/environment.dart';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:chifa_el_meson/model/order_result_model.dart';
import 'package:chifa_el_meson/model/order_summary_model.dart';
import 'package:http/http.dart' as http;

Future<OrderResult> fetchOrder(OrderSummary orderSummary) async {
  try {
    final body = jsonEncode({
      "delivery_type":
          (orderSummary.details is HomeDelivery) ? "dispatch" : "pickup",
      "payment_type": "card",
      "dispatch_zone_id": (orderSummary.details is HomeDelivery)
          ? (orderSummary.details as HomeDelivery).zone.id
          : null,
      "order_products": orderSummary.shoppingCart.cartItems.map((cartItem) {
        return {
          "product_id": cartItem.dish.id,
          "quantity": cartItem.quantity,
          "product_note": cartItem.preferenceNote,
        };
      }).toList(),
      "client": {
        "name": orderSummary.userDetails.fullName,
        "email": orderSummary.userDetails.email,
        "phone": orderSummary.userDetails.phoneNumber,
        "address": (orderSummary.details is HomeDelivery)
            ? (orderSummary.details as HomeDelivery).address
            : null,
      },
    });
    final response = await http.post(
        Uri.parse(
          "${Urls.apiUrl}/api/orders/${Urls.companyId}",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final String paymentUrl = result['payment_url'];
      final int publicId = result['order']['public_id'];
      if (paymentUrl.isEmpty) {
        throw FetchOrderException(response.body.toString());
      }
      return OrderResult(urlPayment: paymentUrl, publicId: publicId);
    } else {
      throw FetchOrderException(response.body.toString());
    }
  } catch (e) {
    throw FetchOrderException(e.toString());
  }
}
