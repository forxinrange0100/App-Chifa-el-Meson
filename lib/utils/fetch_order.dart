import 'dart:convert';
import 'dart:developer';
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:http/http.dart' as http;

Future<PaymentResult> fetchOrder(OrderSummary orderSummary) async {
  try {
    final body = jsonEncode({
      "delivery_type":
          (orderSummary.details is HomeDelivery) ? "dispatch" : "pickup",
      "payment_type": orderSummary.paymentType,
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

    log("Haciendo fetch order");
    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");
  // if (response.statusCode == 200) {
    final result = json.decode(response.body);
    log("Result: $result");
    if (response.statusCode != 201) {
      // stats code
      log(result['message']);
      throw FetchOrderException("Failed to fetch order: ${result['message']}");
    }

    // Create PaymentData type { payment_type, payment_url, token? }
    final paymentData = PaymentData.fromJson(result['payment_data']);

    final int publicId = result['order']?['public_id'] ?? 0;

    return PaymentResult(paymentData: paymentData, publicId: publicId);

    // } else {
    //   throw FetchOrderException(response.body.toString());
    // }
  } catch (e) {
    rethrow;
  }
}
