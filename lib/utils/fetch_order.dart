import 'dart:convert';
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/order_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:http/http.dart' as http;

Future<OrderResult> fetchOrder(OrderSummary orderSummary) async {
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
    // if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (response.statusCode != 200) {
        throw FetchOrderException("Failed to fetch order: ${result['message']}");
      }
      final String paymentUrl = result['payment_url'] ?? '';
      final int publicId = result['order']?['public_id'] ?? 0;
      // ignore: unnecessary_null_comparison
      if (!paymentUrl.isNotEmpty) {
        throw FetchOrderException("Payment URL is empty");
      } 
      if (publicId == 0) {
        throw FetchOrderException("Public ID is not valid");
      }

      return OrderResult(urlPayment: paymentUrl, publicId: publicId);

    // } else {
    //   throw FetchOrderException(response.body.toString());
    // }
  } catch (e) {
    throw Exception("Error fetching order: $e");
  }
}
