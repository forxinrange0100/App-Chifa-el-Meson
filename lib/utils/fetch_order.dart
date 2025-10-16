import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/services/firebase_messaging_service.dart' show FirebaseMessagingService;

/// Realiza la peticion para crear el pedido y devuelve el resultado. La petición incluye el token FCM para notificaciones push.
Future<PaymentResult> fetchOrder(OrderSummary orderSummary) async {
  final String? fcmToken = FirebaseMessagingService.instance().token;

  try {
    final body = jsonEncode({
      "delivery_type": (orderSummary.deliveryDetails is Dispatch) ? "dispatch" : "pickup",
      "payment_type": orderSummary.paymentType,
      "dispatch_zone_id": (orderSummary.deliveryDetails is Dispatch) ? (orderSummary.deliveryDetails as Dispatch).zone.id : null,
      "order_products": orderSummary.shoppingCart.cartItems.map((cartItem) {
        return {
          "product_id": cartItem.dish.id,
          "quantity": cartItem.quantity,
          "product_note": cartItem.notes,
        };
      }).toList(),
      "client": {
        "name": orderSummary.userDetails.fullName,
        "email": orderSummary.userDetails.email,
        "phone": orderSummary.userDetails.phoneNumber,
        "address": (orderSummary.deliveryDetails is Dispatch) ? (orderSummary.deliveryDetails as Dispatch).address : null,
      },
      "device_token": fcmToken,
    });

    log("Realizando fetchOrder");
    final response = await http.post(
      Uri.parse(
        "${Urls.apiUrl}/api/orders/${Urls.companyId}",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    log("Response status: ${response.statusCode}");
    late final dynamic result;

    try {
      result = json.decode(response.body);
    } catch (e) {
      final errorMessage = "Error al parsear la respuesta del servidor: ";
      log(errorMessage, error: e);
      throw FetchOrderException(errorMessage);
    }

    // if (response.statusCode == 200) {
    // log("Result: $result");

    if (response.statusCode != 201) {
      final errorMessage = "Ocurrió un error al realizar el pedido: ${result['message']}";
      // stats code
      log(errorMessage);
      throw FetchOrderException(errorMessage);
    }


    // Create PaymentData type { payment_type, payment_url, token? }
    final PaymentData paymentData = PaymentData.fromJson(result['payment_data']);

    final int publicId = result['order']?['public_id'] ?? 0;

    return PaymentResult(paymentData: paymentData, publicId: publicId);

    // } else {
    //   throw FetchOrderException(response.body.toString());
    // }
  } catch (e) {
    rethrow;
  } finally {
    log('fetchOrder finalizado');
  }
}
